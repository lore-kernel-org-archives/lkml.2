Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0GRLFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 07:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0GRLFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 07:05:05 -0400
Message-ID: <4C42DF9A.5090908@redhat.com>
Date: Sun, 18 Jul 2010 14:03:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
References: <20100714154923.947138065@efficios.com>	<20100714155804.049012415@efficios.com>	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>	<20100714170617.GB4955@Krystal>	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>	<20100714203940.GC22096@Krystal>	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>	<20100714222115.GA30122@Krystal>	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com> <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
In-Reply-To: <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 04:23 AM, Linus Torvalds wrote:
> On Wed, Jul 14, 2010 at 3:37 PM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>    
>> I think the %rip check should be pretty simple - exactly because there
>> is only a single point where the race is open between that 'mov' and
>> the 'iret'. So it's simpler than the (similar) thing we do for
>> debug/nmi stack fixup for sysenter that has to check a range.
>>      
> So this is what I think it might look like, with the %rip in place.
> And I changed the "nmi_stack_ptr" thing to have both the pointer and a
> flag - because it turns out that in the single-instruction race case,
> we actually want the old pointer.
>
> Totally untested, of course. But _something_ like this might work:
>
> #
> # Two per-cpu variables: a "are we nested" flag (one byte), and
> # a "if we're nested, what is the %rsp for the nested case".
> #
> # The reason for why we can't just clear the saved-rsp field and
> # use that as the flag is that we actually want to know the saved
> # rsp for the special case of having a nested NMI happen on the
> # final iret of the unnested case.
> #
> nmi:
> 	cmpb $0,%__percpu_seg:nmi_stack_nesting
> 	jne nmi_nested_corrupt_and_return
> 	cmpq $nmi_iret_address,0(%rsp)
> 	je nmi_might_be_nested
> 	# create new stack
> is_unnested_nmi:
> 	# Save some space for nested NMI's. The exception itself
> 	# will never use more space, but it might use less (since
> 	# if will be a kernel-kernel transition). But the nested
> 	# exception will want two save registers and a place to
> 	# save the original CS that it will corrupt
> 	subq $64,%rsp
>
> 	# copy the five words of stack info. 96 = 64 + stack
> 	# offset of ss.
> 	pushq 96(%rsp)   # ss
> 	pushq 96(%rsp)   # rsp
> 	pushq 96(%rsp)   # eflags
> 	pushq 96(%rsp)   # cs
> 	pushq 96(%rsp)   # rip
>
> 	# and set the nesting flags
> 	movq %rsp,%__percpu_seg:nmi_stack_ptr
> 	movb $0xff,%__percpu_seg:nmi_stack_nesting
>
>    

By trading off some memory, we don't need this trickery.  We can 
allocate two nmi stacks, so the code becomes:

nmi:
     cmpb $0, %__percpu_seg:nmi_stack_nesting
     je unnested_nmi
     cmpq $nmi_iret,(%rsp)
     jne unnested_nmi
     cmpw $__KERNEL_CS,8(%rsp)
     jne unnested_nmi
     popf
     retfq
unnested_nmi:
     xorq $(nmi_stack_1 ^ nmi_stack_2),%__percpu_seg:tss_nmi_ist_entry
     movb $1, __percpu_seg:nmi_stack_nesting
regular_nmi:
     ...
regular_nmi_end:
     movb $0, __percpu_seg:nmi_stack_nesting
nmi_iret:
     iretq




-- 
error compiling committee.c: too many arguments to function

