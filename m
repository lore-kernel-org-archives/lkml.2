Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab1C2FEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 01:04:12 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44628 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1C2FEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 01:04:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july>
Date: Tue, 29 Mar 2011 14:04:05 +0900
In-Reply-To: <20110328103431.GA22323@july> (Kyungmin Park's message of "Mon,
	28 Mar 2011 19:34:31 +0900")
Message-ID: <87k4fi4iwq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

> +int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
> +{
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +	struct fatent_operations *ops = sbi->fatent_ops;
> +	struct fat_entry fatent;
> +	unsigned long reada_blocks, reada_mask, cur_block;
> +	int err, free, count, entry;
> +	int start, len, minlen, trimmed;
> +
> +	start = range->start >> sb->s_blocksize_bits;
> +	len = range->len >> sb->s_blocksize_bits;
> +	len = round_down(start + len, sbi->sec_per_clus);
> +	start = round_up(start, sbi->sec_per_clus);
> +	minlen = range->minlen >> sb->s_blocksize_bits;
> +	minlen = round_up(minlen, sbi->sec_per_clus);
> +	trimmed = 0;
> +	count = 0;
> +	err = -EINVAL;

Sorry for didn't mention at previous. You can use ->cluster_size, and
->cluster_bits.

> +	if (start >= sbi->max_cluster)
> +		goto out;
> +
> +	len = (len > sbi->max_cluster) ? sbi->max_cluster : len;

[...]

> +		trimmed += free;
> +	}
> +	range->len = (u64)(trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
> +	fatent_brelse(&fatent);
> +out:
> +	unlock_fat(sbi);
> +	return err;

Again, this ioctl's design is unclear, and seems to be strange. I
wouldn't want to add this before clearing it. Please explain what is
right behavior.

E.g. if user specified 0-1024 and FS data block was actually started at
2048. What is right behavior? And if the end of blocks, what returned?
For now, it seems to return range->len == 0 on both cases.

Well, so, my suggestion is providing this like flat one extent
file. I.e. FS have to map actual block placement to flat. And result
also like write/read (return bytes as trimed, and at EOF returns 0).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
