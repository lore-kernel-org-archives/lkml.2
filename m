Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab1IKPI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 11:08:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:33708 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1IKPI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:08:58 -0400
Subject: Re: [patch v3 30/36] Hexagon: Add page-fault support.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110909010917.578513171@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
	 <20110909010917.578513171@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 12:08:49 -0300
Message-ID: <1315753729.455.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 20:09 -0500, Richard Kuo wrote:

> +/*
> + * Canonical page fault handler
> + */
> +void do_page_fault(unsigned long address, long cause, struct pt_regs *regs)
> +{
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm = current->mm;
> +	siginfo_t info;
> +	int si_code;
> +	int fault;
> +	const struct exception_table_entry *fixup;
> +
> +	si_code = SEGV_MAPERR;
> +	local_irq_enable();
> +
> +	/*
> +	 * If we're in an interrupt or have no user context,
> +	 * then must not take the fault.
> +	 */
> +	if (unlikely(in_interrupt() || !mm))
> +		goto no_context;

Are you sure about enabling interrupts before going to "no_context" ?

If somebody does a user access "in atomic" with interrupt disabled (with
the expectation that a fault would be caught by search_exception_tables
and returned as -EFAULT), such code probably doesn't expect interrupts
to be re-enabled implicitely.

Cheers,
Ben.


