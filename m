Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2BPROV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:14:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab2BPROU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:14:20 -0500
Message-ID: <4F3D395B.1000708@redhat.com>
Date: Thu, 16 Feb 2012 19:14:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Amit Shah <amit.shah@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com> <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com> <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com> <4F3D2C09.1020803@redhat.com> <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com>
In-Reply-To: <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 06:45 PM, Andy Lutomirski wrote:
> >
> >> So I could have messed up, or there could be a subtle
> >> bug somewhere.  Any ideas?
> >
> > What's the code trying to do?  Execute an instruction from an
> > non-executable page, trap the #PF, and emulate?  And what are the
> > symptoms? wrong error code for the #PF?  That could easily be a kvm bug.
> >
>
> The symptom is that some kind of access to a page that's supposed to
> be readable, NX is reporting error 5.  I'm not quite sure what kind of
> access is causing that.

Might it be a fetch access, with kvm forgetting to set bit 4 correctly?

> >
> > Can you point me at the code in question?
>
> The setup code is in arch/x86/kernel/vsyscall_64.c in map_vsyscall.
> The bad access is to the vsyscall page.

The bad access is on purpose, yes?

>From fault.c:

#ifdef CONFIG_X86_64
                /*
                 * Instruction fetch faults in the vsyscall page might need
                 * emulation.
                 */
                if (unlikely((error_code & PF_INSTR) &&
                             ((address & ~0xfff) == VSYSCALL_START))) {
                        if (emulate_vsyscall(regs, address))
                                return;
                }
#endif

so it seems like kvm doesn't set PF_INSTR?

I thought we unit tested that, but maybe not this exact scenario.


-- 
error compiling committee.c: too many arguments to function

