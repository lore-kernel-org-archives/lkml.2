Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2BVPq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:46:57 -0500
Received: from sh.osrg.net ([192.16.179.4]:59560 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2BVPqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:46:54 -0500
Date: Thu, 23 Feb 2012 00:46:50 +0900 (JST)
Message-Id: <20120223.004650.160012804.ryusuke@osrg.net>
To: haogangchen@gmail.com
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FS: nilfs2: clamps ns_r_segments_percentage to [1, 99]
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1329774930-17162-1-git-send-email-haogangchen@gmail.com>
References: <1329774930-17162-1-git-send-email-haogangchen@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.7 (sh.osrg.net [192.16.179.4]); Thu, 23 Feb 2012 00:46:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chen

On Mon, 20 Feb 2012 16:55:30 -0500, Haogang Chen wrote:
> ns_r_segments_percentage is read from the disk. Bogus or malicious
> value could cause integer overflow and potential security holes.
> This patch reports error when mounting such bogus volumes.
> 
> Signed-off-by: Haogang Chen <haogangchen@gmail.com>

Ok, I will pick this up as a fix.

But this seems not to cause security issues; it just makes some disk
usage calculations meaningless and causes malfunction for such
out-of-range values.  Right?

May I amend the change log in terms of the impact ?


Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/the_nilfs.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
> index d327140..e12b47b 100644
> --- a/fs/nilfs2/the_nilfs.c
> +++ b/fs/nilfs2/the_nilfs.c
> @@ -409,6 +409,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
>  	nilfs->ns_first_data_block = le64_to_cpu(sbp->s_first_data_block);
>  	nilfs->ns_r_segments_percentage =
>  		le32_to_cpu(sbp->s_r_segments_percentage);
> +	if (nilfs->ns_r_segments_percentage < 1 ||
> +		nilfs->ns_r_segments_percentage > 99) {
> +		printk(KERN_ERR "NILFS: invalid reserved segments percentage.\n");
> +		return -EINVAL;
> +	}
> +
>  	nilfs_set_nsegments(nilfs, le64_to_cpu(sbp->s_nsegments));
>  	nilfs->ns_crc_seed = le32_to_cpu(sbp->s_crc_seed);
>  	return 0;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
