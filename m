Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2FLIsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:48:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42713 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2FLIsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:48:32 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120612021352.GA2845@amt.cnet>
References: <CA+icZUUD+oHPK=L6iHg-FfkpXVCPQTKHuzwDo9EaYYjYmYePCA@mail.gmail.com>
	<0669740d6e2f3648f1c5c9a50e72f6eb@mgebm.net>
	<20120611220719.GA27415@amt.cnet>
	<ff5b99576bc8f0cbe81a432ddae5f9b5@mgebm.net>
	<20120612021352.GA2845@amt.cnet>
Date: Tue, 12 Jun 2012 10:48:31 +0200
Message-ID: <CA+icZUVw5_vpUcp9JrAV2qPdUKhZtt5RLNuRw3Z=GZMezEU0yA@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/kvmclock.c:127
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 4:13 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jun 11, 2012 at 06:10:34PM -0400, Eric B Munson wrote:
>> On Mon, 11 Jun 2012 19:07:19 -0300, Marcelo Tosatti wrote:
>> >On Mon, Jun 11, 2012 at 05:47:00PM -0400, Eric B Munson wrote:
>> >>On Sun, 10 Jun 2012 17:47:24 +0200, Sedat Dilek wrote:
>> >>>Hi,
>> >>>
>> >>>I see the same warning especially when resuming from a suspend (see
>> >>>timestamps >=30-35sec) between Linux v3.5-rc1..v3.5-rc2.
>> >>>
>> >>>$ sudo grep kvmclock.c /var/log/kern.log
>> >>>Jun  4 21:11:32 fambox kernel: [  784.037237] WARNING: at
>> >>>arch/x86/kernel/kvmclock.c:127
>> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
>> >>>Jun  5 20:35:57 fambox kernel: [ 1928.458060] WARNING: at
>> >>>arch/x86/kernel/kvmclock.c:127
>> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
>> >>>Jun  8 09:35:52 fambox kernel: [ 3290.134637] WARNING: at
>> >>>arch/x86/kernel/kvmclock.c:127
>> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
>> >>>Jun  8 09:35:52 fambox kernel: [ 3290.238592] WARNING: at
>> >>>arch/x86/kernel/kvmclock.c:127
>> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
>> >>>Jun  8 12:11:20 fambox kernel: [ 5777.023571] WARNING: at
>> >>>arch/x86/kernel/kvmclock.c:127
>> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
>> >>>Jun  9 13:32:50 fambox kernel: [ 2778.842695] WARNING: at
>> >>>arch/x86/kernel/kvmclock.c:127
>> >>>kvm_check_and_clear_guest_paused+0x52/0x60()
>> >>>
>> >>>From [1]:
>> >>>
>> >>>"...The warning itself is not required for the check_and_clear
>> >>>function and can be removed as far as I am concerned."
>> >>>
>> >>>From [2] commit 3b5d56b9317fa7b5407dff1aa7b115bf6cdbd494
>> >>("kvmclock:
>> >>>Add functions to check if the host has stopped the vm")
>> >>>...
>> >>>+bool kvm_check_and_clear_guest_paused(void)
>> >>>+{
>> >>>+       bool ret = false;
>> >>>+       struct pvclock_vcpu_time_info *src;
>> >>>+
>> >>>+       /*
>> >>>+        * per_cpu() is safe here because this function is only
>> >>>called from
>> >>>+        * timer functions where preemption is already disabled.
>> >>>+        */
>> >>>+       WARN_ON(!in_atomic());
>> >>>+       src = &__get_cpu_var(hv_clock);
>> >>>+       if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
>> >>>+               __this_cpu_and(hv_clock.flags,
>> >>>~PVCLOCK_GUEST_STOPPED);
>> >>>+               ret = true;
>> >>>+       }
>> >>>+
>> >>>+       return ret;
>> >>>+}
>> >>>+EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
>> >>>+
>> >>>...
>> >>>( The export macro was dropped in a followup commit. )
>> >>>
>> >>>So you mean "WARN_ON(!in_atomic());" can be deleted?
>> >
>> >Yes.
>> >
>> >>When I wrote the patch originally, I was under the (incorrect)
>> >>assumption that the watch dog was only ever reset in an atomic
>> >>context.  Given that this is not the case, the warning can be
>> >>removed.  Though before that happens, I have a question: if this is
>> >>called outside of an atomic context, is the use of __get_cpu_Var()
>> >>and __this_cpu_and() invalid?
>> >
>> >It remains valid because its called with interrupts
>> >disabled (see migrate_hrtimers).
>>
>> Thank you, that was my assumption but I wanted to confirm.  I do not
>> have access to my working kernel tree and won't for 2 days.  I can't
>> get to the patch until late Wednesday so if someone else wants to
>> work that up I'd appreciate it.
>>
>> Thanks,
>> Eric
>
> Removed the warning in kvm.git master.
>

I am reading your email approx. 6hrs after you have sent it and I do
NOT see the patch in [1].
Can you please send me the patch as an attachment, Thanks!

- Sedat -

[1] http://git.kernel.org/?p=virt/kvm/kvm.git;a=shortlog;h=refs/heads/master
