Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0IONMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:12:34 -0400
Received: from www.tglx.de ([62.245.132.106]:46502 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab0IONMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:12:33 -0400
Date: Wed, 15 Sep 2010 15:11:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Nix <nix@esperi.org.uk>, Artur Skawina <art.08.09@gmail.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH RFC] x86: hpet: Avoid the readback penalty
In-Reply-To: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
Message-ID: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, tip-bot for Thomas Gleixner wrote:
> x86: hpet: Work around hardware stupidity

After my brain recovered from yesterdays exposure with the x86 timer
horror, I came up with a different solution for this problem, which
avoids the readback of the compare register completely. It works
nicely on my affected ATI system, but needs some exposure to the other
machines.

Comments ?

Thanks,

	tglx
---
Subject: x86: hpet: Avoid the readback penalty
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 15 Sep 2010 14:32:17 +0200

Due to the overly intelligent design of HPETs, we need to workaround
the problem that the compare value which we write is already behind
the actual counter value at the point where the value hits the real
compare register. This happens for two reasons:

1) We read out the counter, add the delta and write the result to the
   compare register. When a NMI or SMI hits between the read out and
   the write then the counter can be ahead of the event already

2) The write to the compare register is delayed by up to two HPET
   cycles in certain chipsets.

We worked around this by reading back the compare register to make
sure that the written value has hit the hardware. For certain ICH9+
chipsets this can require two readouts, as the first one can return
the previous compare register value. That's bad performance wise for
the normal case where the event is far enough in the future.

As we already know that the write can be delayed by up to two cycles
we can avoid the read back of the compare register completely if we
make the decision whether the delta has elapsed already or not based
on the following calculation:

  cmp = event - actual_count;

If cmp is less than 8 HPET clock cycles, then we decide that the event
has happened already and return -ETIME. That covers the above #1 and
#2 problems which would cause a wait for HPET wraparound (~306
seconds).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c |   51 ++++++++++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hpet.c
+++ linux-2.6-tip/arch/x86/kernel/hpet.c
@@ -380,44 +380,35 @@ static int hpet_next_event(unsigned long
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
+	 * based on a equal comparison and does provide a less than or
+	 * equal functionality (which would require to take the
+	 * wraparound into account) and it does not provide a simple
+	 * count down event mode. Further the write to the comparator
+	 * register is delayed internaly up to two HPET clock cycles
+	 * in certain chipsets (ATI, ICH9,10). We worked around that
+	 * by reading back the compare register, but that required
+	 * another workaround for ICH9,10 chips where the first
+	 * readout after write can return the old stale value. We
+	 * already have a minimum delta of 5us enforced, but a NMI or
+	 * SMI hitting between the counter readout and the comparator
+	 * write can move us behind that point easily. Now instead of
+	 * reading the compare register back several times, we make
+	 * the ETIME decision based on the following: Return ETIME if
+	 * the counter value after the write is less than 8 HPET
+	 * cycles away from the event or if the counter is already
+	 * ahead of the event.
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
