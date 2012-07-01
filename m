Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2GATCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:02:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57522 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2GATCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:02:45 -0400
Date: Sun, 1 Jul 2012 12:02:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [ 11/48] mm: correctly synchronize rss-counters at exit/exec
In-Reply-To: <20120701172008.252571630@decadent.org.uk>
Message-ID: <alpine.LSU.2.00.1207011150480.1905@eggly.anvils>
References: <20120701172008.252571630@decadent.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2012, Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> commit 4fe7efdbdfb1c7e7a7f31decfd831c0f31d37091 upstream.
> 
> do_exit() and exec_mmap() call sync_mm_rss() before mm_release() does
> put_user(clear_child_tid) which can update task->rss_stat and thus make
> mm->rss_stat inconsistent.  This triggers the "BUG:" printk in check_mm().
> 
> Let's fix this bug in the safest way, and optimize/cleanup this later.
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [bwh: Backported to 3.2: sync_mm_rss() still takes a struct task_struct *]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

If you or Konstantin or Oleg have done full diligence on this,
to ensure that it is really applicable to 3.2 (not just that
the patch applies without rejects), fair enough.

But I'd be cautious about it: it went through enough alternatives
and revisions that I wouldn't call it trivial; it's easy for me to
imagine that some of the affected paths were actually slightly different
in 3.2 days than they were in 3.4 days; and the disturbing warning that
these mods silence ("BUG: Bad rss-counter state ") did not exist before
3.4 - unless you've ported that too?

That's not to assert that we had no rss problem at all before 3.4,
but we've not heard of any trouble from it.  Caution tells me that
this patch might cause more trouble than it's worth.

Hugh

> ---
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -820,10 +820,10 @@
>  	/* Notify parent that we're no longer interested in the old VM */
>  	tsk = current;
>  	old_mm = current->mm;
> -	sync_mm_rss(tsk, old_mm);
>  	mm_release(tsk, old_mm);
>  
>  	if (old_mm) {
> +		sync_mm_rss(tsk, old_mm);
>  		/*
>  		 * Make sure that if there is a core dump in progress
>  		 * for the old mm, we get out and die instead of going
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -641,6 +641,7 @@
>  	mm_release(tsk, mm);
>  	if (!mm)
>  		return;
> +	sync_mm_rss(tsk, mm);
>  	/*
>  	 * Serialize with any possible pending coredump.
>  	 * We must hold mmap_sem around checking core_state
> 
> 
> 
