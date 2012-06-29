Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab2F2U3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:29:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2F2U3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:29:36 -0400
Date: Fri, 29 Jun 2012 13:29:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Fix a possible deadlock in panic()
Message-Id: <20120629132935.45f731e1.akpm@linux-foundation.org>
In-Reply-To: <1340926985-8270-1-git-send-email-markivx@codeaurora.org>
References: <1340926985-8270-1-git-send-email-markivx@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 16:43:05 -0700
Vikram Mulukutla <markivx@codeaurora.org> wrote:

> panic_lock is meant to ensure that panic processing takes
> place only on one cpu; if any of the other cpus encounter
> a panic, they will spin waiting to be shut down.
> 
> However, this causes a regression in this scenario:
> 
> 1. Cpu 0 encounters a panic and acquires the panic_lock
>    and proceeds with the panic processing.
> 2. There is an interrupt on cpu 0 that also encounters
>    an error condition and invokes panic.
> 3. This second invocation fails to acquire the panic_lock
>    and enters the infinite while loop in panic_smp_self_stop.
> 
> Thus all panic processing is stopped, and the cpu is stuck
> for eternity in the while(1) inside panic_smp_self_stop.
> 
> To address this, disable local interrupts with
> local_irq_disable before acquiring the panic_lock. This will
> prevent interrupt handlers from executing during the panic
> processing, thus avoiding this particular problem.
> 
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -75,6 +75,14 @@ void panic(const char *fmt, ...)
>  	int state = 0;
>  
>  	/*
> +	 * Disable local interrupts. This will prevent panic_smp_self_stop
> +	 * from deadlocking the first cpu that invokes the panic, since
> +	 * there is nothing to prevent an interrupt handler (that runs
> +	 * after the panic_lock is acquired) from invoking panic again.
> +	 */
> +	local_irq_disable();
> +
> +	/*
>  	 * It's possible to come here directly from a panic-assertion and
>  	 * not have preempt disabled. Some functions called from here want
>  	 * preempt to be disabled. No point enabling it later though...

Seems sane.  panic() *should* work correctly when called with
interrupts disabled, so there be no bad effects from internally
disabling interrupts.  If there are bad effects, we should fix them up.

