Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1BWJfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:35:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab1BWJfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:35:44 -0500
Date: Wed, 23 Feb 2011 10:35:39 +0100
From: Jan Kara <jack@suse.cz>
To: "George G. Davis" <gdavis@mvista.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] UDF: Fix compiler warning
Message-ID: <20110223093539.GA32543@quack.suse.cz>
References: <20110222190419.GH1397@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222190419.GH1397@mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-02-11 14:04:19, George G. Davis wrote:
> From: Dirk Behme <dirk.behme@de.bosch.com>
> 
> Fix compiler warning
> 
> fs/udf/balloc.c: In function 'udf_bitmap_new_block':
> fs/udf/balloc.c:273: warning: passing argument 1 of '_find_next_bit_le' from incompatible pointer type
> fs/udf/balloc.c:285: warning: passing argument 1 of '_find_next_bit_le' from incompatible pointer type
> fs/udf/balloc.c:311: warning: passing argument 1 of '_find_next_bit_le' from incompatible pointer type
> fs/udf/balloc.c:325: warning: passing argument 1 of '_find_next_bit_le' from incompatible pointer type
> 
> The main fix is to add a cast in ext2_find_next_bit().
> 
> As all other usage locations of udf_find_next_one_bit()
> directly use bh->b_data (which is a char *), the useless
> (char *) cast in line 311 can be removed, too.
> 
> Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: George G. Davis <gdavis@mvista.com>
  Thanks. Merged into my tree.

								Honza

> ---
> This fixes a long standing ARM Linux kernel UDF_FS build warning [1].
> 
> [1] http://armlinux.simtec.co.uk/kautobuild/2.6.37/warnings.html#modules
> 
>  fs/udf/balloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index 306ee39..8994dd0 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -31,7 +31,7 @@
>  #define udf_set_bit(nr, addr) ext2_set_bit(nr, addr)
>  #define udf_test_bit(nr, addr) ext2_test_bit(nr, addr)
>  #define udf_find_next_one_bit(addr, size, offset) \
> -		ext2_find_next_bit(addr, size, offset)
> +		ext2_find_next_bit((unsigned long *)(addr), size, offset)
>  
>  static int read_block_bitmap(struct super_block *sb,
>  			     struct udf_bitmap *bitmap, unsigned int block,
> @@ -297,7 +297,7 @@ repeat:
>  				break;
>  			}
>  		} else {
> -			bit = udf_find_next_one_bit((char *)bh->b_data,
> +			bit = udf_find_next_one_bit(bh->b_data,
>  						    sb->s_blocksize << 3,
>  						    group_start << 3);
>  			if (bit < sb->s_blocksize << 3)
> -- 
> 1.7.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
