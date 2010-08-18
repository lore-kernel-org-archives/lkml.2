Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0HRQ6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:58:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:52288 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab0HRQ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,228,1280732400"; 
   d="scan'208";a="597863114"
Subject: Re: [PATCH] shmem: fix percpu_counters list corruption
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.1008172030320.2933@sister.anvils>
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp>
	 <201008170751.o7H7pmAl038739@www262.sakura.ne.jp>
	 <alpine.LSU.2.00.1008171523270.2106@sister.anvils>
	 <201008180113.o7I1DXg6077317@www262.sakura.ne.jp>
	 <alpine.LSU.2.00.1008172022140.2868@sister.anvils>
	 <alpine.LSU.2.00.1008172030320.2933@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 09:50:59 -0700
Message-ID: <1282150259.9542.2.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was my bad.  I had those two chunks of code in a previous version
of the patch but somehow missed them in the final one.

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

On Tue, 2010-08-17 at 20:32 -0700, Hugh Dickins wrote:
> list_add() corruption messages reported from shmem_fill_super()'s recently
> introduced percpu_counter_init(): shmem_put_super() needs to remember to
> percpu_counter_destroy().  And also check error from percpu_counter_init().
> 
> Reported to fix oopses in __free_pipe_info() but I cannot work that out!
> 
> Reported-and-bisected-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> ---
> 
>  mm/shmem.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> --- 2.6.36-rc1/mm/shmem.c	2010-08-16 00:18:01.000000000 -0700
> +++ linux/mm/shmem.c	2010-08-17 14:42:56.000000000 -0700
> @@ -2325,7 +2325,10 @@ static int shmem_show_options(struct seq
>  
>  static void shmem_put_super(struct super_block *sb)
>  {
> -	kfree(sb->s_fs_info);
> +	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
> +
> +	percpu_counter_destroy(&sbinfo->used_blocks);
> +	kfree(sbinfo);
>  	sb->s_fs_info = NULL;
>  }
>  
> @@ -2367,7 +2370,8 @@ int shmem_fill_super(struct super_block
>  #endif
>  
>  	spin_lock_init(&sbinfo->stat_lock);
> -	percpu_counter_init(&sbinfo->used_blocks, 0);
> +	if (percpu_counter_init(&sbinfo->used_blocks, 0))
> +		goto failed;
>  	sbinfo->free_inodes = sbinfo->max_inodes;
>  
>  	sb->s_maxbytes = SHMEM_MAX_BYTES;


