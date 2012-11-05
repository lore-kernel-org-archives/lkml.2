Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2KEKxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:53:55 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57545 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2KEKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:53:53 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH v2 3/3] fat: warn when discard request fails other than EOPNOTSUPP
References: <1351924134-14320-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 19:53:50 +0900
In-Reply-To: <1351924134-14320-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 3 Nov 2012 15:28:54 +0900")
Message-ID: <87fw4omibl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> FAT also warn user then the discard request fails
> as ext4(http://patchwork.ozlabs.org/patch/192669/)

Why don't we do this at block layer like normal bio?

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/fatent.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
> index 260705c..fc1f407 100644
> --- a/fs/fat/fatent.c
> +++ b/fs/fat/fatent.c
> @@ -583,12 +583,15 @@ int fat_free_clusters(struct inode *inode, int cluster)
>  			 */
>  			if (cluster != fatent.entry + 1) {
>  				int nr_clus = fatent.entry - first_cl + 1;
> -
> -				sb_issue_discard(sb,
> -					fat_clus_to_blknr(sbi, first_cl),
> -					nr_clus * sbi->sec_per_clus,
> -					GFP_NOFS, 0);
> -
> +				sector_t sblk = fat_clus_to_blknr(sbi, first_cl);
> +				sector_t nrblk = nr_clus * sbi->sec_per_clus;
> +
> +				err = sb_issue_discard(sb,
> +						sblk, nrblk, GFP_NOFS, 0);
> +				if (err && err != -EOPNOTSUPP)
> +					fat_msg(sb, KERN_WARNING, "discard request for"
> +							" block:%llu count:%llu failed"
> +							" with %d", sblk, nrblk, err);
>  				first_cl = cluster;
>  			}
>  		}

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
