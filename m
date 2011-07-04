Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1GDHeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:34:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:23788 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1GDHeK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 4 Jul 2011 03:34:10 -0400
Message-Id: <4E11890D020000780004BF40@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 04 Jul 2011 08:34:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/6] x86,64: Separate arg1 from rbp handling in
	 SAVE_REGS_IRQ
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-5-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1309624184-9790-5-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.07.11 at 18:29, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Just for clarity in the code. Have a first block that handles
> the frame pointer and a separate one that handles pt_regs
> pointer and its use.

While possible indeed making the code easier to read, it increases the
chance of a latency related stall (due to the write to %rdi immediately
preceding its use as a memory operand's address).

Jan

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jan Beulich <JBeulich@novell.com>
> ---
>  arch/x86/kernel/entry_64.S |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b6b2e85..20dc8e6 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -310,9 +310,10 @@ ENDPROC(native_usergs_sysret64)
>  	movq_cfi r10, R10-RBP
>  	movq_cfi r11, R11-RBP
>  
> -	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
>  	movq_cfi rbp, 0		/* push %rbp */
>  	movq %rsp, %rbp
> +
> +	leaq -RBP(%rsp),%rdi	/* arg1 for handler */
>  	testl $3, CS(%rdi)
>  	je 1f
>  	SWAPGS




