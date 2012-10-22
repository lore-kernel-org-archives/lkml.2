Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2JVVwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:52:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2JVVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:52:00 -0400
Date: Mon, 22 Oct 2012 14:51:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-Id: <20121022145158.53bddfc1.akpm@linux-foundation.org>
In-Reply-To: <20121022213449.GH31440@moon>
References: <20121022191452.785366817@openvz.org>
	<20121022122934.d2e2fa57.akpm@linux-foundation.org>
	<5085B1A8.4020609@parallels.com>
	<20121022205641.GL2303@moon>
	<20121022213449.GH31440@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 01:34:49 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>
> ...
>
> +VmFlags: rd ex mr mw me de

ho hum OK, let's do that.
  
> +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> +{
> +	/*
> +	 * Don't forget to update Documentation/ on changes.
> +	 */
> +
> +#define __seq_show_vmflag(_f, _s)		\
> +	do {					\
> +		if (vma->vm_flags & (_f))	\
> +			seq_puts(m, _s);	\
> +	} while (0)
> +
> +	seq_puts(m, "VmFlags: ");
> +
> +	__seq_show_vmflag(VM_READ,	"rd ");
> +	__seq_show_vmflag(VM_WRITE,	"wr ");
> +	__seq_show_vmflag(VM_EXEC,	"ex ");
> +	__seq_show_vmflag(VM_SHARED,	"sh ");
> +	__seq_show_vmflag(VM_MAYREAD,	"mr ");
> +	__seq_show_vmflag(VM_MAYWRITE,	"mw ");
> +	__seq_show_vmflag(VM_MAYEXEC,	"me ");
> +	__seq_show_vmflag(VM_MAYSHARE,	"ms ");
> +	__seq_show_vmflag(VM_GROWSDOWN,	"gd ");
> +	__seq_show_vmflag(VM_PFNMAP,	"pf ");
> +	__seq_show_vmflag(VM_DENYWRITE,	"dw ");
> +	__seq_show_vmflag(VM_LOCKED,	"lo ");
> +	__seq_show_vmflag(VM_IO,	"io ");
> +	__seq_show_vmflag(VM_SEQ_READ,	"sr ");
> +	__seq_show_vmflag(VM_RAND_READ,	"rr ");
> +	__seq_show_vmflag(VM_DONTCOPY,	"dc ");
> +	__seq_show_vmflag(VM_DONTEXPAND,"de ");
> +	__seq_show_vmflag(VM_ACCOUNT,	"ac ");
> +	__seq_show_vmflag(VM_NORESERVE,	"nr ");
> +	__seq_show_vmflag(VM_HUGETLB,	"ht ");
> +	__seq_show_vmflag(VM_NONLINEAR,	"nl ");
> +	__seq_show_vmflag(VM_ARCH_1,	"ar ");
> +	__seq_show_vmflag(VM_DONTDUMP,	"dd ");
> +	__seq_show_vmflag(VM_MIXEDMAP,	"mm ");
> +	__seq_show_vmflag(VM_HUGEPAGE,	"hg ");
> +	__seq_show_vmflag(VM_NOHUGEPAGE,"nh ");
> +	__seq_show_vmflag(VM_MERGEABLE,	"mg ");
> +
> +	seq_putc(m, '\n');
> +
> +#undef __seq_show_vmflag
> +}

This code would be much denser if we did the old

	static const char foo[] = "rdwrexshmrmw...";
	unsigned i;

	for (i = 0; i < BITS_PER_LONG; i++) {
		if (flags & (1 << i))
			seq_printf("%c%c ", foo[i * 2], foo[i * 2 + 1]);
	}

trick.  But then we'd have to remember to fix foo[] each time we
alter the flags, so maybe let's not do that.

