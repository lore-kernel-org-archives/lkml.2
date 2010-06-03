Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab0FCKmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:42:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:46939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762Ab0FCKmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:42:07 -0400
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100603103542.GV5483@bicker>
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp>
	 <20100603103542.GV5483@bicker>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 12:42:14 +0200
Message-ID: <1275561734.27810.35399.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 12:35 +0200, Dan Carpenter wrote:
> copy_to_user() returns the number of bytes remaining, but we want to
> return -EFAULT.
> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
> With the original code ret would be 8 here.
> 
> V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index f74d270..51e11bf 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -274,7 +274,7 @@ static int f_setown_ex(struct file *filp, unsigned long arg)
>  
>  	ret = copy_from_user(&owner, owner_p, sizeof(owner));
>  	if (ret)
> -		return ret;
> +		return -EFAULT;
>  
>  	switch (owner.type) {
>  	case F_OWNER_TID:
> @@ -332,8 +332,11 @@ static int f_getown_ex(struct file *filp, unsigned long arg)
>  	}
>  	read_unlock(&filp->f_owner.lock);
>  
> -	if (!ret)
> +	if (!ret) {
>  		ret = copy_to_user(owner_p, &owner, sizeof(owner));
> +		if (ret)
> +			ret = -EFAULT;
> +	}
>  	return ret;
>  }
>  

