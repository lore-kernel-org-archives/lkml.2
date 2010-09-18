Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0IRKNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 06:13:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:58342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0IRKNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 06:13:53 -0400
Date: Sat, 18 Sep 2010 10:13:05 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, arjan@linux.intel.com, drescherjm@gmail.com,
        art.08.09@gmail.com, damien.wyart@free.fr, suresh.b.siddha@intel.com,
        tglx@linutronix.de, nix@esperi.org.uk, borislav.petkov@amd.com,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, andreas.herrmann3@amd.com, drescherjm@gmail.com,
        art.08.09@gmail.com, damien.wyart@free.fr, suresh.b.siddha@intel.com,
        tglx@linutronix.de, nix@esperi.org.uk, borislav.petkov@amd.com,
        venki@google.com
In-Reply-To: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
References: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/timers] x86: Hpet: Avoid the comparator readback penalty
Message-ID: <tip-995bd3bb5c78f3ff71339803c0b8337ed36d64fb@git.kernel.org>
Git-Commit-ID: 995bd3bb5c78f3ff71339803c0b8337ed36d64fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Sep 2010 10:13:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  995bd3bb5c78f3ff71339803c0b8337ed36d64fb
Gitweb:     http://git.kernel.org/tip/995bd3bb5c78f3ff71339803c0b8337ed36d64fb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 15 Sep 2010 15:11:57 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 18 Sep 2010 12:09:13 +0200

x86: Hpet: Avoid the comparator readback penalty

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
Tested-by: Nix <nix@esperi.org.uk>
Tested-by: Artur Skawina <art.08.09@gmail.com>
Cc: Damien Wyart <damien.wyart@free.fr>
Tested-by: John Drescher <drescherjm@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>

---
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
