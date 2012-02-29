Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386Ab2B2XQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:16:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45690 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965370Ab2B2XQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:16:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, vgoyal@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
	<20120216172735.GX9751@redhat.com>
	<CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
	<20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org>
	<m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com>
	<m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com>
	<m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com>
Date: Wed, 29 Feb 2012 15:19:11 -0800
In-Reply-To: <20120221135934.GF26998@redhat.com> (Don Zickus's message of
	"Tue, 21 Feb 2012 08:59:34 -0500")
Message-ID: <m1ipip6xe8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+FEAk7Q3Hj2GBwIhW5yMEMWHFp3xci14w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Don Zickus <dzickus@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> On Tue, Feb 21, 2012 at 12:01:07AM -0800, Eric W. Biederman wrote:
>> Don Zickus <dzickus@redhat.com> writes:
>> 
>> 2> On Fri, Feb 17, 2012 at 07:21:52PM -0800, Eric W. Biederman wrote:
>> >> Don Zickus <dzickus@redhat.com> writes:
>> >> 
>> >> > On Fri, Feb 17, 2012 at 04:41:01AM -0800, Eric W. Biederman wrote:
>> >> >> 
>> >> >> The fix with a guarantee of no more scope creep is to just disable the
>> >> >> nmi watchdog on the kexec on panic path.
>> >> >> 
>> >> >> Don if you have time please figure out is needed to ignore nmi's and
>> >> >> possible record and/or report them while we boot, otherwise please cook
>> >> >> up a patch that just disables the nmi watchdog wherever we are sending
>> >> >> it from (the local apic or the ioapic).
>> >> >
>> >> > Can I keep things even simpler?  The original problem was the deadlock
>> >> > with the ioapic lock.  We fixed that by removing the call to
>> >> > disable_IO_APIC().  Can we just leave the disable_local_APIC calls in
>> >> > there for now?  Is there any real harm?
>> >> 
>> >> > All this rewrite is going to take time which will delay fixing a current
>> >> > problem with kexec on panic, the ioapic deadlock.
>> >> 
>> >> Hmm.
>> >> 
>> >> My apologies I just realized that we can not disable the nmi watchdog
>> >> safely in all cases.  To avoid the deadlock we fundamentally can not
>> >> write to the io_apic, because the locks are the io_apic write path.
>> >> The nmi watchdog can be sourced from either the local apics or the
>> >> io_apics.  To disable the nmi_watchdog we need at least potentially
>> >> to write io_apic.
>> >
>> > I am curious where you see the nmi watchdog being sourced from the ioapic?
>> > I thought I removed that code 3 or 4 releases ago.
>> 
>> In my memory, and in references to the code in comments in various apic
>> related code.  I couldn't figure out what the current code was doing and
>> assumed the implementation was equivalent.  It does look like you
>> removed the code that used the io_apic.  I still haven't figured
>> out just how the new implementation works yet.
>
> It is just a client of perf now.  Perf controls the local apic accesses.
> A lot simpler now.
>
>> 
>> So maybe in the short term we can safely just stomp the timer that
>> triggers the nmi watchdog in the local apic.  Over the long term that
>> feels like it is just asking for trouble.
>
> I can understand that.
>
>> 
>> I wonder if the reason that we have an hpet stomp in that code is
>> for a similar reason.  Did we ever source nmi's from the hpet timer?
>> 
>> >> So it appears to me that the only reasonable and robust thing we can
>> >> do is to ignore nmis in the kexec on panic path.
>> >> 
>> >> So it looks to me that the only path forward at this point is to fix
>> >> the other bug where an unexpected nmi will kill the kexec on panic boot.
>> >> 
>> >> I just took a look at the code in /sbin/kexec and that code does not in
>> >> fact change the idt except when we switch to 16bit mode, which we
>> >> definitely do not do in the kexec on panic case.  So it appears that we
>> >> don't need to coordinate an /sbin/kexec release with a kernel release to
>> >> ignore nmis.
>> >> 
>> >> In fact it looks like we only need to fix the interrupt descriptors
>> >> loaded in machine_kexec_64.c and head64.c to ignore nmis.
>> >> 
>> >> At which point we will have fixed two bugs and have a much more reliable
>> >> kexec on panic implementation.
>> >
>> > Ok.  I'll talk with Vivek about how the can be implemented.
>> 
>> Thanks.  It really doesn't look very hard.  Just a tiny idt with
>> an nmi entry that says iret.
>
> It probably is, except I never hacked on idt code before and my assembly
> isn't that good.  I have been trying to find examples to copy from to give
> it a try.  So far I was using early_idt_handlers with early_printk to see
> if I could capture some printk messages while jumping from the first
> kernel to the second kernel (when the other early_idt_handlers would kick
> in for the second kernel).
>
> Tips?  Better examples?

That is a particularly good example.  When I took a quick look earlier
that is the first place we reload the idt in the kernel boot so that is
one of two places that needs to be modified.

The other place in the reboot code page (which will be a little tricky
because of it's relocatability) needs to have code that roughly says:

kexec_nmi_handler:
        ; Does this vector get any other kind of parameters and saved
        ; registers that we need to restore?
        ; Different types of exceptions handlers have different rules
        ; that I don't remember off the top of my head. call gates, trap
 	; gates, etc.
	iret

kexec_idt:
	.long 0, 0				; IDT entry 0
	.long 0, 0				; IDT entry 1
	.long something, kexec_nmi_handler 	; IDT entry 2 NMI's

You can write to the kexec_idt from C code and for the nmi handler you
just need to make certain all is good.

The code has to be tested and the proper Intel CPU manual should
probably be consulted to make certain you dot your eyes and cross your
t's but we really don't need much code to change on this path.

Eric

p.s. Apologies for the delay I overlooked this message earlier.
