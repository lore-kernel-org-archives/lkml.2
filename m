Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0JVHQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:16:44 -0400
Received: from www.tglx.de ([62.245.132.106]:55735 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab0JVHQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:16:43 -0400
Date: Fri, 22 Oct 2010 09:16:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] x86 timers for 2.6.37
Message-ID: <alpine.LFD.2.00.1010220914560.3467@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-timers-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      x86: Hpet: Avoid the comparator readback penalty


 arch/x86/kernel/hpet.c |   51 +++++++++++++++++++----------------------------
 1 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 410fdb3..0b568b3 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -380,44 +380,35 @@ static int hpet_next_event(unsigned long delta,
 			   struct clock_event_device *evt, int timer)
 {
 	u32 cnt;
+	s32 res;
 
 	cnt = hpet_readl(HPET_COUNTER);
 	cnt += (u32) delta;
 	hpet_writel(cnt, HPET_Tn_CMP(timer));
 
 	/*
-	 * We need to read back the CMP register on certain HPET
-	 * implementations (ATI chipsets) which seem to delay the
-	 * transfer of the compare register into the internal compare
-	 * logic. With small deltas this might actually be too late as
-	 * the counter could already be higher than the compare value
-	 * at that point and we would wait for the next hpet interrupt
-	 * forever. We found out that reading the CMP register back
-	 * forces the transfer so we can rely on the comparison with
-	 * the counter register below. If the read back from the
-	 * compare register does not match the value we programmed
-	 * then we might have a real hardware problem. We can not do
-	 * much about it here, but at least alert the user/admin with
-	 * a prominent warning.
-	 *
-	 * An erratum on some chipsets (ICH9,..), results in
-	 * comparator read immediately following a write returning old
-	 * value. Workaround for this is to read this value second
-	 * time, when first read returns old value.
-	 *
-	 * In fact the write to the comparator register is delayed up
-	 * to two HPET cycles so the workaround we tried to restrict
-	 * the readback to those known to be borked ATI chipsets
-	 * failed miserably. So we give up on optimizations forever
-	 * and penalize all HPET incarnations unconditionally.
+	 * HPETs are a complete disaster. The compare register is
+	 * based on a equal comparison and neither provides a less
+	 * than or equal functionality (which would require to take
+	 * the wraparound into account) nor a simple count down event
+	 * mode. Further the write to the comparator register is
+	 * delayed internally up to two HPET clock cycles in certain
+	 * chipsets (ATI, ICH9,10). We worked around that by reading
+	 * back the compare register, but that required another
+	 * workaround for ICH9,10 chips where the first readout after
+	 * write can return the old stale value. We already have a
+	 * minimum delta of 5us enforced, but a NMI or SMI hitting
+	 * between the counter readout and the comparator write can
+	 * move us behind that point easily. Now instead of reading
+	 * the compare register back several times, we make the ETIME
+	 * decision based on the following: Return ETIME if the
+	 * counter value after the write is less than 8 HPET cycles
+	 * away from the event or if the counter is already ahead of
+	 * the event.
 	 */
-	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
-		if (hpet_readl(HPET_Tn_CMP(timer)) != cnt)
-			printk_once(KERN_WARNING
-				"hpet: compare register read back failed.\n");
-	}
+	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
+	return res < 8 ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
