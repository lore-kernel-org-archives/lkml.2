Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756Ab0GTUpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:45:46 -0400
Received: from claw.goop.org ([74.207.240.146]:50947 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761605Ab0GTUmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:42:50 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Daniel Stodden <daniel.stodden@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/16] xenbus: Make xenbus_switch_state transactional
Date: Tue, 20 Jul 2010 13:42:15 -0700
Message-Id: <6c2fdd4f8b4210dd0d6181324cbd420412aa52db.1279658433.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279658231.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
References: <355e718c3f164de385d165eb8a0594895f034ebd.1279658433.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Stodden <daniel.stodden@citrix.com>

According to the comments, this was how it's been done years ago, but
apparently took an xbt pointer from elsewhere back then. The code was
removed because of consistency issues: cancellation wont't roll back
the saved xbdev->state.

Still, unsolicited writes to the state field remain an issue,
especially if device shutdown takes thread synchronization, and subtle
races cause accidental recreation of the device node.

Fixed by reintroducing the transaction. An internal one is sufficient,
so the xbdev->state value remains consistent.

Also fixes the original hack to prevent infinite recursion. Instead of
bailing out on the first attempt to switch to Closing, checks call
depth now.

Signed-off-by: Daniel Stodden <daniel.stodden@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/xenbus/xenbus_client.c |   90 ++++++++++++++++++++++++++----------
 1 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 7b3e973..7e49527 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -133,17 +133,12 @@ int xenbus_watch_pathfmt(struct xenbus_device *dev,
 }
 EXPORT_SYMBOL_GPL(xenbus_watch_pathfmt);
 
+static void xenbus_switch_fatal(struct xenbus_device *, int, int,
+				const char *, ...);
 
-/**
- * xenbus_switch_state
- * @dev: xenbus device
- * @state: new state
- *
- * Advertise in the store a change of the given driver to the given new_state.
- * Return 0 on success, or -errno on error.  On error, the device will switch
- * to XenbusStateClosing, and the error will be saved in the store.
- */
-int xenbus_switch_state(struct xenbus_device *dev, enum xenbus_state state)
+static int
+__xenbus_switch_state(struct xenbus_device *dev,
+		      enum xenbus_state state, int depth)
 {
 	/* We check whether the state is currently set to the given value, and
 	   if not, then the state is set.  We don't want to unconditionally
@@ -152,35 +147,65 @@ int xenbus_switch_state(struct xenbus_device *dev, enum xenbus_state state)
 	   to it, as the device will be tearing down, and we don't want to
 	   resurrect that directory.
 
-	   Note that, because of this cached value of our state, this function
-	   will not work inside a Xenstore transaction (something it was
-	   trying to in the past) because dev->state would not get reset if
-	   the transaction was aborted.
-
+	   Note that, because of this cached value of our state, this
+	   function will not take a caller's Xenstore transaction
+	   (something it was trying to in the past) because dev->state
+	   would not get reset if the transaction was aborted.
 	 */
 
+	struct xenbus_transaction xbt;
 	int current_state;
-	int err;
+	int err, abort;
 
 	if (state == dev->state)
 		return 0;
 
-	err = xenbus_scanf(XBT_NIL, dev->nodename, "state", "%d",
-			   &current_state);
-	if (err != 1)
+again:
+	abort = 1;
+
+	err = xenbus_transaction_start(&xbt);
+	if (err) {
+		xenbus_switch_fatal(dev, depth, err, "starting transaction");
 		return 0;
+	}
+
+	err = xenbus_scanf(xbt, dev->nodename, "state", "%d", &current_state);
+	if (err != 1)
+		goto abort;
 
-	err = xenbus_printf(XBT_NIL, dev->nodename, "state", "%d", state);
+	err = xenbus_printf(xbt, dev->nodename, "state", "%d", state);
 	if (err) {
-		if (state != XenbusStateClosing) /* Avoid looping */
-			xenbus_dev_fatal(dev, err, "writing new state");
-		return err;
+		xenbus_switch_fatal(dev, depth, err, "writing new state");
+		goto abort;
 	}
 
-	dev->state = state;
+	abort = 0;
+abort:
+	err = xenbus_transaction_end(xbt, abort);
+	if (err) {
+		if (err == -EAGAIN && !abort)
+			goto again;
+		xenbus_switch_fatal(dev, depth, err, "ending transaction");
+	} else
+		dev->state = state;
 
 	return 0;
 }
+
+/**
+ * xenbus_switch_state
+ * @dev: xenbus device
+ * @state: new state
+ *
+ * Advertise in the store a change of the given driver to the given new_state.
+ * Return 0 on success, or -errno on error.  On error, the device will switch
+ * to XenbusStateClosing, and the error will be saved in the store.
+ */
+int xenbus_switch_state(struct xenbus_device *dev, enum xenbus_state state)
+{
+	return __xenbus_switch_state(dev, state, 0);
+}
+
 EXPORT_SYMBOL_GPL(xenbus_switch_state);
 
 int xenbus_frontend_closed(struct xenbus_device *dev)
@@ -284,6 +309,23 @@ void xenbus_dev_fatal(struct xenbus_device *dev, int err, const char *fmt, ...)
 EXPORT_SYMBOL_GPL(xenbus_dev_fatal);
 
 /**
+ * Equivalent to xenbus_dev_fatal(dev, err, fmt, args), but helps
+ * avoiding recursion within xenbus_switch_state.
+ */
+static void xenbus_switch_fatal(struct xenbus_device *dev, int depth, int err,
+				const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	xenbus_va_dev_error(dev, err, fmt, ap);
+	va_end(ap);
+
+	if (!depth)
+		__xenbus_switch_state(dev, XenbusStateClosing, 1);
+}
+
+/**
  * xenbus_grant_ring
  * @dev: xenbus device
  * @ring_mfn: mfn of ring to grant
-- 
1.7.1.1

