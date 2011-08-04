Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1HDQVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:21:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:19670 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1HDQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:21:11 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll2c7pEOUO
X-RZG-CLASS-ID: mo00
Message-Id: <20110804162054.096018606@aepfle.de>
User-Agent: quilt/0.48-16.4
Date: Thu, 04 Aug 2011 18:20:54 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 1/3] xen/pv-on-hvm kexec: add xs_introduce to shutdown watches from old kernel
References: <20110804162053.723541930@aepfle.de>
Content-Disposition: inline; filename=xen.kexec.xs_introduce.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new xs_introduce function to shutdown watches from old kernel after
kexec boot.  The old kernel does not unregister all watches in the
shutdown path.  They are still active, the double registration can not
be detected by the new kernel.  When the watches fire, unexpected events
will arrive and the xenwatch thread will crash (jumps to NULL).  An
orderly reboot of a hvm guest will destroy the entire guest with all its
resources (including the watches) before it is rebuilt from scratch, so
the missing unregister is not an issue in that case.

With this change the xenstored is instructed to wipe all active watches
for the guest.  However, a patch for xenstored is required so that it
accepts the XS_INTRODUCE request from a guest. Up to now such a request
was only allowed from the xen tool stack in dom0.

http://lists.xensource.com/archives/html/xen-devel/2011-08/msg00007.html

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/xen/xenbus/xenbus_comms.h |    2 +-
 drivers/xen/xenbus/xenbus_probe.c |    2 +-
 drivers/xen/xenbus/xenbus_xs.c    |   27 ++++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

Index: linux-3.0/drivers/xen/xenbus/xenbus_comms.h
===================================================================
--- linux-3.0.orig/drivers/xen/xenbus/xenbus_comms.h
+++ linux-3.0/drivers/xen/xenbus/xenbus_comms.h
@@ -31,7 +31,7 @@
 #ifndef _XENBUS_COMMS_H
 #define _XENBUS_COMMS_H
 
-int xs_init(void);
+int xs_init(unsigned long xen_store_mfn);
 int xb_init_comms(void);
 
 /* Low level routines. */
Index: linux-3.0/drivers/xen/xenbus/xenbus_probe.c
===================================================================
--- linux-3.0.orig/drivers/xen/xenbus/xenbus_probe.c
+++ linux-3.0/drivers/xen/xenbus/xenbus_probe.c
@@ -757,7 +757,7 @@ static int __init xenbus_init(void)
 	}
 
 	/* Initialize the interface to xenstore. */
-	err = xs_init();
+	err = xs_init(xen_store_mfn);
 	if (err) {
 		printk(KERN_WARNING
 		       "XENBUS: Error initializing xenstore comms: %i\n", err);
Index: linux-3.0/drivers/xen/xenbus/xenbus_xs.c
===================================================================
--- linux-3.0.orig/drivers/xen/xenbus/xenbus_xs.c
+++ linux-3.0/drivers/xen/xenbus/xenbus_xs.c
@@ -620,6 +620,20 @@ static struct xenbus_watch *find_watch(c
 	return NULL;
 }
 
+static int xs_introduce(const char *domid, const char *mfn, const char *port)
+{
+	struct kvec iov[3];
+
+	iov[0].iov_base = (char *)domid;
+	iov[0].iov_len = strlen(domid) + 1;
+	iov[1].iov_base = (char *)mfn;
+	iov[1].iov_len = strlen(mfn) + 1;
+	iov[2].iov_base = (char *)port;
+	iov[2].iov_len = strlen(port) + 1;
+
+	return xs_error(xs_talkv(XBT_NIL, XS_INTRODUCE, iov,
+				 ARRAY_SIZE(iov), NULL));
+}
 /* Register callback to watch this node. */
 int register_xenbus_watch(struct xenbus_watch *watch)
 {
@@ -867,10 +881,11 @@ static int xenbus_thread(void *unused)
 	return 0;
 }
 
-int xs_init(void)
+int xs_init(unsigned long xen_store_mfn)
 {
 	int err;
 	struct task_struct *task;
+	char domid[12], mfn[24], port[24];
 
 	INIT_LIST_HEAD(&xs_state.reply_list);
 	spin_lock_init(&xs_state.reply_lock);
@@ -897,5 +912,15 @@ int xs_init(void)
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 
+	snprintf(domid, sizeof(domid), "%u", DOMID_SELF);
+	snprintf(mfn, sizeof(mfn), "%lu", xen_store_mfn);
+	snprintf(port, sizeof(port), "%d", xen_store_evtchn);
+	if (xen_hvm_domain()) {
+		/* shutdown watches for kexec boot */
+		err = xs_introduce(domid, mfn, port);
+		if (err)
+			printk(KERN_WARNING "xs_introduce failed: %d\n", err);
+	}
+
 	return 0;
 }

