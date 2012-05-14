Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2ENXyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:54:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2ENXyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:54:02 -0400
Date: Mon, 14 May 2012 16:54:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/mqueue: use correct gfp flags in msg_insert
Message-Id: <20120514165401.e4efc2fd.akpm@linux-foundation.org>
In-Reply-To: <1337029525-8760-1-git-send-email-levinsasha928@gmail.com>
References: <1337029525-8760-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 23:05:25 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> msg_insert() tries to allocate using GFP_KERNEL, while in both cases when it's called,
> it's coming from an atomic context. Introduced by 7dd7edf ("ipc/mqueue: improve
> performance of send/recv").
> 
> Use GFP_ATOMIC instead.
> 
> Also, fix up coding style in the kzalloc while we're there.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  ipc/mqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 30f6f8f..9ec6896 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -133,7 +133,7 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
>  		else
>  			p = &(*p)->rb_right;
>  	}
> -	leaf = kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
> +	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
>  	if (!leaf)
>  		return -ENOMEM;
>  	rb_init_node(&leaf->rb_node);

hm, that should have spewed warnings everywhere the first time anyone
tested it.  Doug, is a re-read of Documentation/SubmitChecklist needed?

Switching to GFP_ATOMIC is a bit regrettable.  Can we avoid this by
speculatively allocating the memory before taking the lock, then free
it again if we ended up not using it?
