Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2KMHxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:53:03 -0500
Received: from mail.in-ulm.de ([217.10.8.10]:57744 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753134Ab2KMHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:52:57 -0500
Date: Tue, 13 Nov 2012 08:52:54 +0100
From: Christian Ehrhardt <lk@c--e.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Christian Ehrhardt <lk@c--e.de>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fix lapic time counter read for periodic mode
Message-ID: <20121113075254.GA15071@lisa.in-ulm.de>
References: <20121111122528.GC19718@lisa.in-ulm.de>
 <20121112213237.GA31377@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112213237.GA31377@amt.cnet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

thanks for your reply.

On Mon, Nov 12, 2012 at 07:32:37PM -0200, Marcelo Tosatti wrote:
> > there is a bug in the emulation of the lapic time counter. In particular
> > what we are seeing is that the time counter of a periodic lapic timer
> > in the guest reads as zero 99% of the time. The patch below fixes that.
> > 
> > The emulation of the lapic timer is done with the help of a hires
> > timer that expires with the same frequency as the lapic counter.
> > New expiration times for a periodic timer are calculated incrementally
> > based on the last scheduled expiration time. This ensures long term
> > accuracy of the emulated timer close to that of the underlying clock.
> > 
> > The actual value of the lapic time counter is calculated from the
> > real time difference between current time and scheduled expiration time
> > of the hires timer. If this difference is negative, the hires timer
> > expired. For oneshot mode this is correctly translated into a zero value
> > for the time counter. However, in periodic mode we must use the negative
> > difference unmodified.
> > 
> >      regards   Christian
> > 
> > Fix lapic time counter read for periodic mode.
> 
> In periodic mode the hrtimer is rearmed once expired, see
> apic_timer_fn. So _get_remaining should return proper value
> even if the guest is not able to process timer interrupts. 
> 
> Can you describe your specific scenario in more detail?

In my specific case, the host is admittedly somewhat special as it
already is a rehosted version of linux, i.e. not running directly on
native hardware. It is still unclear if the host has sufficiently accurate
timer interrupts. This is most likely part of the problems we are seeing.

However, AFAICS apic_timer_fn is only called once per jiffy (at least in
some configurations). In particular, it is not called by
hrtimer_get_remaining. Thus depending on the frequency of the LAPIC timer
in the guest there might _several_ iterations that are missed. This can
probably be mitigated by a hires timer interrupts. However, I think
the problem is still there even in that case.

Additionally, the behaviour that I want to establish matches that of the
PIT timer (in a not completely obvious way, though).

Having said that the proposed patch in my first mail is incomplete, as
the mod_64 does not work correctly for negative values. A fixed version
is below.

     regards     Christian

Signed-off-by: Christian Ehrhardt <lk@c--e.de>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 43e9fad..ec7242c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -810,11 +810,22 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	if (kvm_apic_get_reg(apic, APIC_TMICT) == 0)
 		return 0;
 
+	/*
+	 * hrtimer_get_remaining returns the signed difference between
+	 * timer expiration time and current time. Keep negative return
+	 * values iff the the timer is periodic.
+	 */
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
-	if (ktime_to_ns(remaining) < 0)
-		remaining = ktime_set(0, 0);
+	ns = ktime_to_ns(remaining);
+	if (unlikely(ns < 0)) {
+		if (apic_lvtt_period(apic))
+			ns = apic->lapic_timer.period -
+				mod_64(-ns, apic->lapic_timer.period);
+		else
+			ns = 0;
+	}
 
-	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
+	ns = mod_64(ns, apic->lapic_timer.period);
 	tmcct = div64_u64(ns,
 			 (APIC_BUS_CYCLE_NS * apic->divide_count));
 
