Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab0G3Rrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:47:49 -0400
Received: from mx2.netapp.com ([216.240.18.37]:32521 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab0G3Rro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:47:44 -0400
X-IronPort-AV: E=Sophos;i="4.55,288,1278313200"; 
   d="scan'208";a="415741445"
Subject: Re: [PATCH 8/9] fs: nfs: misused copy_to_user() return value
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1280488190-20979-1-git-send-email-segooon@gmail.com>
References: <1280488190-20979-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Fri, 30 Jul 2010 13:47:27 -0400
Message-ID: <1280512047.12852.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
X-OriginalArrivalTime: 30 Jul 2010 17:47:28.0981 (UTC) FILETIME=[47586850:01CB300F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 15:09 +0400, Kulikov Vasiliy wrote:
> copy_to_user() returns nonzero value on error, this value may be any
> value between 0 and requested count, not only requested count.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  fs/nfs/idmap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
> index 21a84d4..a9f2cd5 100644
> --- a/fs/nfs/idmap.c
> +++ b/fs/nfs/idmap.c
> @@ -362,7 +362,7 @@ idmap_pipe_upcall(struct file *filp, struct rpc_pipe_msg *msg,
>  	unsigned long left;
>  
>  	left = copy_to_user(dst, data, mlen);
> -	if (left == mlen) {
> +	if (left)
>  		msg->errno = -EFAULT;
>  		return -EFAULT;
>  	}

...and we do handle the case where copy_to_user returns less than the
requested number of bytes: it is called a 'short read' and is quite
allowed in POSIX. The userland application can just call sys_read()
again...

Trond
