Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2JCMfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:35:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47492 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2JCMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:35:10 -0400
Date: Wed, 3 Oct 2012 14:35:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCHv3] perf x86_64: Fix rsp register for system call fast path
Message-ID: <20121003123448.GA637@somewhere>
References: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
 <1349174644.7780.23.camel@twins>
 <20121002145815.GH6379@krava.brq.redhat.com>
 <20121002154914.GC10605@somewhere>
 <20121002160626.GA26598@krava.brq.redhat.com>
 <20121002161633.GF10605@somewhere>
 <20121003122947.GB945@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003122947.GB945@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 02:29:47PM +0200, Jiri Olsa wrote:
> +#ifdef CONFIG_X86_64
> +__weak void

Only annotate with __weak the default implementation you want to be
overriden. Here you want it to actually override the default __weak version.

> +arch_sample_regs_user_fixup(struct perf_regs_user *uregs, int kernel)
> +{
> +	/*
> +	 * If the perf event was triggered within the kernel code
> +	 * path, then it was either syscall or interrupt. While
> +	 * interrupt stores almost all user registers, the syscall
> +	 * fast path does not. At this point we can at least set
> +	 * rsp register right, which is crucial for dwarf unwind.
> +	 *
> +	 * The syscall_get_nr function returns -1 (orig_ax) for
> +	 * interrupt, and positive value for syscall.
> +	 *
> +	 * We have two race windows in here:
> +	 *
> +	 * 1) Few instructions from syscall entry until old_rsp is
> +	 *    set.
> +	 *
> +	 * 2) In syscall/interrupt path from entry until the orig_ax
> +	 *    is set.
> +	 *
> +	 * Above described race windows are fractional opposed to
> +	 * the syscall fast path, so we get much better results
> +	 * fixing rsp this way.
> +	 */
> +	if (kernel && (syscall_get_nr(current, uregs->regs) >= 0)) {
> +		/* Make a copy and link it to regs pointer. */
> +		memcpy(&uregs->regs_copy, uregs->regs, sizeof(*uregs->regs));
> +		uregs->regs = &uregs->regs_copy;
> +
> +		/* And fix the rsp. */
> +		uregs->regs->sp = this_cpu_read(old_rsp);
> +	}
> +}
> +#endif
