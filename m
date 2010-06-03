Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab0FCKSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:18:30 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34465 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab0FCKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:18:29 -0400
Message-ID: <4C07826A.6060302@oss.ntt.co.jp>
Date: Thu, 03 Jun 2010 19:22:34 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fcntl: return -EFAULT if copy_to_user fails
References: <20100603100402.GR5483@bicker>
In-Reply-To: <20100603100402.GR5483@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/03 19:04), Dan Carpenter wrote:
> copy_to_user() returns the number of bytes remaining, but we want to
> return -EFAULT.
>
> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
>
> With the original code ret would be 8 here.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>

How about f_getown_ex() ?

	if (!ret)
		ret = copy_to_user(owner_p, &owner, sizeof(owner));
	return ret;

Fixing this too would be better, I think.

   Takuya

>
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index f74d270..0ea7b0f 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -274,7 +274,7 @@ static int f_setown_ex(struct file *filp, unsigned long arg)
>
>   	ret = copy_from_user(&owner, owner_p, sizeof(owner));
>   	if (ret)
> -		return ret;
> +		return -EFAULT;
>
>   	switch (owner.type) {
>   	case F_OWNER_TID:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

