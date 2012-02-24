Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab2BXOgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:36:33 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:51403 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2BXOgc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 24 Feb 2012 09:36:32 -0500
Message-Id: <4F47AE7D0200007800074ABB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 14:36:29 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Steven Rostedt" <srostedt@redhat.com>
Cc: <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
        <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix CFI annotations for NMI nesting code
References: <4F478B630200007800074A31@nat28.tlf.novell.com>
 <1330092690.3306.18.camel@fedora>
In-Reply-To: <1330092690.3306.18.camel@fedora>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.02.12 at 15:11, Steven Rostedt <srostedt@redhat.com> wrote:
> On Fri, 2012-02-24 at 12:06 +0000, Jan Beulich wrote:
>>  	/* Make another copy, this one may be modified by nested NMIs */
>>  	.rept 5
>>  	pushq_cfi 4*8(%rsp)
> 
> Half way through this copy (the rept is not atomic) we get an NMI, it
> sees that we are nested so it updates this copy of the interrupt frame
> and returns. Now the rest of the copy finishes so we end up with a half
> and half stack frame (half to go back to restart_nmi and half to go back
> to the original location of the stack). The result is a system crash.
> 
> But! There is a fix to this. We can move the setting of the special
> variable to here and make this the "repeart_nmi" instead. The nested NMI
> checks that we are not in the repeat nmi before updating the stack. If
> it interrupted in the repeat nmi it will just return knowing a repeat is
> about to take place anyway.
> 
> 
> So instead of adding restart_nmi here, add:
> 
> repeat_nmi:
> 	/* Update the stack variable to say we are in NMI */
> 	movq $1, 5*8(%rsp)
> 	
> 	/* Make another copy, this one may be modified by nested NMIs */
> 	.rept 5
> 	pushq_cfi 4*8(%rsp)
> end_repeat_nmi:
> 
> 
> And just continue. We only need to protect against updating the stack
> and the nested NMI will not touch it if it interrupted RIP is between
> repeat_nmi and end_repeat_nmi. But there's no reason that we can't just
> set the iret jump to go back into the middle of the NMI handler.
> 
> Would that work for you?

Of course, thanks for spotting this oversight of mine. I assume you
meant the end_repeat_nmi to go after the .endr though, not before.
I'll get a fixed patch sent out soon.

Jan

> Also we need to add a comment about this. Just above the repeat_nmi:
> 
> 	/*
> 	 * If there was a nested NMI, the first NMI's iret will return
> 	 * here. But NMIs are still enabled and we can take another
> 	 * nested NMI. The nested NMI checks the interrupted RIP to see
> 	 * if it is between repeat_nmi and end_repeat_nmi, and if so
> 	 * it will just return, as we are about to repeat an NMI anyway.
> 	 * This makes it safe to copy to the stack frame that a nested
> 	 * NMI will update.
> 	 */
> 
> 
> -- Steve
> 
>>  	.endr
>> -
>> -	/* Do not pop rdx, nested NMIs will corrupt it */
>> -	movq 11*8(%rsp), %rdx
>> +	CFI_DEF_CFA_OFFSET SS+8-RIP
>>  
>>  	/*
>>  	 * Everything below this point can be preempted by a nested
>> @@ -1639,7 +1647,6 @@ first_nmi:
>>  	 * caused by an exception and nested NMI will start here, and
>>  	 * can still be preempted by another NMI.
>>  	 */
>> -restart_nmi:
>>  	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
>>  	subq $ORIG_RAX-R15, %rsp
>>  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>> @@ -1665,8 +1672,6 @@ nmi_restore:
>>  	/* Clear the NMI executing stack variable */
>>  	movq $0, 10*8(%rsp)
>>  	jmp irq_return
>> -	CFI_ENDPROC
>> -END(nmi)
>>  
>>  	/*
>>  	 * If an NMI hit an iret because of an exception or breakpoint,
>> @@ -1675,18 +1680,12 @@ END(nmi)
>>  	 * stack to jump to here when it does the final iret.
>>  	 */
>>  repeat_nmi:
>> -	INTR_FRAME
>>  	/* Update the stack variable to say we are still in NMI */
>>  	movq $1, 5*8(%rsp)
>> -
>> -	/* copy the saved stack back to copy stack */
>> -	.rept 5
>> -	pushq_cfi 4*8(%rsp)
>> -	.endr
>> -
>>  	jmp restart_nmi
>> -	CFI_ENDPROC
>>  end_repeat_nmi:
>> +	CFI_ENDPROC
>> +END(nmi)
>>  
>>  ENTRY(ignore_sysret)
>>  	CFI_STARTPROC
>> 
>> 
>> 



