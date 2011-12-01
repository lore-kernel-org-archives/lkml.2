Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1LAWHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab1LAWHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:07:09 -0500
Message-ID: <4ED7FA81.9090802@redhat.com>
Date: Thu, 01 Dec 2011 16:06:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: tytso@mit.edu, tm@tao.ma, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
References: <20111201070052.GA29708@july>
In-Reply-To: <20111201070052.GA29708@july>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/11 1:00 AM, Kyungmin Park wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Now trim information doesn't stored at disk so every boot time. it's cleared.
> and do the trim all disk groups.
> But assume that it's already trimmed at previous time so don't need to trim it again. So set the intial state as trimmed.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2d8be8..97ef342 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
>  		goto err;
>  	}
>  	mark_page_accessed(page);
> +
> +	/*
> +	 * TRIM information is not stored at disk so set the initial
> +	 * state as trimmed. Since previous time it's already trimmed all
> +	 */
> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);

Hm, so if there were freed but un-trimmed blocks at this point, we will
never trim them until we free _another_ block in the group, right?  That
might be a reasonable tradeoff, but it is somewhat surprising behavior.

i.e. say we do:

mount /mnt
rm -rf /mnt/very_big_file
umount /mnt

mount /mnt
fitrim /mnt

then we won't trim anything at all, right, despite there being many
new free blocks?  Which would be rather unexpected.

If we don't store the trimmed state on disk, I think we should
probably stick with the slower first-time trim, and the more obvious
behavior (all free blocks are always trimmed whenever a trim
command is issued).

-Eric

>  err:
>  	ext4_mb_put_buddy_page_lock(&e4b);
>  	return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

