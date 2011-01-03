Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1ACLje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:39:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab1ACLjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:39:33 -0500
Date: Mon, 3 Jan 2011 12:39:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brk: fix min_brk lower bound computation for
 COMPAT_BRK
In-Reply-To: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jan 2011, Jiri Kosina wrote:

> Even if CONFIG_COMPAT_BRK is set in the kernel configuration, it can still 
> be overriden by randomize_va_space sysctl.
> 
> If this is the case, the min_brk computation in sys_brk() implementation 
> is wrong, as it solely takes into account COMPAT_BRK setting, assuming 
> that brk start is not randomized. But that might not be the case if 
> randomize_va_space sysctl has been set to '2' at the time the binary has 
> been loaded from disk.
> 
> In such case, the check has to be done in a same way as in 
> !CONFIG_COMPAT_BRK case.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  mm/mmap.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 50a4aa0..35d9f9c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -253,7 +253,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
>  	down_write(&mm->mmap_sem);
>  
>  #ifdef CONFIG_COMPAT_BRK
> -	min_brk = mm->end_code;
> +	/*
> +	 * CONFIG_COMPAT_BRK can still be overridden by setting
> +	 * randomize_va_space to 2, which will still make mm->start_brk
> +	 * to be arbitrarily shifted
> +	 */
> +	if (mm->start_brk > mm->end_code)
> +		min_brk = mm->start_brk;
> +	else
> +		min_brk = mm->end_code;
>  #else
>  	min_brk = mm->start_brk;
>  #endif

Hmm, actually no, that will bring us back into pre-a5b4592c era, please 
disregard that. 

I will have to come up with something more clever (we can't just check 
'randomize_va_space == 2', as that would be racy for already running 
programs).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
