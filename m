Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2DRDXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:23:09 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47546 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2DRDXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:23:08 -0400
Date: Wed, 18 Apr 2012 03:24:04 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KOSAKI Motohiro <mkosaki@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [Patch 6/8] mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
Message-ID: <20120418032404.GC18830@mail.hallyn.com>
References: <cover.1334676645.git.dledford@redhat.com>
 <a4466082257558adf6654facc633630c14b65033.1334676645.git.dledford@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4466082257558adf6654facc633630c14b65033.1334676645.git.dledford@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Doug Ledford (dledford@redhat.com):
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> KMALLOC_MAX_SIZE is no good threshold. It is extream high and
> problematic. Unfortunately, some silly drivers depend on and
> we can't change it. but any new code don't use such extream
> ugly high order allocations. It bring us awful fragmentation
> issue and system slowdown.
> 
> Signed-off-by: KOSAKI Motohiro <mkosaki@jp.fujitsu.com>
> Acked-by: Doug Ledford <dledford@redhat.com>
> Acked-by: Joe Korty <joe.korty@ccur.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>

Looks reasonable to me, but that doesn't mean much.  Cc:d Dave Hansen
explicitly, he'd have a better idea.

> Cc: Jiri Slaby <jslaby@suse.cz>
> ---
>  ipc/mqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 3ced596..f9f0782 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -150,7 +150,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  			info->attr.mq_msgsize = attr->mq_msgsize;
>  		}
>  		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
> -		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
> +		if (mq_msg_tblsz > PAGE_SIZE)
>  			info->messages = vmalloc(mq_msg_tblsz);
>  		else
>  			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
> @@ -263,7 +263,7 @@ static void mqueue_evict_inode(struct inode *inode)
>  	spin_lock(&info->lock);
>  	for (i = 0; i < info->attr.mq_curmsgs; i++)
>  		free_msg(info->messages[i]);
> -	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
> +	if (is_vmalloc_addr(info->messages))
>  		vfree(info->messages);
>  	else
>  		kfree(info->messages);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
