Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512Ab2EOCeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:34:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:49832 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965441Ab2EOCSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 148/179] x86: Hpet: Avoid the comparator readback penalty
Date: Mon, 14 May 2012 22:14:04 -0400
Message-ID: <1337048075-6132-149-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 995bd3bb5c78f3ff71339803c0b8337ed36d64fb upstream.

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
[PG: diffstat differs from 995bd3bb since deleted comment was re-wrapped]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/hpet.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index c5f8121..e3be610 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -381,36 +381,35 @@ static int hpet_next_event(unsigned long delta,
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
-	 * An erratum on some chipsets (ICH9,..), results in comparator read
-	 * immediately following a write returning old value. Workaround
-	 * for this is to read this value second time, when first
-	 * read returns old value.
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
-		WARN_ONCE(hpet_readl(HPET_Tn_CMP(timer)) != cnt,
-		  KERN_WARNING "hpet: compare register read back failed.\n");
-	}
+	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
+	return res < 8 ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,
-- 
1.7.9.6

