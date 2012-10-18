Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2JRUDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:03:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35364 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2JRUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:03:43 -0400
Date: Thu, 18 Oct 2012 13:03:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7 v2] mm, mempolicy: avoid taking mutex inside
 spinlock when reading numa_maps
In-Reply-To: <507F86BD.7070201@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210181255470.26994@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
 <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <20121017181413.GA16805@redhat.com> <alpine.DEB.2.00.1210171219010.28214@chino.kir.corp.google.com> <20121017193229.GC16805@redhat.com>
 <alpine.DEB.2.00.1210171237130.28214@chino.kir.corp.google.com> <20121017194501.GA24400@redhat.com> <alpine.DEB.2.00.1210171318400.28214@chino.kir.corp.google.com> <alpine.DEB.2.00.1210171428540.20712@chino.kir.corp.google.com> <507F803A.8000900@jp.fujitsu.com>
 <507F86BD.7070201@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Kamezawa Hiroyuki wrote:

> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index cceaab0..43973b0 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -12,6 +12,7 @@
>  #include <linux/sched.h>
>  #include <linux/proc_fs.h>
>  struct  ctl_table_header;
> +struct  mempolicy;
>   extern struct proc_dir_entry proc_root;
>  #ifdef CONFIG_PROC_SYSCTL
> @@ -74,6 +75,9 @@ struct proc_maps_private {
>  #ifdef CONFIG_MMU
>  	struct vm_area_struct *tail_vma;
>  #endif
> +#ifdef CONFIG_NUMA
> +	struct mempolicy *task_mempolicy;
> +#endif
>  };
>   void proc_init_inodecache(void);
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 14df880..624927d 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -89,11 +89,41 @@ static void pad_len_spaces(struct seq_file *m, int len)
>  		len = 1;
>  	seq_printf(m, "%*c", len, ' ');
>  }
> +#ifdef CONFIG_NUMA
> +/*
> + * numa_maps scans all vmas under mmap_sem and checks their mempolicy.

Doesn't only affect numa_maps, it also affects maps and smaps although 
they don't need the refcounts.

> + * But task->mempolicy is not guarded by mmap_sem, it can be cleared/freed
> + * under task_lock() (see kernel/exit.c) replacement of it is guarded by
> + * mmap_sem.

I think this should be a little more verbose making it clear that 
task->mempolicy can be cleared and freed if its refcount drops to 0 and is 
only protected by task_lock() and that we're safe from task->mempolicy 
changing between ->start(), ->next(), and ->stop() because 
task->mm->mmap_sem is held for the duration.

> So, take referenceount under task_lock() before we start
> + * scanning and drop it when numa_maps reaches the end.
> + */
> +static void hold_task_mempolicy(struct proc_maps_private *priv)
> +{
> +	struct task_struct *task = priv->task;
> +
> +	task_lock(task);
> +	priv->task_mempolicy = task->mempolicy;
> +	mpol_get(priv->task_mempolicy);
> +	task_unlock(task);
> +}
> +static void release_task_mempolicy(struct proc_maps_private *priv)
> +{
> +	mpol_put(priv->task_mempolicy);
> +}
> +#else
> +static void hold_task_mempolicy(struct proc_maps_private *priv)
> +{
> +}
> +static void release_task_mempolicy(struct proc_maps_private *priv)
> +{
> +}
> +#endif
>   static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct
> *vma)
>  {
>  	if (vma && vma != priv->tail_vma) {
>  		struct mm_struct *mm = vma->vm_mm;
> +		release_task_mempolicy(priv);
>  		up_read(&mm->mmap_sem);
>  		mmput(mm);
>  	}
> @@ -132,7 +162,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>   	tail_vma = get_gate_vma(priv->task->mm);
>  	priv->tail_vma = tail_vma;
> -
> +	hold_task_mempolicy(priv);
>  	/* Start with last addr hint */
>  	vma = find_vma(mm, last_addr);
>  	if (last_addr && vma) {
> @@ -159,6 +189,7 @@ out:
>  	if (vma)
>  		return vma;
>  +	release_task_mempolicy(priv);
>  	/* End of vmas has been reached */
>  	m->version = (tail_vma != NULL)? 0: -1UL;
>  	up_read(&mm->mmap_sem);

Otherwise looks good, but please remove the two task_lock()'s in 
show_numa_map() that I added as part of this since you're replacing the 
need for locking.
