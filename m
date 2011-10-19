Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1JSStw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:49:52 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:6632 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1JSStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:49:45 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LTBTLD-01-K0M-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [V2][PATCH 4/5] oprofile: Remove exit function for timer mode
Date: Wed, 19 Oct 2011 20:47:54 +0200
Message-ID: <1319050075-23901-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319050075-23901-1-git-send-email-robert.richter@amd.com>
References: <1319050075-23901-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove exit functions by moving init/exit code to oprofile's setup/
shutdown functions. Doing so the oprofile module exit code will be
easier and less error-prone.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprof.c     |    8 ++------
 drivers/oprofile/timer_int.c |   30 +++++++++++++++---------------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index f8c752e..f7cd069 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -262,9 +262,7 @@ static int __init oprofile_init(void)
 		return 0;
 
 	/* failed */
-	if (timer_mode)
-		oprofile_timer_exit();
-	else
+	if (!timer_mode)
 		oprofile_arch_exit();
 
 	return err;
@@ -274,9 +272,7 @@ static int __init oprofile_init(void)
 static void __exit oprofile_exit(void)
 {
 	oprofilefs_unregister();
-	if (timer_mode)
-		oprofile_timer_exit();
-	else
+	if (!timer_mode)
 		oprofile_arch_exit();
 }
 
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 878fba1..93404f7 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -97,24 +97,24 @@ static struct notifier_block __refdata oprofile_cpu_notifier = {
 	.notifier_call = oprofile_cpu_notify,
 };
 
-int oprofile_timer_init(struct oprofile_operations *ops)
+static int oprofile_hrtimer_setup(void)
 {
-	int rc;
-
-	rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
-	if (rc)
-		return rc;
-	ops->create_files = NULL;
-	ops->setup = NULL;
-	ops->shutdown = NULL;
-	ops->start = oprofile_hrtimer_start;
-	ops->stop = oprofile_hrtimer_stop;
-	ops->cpu_type = "timer";
-	printk(KERN_INFO "oprofile: using timer interrupt.\n");
-	return 0;
+	return register_hotcpu_notifier(&oprofile_cpu_notifier);
 }
 
-void oprofile_timer_exit(void)
+static void oprofile_hrtimer_shutdown(void)
 {
 	unregister_hotcpu_notifier(&oprofile_cpu_notifier);
 }
+
+int oprofile_timer_init(struct oprofile_operations *ops)
+{
+	ops->create_files	= NULL;
+	ops->setup		= oprofile_hrtimer_setup;
+	ops->shutdown		= oprofile_hrtimer_shutdown;
+	ops->start		= oprofile_hrtimer_start;
+	ops->stop		= oprofile_hrtimer_stop;
+	ops->cpu_type		= "timer";
+	printk(KERN_INFO "oprofile: using timer interrupt.\n");
+	return 0;
+}
-- 
1.7.7


