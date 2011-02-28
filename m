Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1B1O3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:29:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:38420 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab1B1O3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:29:45 -0500
Date: Mon, 28 Feb 2011 15:29:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Frank Heckenbach <f.heckenbach@fh-soft.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: brk() should check randomize_va_space rather then
 CONFIG_COMPAT_BRK
In-Reply-To: <1298792275.19234.928360@goedel.fjf.gnu.de>
Message-ID: <alpine.LNX.2.00.1102281524480.2160@pobox.suse.cz>
References: <1298792275.19234.928360@goedel.fjf.gnu.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Feb 2011, Frank Heckenbach wrote:

> The brk() syscall checks CONFIG_COMPAT_BRK to decide whether the brk
> area starts just after the end of the code+bss.
> 
> Since CONFIG_COMPAT_BRK can be overridden by
> /proc/sys/kernel/randomize_va_space, it should rather check this
> variable (which is initialized in mm/memory.c from
> CONFIG_COMPAT_BRK), see the patch below.
> 
> I've tested it with an old libc5 binary: Without the patch, if the
> kernel was configured without CONFIG_COMPAT_BRK, the first malloc()
> fails with any setting of randomize_va_space. With the patch
> applied, the program runs correctly with randomize_va_space < 2, but
> not with randomize_va_space == 2, as it should be.
> 
> --- linux-2.6.37.2/mm/mmap.c.orig	2011-02-25 00:09:00.000000000 +0100
> +++ linux-2.6.37.2/mm/mmap.c	2011-02-26 01:13:53.000000000 +0100
> @@ -252,11 +252,11 @@
>  
>  	down_write(&mm->mmap_sem);
>  
> -#ifdef CONFIG_COMPAT_BRK
> -	min_brk = mm->end_code;
> -#else
> -	min_brk = mm->start_brk;
> -#endif
> +	if (randomize_va_space < 2)
> +		min_brk = mm->end_code;
> +	else
> +		min_brk = mm->start_brk;
> +
>  	if (brk < min_brk)
>  		goto out;

Hi Frank,

how do you avoid race here? 

More precisely -- randomize_va_space can be changed in runtime, when 
already running processess have been started with different 
randomize_va_space value (and thus the shifting of mm->brk already 
happened in arch_randomize_brk())

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
