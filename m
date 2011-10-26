Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab1JZRaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:30:05 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:35364 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab1JZRaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:30:04 -0400
Date: Wed, 26 Oct 2011 13:29:59 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, joe korty <joe.korty@ccur.com>,
        amwang@redhat.com
Subject: Re: [PATCH 6/4] ipc/mqueue: don't use kmalloc(KMALLOC_MAX_SIZE)
Message-ID: <06a69900-6d92-4e20-89ce-e35160dc7ec3@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4EA8294C.2050703@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.113.99]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> 
> KMALLOC_MAX_SIZE is no good threshold. It is extream high and
> problematic. Unfortunately, some silly drivers depend on and
> we can't change it. but any new code don't use such extream
> ugly high order allocations. It bring us awful fragmentation
> issue and system slowdown.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Joe Korty <joe.korty@ccur.com>

Acked-by: Doug Ledford <dledford@redhat.com>

> ---
>  ipc/mqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 229a5fb..91ca145 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -151,7 +151,7 @@ static struct inode *mqueue_get_inode(struct
> super_block *sb,
>  			info->attr.mq_msgsize = attr->mq_msgsize;
>  		}
>  		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
> -		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
> +		if (mq_msg_tblsz > PAGE_SIZE)
>  			info->messages = vmalloc(mq_msg_tblsz);
>  		else
>  			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
> @@ -275,7 +275,7 @@ static void mqueue_evict_inode(struct inode
> *inode)
>  	spin_lock(&info->lock);
>  	for (i = 0; i < info->attr.mq_curmsgs; i++)
>  		free_msg(info->messages[i]);
> -	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) >
> KMALLOC_MAX_SIZE)
> +	if (is_vmalloc_addr(info->messages))
>  		vfree(info->messages);
>  	else
>  		kfree(info->messages);
> --
> 1.7.5.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

