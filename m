Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2JHUf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:35:57 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40996 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2JHUfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:35:44 -0400
Date: Mon, 8 Oct 2012 13:35:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mpol_to_str revisited.
In-Reply-To: <20121008150949.GA15130@redhat.com>
Message-ID: <alpine.DEB.2.00.1210081330160.18768@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, Dave Jones wrote:

> unanswered question: why are the buffer sizes here different ? which is correct?
> 

Given the current set of mempolicy modes and flags, it's 34, but this can 
change if new modes or flags are added with longer names.  I see no reason 
why shmem shouldn't round up to the nearest power-of-2 of 64 like it 
already does, but 50 is certainly safe as well in task_mmu.c.

> diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/fs/proc/task_mmu.c linux-dj/fs/proc/task_mmu.c
> --- src/git-trees/kernel/linux/fs/proc/task_mmu.c	2012-05-31 22:32:46.778150675 -0400
> +++ linux-dj/fs/proc/task_mmu.c	2012-10-04 19:31:41.269988984 -0400
> @@ -1162,6 +1162,7 @@ static int show_numa_map(struct seq_file
>  	struct mm_walk walk = {};
>  	struct mempolicy *pol;
>  	int n;
> +	int ret;
>  	char buffer[50];
>  
>  	if (!mm)
> @@ -1178,7 +1179,11 @@ static int show_numa_map(struct seq_file
>  	walk.mm = mm;
>  
>  	pol = get_vma_policy(proc_priv->task, vma, vma->vm_start);
> -	mpol_to_str(buffer, sizeof(buffer), pol, 0);
> +	memset(buffer, 0, sizeof(buffer));
> +	ret = mpol_to_str(buffer, sizeof(buffer), pol, 0);
> +	if (ret < 0)
> +		return 0;

We should need the mpol_cond_put(pol) here before returning.

> +
>  	mpol_cond_put(pol);
>  
>  	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
> diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/mm/shmem.c linux-dj/mm/shmem.c
> --- src/git-trees/kernel/linux/mm/shmem.c	2012-10-02 15:49:51.977277944 -0400
> +++ linux-dj/mm/shmem.c	2012-10-04 19:32:28.862949907 -0400
> @@ -885,13 +885,15 @@ redirty:
>  static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
>  {
>  	char buffer[64];
> +	int ret;
>  
>  	if (!mpol || mpol->mode == MPOL_DEFAULT)
>  		return;		/* show nothing */
>  
> -	mpol_to_str(buffer, sizeof(buffer), mpol, 1);
> -
> -	seq_printf(seq, ",mpol=%s", buffer);
> +	memset(buffer, 0, sizeof(buffer));
> +	ret = mpol_to_str(buffer, sizeof(buffer), mpol, 1);
> +	if (ret > 0)
> +		seq_printf(seq, ",mpol=%s", buffer);
>  }
>  
>  static struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
