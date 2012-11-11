Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2KKMcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:32:12 -0500
Received: from mail.in-ulm.de ([217.10.8.10]:44151 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752730Ab2KKMcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:32:10 -0500
Date: Sun, 11 Nov 2012 13:25:28 +0100
From: Christian Ehrhardt <lk@c--e.de>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fix lapic time counter read for periodic mode
Message-ID: <20121111122528.GC19718@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

there is a bug in the emulation of the lapic time counter. In particular
what we are seeing is that the time counter of a periodic lapic timer
in the guest reads as zero 99% of the time. The patch below fixes that.

The emulation of the lapic timer is done with the help of a hires
timer that expires with the same frequency as the lapic counter.
New expiration times for a periodic timer are calculated incrementally
based on the last scheduled expiration time. This ensures long term
accuracy of the emulated timer close to that of the underlying clock.

The actual value of the lapic time counter is calculated from the
real time difference between current time and scheduled expiration time
of the hires timer. If this difference is negative, the hires timer
expired. For oneshot mode this is correctly translated into a zero value
for the time counter. However, in periodic mode we must use the negative
difference unmodified.

     regards   Christian

Fix lapic time counter read for periodic mode.

Signed-off-by: Christian Ehrhardt <lk@c--e.de>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 43e9fad..eff902d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -810,8 +810,13 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	if (kvm_apic_get_reg(apic, APIC_TMICT) == 0)
 		return 0;
 
+	/*
+	 * hrtimer_get_remaining returns the signed difference between
+	 * timer expiration time and current time. Keep negative return
+	 * value iff the the timer is periodic.
+	 */
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
-	if (ktime_to_ns(remaining) < 0)
+	if (ktime_to_ns(remaining) < 0 && !apic_lvtt_period(apic))
 		remaining = ktime_set(0, 0);
 
 	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
