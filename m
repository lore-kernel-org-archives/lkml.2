Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2BPRgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:36:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50981 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BPRgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:36:17 -0500
MIME-Version: 1.0
In-Reply-To: <4F3D395B.1000708@redhat.com>
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com>
 <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com>
 <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
 <4F3D2C09.1020803@redhat.com> <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com>
 <4F3D395B.1000708@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Feb 2012 09:35:57 -0800
Message-ID: <CALCETrXjJtKLhe2rRkuy57Ai+5X2-+qh9eMbE5y-UhX=CPWftA@mail.gmail.com>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
To: Avi Kivity <avi@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 9:14 AM, Avi Kivity <avi@redhat.com> wrote:
> On 02/16/2012 06:45 PM, Andy Lutomirski wrote:
>> >
>> >> So I could have messed up, or there could be a subtle
>> >> bug somewhere.  Any ideas?
>> >
>> > What's the code trying to do?  Execute an instruction from an
>> > non-executable page, trap the #PF, and emulate?  And what are the
>> > symptoms? wrong error code for the #PF?  That could easily be a kvm bug.
>> >
>>
>> The symptom is that some kind of access to a page that's supposed to
>> be readable, NX is reporting error 5.  I'm not quite sure what kind of
>> access is causing that.
>
> Might it be a fetch access, with kvm forgetting to set bit 4 correctly?
>
>> >
>> > Can you point me at the code in question?
>>
>> The setup code is in arch/x86/kernel/vsyscall_64.c in map_vsyscall.
>> The bad access is to the vsyscall page.
>
> The bad access is on purpose, yes?
>
> From fault.c:
>
> #ifdef CONFIG_X86_64
>                /*
>                 * Instruction fetch faults in the vsyscall page might need
>                 * emulation.
>                 */
>                if (unlikely((error_code & PF_INSTR) &&
>                             ((address & ~0xfff) == VSYSCALL_START))) {
>                        if (emulate_vsyscall(regs, address))
>                                return;
>                }
> #endif
>
> so it seems like kvm doesn't set PF_INSTR?

Yes, this is on purpose, and you're almost certainly right (and I feel
dumb for not figuring this out immediately).  The error message is:

segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff103d72f8 error 5

which is garbage.  The instruction at 0xffffffffff600400 can't fetch
itself as data and fault on the data access (at least not in 64-bit
mode, as far as I can think of, without evil messing with the TLBs).

So... what do we do about this?  This (whitespace-damaged, untested)
patch will probably work around it well enough to boot the system:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d74824..52b9522 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -741,8 +741,11 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long
                 * Instruction fetch faults in the vsyscall page might need
                 * emulation.
                 */
-               if (unlikely((error_code & PF_INSTR) &&
+               if (unlikely(address == regs->ip && !(error_code & PF_WRITE) &&
                             ((address & ~0xfff) == VSYSCALL_START))) {
+                       WARN_ONCE(!(error_code & PF_INSTR),
+                                 "Fixing up bogus vsyscall read fault -- "
+                                 "your hypervisor is buggy.");
                        if (emulate_vsyscall(regs, address))
                                return;
                }

Before we patch the guest like this, though, it would be nice to know
what hosts are affected.  If it's just one version of RHEL6, maybe it
makes sense to fix the hypervisor and either leave the guest alone or
just add a warning saying to fix your hypervisor, like:

WARN_ONCE(address == regs->ip && !(error_code & (PF_INSTR | PF_WRITE))
&& user_64bit_mode(regs), "Fishy page fault -- you might need to fix
your hypervisor");

near some exit path in the page fault handler.  The 64-bit check is
because (I think) 32-bit code can mess with regs->ip using a cs offset
in the LDT and trigger the warning at will.

--Andy
