Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1HSSK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:10:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48398 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1HSSK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:10:56 -0400
Date: Fri, 19 Aug 2011 19:10:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] fs/minix: Verify bitmap block counts before mounting
Message-ID: <20110819181054.GA2203@ZenIV.linux.org.uk>
References: <20110819180159.GB2270@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819180159.GB2270@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:02:00PM -0400, Josh Boyer wrote:

> -unsigned long minix_count_free_blocks(struct minix_sb_info *sbi)
> +unsigned long minix_count_free_blocks(struct super_block *sb)
>  {
> -	return (count_free(sbi->s_zmap, sbi->s_zmap_blocks,
> -		sbi->s_nzones - sbi->s_firstdatazone + 1)
> +	struct minix_sb_info *sbi = minix_sb(sb);
> +	u32 bits = sbi->s_nzones - (sbi->s_firstdatazone + 1);
> +	unsigned blocks = minix_blocks_needed(bits, sb->s_blocksize);
> +
> +	return (count_free(sbi->s_zmap, blocks, bits)
>  		<< sbi->s_log_zone_size);
>  }

> +	unsigned blocks = minix_blocks_needed(bits, sb->s_blocksize);
> +
> +	return count_free(sbi->s_imap, blocks, bits);

I'd pass sb->s_blocksize to that sucker instead of blocks; less redundancy
and we have good uses for it there anyway.

> +static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
> +{
> +	unsigned blocks = bits / (blocksize * 8);
> +
> +	if (bits % (blocksize * 8))
> +		blocks++;
> +	return blocks;
> +}

Yecchh...  The usual idiom for that is DIV_ROUND_UP(bits, blocksize * 8)
(see linux/kernel.h for details).
