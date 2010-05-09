Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0EIJTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 05:19:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48022 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0EIJTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 05:19:41 -0400
Date: Sun, 9 May 2010 10:18:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: tom.leiming@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: fix inbalance of hardirqs trace before return to
	user or exception
Message-ID: <20100509091856.GA29763@n2100.arm.linux.org.uk>
References: <1273377379-18078-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273377379-18078-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 11:56:19AM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch introduces macro of trace_ret_hardirqs_on, which will
> call asm_trace_hardirqs_on if I flag in the stored CPSR is zero.
> 
> The patch adds trace_ret_hardirqs_on before returning to user
> or exception mode once disable_irq was called explicitly, which does
> fix the inbalance of hardirqs trace and make lockdep happy. The patch
> does fix this kind of lockdep warning below:

I'm not convinced that this is required in all the places you're adding
it.  Eg, in the return-to-user case, userspace _always_ has IRQs
enabled, and when we enter kernel space from the exception handler, we
always enable IRQs.  Returning from any syscall with IRQs disabled is a
bug, and so that _should_ produce a warning.

In fact, returning to user mode with IRQs disabled in _any_ case is a
bug.

Please provide your reasoning for adding this to every path.

Finally, using asm_trace_hardirqs_on is extremely expensive, and in
many cases the register saving is completely wasteful.  That's why
places were doing this:

#ifdef CONFIG_TRACE_IRQFLAGS
        tst     r4, #PSR_I_BIT
        bleq    trace_hardirqs_on
#endif

which is much more efficient.
