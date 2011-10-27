Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1J0QzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:55:14 -0400
Received: from flusers.ccur.com ([173.221.59.2]:37530 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752554Ab1J0QzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:55:13 -0400
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 12:55:12 EDT
Date: Thu, 27 Oct 2011 12:41:40 -0400
From: Joe Korty <joe.korty@ccur.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amwang@redhat.com" <amwang@redhat.com>
Subject: Re: [PATCH 6/4] ipc/mqueue: don't use kmalloc(KMALLOC_MAX_SIZE)
Message-ID: <20111027164140.GD21264@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com> <1317162613-11060-3-git-send-email-dledford@redhat.com> <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com> <4EA828E4.1070409@gmail.com> <4EA8294C.2050703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA8294C.2050703@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:37:48AM -0400, KOSAKI Motohiro wrote:
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
> ---
>  ipc/mqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 229a5fb..91ca145 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -151,7 +151,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  			info->attr.mq_msgsize = attr->mq_msgsize;
>  		}
>  		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
> -		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
> +		if (mq_msg_tblsz > PAGE_SIZE)
>  			info->messages = vmalloc(mq_msg_tblsz);
>  		else
>  			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
> @@ -275,7 +275,7 @@ static void mqueue_evict_inode(struct inode *inode)
>  	spin_lock(&info->lock);
>  	for (i = 0; i < info->attr.mq_curmsgs; i++)
>  		free_msg(info->messages[i]);
> -	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
> +	if (is_vmalloc_addr(info->messages))
>  		vfree(info->messages);
>  	else
>  		kfree(info->messages);
> -- 
> 1.7.5.2

Acked-by: Joe Korty <joe.korty@ccur.com>
