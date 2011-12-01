Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1LAPdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:33:17 -0500
Received: from sh.osrg.net ([192.16.179.4]:59469 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1LAPdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:33:16 -0500
Date: Fri, 02 Dec 2011 00:33:12 +0900 (JST)
Message-Id: <20111202.003312.179955221.ryusuke@osrg.net>
To: haogangchen@gmail.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: nilfs2: potential integer overflow in
 nilfs_ioctl_clean_segments()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1322708399-26919-1-git-send-email-haogangchen@gmail.com>
References: <1322708399-26919-1-git-send-email-haogangchen@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 02 Dec 2011 00:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 21:59:59 -0500, Haogang Chen wrote:
> There is a potential integer overflow in nilfs_ioctl_clean_segments().
> When a large argv[n].v_nmembs is passed from the userspace, the
> subsequent call to vmalloc() will allocate a buffer smaller than
> expected, which leads to out-of-bound access in
> nilfs_ioctl_move_blocks() and lfs_clean_segments().
> 
> The following check does not prevent the overflow because nsegs is also
> controlled by the userspace and could be very large.
> 
> 		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
> 			goto out_free;
> 
> This patch clamps argv[n].v_nmembs to UINT_MAX / argv[n].v_size, and
> returns -EINVAL when overflow.
> 
> Signed-off-by: Haogang Chen <haogangchen@gmail.com>

Ahh, that makes sense.

I will apply your patch.

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/ioctl.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index 41d6743..b805df9 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -625,6 +625,9 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  		if (argv[n].v_nmembs > nsegs * nilfs->ns_blocks_per_segment)
>  			goto out_free;
>  
> +		if (argv[n].v_nmembs >= UINT_MAX / argv[n].v_size)
> +			goto out_free;
> +
>  		len = argv[n].v_size * argv[n].v_nmembs;
>  		base = (void __user *)(unsigned long)argv[n].v_base;
>  		if (len == 0) {
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
