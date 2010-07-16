Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab0GPTNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:13:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43750 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758995Ab0GPTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:13:07 -0400
Date: Fri, 16 Jul 2010 15:13:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100716191304.GB8309@Krystal>
References: <20100714203940.GC22096@Krystal> <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com> <20100714222115.GA30122@Krystal> <AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com> <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com> <AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com> <20100715183153.GA9276@Krystal> <AANLkTilfXUtQznSzOmO9ecoaviIt62Hv6jdUOMSRLdrF@mail.gmail.com> <AANLkTimAn0uMpeYKctO0qxM6nwbfev3RHARLZIbf991k@mail.gmail.com> <20100715220117.GA1499@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715220117.GA1499@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:50:26 up 174 days, 21:27,  6 users,  load average: 0.08, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

What I omitted in my original description paragraph is that I also test for NMIs
nested over NMI "regular code" with a "nesting" per-cpu flag, which deals with
the concerns you expressed in your reply about function calls and traps.

I'm self-replying to keep track of Avi's comment about the need to save/restore
cr2 at the beginning/end of the NMI handler, so we don't end up corrupting a VM
CR2 if we have the following scenario: trap in VM, NMI, trap in NMI. So I added
cr2 awareness to the code snippet below, so we should be close to have something
that starts to make sense. (although I'm not saying it's bug-free yet) ;)

Please note that I'll be off on vacation for 2 weeks starting this evening (back
on August 2) without Internet access, so my answers might be delayed.

Thanks !

Mathieu


Code originally written by Linus Torvalds, modified by Mathieu Desnoyers
intenting to handle the fake NMI entry gracefully given that NMIs are not
necessarily disabled at the entry point. It uses a "need fake NMI" flag rather
than playing games with CS and faults. When a fake NMI is needed, it simply
jumps back to the beginning of regular nmi code. NMI exit code and fake NMI
entry are made reentrant with respect to NMI handler interruption by testing, at
the very beginning of the NMI handler, if a NMI is nested over the whole
nmi_atomic ..  nmi_atomic_end code region. It also tests for nested NMIs by
keeping a per-cpu "nmi nested" flag"; this deals with detection of nesting over
the "regular nmi" execution. This code assumes NMIs have a separate stack.

#
# Two per-cpu variables: a "are we nested" flag (one byte).
# a "do we need to execute a fake NMI" flag (one byte).
# The %rsp at which the stack copy is saved is at a fixed address, which leaves
# enough room at the bottom of NMI stack for the "real" NMI entry stack. This
# assumes we have a separate NMI stack.
# The NMI stack copy top of stack is at nmi_stack_copy.
# The NMI stack copy "rip" is at nmi_stack_copy_rip, which is set to
# nmi_stack_copy-40.
#
nmi:
	# Test if nested over atomic code.
	cmpq $nmi_atomic,0(%rsp)
	jae nmi_addr_is_ae
	# Test if nested over general NMI code.
	cmpb $0,%__percpu_seg:nmi_stack_nesting
	jne nmi_nested_set_fake_and_return
	# create new stack
is_unnested_nmi:
	# Save some space for nested NMI's. The exception itself
	# will never use more space, but it might use less (since
	# if will be a kernel-kernel transition).

	# Save %rax on top of the stack (need to temporarily use it)
	pushq %rax
	movq %rsp, %rax
	movq $nmi_stack_copy,%rsp

	# copy the five words of stack info. rip starts at 8+0(%rax).
	# cr2 is saved at nmi_stack_copy_rip+40
	pushq %cr2          # save cr2 to handle nesting over page faults
	pushq 8+32(%rax)    # ss
	pushq 8+24(%rax)    # rsp
	pushq 8+16(%rax)    # eflags
	pushq 8+8(%rax)     # cs
	pushq 8+0(%rax)     # rip
	movq 0(%rax),%rax   # restore %rax

set_nmi_nesting:
	# and set the nesting flags
	movb $0xff,%__percpu_seg:nmi_stack_nesting

regular_nmi_code:
	...
	# regular NMI code goes here, and can take faults,
	# because this sequence now has proper nested-nmi
	# handling
	...

nmi_atomic:
	# An NMI nesting over the whole nmi_atomic .. nmi_atomic_end region will
	# be handled specially. This includes the fake NMI entry point.
	cmpb $0,%__percpu_seg:need_fake_nmi
	jne fake_nmi
	movb $0,%__percpu_seg:nmi_stack_nesting
	# restore cr2
	movq %nmi_stack_copy_rip+40,%cr2
	iret

	# This is the fake NMI entry point.
fake_nmi:
	movb $0x0,%__percpu_seg:need_fake_nmi
	jmp regular_nmi_code
nmi_atomic_end:

	# Make sure the address is in the nmi_atomic range and in CS segment.
nmi_addr_is_ae:
	cmpq $nmi_atomic_end,0(%rsp)
	jae is_unnested_nmi
	# The saved rip points to the final NMI iret. Check the CS segment to
	# make sure.
	cmpw $__KERNEL_CS,8(%rsp)
	jne is_unnested_nmi

# This is the case when we hit just as we're supposed to do the atomic code
# of a previous nmi.  We run the NMI using the old return address that is still
# on the stack, rather than copy the new one that is bogus and points to where
# the nested NMI interrupted the original NMI handler!
# Easy: just set the stack pointer to point to the stack copy, clear
# need_fake_nmi (because we are directly going to execute the requested NMI) and
# jump to "nesting flag set" (which is followed by regular nmi code execution).
	movq $nmi_stack_copy_rip,%rsp
	movb $0x0,%__percpu_seg:need_fake_nmi
	jmp set_nmi_nesting

# This is the actual nested case. Make sure we branch to the fake NMI handler
# after this handler is done.
nmi_nested_set_fake_and_return:
	movb $0xff,%__percpu_seg:need_fake_nmi
	popfq
	jmp *(%rsp)


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
