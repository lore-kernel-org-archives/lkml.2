Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab0ELWxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:53:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44663 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab0ELWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:53:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 12/12] Use down_read_unfair() for /sys/<pid>/exe and /sys/<pid>/maps files
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
In-Reply-To: <1273634462-2672-13-git-send-email-walken@google.com>
References: <1273634462-2672-1-git-send-email-walken@google.com> <1273634462-2672-13-git-send-email-walken@google.com>
Message-Id: <20100513074949.2136.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 07:53:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This helps in the following situation:
> - Thread A takes a page fault while reading or writing memory.
>   do_page_fault() acquires the mmap_sem for read and blocks on disk
>   (either reading the page from file, or hitting swap) for a long time.
> - Thread B does an mmap call and blocks trying to acquire the mmap_sem
>   for write
> - Thread C is a monitoring process trying to read every /proc/pid/maps
>   in the system. This requires acquiring the mmap_sem for read. Thread C
>   blocks behind B, waiting for A to release the rwsem.  If thread C
>   could be allowed to run in parallel with A, it would probably get done
>   long before thread A's disk access completes, thus not actually slowing
>   down thread B.
> 
> Test results with down_read_unfair_test (10 seconds):
> 
> 2.6.33.3:
> threadA completes ~600 faults
> threadB completes ~300 mmap/munmap cycles
> threadC completes ~600 /proc/pid/maps reads
> 
> 2.6.33.3 + down_read_unfair:
> threadA completes ~600 faults
> threadB completes ~300 mmap/munmap cycles
> threadC completes ~160000 /proc/pid/maps reads
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Is it good idea?
So I think /proc shouldn't use unfair thing as backdoor. 
It doesn't only makes performance improvement, but also 
DoS chance is there.

Please use this feature only in internal.



> ---
>  fs/proc/base.c       |    2 +-
>  fs/proc/task_mmu.c   |    2 +-
>  fs/proc/task_nommu.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 8418fcc..9132488 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1367,7 +1367,7 @@ struct file *get_mm_exe_file(struct mm_struct *mm)
>  
>  	/* We need mmap_sem to protect against races with removal of
>  	 * VM_EXECUTABLE vmas */
> -	down_read(&mm->mmap_sem);
> +	down_read_unfair(&mm->mmap_sem);
>  	exe_file = mm->exe_file;
>  	if (exe_file)
>  		get_file(exe_file);
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 0705534..09647ad 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -123,7 +123,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>  	mm = mm_for_maps(priv->task);
>  	if (!mm)
>  		return NULL;
> -	down_read(&mm->mmap_sem);
> +	down_read_unfair(&mm->mmap_sem);
>  
>  	tail_vma = get_gate_vma(priv->task);
>  	priv->tail_vma = tail_vma;
> diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
> index 46d4b5d..56ca830 100644
> --- a/fs/proc/task_nommu.c
> +++ b/fs/proc/task_nommu.c
> @@ -194,7 +194,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
>  		priv->task = NULL;
>  		return NULL;
>  	}
> -	down_read(&mm->mmap_sem);
> +	down_read_unfair(&mm->mmap_sem);
>  
>  	/* start from the Nth VMA */
>  	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
> -- 
> 1.7.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



