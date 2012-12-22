Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2LVCBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:01:52 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:33965 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2LVB62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:28 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org
Subject: [PATCH 15/25] x86/mce: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:05 -0800
Message-Id: <1356141435-17340-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from x86/mce.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 arch/x86/kernel/cpu/mcheck/mce.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 80dbda8..c06a736 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -514,8 +514,7 @@ static void mce_schedule_work(void)
 {
 	if (!mce_ring_empty()) {
 		struct work_struct *work = &__get_cpu_var(mce_work);
-		if (!work_pending(work))
-			schedule_work(work);
+		schedule_work(work);
 	}
 }
 
@@ -1351,12 +1350,7 @@ int mce_notify_irq(void)
 		/* wake processes polling /dev/mcelog */
 		wake_up_interruptible(&mce_chrdev_wait);
 
-		/*
-		 * There is no risk of missing notifications because
-		 * work_pending is always cleared before the function is
-		 * executed.
-		 */
-		if (mce_helper[0] && !work_pending(&mce_trigger_work))
+		if (mce_helper[0])
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
-- 
1.8.0.2

