Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2L1VoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:44:08 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:58136 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2L1VoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:44:05 -0500
Date: Fri, 28 Dec 2012 16:44:00 -0500
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org
Subject: [PATCH v2 15/25] x86/mce: don't use [delayed_]work_pending()
Message-ID: <20121228214400.GI3062@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-16-git-send-email-tj@kernel.org>
 <20121225110742.GA7720@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121225110742.GA7720@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from x86/mce.  Only compile tested.

v2: Local var work removed from mce_schedule_work() as suggested by
    Borislav.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac@vger.kernel.org
---
Applied to wq/for-3.9-cleanups.  Thanks.

Thanks.

 arch/x86/kernel/cpu/mcheck/mce.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -512,11 +512,8 @@ int mce_available(struct cpuinfo_x86 *c)
 
 static void mce_schedule_work(void)
 {
-	if (!mce_ring_empty()) {
-		struct work_struct *work = &__get_cpu_var(mce_work);
-		if (!work_pending(work))
-			schedule_work(work);
-	}
+	if (!mce_ring_empty())
+		schedule_work(&__get_cpu_var(mce_work));
 }
 
 DEFINE_PER_CPU(struct irq_work, mce_irq_work);
@@ -1351,12 +1348,7 @@ int mce_notify_irq(void)
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
