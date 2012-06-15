Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab2FONpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab2FONpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:45:11 -0400
Date: Fri, 15 Jun 2012 08:08:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: sedat.dilek@gmail.com
Cc: Eric B Munson <emunson@mgebm.net>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Subject: Re: WARNING: at arch/x86/kernel/kvmclock.c:127
Message-ID: <20120615110837.GA14316@amt.cnet>
References: <CA+icZUUD+oHPK=L6iHg-FfkpXVCPQTKHuzwDo9EaYYjYmYePCA@mail.gmail.com>
 <0669740d6e2f3648f1c5c9a50e72f6eb@mgebm.net>
 <20120611220719.GA27415@amt.cnet>
 <ff5b99576bc8f0cbe81a432ddae5f9b5@mgebm.net>
 <20120612021352.GA2845@amt.cnet>
 <CA+icZUVpVPQUMuv13vonO=fed8qMxaXXTO9BYOh8ps316ePrGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUVpVPQUMuv13vonO=fed8qMxaXXTO9BYOh8ps316ePrGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:35:58AM +0200, Sedat Dilek wrote:
> On Tue, Jun 12, 2012 at 4:13 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Mon, Jun 11, 2012 at 06:10:34PM -0400, Eric B Munson wrote:
> >> On Mon, 11 Jun 2012 19:07:19 -0300, Marcelo Tosatti wrote:
> >> >On Mon, Jun 11, 2012 at 05:47:00PM -0400, Eric B Munson wrote:
> >> >>On Sun, 10 Jun 2012 17:47:24 +0200, Sedat Dilek wrote:
> >> >>>Hi,
> >> >>>
> >> >>>I see the same warning especially when resuming from a suspend (see
> >> >>>timestamps >=30-35sec) between Linux v3.5-rc1..v3.5-rc2.
> >> >>>
> >> >>>$ sudo grep kvmclock.c /var/log/kern.log
> >> >>>Jun  4 21:11:32 fambox kernel: [  784.037237] WARNING: at
> >> >>>arch/x86/kernel/kvmclock.c:127
> >> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
> >> >>>Jun  5 20:35:57 fambox kernel: [ 1928.458060] WARNING: at
> >> >>>arch/x86/kernel/kvmclock.c:127
> >> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
> >> >>>Jun  8 09:35:52 fambox kernel: [ 3290.134637] WARNING: at
> >> >>>arch/x86/kernel/kvmclock.c:127
> >> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
> >> >>>Jun  8 09:35:52 fambox kernel: [ 3290.238592] WARNING: at
> >> >>>arch/x86/kernel/kvmclock.c:127
> >> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
> >> >>>Jun  8 12:11:20 fambox kernel: [ 5777.023571] WARNING: at
> >> >>>arch/x86/kernel/kvmclock.c:127
> >> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
> >> >>>Jun  9 13:32:50 fambox kernel: [ 2778.842695] WARNING: at
> >> >>>arch/x86/kernel/kvmclock.c:127
> >> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
> >> >>>
> >> >>>From [1]:
> >> >>>
> >> >>>"...The warning itself is not required for the check_and_clear
> >> >>>function and can be removed as far as I am concerned."
> >> >>>
> >> >>>From [2] commit 3b5d56b9317fa7b5407dff1aa7b115bf6cdbd494
> >> >>("kvmclock:
> >> >>>Add functions to check if the host has stopped the vm")
> >> >>>...
> >> >>>+bool kvm_check_and_clear_guest_paused(void)
> >> >>>+{
> >> >>>+       bool ret = false;
> >> >>>+       struct pvclock_vcpu_time_info *src;
> >> >>>+
> >> >>>+       /*
> >> >>>+        * per_cpu() is safe here because this function is only
> >> >>>called from
> >> >>>+        * timer functions where preemption is already disabled.
> >> >>>+        */
> >> >>>+       WARN_ON(!in_atomic());
> >> >>>+       src = &__get_cpu_var(hv_clock);
> >> >>>+       if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
> >> >>>+               __this_cpu_and(hv_clock.flags,
> >> >>>~PVCLOCK_GUEST_STOPPED);
> >> >>>+               ret = true;
> >> >>>+       }
> >> >>>+
> >> >>>+       return ret;
> >> >>>+}
> >> >>>+EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
> >> >>>+
> >> >>>...
> >> >>>( The export macro was dropped in a followup commit. )
> >> >>>
> >> >>>So you mean "WARN_ON(!in_atomic());" can be deleted?
> >> >
> >> >Yes.
> >> >
> >> >>When I wrote the patch originally, I was under the (incorrect)
> >> >>assumption that the watch dog was only ever reset in an atomic
> >> >>context.  Given that this is not the case, the warning can be
> >> >>removed.  Though before that happens, I have a question: if this is
> >> >>called outside of an atomic context, is the use of __get_cpu_Var()
> >> >>and __this_cpu_and() invalid?
> >> >
> >> >It remains valid because its called with interrupts
> >> >disabled (see migrate_hrtimers).
> >>
> >> Thank you, that was my assumption but I wanted to confirm.  I do not
> >> have access to my working kernel tree and won't for 2 days.  I can't
> >> get to the patch until late Wednesday so if someone else wants to
> >> work that up I'd appreciate it.
> >>
> >> Thanks,
> >> Eric
> >
> > Removed the warning in kvm.git master.
> >
> 
> Unfortunately, I was busy this week with familiar affairs.
> I have seen too late that Marcelo sent me the patch via PM.
> 
> Marcelo, could you please give credits to people next time, Thanks.
> 
> I am missing sth. like this in the commit now in Linus upstream GIT...
> 
> Reported-by: Frank Arnold <frank.arnold@...> (hidden - me reads KVM ML offline)
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com> (lazy guy - could
> have reported earlier)
> Acked-by or Reviewed-by: Eric B Munson <emunson@mgebm.net>
> 
> - Sedat -
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=e32025a56403df4386cd61a741c0a36afe79ae8a

Sedat,

You are right, sorry for not giving appropriate credit.

Unfortunately we cannot change the commit message now.

Thanks anyway for reporting.

