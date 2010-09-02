Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0IBXJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:09:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49668 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab0IBXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:09:07 -0400
Message-Id: <1283468946.15328.1393106295@webmail.messagingengine.com>
X-Sasl-Enc: NSOB4UkBXelIbN3KSkY23yOmQcYspshel54LbDkM5iir 1283468946
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4C7FBCF00200007800013F99@vpn.id2.novell.com>
Subject: Re: [PATCH] i386: add unwind directives to syscall ptregs stubs
In-Reply-To: <4C7FBCF00200007800013F99@vpn.id2.novell.com>
Date: Fri, 03 Sep 2010 01:09:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 14:04 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> When these stubs are actual functions (i.e. having a return
> instruction) and have stack manipulation instructions in them, they
> should also be annotated to allow unwinding through them.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Compiles to exactly the same machine code.

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

> ---
>  arch/x86/kernel/entry_32.S    |  16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.36-rc3/arch/x86/kernel/entry_32.S
> +++ 2.6.36-rc3-x86-push-pop-cfi/arch/x86/kernel/entry_32.S
> @@ -750,14 +710,18 @@ ptregs_##name: \
>  #define PTREGSCALL3(name) \
>  	ALIGN; \
>  ptregs_##name: \
> +       CFI_STARTPROC; \
>  	leal 4(%esp),%eax; \
> -       pushl %eax; \
> +       pushl_cfi %eax; \
>  	movl PT_EDX(%eax),%ecx; \
>  	movl PT_ECX(%eax),%edx; \
>  	movl PT_EBX(%eax),%eax; \
>  	call sys_##name; \
>  	addl $4,%esp; \
> -       ret
> +       CFI_ADJUST_CFA_OFFSET -4; \
> +       ret; \
> +       CFI_ENDPROC; \
> +ENDPROC(ptregs_##name)
>  
>  PTREGSCALL1(iopl)
>  PTREGSCALL0(fork)
> @@ -772,15 +736,19 @@ PTREGSCALL1(vm86old)
>  /* Clone is an oddball.  The 4th arg is in %edi */
>  	ALIGN;
>  ptregs_clone:
> +       CFI_STARTPROC
>  	leal 4(%esp),%eax
> -       pushl %eax
> -       pushl PT_EDI(%eax)
> +       pushl_cfi %eax
> +       pushl_cfi PT_EDI(%eax)
>  	movl PT_EDX(%eax),%ecx
>  	movl PT_ECX(%eax),%edx
>  	movl PT_EBX(%eax),%eax
>  	call sys_clone
>  	addl $8,%esp
> +       CFI_ADJUST_CFA_OFFSET -8
>  	ret
> +       CFI_ENDPROC
> +ENDPROC(ptregs_clone)
>  
>  .macro FIXUP_ESPFIX_STACK
>  /*
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
