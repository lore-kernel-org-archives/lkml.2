Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2B1JJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:09:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42332 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab2B1JJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:09:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.14.199.193 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
From: Miklos Szeredi <miklos@szeredi.hu>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, fuse-devel@lists.sourceforge.net
Subject: Re: [RFC PATCH 03/22] fuse: convert fuse to use iov_iter_copy_[to|from]_user
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
	<1330377576-3659-4-git-send-email-dave.kleikamp@oracle.com>
Date: Tue, 28 Feb 2012 10:09:44 +0100
In-Reply-To: <1330377576-3659-4-git-send-email-dave.kleikamp@oracle.com> (Dave
	Kleikamp's message of "Mon, 27 Feb 2012 15:19:17 -0600")
Message-ID: <871upfb9yf.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> A future patch hides the internals of struct iov_iter, so fuse should
> be using the supported interface.
>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

Thanks,
Miklos

> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: fuse-devel@lists.sourceforge.net
> ---
>  fs/fuse/file.c |   29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 4a199fd..877cee0 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1582,30 +1582,17 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
>  	while (iov_iter_count(&ii)) {
>  		struct page *page = pages[page_idx++];
>  		size_t todo = min_t(size_t, PAGE_SIZE, iov_iter_count(&ii));
> -		void *kaddr;
> +		size_t left;
>  
> -		kaddr = kmap(page);
> -
> -		while (todo) {
> -			char __user *uaddr = ii.iov->iov_base + ii.iov_offset;
> -			size_t iov_len = ii.iov->iov_len - ii.iov_offset;
> -			size_t copy = min(todo, iov_len);
> -			size_t left;
> -
> -			if (!to_user)
> -				left = copy_from_user(kaddr, uaddr, copy);
> -			else
> -				left = copy_to_user(uaddr, kaddr, copy);
> -
> -			if (unlikely(left))
> -				return -EFAULT;
> +		if (!to_user)
> +			left = iov_iter_copy_from_user(page, &ii, 0, todo);
> +		else
> +			left = iov_iter_copy_to_user(page, &ii, 0, todo);
>  
> -			iov_iter_advance(&ii, copy);
> -			todo -= copy;
> -			kaddr += copy;
> -		}
> +		if (unlikely(left))
> +			return -EFAULT;
>  
> -		kunmap(page);
> +		iov_iter_advance(&ii, todo);
>  	}
>  
>  	return 0;
