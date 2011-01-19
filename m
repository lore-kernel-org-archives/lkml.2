Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1ASX3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:29:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab1ASX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:29:07 -0500
Date: Wed, 19 Jan 2011 15:28:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: fix E+/F+ dir size > 2048 crashing kernel
Message-Id: <20110119152825.bc81bdfc.akpm@linux-foundation.org>
In-Reply-To: <4D2DEB59.1030605@gmail.com>
References: <4D2DEB59.1030605@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 17:56:41 +0000
Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:

> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> 
> Kernel crashes in fs/adfs module when accessing directories with a large number
> of objects on mounted Acorn ADFS E+/F+ format discs (or images) as the existing
> code writes off the end of the fixed array of struct buffer_head pointers.
> 
> Additionally, each directory access that didn't crash would leak a buffer as
> nr_buffers was not adjusted correctly for E+/F+ discs (was always left as one
> less than required).
> 
> The patch fixes this by allocating a dynamically-sized set of struct
> buffer_head pointers if necessary for the E+/F+ case (many directories still do
> in fact fit in 2048 bytes) and sets the correct nr_buffers so that all buffers
> are released.

I don't know adfs from a bar of soap.  Poor me :(

>
> ...
>
> @@ -22,30 +23,53 @@ adfs_fplus_read(struct super_block *sb,
> 
>   	dir->nr_buffers = 0;
> 
> +	/* start off using fixed bh set - only alloc for big dirs */
> +	dir->bh_fplus =&dir->bh[0];
> +
>   	block = __adfs_block_map(sb, id, 0);
>   	if (!block) {
>   		adfs_error(sb, "dir object %X has a hole at offset 0", id);
>   		goto out;
>   	}
> 
> -	dir->bh[0] = sb_bread(sb, block);
> -	if (!dir->bh[0])
> +	dir->bh_fplus[0] = sb_bread(sb, block);
> +	if (!dir->bh_fplus[0])
>   		goto out;
>   	dir->nr_buffers += 1;
> 
> -	h = (struct adfs_bigdirheader *)dir->bh[0]->b_data;
> +	h = (struct adfs_bigdirheader *)dir->bh_fplus[0]->b_data;
>   	size = le32_to_cpu(h->bigdirsize);
>   	if (size != sz) {
> -		printk(KERN_WARNING "adfs: adfs_fplus_read: directory header size\n"
> -				" does not match directory size\n");
> +		printk(KERN_WARNING "adfs: adfs_fplus_read:"
> +					" directory header size %X\n"
> +					" does not match directory size %X\n",
> +					size, sz);
>   	}
> 
>   	if (h->bigdirversion[0] != 0 || h->bigdirversion[1] != 0 ||
>   	    h->bigdirversion[2] != 0 || size&  2047 ||
> -	    h->bigdirstartname != cpu_to_le32(BIGDIRSTARTNAME))
> +	    h->bigdirstartname != cpu_to_le32(BIGDIRSTARTNAME)) {
> +		printk(KERN_WARNING "adfs: dir object %X has"
> +					" malformed dir header\n", id);
>   		goto out;
> +	}
> 
>   	size>>= sb->s_blocksize_bits;
> +	if (size>  sizeof(dir->bh)/sizeof(dir->bh[0])) {
> +		/* this directory is too big for fixed bh set, must allocate */
> +		struct buffer_head **bh_fplus =
> +			kzalloc(size * sizeof(struct buffer_head *),
> +				GFP_KERNEL);

kcalloc() would produce a safer and more pleasing result here.

> +		if (!bh_fplus) {
> +			adfs_error(sb, "not enough memory for"
> +					" dir object %X (%d blocks)", id, size);
> +			goto out;
> +		}
> +		dir->bh_fplus = bh_fplus;
> +		/* copy over the pointer to the block that we've already read */
> +		dir->bh_fplus[0] = dir->bh[0];
> +	}
> +
>   	for (blk = 1; blk<  size; blk++) {
>   		block = __adfs_block_map(sb, id, blk);
>   		if (!block) {
> @@ -53,25 +77,44 @@ adfs_fplus_read(struct super_block *sb,
>   			goto out;
>   		}
> 
> -		dir->bh[blk] = sb_bread(sb, block);
> -		if (!dir->bh[blk])
> +		dir->bh_fplus[blk] = sb_bread(sb, block);
> +		if (!dir->bh_fplus[blk]) {
> +			adfs_error(sb,	"dir object %X failed read for"
> +					" offset %d, mapped block %X",
> +					id, blk, block);
>   			goto out;
> -		dir->nr_buffers = blk;
> +		}
> +
> +		dir->nr_buffers += 1;
>   	}
> 
> -	t = (struct adfs_bigdirtail *)(dir->bh[size - 1]->b_data + (sb->s_blocksize - 8));
> +	t = (struct adfs_bigdirtail *)
> +		(dir->bh_fplus[size - 1]->b_data + (sb->s_blocksize - 8));
> 
>   	if (t->bigdirendname != cpu_to_le32(BIGDIRENDNAME) ||
>   	    t->bigdirendmasseq != h->startmasseq ||
> -	    t->reserved[0] != 0 || t->reserved[1] != 0)
> +	    t->reserved[0] != 0 || t->reserved[1] != 0) {
> +		printk(KERN_WARNING "adfs: dir object %X has "
> +					"malformed dir end\n", id);
>   		goto out;
> +	}
> 
>   	dir->parent_id = le32_to_cpu(h->bigdirparent);
>   	dir->sb = sb;
>   	return 0;
> +
>   out:
> -	for (i = 0; i<  dir->nr_buffers; i++)
> -		brelse(dir->bh[i]);
> +	if (dir->bh_fplus) {
> +		for (i = 0; i<  dir->nr_buffers; i++)

Strange that checkpatch didn't complain about the layout here.

> +			brelse(dir->bh_fplus[i]);

brelse() is only needed if the bh might be NULL.  Otherwise, put_bh().

> +		if (&dir->bh[0] != dir->bh_fplus)
> +			kfree(dir->bh_fplus);
> +
> +		dir->bh_fplus = NULL;
> +	}
> +
> +	dir->nr_buffers = 0;
>   	dir->sb = NULL;
>   	return ret;
>   }
>
> ...
>
> @@ -174,8 +224,17 @@ adfs_fplus_free(struct adfs_dir *dir)
>   {
>   	int i;
> 
> -	for (i = 0; i<  dir->nr_buffers; i++)
> -		brelse(dir->bh[i]);
> +	if (dir->bh_fplus) {
> +		for (i = 0; i<  dir->nr_buffers; i++)
> +			brelse(dir->bh_fplus[i]);
> +
> +		if (&dir->bh[0] != dir->bh_fplus)
> +			kfree(dir->bh_fplus);
> +
> +		dir->bh_fplus = NULL;
> +	}
> +
> +	dir->nr_buffers = 0;
>   	dir->sb = NULL;
>   }

Dittoes.


Oh well, the code eyeballs OK to me and you tested it, so I'll toss it
in there.  
