Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0KSRA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:00:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab0KSRA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:00:26 -0500
Date: Fri, 19 Nov 2010 11:59:52 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101119165952.GJ18100@redhat.com>
References: <20101112172755.GR4823@redhat.com>
 <20101116184325.GB4823@redhat.com>
 <4CE2E3C3.6060800@windriver.com>
 <20101118080516.GJ32621@elte.hu>
 <4CE52048.5080802@windriver.com>
 <1290086232.2109.1507.camel@laptop>
 <20101118193247.GF18100@redhat.com>
 <4CE583D0.8050407@windriver.com>
 <20101118200807.GC8131@redhat.com>
 <1290112234.2109.1534.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290112234.2109.1534.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:30:33PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 15:08 -0500, Don Zickus wrote:
> > On Thu, Nov 18, 2010 at 01:51:44PM -0600, Jason Wessel wrote:
> > > > So the problem is when the nmi watchdog is enabled, the perf event is
> > > > 'active' and thus tries to read the counter value.  Because it is always
> > > > zero, perf just assumes the counter overflowed and the NMI is his.
> > > >
> > > > Not sure how to fix it yet, other than include the logic that detects we
> > > > are on a guest and disable perf??
> > > >
> > > >   
> > > 
> > > I highly doubt we want to disable perf.   I would rather use the source
> > > and fix the nmi emulation in KVM/Qemu after we hear back the results
> > 
> > Well I think Peter does not have a positive opinion about emulating perf
> > inside a guest.  
> 
> Well, I'll let someone else write it.. I tihnk its pretty pointless to
> have, the whole virt layer totally destroys many (if not all) useful
> metrics.
> 
> But I don't have a problem with full msr emulation, what I do not like
> is a direct msr passthough bypassing perf.
> 
> > Nor are the KVM folks having much success in doing so.
> 
> Just busy doing other stuff I guess.. Jes was going to prod at it at
> some point.
> 
> > Just to clarify, perf counter emulation is _not_ implemented in kvm.
> > Therefore disabling perf in the guest makes sense until someone gets
> > around to actually writing the emulation code for perf in a guest. :-)
> 
> Right, which is what I proposed, on init do a checking_wrmsrl() on a
> known PMU reg, KVM/qemu should fault on that.. (I'd prefer it if they'd
> also fault on reading it too).

Reading the kvm code in arch/x86/kernel/kvm/x86.c, it seems like they do
_not_ fault on writes, only on some (which don't include a bunch of the
perfctrs).  The reason seems to be to prevent older distros from falling
apart that could not handle those faults properly.

I thought about a patch like this, but it only works for kvm and doesn't
really solve the problem for other virt-machines like xen and vmware.

Cheers,
Don


diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bbe3c4a..ef7119e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -493,6 +493,10 @@ static int x86_setup_perfctr(struct perf_event *event)
 
 static int x86_pmu_hw_config(struct perf_event *event)
 {
+	
+	if (perf_guest_cbs && !perf_guest_cbs->is_perfctr_emulated())
+		return -EOPNOTSUPP;
+
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2288ad8..58203ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4600,10 +4600,16 @@ static unsigned long kvm_get_guest_ip(void)
 	return ip;
 }
 
+static int kvm_is_perfctr_emulated(void)
+{
+	return 0;
+}
+
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.is_in_guest		= kvm_is_in_guest,
 	.is_user_mode		= kvm_is_user_mode,
 	.get_guest_ip		= kvm_get_guest_ip,
+	.is_perfctr_emulated	= kvm_is_perfctr_emulated,
 };
 
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..9cb500b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -469,6 +469,7 @@ struct perf_guest_info_callbacks {
 	int (*is_in_guest) (void);
 	int (*is_user_mode) (void);
 	unsigned long (*get_guest_ip) (void);
+	int (*is_perfctr_emulated) (void);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
