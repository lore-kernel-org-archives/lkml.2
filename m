Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0GOBYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:24:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757932Ab0GOBYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:24:09 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
	<20100714222115.GA30122@Krystal>
	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
Date: Wed, 14 Jul 2010 18:23:29 -0700
Message-ID: <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 3:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think the %rip check should be pretty simple - exactly because there
> is only a single point where the race is open between that 'mov' and
> the 'iret'. So it's simpler than the (similar) thing we do for
> debug/nmi stack fixup for sysenter that has to check a range.

So this is what I think it might look like, with the %rip in place.
And I changed the "nmi_stack_ptr" thing to have both the pointer and a
flag - because it turns out that in the single-instruction race case,
we actually want the old pointer.

Totally untested, of course. But _something_ like this might work:

#
# Two per-cpu variables: a "are we nested" flag (one byte), and
# a "if we're nested, what is the %rsp for the nested case".
#
# The reason for why we can't just clear the saved-rsp field and
# use that as the flag is that we actually want to know the saved
# rsp for the special case of having a nested NMI happen on the
# final iret of the unnested case.
#
nmi:
	cmpb $0,%__percpu_seg:nmi_stack_nesting
	jne nmi_nested_corrupt_and_return
	cmpq $nmi_iret_address,0(%rsp)
	je nmi_might_be_nested
	# create new stack
is_unnested_nmi:
	# Save some space for nested NMI's. The exception itself
	# will never use more space, but it might use less (since
	# if will be a kernel-kernel transition). But the nested
	# exception will want two save registers and a place to
	# save the original CS that it will corrupt
	subq $64,%rsp

	# copy the five words of stack info. 96 = 64 + stack
	# offset of ss.
	pushq 96(%rsp)   # ss
	pushq 96(%rsp)   # rsp
	pushq 96(%rsp)   # eflags
	pushq 96(%rsp)   # cs
	pushq 96(%rsp)   # rip

	# and set the nesting flags
	movq %rsp,%__percpu_seg:nmi_stack_ptr
	movb $0xff,%__percpu_seg:nmi_stack_nesting

regular_nmi_code:
	...
	# regular NMI code goes here, and can take faults,
	# because this sequence now has proper nested-nmi
	# handling
	...
nmi_exit:
	movb $0,%__percpu_seg:nmi_stack_nesting
nmi_iret_address:
	iret

# The saved rip points to the final NMI iret, after we've cleared
# nmi_stack_ptr. Check the CS segment to make sure.
nmi_might_be_nested:
	cmpw $__KERNEL_CS,8(%rsp)
	jne is_unnested_nmi

# This is the case when we hit just as we're supposed to do the final
# iret of a previous nmi.  We run the NMI using the old return address
# that is still on the stack, rather than copy the new one that is bogus
# and points to where the nested NMI interrupted the original NMI
# handler!
# Easy: just reset the stack pointer to the saved one (this is why
# we use a separate "valid" flag, so that we can still use the saved
# stack pointer)
	movq %__percpu_seg:nmi_stack_ptr,%rsp
	jmp regular_nmi_code

# This is the actual nested case.  Make sure we fault on iret by setting
# CS to zero and saving the old CS.  %rax contains the stack pointer to
# the original code.
nmi_nested_corrupt_and_return:
	pushq %rax
	pushq %rdx
	movq %__percpu_seg:nmi_stack_ptr,%rax
	movq 8(%rax),%rdx	# CS of original NMI
	testq %rdx,%rdx		# CS already zero?
	je nmi_nested_and_already_corrupted
	movq %rdx,40(%rax)	# save old CS away
	movq $0,8(%rax)
nmi_nested_and_already_corrupted:
	popq %rdx
	popq %rax
	popfq
	jmp *(%rsp)

Hmm?

               Linus
