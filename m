Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2JCTZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:25:41 -0400
Received: from mxout1.idt.com ([157.165.5.25]:40746 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2JCTZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:25:37 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 1/5] rapidio: fix blocking wait for discovery ready
Date: Wed,  3 Oct 2012 15:18:39 -0400
Message-Id: <1349291923-22860-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
References: <1349291923-22860-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix blocking wait loop in the RapidIO discovery routine to avoid warning
dumps about stalled CPU on x86 platforms.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/rapidio/rio-scan.c |   62 ++++++++++++++-----------------------------
 1 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 02e686b..0a27253 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
+#include <linux/sched.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
 
@@ -39,8 +40,6 @@
 LIST_HEAD(rio_devices);
 static LIST_HEAD(rio_switches);
 
-static void rio_enum_timeout(unsigned long);
-
 static void rio_init_em(struct rio_dev *rdev);
 
 DEFINE_SPINLOCK(rio_global_list_lock);
@@ -49,9 +48,6 @@ static int next_destid = 0;
 static int next_net = 0;
 static int next_comptag = 1;
 
-static struct timer_list rio_enum_timer =
-TIMER_INITIALIZER(rio_enum_timeout, 0, 0);
-
 static int rio_mport_phys_table[] = {
 	RIO_EFB_PAR_EP_ID,
 	RIO_EFB_PAR_EP_REC_ID,
@@ -1234,20 +1230,6 @@ static void rio_build_route_tables(void)
 }
 
 /**
- * rio_enum_timeout- Signal that enumeration timed out
- * @data: Address of timeout flag.
- *
- * When the enumeration complete timer expires, set a flag that
- * signals to the discovery process that enumeration did not
- * complete in a sane amount of time.
- */
-static void rio_enum_timeout(unsigned long data)
-{
-	/* Enumeration timed out, set flag */
-	*(int *)data = 1;
-}
-
-/**
  * rio_disc_mport- Start discovery through a master port
  * @mport: Master port to send transactions
  *
@@ -1260,34 +1242,33 @@ static void rio_enum_timeout(unsigned long data)
 int __devinit rio_disc_mport(struct rio_mport *mport)
 {
 	struct rio_net *net = NULL;
-	int enum_timeout_flag = 0;
+	unsigned long to_end;
 
 	printk(KERN_INFO "RIO: discover master port %d, %s\n", mport->id,
 	       mport->name);
 
 	/* If master port has an active link, allocate net and discover peers */
 	if (rio_mport_is_active(mport)) {
-		if (!(net = rio_alloc_net(mport))) {
-			printk(KERN_ERR "RIO: Failed to allocate new net\n");
-			goto bail;
-		}
+		pr_debug("RIO: wait for enumeration to complete...\n");
 
-		pr_debug("RIO: wait for enumeration complete...");
-
-		rio_enum_timer.expires =
-		    jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
-		rio_enum_timer.data = (unsigned long)&enum_timeout_flag;
-		add_timer(&rio_enum_timer);
-		while (!rio_enum_complete(mport)) {
-			mdelay(1);
-			if (enum_timeout_flag) {
-				del_timer_sync(&rio_enum_timer);
-				goto timeout;
-			}
+		to_end = jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
+		while (time_before(jiffies, to_end)) {
+			if (rio_enum_complete(mport))
+				goto enum_done;
+			schedule_timeout_uninterruptible(msecs_to_jiffies(10));
 		}
-		del_timer_sync(&rio_enum_timer);
 
-		pr_debug("done\n");
+		pr_debug("RIO: discovery timeout on mport %d %s\n",
+			 mport->id, mport->name);
+		goto bail;
+enum_done:
+		pr_debug("RIO: ... enumeration done\n");
+
+		net = rio_alloc_net(mport);
+		if (!net) {
+			printk(KERN_ERR "RIO: Failed to allocate new net\n");
+			goto bail;
+		}
 
 		/* Read DestID assigned by enumerator */
 		rio_local_read_config_32(mport, RIO_DID_CSR,
@@ -1307,9 +1288,6 @@ int __devinit rio_disc_mport(struct rio_mport *mport)
 	}
 
 	return 0;
-
-      timeout:
-	pr_debug("timeout\n");
-      bail:
+bail:
 	return -EBUSY;
 }
-- 
1.7.8.4

