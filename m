Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0F2XWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:22:33 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:32036 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab0F2XW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:22:29 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com
Subject: [RFC/PATCH 1/2] VMware balloon: add module parameter limiting ballon size
Date: Tue, 29 Jun 2010 16:15:43 -0700
Message-Id: <1277853344-19617-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Huang <whuang@vmware.com>

To avoid over-ballooning a VM and causing OOM situation introduce module
parameter allowing to specify amount of memory (percentage-wise) that is
reserved for the kernel, and which is not balloonable.

Signed-off-by: Wei Huang <whuang@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 drivers/misc/vmware_balloon.c       |   18 ++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82d6aeb..3aabe6e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2813,6 +2813,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vmware_balloon.os_percentage =
+			[HW] Percentage of memory reserved for OS needs and
+			therefore is not balloonable. Default is 20%.
+
 	vt.cur_default=	[VT] Default cursor shape.
 			Format: 0xCCBBAA, where AA, BB, and CC are the same as
 			the parameters of the <Esc>[?A;B;Cc escape sequence;
diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
index 2a1e804..061cc3e 100644
--- a/drivers/misc/vmware_balloon.c
+++ b/drivers/misc/vmware_balloon.c
@@ -45,13 +45,13 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.1-k");
+MODULE_VERSION("1.2.1.2-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
 
 /*
- * Various constants controlling rate of inflaint/deflating balloon,
+ * Various constants controlling rate of inflating/deflating balloon,
  * measured in pages.
  */
 
@@ -218,6 +218,14 @@ static struct vmballoon balloon;
 static struct workqueue_struct *vmballoon_wq;
 
 /*
+ * We reserve, by default, 20% of the total RAM for OS needs, limiting
+ * balloon size to 80% of the total RAM.
+ */
+static unsigned int vmballoon_os_percentage = 20;
+module_param_named(os_percentage, vmballoon_os_percentage, uint, 0644);
+MODULE_PARM_DESC(os_percentage, "Amount of memory reserved for OS and therefore is not balloonable (default=20%)");
+
+/*
  * Send "start" command to the host, communicating supported version
  * of the protocol.
  */
@@ -651,7 +659,7 @@ static void vmballoon_work(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct vmballoon *b = container_of(dwork, struct vmballoon, dwork);
-	unsigned int target;
+	unsigned int max_target, target;
 
 	STATS_INC(b->stats.timer);
 
@@ -663,7 +671,9 @@ static void vmballoon_work(struct work_struct *work)
 
 	if (vmballoon_send_get_target(b, &target)) {
 		/* update target, adjust size */
-		b->target = target;
+		max_target = b->sysinfo.totalram *
+				(100 - vmballoon_os_percentage) / 100;
+		b->target = min(target, max_target);
 
 		if (b->size < target)
 			vmballoon_inflate(b);
-- 
1.7.0

