Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1IVOPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:15:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:13778 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1IVOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:15:42 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDEQEiPVxA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 2/2] xen/pv-on-hvm kexec: add xs_reset_watches to shutdown watches from old kernel
Date: Thu, 22 Sep 2011 16:14:49 +0200
Message-Id: <1316700889-3518-3-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316700889-3518-1-git-send-email-olaf@aepfle.de>
References: <1316700889-3518-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new xs_reset_watches function to shutdown watches from old kernel after
kexec boot.  The old kernel does not unregister all watches in the
shutdown path.  They are still active, the double registration can not
be detected by the new kernel.  When the watches fire, unexpected events
will arrive and the xenwatch thread will crash (jumps to NULL).  An
orderly reboot of a hvm guest will destroy the entire guest with all its
resources (including the watches) before it is rebuilt from scratch, so
the missing unregister is not an issue in that case.

With this change the xenstored is instructed to wipe all active watches
for the guest.  However, a patch for xenstored is required so that it
accepts the XS_RESET_WATCHES request from a client (see changeset
23839:42a45baf037d in xen-unstable.hg). Without the patch for xenstored
the registration of watches will fail and some features of a PVonHVM
guest are not available. The guest is still able to boot, but repeated
kexec boots will fail.

v5:
  - use xs_single instead of passing a dummy string to xs_talkv

v4:
  - ignore -EEXIST in xs_reset_watches

v3:
  - use XS_RESET_WATCHES instead of XS_INTRODUCE

v2:
  - move all code which deals with XS_INTRODUCE into xs_introduce()
    (based on feedback from Ian Campbell)
  - remove casts from kvec assignment

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/xen/xenbus/xenbus_xs.c     |   13 +++++++++++++
 include/xen/interface/io/xs_wire.h |    3 ++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 5534690..01bdb98 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -620,6 +620,15 @@ static struct xenbus_watch *find_watch(const char *token)
 	return NULL;
 }
 
+static void xs_reset_watches(void)
+{
+	int err;
+
+	err = xs_error(xs_single(XBT_NIL, XS_RESET_WATCHES, "", NULL));
+	if (err && err != -EEXIST)
+		printk(KERN_WARNING "xs_reset_watches failed: %d\n", err);
+}
+
 /* Register callback to watch this node. */
 int register_xenbus_watch(struct xenbus_watch *watch)
 {
@@ -897,5 +906,9 @@ int xs_init(void)
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 
+	/* shutdown watches for kexec boot */
+	if (xen_hvm_domain())
+		xs_reset_watches();
+
 	return 0;
 }
diff --git a/include/xen/interface/io/xs_wire.h b/include/xen/interface/io/xs_wire.h
index f6f07aa..f0b6890 100644
--- a/include/xen/interface/io/xs_wire.h
+++ b/include/xen/interface/io/xs_wire.h
@@ -29,7 +29,8 @@ enum xsd_sockmsg_type
     XS_IS_DOMAIN_INTRODUCED,
     XS_RESUME,
     XS_SET_TARGET,
-    XS_RESTRICT
+    XS_RESTRICT,
+    XS_RESET_WATCHES
 };
 
 #define XS_WRITE_NONE "NONE"
-- 
1.7.3.4

