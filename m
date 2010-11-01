Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0KAUnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:43:03 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22402 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0KAUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:43:00 -0400
Date: Mon, 1 Nov 2010 21:32:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/29] Staging: yaffs2: yaffs_tagscompact: Add files
In-Reply-To: <1288636877-7964-22-git-send-email-tdent48227@gmail.com>
Message-ID: <alpine.LNX.2.00.1011012119210.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-22-git-send-email-tdent48227@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Tracey Dent wrote:

> Adding files to yaffs2 directory.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_tagscompat.c |  539 +++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_tagscompat.h |   39 ++
>  2 files changed, 578 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_tagscompat.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_tagscompat.h
> 
> diff --git a/drivers/staging/yaffs2/yaffs_tagscompat.c b/drivers/staging/yaffs2/yaffs_tagscompat.c
> new file mode 100644
> index 0000000..1e910f2
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_tagscompat.c
[snip]
> +int yaffs_count_bits(__u8 x)
> +{
> +	int ret_val;
> +	ret_val = yaffs_count_bits_table[x];
> +	return ret_val;

How about just getting rid of the unneeded temporary variable and just 
doing:

int yaffs_count_bits(__u8 x)
{
     return yaffs_count_bits_table[x];
}

??

[snip]
> +void yaffs_calc_tags_ecc(yaffs_tags_t *tags)
> +{
> +	/* Calculate an ecc */
> +
> +	unsigned char *b = ((yaffs_tags_union_t *) tags)->as_bytes;
> +	unsigned i, j;
> +	unsigned ecc = 0;
> +	unsigned bit = 0;
> +
> +	tags->ecc = 0;

tags->ecc is not touched between here

> +
> +	for (i = 0; i < 8; i++) {
> +		for (j = 1; j & 0xff; j <<= 1) {
> +			bit++;
> +			if (b[i] & j)
> +				ecc ^= bit;
> +		}
> +	}
> +
> +	tags->ecc = ecc;

and this assignment here, so the first 'tags->ecc = 0' assignment is 
pointless and should just go away IMHO.

> +int yaffs_tags_compat_wr(yaffs_dev_t *dev,
> +						int nand_chunk,
> +						const __u8 *data,
> +						const yaffs_ext_tags *ext_tags)
> +{
> +	yaffs_spare spare;
> +	yaffs_tags_t tags;
> +
> +	yaffs_spare_init(&spare);
> +
> +	if (ext_tags->is_deleted)
> +		spare.page_status = 0;
> +	else {

purely a minor style issue, but I believe the kernel coding style here is 
to put curly braces for both the 'if' and 'else' branches if either 
requires them, so

if (ext_tags->is_deleted) {
        spare.page_status = 0;
} else {
        ...
        ...
}


[snip]
> +int yaffs_tags_compat_rd(yaffs_dev_t *dev,
> +						     int nand_chunk,
> +						     __u8 *data,
> +						     yaffs_ext_tags *ext_tags)
> +{
> +
> +	yaffs_spare spare;
> +	yaffs_tags_t tags;
> +	yaffs_ecc_result ecc_result = YAFFS_ECC_RESULT_UNKNOWN;
> +
> +	static yaffs_spare spare_ff;
> +	static int init;
> +
> +	if (!init) {
> +		memset(&spare_ff, 0xFF, sizeof(spare_ff));
> +		init = 1;
> +	}
> +
> +	if (yaffs_rd_chunk_nand
> +	    (dev, nand_chunk, data, &spare, &ecc_result, 1)) {
> +		/* ext_tags may be NULL */
> +		if (ext_tags) {
> +
> +			int deleted =
> +			    (yaffs_count_bits(spare.page_status) < 7) ? 1 : 0;
> +
> +			ext_tags->is_deleted = deleted;
> +			ext_tags->ecc_result = ecc_result;
> +			ext_tags->block_bad = 0;	/* We're reading it */
> +			/* therefore it is not a bad block */
> +			ext_tags->chunk_used =
> +			    (memcmp(&spare_ff, &spare, sizeof(spare_ff)) !=
> +			     0) ? 1 : 0;
> +
> +			if (ext_tags->chunk_used) {
> +				yaffs_get_tags_from_spare(dev, &spare, &tags);
> +
> +				ext_tags->obj_id = tags.obj_id;
> +				ext_tags->chunk_id = tags.chunk_id;
> +				ext_tags->n_bytes = tags.n_bytes_lsb;
> +
> +				if (dev->data_bytes_per_chunk >= 1024)
> +					ext_tags->n_bytes |= (((unsigned) tags.n_bytes_msb) << 10);
> +
> +				ext_tags->serial_number = tags.serial_number;
> +			}
> +		}
> +
> +		return YAFFS_OK;
> +	} else {
> +		return YAFFS_FAIL;
> +	}
> +}

Indentation could be reduced with no negative effect by doing

if (!yaffs_rd_chunk_nand
         (dev, nand_chunk, data, &spare, &ecc_result, 1))
        return YAFFS_FAIL;
...rest of function...


> +int yaffs_tags_compat_mark_bad(struct yaffs_dev_s *dev,
> +					    int flash_block)
> +{
> +
> +	yaffs_spare spare;
> +
> +	memset(&spare, 0xff, sizeof(yaffs_spare));
> +

Why is memset() used directly here, but elsewhere the yaffs_spare_init() 
function is used?


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

