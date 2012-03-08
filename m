Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2CHErV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:47:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56591 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2CHErS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:47:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, vgoyal@redhat.com
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
	<20120216172735.GX9751@redhat.com>
	<CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
	<20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org>
	<m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com>
	<m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com>
	<m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp>
	<4F573E74.5040504@oss.ntt.co.jp> <4F573EF0.1080501@oss.ntt.co.jp>
Date: Wed, 07 Mar 2012 20:50:35 -0800
In-Reply-To: <4F573EF0.1080501@oss.ntt.co.jp> ("Fernando Luis =?utf-8?Q?V?=
 =?utf-8?Q?=C3=A1zquez?= Cao"'s
	message of "Wed, 07 Mar 2012 19:56:48 +0900")
Message-ID: <m1399j1ysk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/n6oOXiVJaKhCp1X5sZCOZPnO+8Zb/9Mg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Fernando Luis V=c3=a1zquez Cao <fernando@oss.ntt.co.jp>?=
X-Spam-Relay-Country: **
Subject: Re: [PATCH 2/2] boot: add early NMI counter
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> writes:

> Subject: [PATCH] boot: add early NMI counter
>
> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>
> We currently ignore early NMIs but it would be nice to be able to
> know whether they actually occurred.
>
> This patch adds an early NMI counter and exports it trough
> /proc/interrupts with the name of ENM (Early NMI).

For a userspace interface I suspect we just want to dump the count
into the NMI counter.

It probably makes sense to have a separate variable in early boot like
you do, but then about the time we setup the normal NMI handler move the
NMI count over and possibly do something like reboot if that is our
policy.

I don't see it making sense to educate userspace for an edge case like
this.

Eric


> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
>
> diff -urNp linux-3.3-rc6-orig/arch/x86/include/asm/processor.h linux-3.3-rc6/arch/x86/include/asm/processor.h
> --- linux-3.3-rc6-orig/arch/x86/include/asm/processor.h	2012-03-07 15:49:01.826241682 +0900
> +++ linux-3.3-rc6/arch/x86/include/asm/processor.h	2012-03-07 18:52:27.668054122 +0900
> @@ -402,6 +402,7 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
>  DECLARE_PER_CPU(unsigned int, irq_count);
>  extern unsigned long kernel_eflags;
>  extern asmlinkage void ignore_sysret(void);
> +extern unsigned int early_nmi_count;
>  #else	/* X86_64 */
>  #ifdef CONFIG_CC_STACKPROTECTOR
>  /*
> diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head_64.S linux-3.3-rc6/arch/x86/kernel/head_64.S
> --- linux-3.3-rc6-orig/arch/x86/kernel/head_64.S	2012-03-07 18:51:17.583160114 +0900
> +++ linux-3.3-rc6/arch/x86/kernel/head_64.S	2012-03-07 18:54:37.205699422 +0900
> @@ -327,6 +327,7 @@ early_exception_handler:
>  	jmp 1b
>  
>  early_nmi_handler:
> +	incl early_nmi_count(%rip) # exported as ENM in /proc/interrupts
>  	iretq
>  
>  #ifdef CONFIG_EARLY_PRINTK
> @@ -340,6 +341,10 @@ early_idt_ripmsg:
>  #endif /* CONFIG_EARLY_PRINTK */
>  	.previous
>  
> +	.globl early_nmi_count
> +early_nmi_count:
> +	.long 0
> +
>  #define NEXT_PAGE(name) \
>  	.balign	PAGE_SIZE; \
>  ENTRY(name)
> diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/irq.c linux-3.3-rc6/arch/x86/kernel/irq.c
> --- linux-3.3-rc6-orig/arch/x86/kernel/irq.c	2012-03-07 15:49:01.838241839 +0900
> +++ linux-3.3-rc6/arch/x86/kernel/irq.c	2012-03-07 18:55:14.078179448 +0900
> @@ -125,6 +125,7 @@ int arch_show_interrupts(struct seq_file
>  #if defined(CONFIG_X86_IO_APIC)
>  	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
>  #endif
> +	seq_printf(p, "%*s: %10u\n", prec, "ENM", early_nmi_count);
>  	return 0;
>  }
>  
