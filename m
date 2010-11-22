Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0KVIHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:07:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37577 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0KVIHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:07:21 -0500
Date: Mon, 22 Nov 2010 09:07:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
Message-ID: <20101122080710.GA1510@elte.hu>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290410581.2405.24.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> Hi, all
> 
> Current -tip tree(92c883a) fail to resume after suspend to mem.
> Bisect to commit 5bd5a45(x86: Add NX protection for kernel data).
> 
> commit 5bd5a452662bc37c54fb6828db1a3faf87e6511c
> Author: Matthieu Castet <castet.matthieu@free.fr>
> Date:   Tue Nov 16 22:31:26 2010 +0100
> 
>     x86: Add NX protection for kernel data
> 
> 
> I did some debug and found the regression is caused by below line.
> 
> -       set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
> +       set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);
> 
> In my machine,
> rodata_start=0xffffffff81a00000, end=0xffffffff81e00000, kernel_end=0xffffffff82200000
> 
> Without this commit, kernel page table dumps
> 
> ---[ High Kernel Mapping ]---
> ....
> 0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE GLB NX pmd
> 0xffffffff81c00000-0xffffffff81d91000        1604K     ro             GLB NX pte
> 0xffffffff81d91000-0xffffffff81e00000         444K     ro             GLB NX pte
> 0xffffffff81e00000-0xffffffff82000000           2M     RW         PSE GLB x  pmd
> 0xffffffff82000000-0xffffffff8200c000          48K     RW             GLB x  pte
> 0xffffffff8200c000-0xffffffff82100000         976K     RW             GLB x  pte
> 0xffffffff82100000-0xffffffff82200000           1M     RW             GLB x  pte
> .....
> 
> With this commit, kernel page table dumps
> 
> ---[ High Kernel Mapping ]---
> ....
> 0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE GLB NX pmd
> 0xffffffff81c00000-0xffffffff81d91000        1604K     ro             GLB NX pte
> 0xffffffff81d91000-0xffffffff81e00000         444K     ro             GLB NX pte
> 0xffffffff81e00000-0xffffffff82000000           2M     RW         PSE GLB NX pmd
> 0xffffffff82000000-0xffffffff8200c000          48K     RW             GLB NX pte
> 0xffffffff8200c000-0xffffffff82100000         976K     RW             GLB NX pte
> 0xffffffff82100000-0xffffffff82200000           1M     RW             GLB NX pte
> .....
> 
> The only difference is 0xffffffff81e00000(end) to 0xffffffff82200000(kernel_end) is set to NX.
> 
> I guess this range code is used by resume wakeup code. So setting it to NX causes problem.
> 
> Any idea?

Yeah, the resume area is a trampoline, it needs to be executable.

Thanks,

	Ingo
