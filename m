Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2IFCd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:33:27 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:36679 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2IFCdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:33:25 -0400
Subject: Re: [RFC PATCH 2/3] tcm_iscsi: support multiple sizes in the
 scatterlist
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@kernel.org>
In-Reply-To: <1346858025-10459-3-git-send-email-pbonzini@redhat.com>
References: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
	 <1346858025-10459-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 19:33:20 -0700
Message-ID: <1346898800.4162.431.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 17:13 +0200, Paolo Bonzini wrote:
> The next patch will use multiple orders to satisfy the allocation
> of the data buffers.
> 
> We need to support this in iscsi_map_iovec and iscsi_unmap_iovec.
> The idea here is to walk each relevant page in the scatterlist
> (which may not be every page in the scatterlist due to data_offset)
> and kmap it.  iscsi_unmap_iovec uses the same algorithm, so that
> each kunmap maps the kmap that was used in iscsi_map_iovec.
> 

CC'ing Agrover here as he last touched the iscsit_[map,unmap]_iovec()
before the mainline merge of this code..

Also, this type of change is going to require other Reviewed-By's and
serious fio+writeverify Tested-By's to make sure we get all of the
corner cases as this enabled for upstream iscsi-target.

I'll be having a deeper look sometime next week, but as long as we can
selectively disable this for fabrics I don't have a problem considering
it for-3.7 code.

Nice work Paolo!

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c      |  106 ++++++++++++++++++++++++-----
>  drivers/target/iscsi/iscsi_target_core.h |    2 +-
>  2 files changed, 89 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 224679e..dc4f5da 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -684,45 +684,115 @@ static int iscsit_map_iovec(
>  	u32 data_offset,
>  	u32 data_length)
>  {
> -	u32 i = 0;
>  	struct scatterlist *sg;
> -	unsigned int page_off;
> +	u32 sg_off, sg_left, cur_len;
> +	u32 sg_pfn = 0;
> +	u32 i = 0;
>  
> -	/*
> -	 * We know each entry in t_data_sg contains a page.
> -	 */
> -	sg = &cmd->se_cmd.t_data_sg[data_offset / PAGE_SIZE];
> -	page_off = (data_offset % PAGE_SIZE);
> +	sg = cmd->se_cmd.t_data_sg;
> +	while (data_offset >= sg->length) {
> +		data_offset -= sg->length;
> +		sg++;
> +	}
>  
>  	cmd->first_data_sg = sg;
> -	cmd->first_data_sg_off = page_off;
> +	cmd->first_data_sg_off = sg->offset + data_offset;
> +	cmd->kmapped_length = data_length;
>  
> +	sg_left = 0;
>  	while (data_length) {
> -		u32 cur_len = min_t(u32, data_length, sg->length - page_off);
> +		if (!sg_left) {
> +			sg_off = sg->offset + data_offset;
> +			sg_pfn = page_to_pfn(sg_page(sg));
> +			sg_pfn += sg_off >> PAGE_SHIFT;
> +			sg_off &= PAGE_SIZE - 1;
> +
> +			sg_left = min(sg->length, data_length);
> +
> +			/*
> +			 * The next scatterlist is mapped from the beginning.
> +			 */
> +			sg++;
> +			data_offset = 0;
> +		}
>  
> -		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset + page_off;
> +		/*
> +		 * Create an iovec for (a part of) this page.
> +		 */
> +		cur_len = min_t(u32, PAGE_SIZE - sg_off, sg_left);
> +		BUG_ON(!cur_len);
> +
> +		iov[i].iov_base = kmap(pfn_to_page(sg_pfn)) + sg_off;
>  		iov[i].iov_len = cur_len;
> +		i++;
>  
>  		data_length -= cur_len;
> -		page_off = 0;
> -		sg = sg_next(sg);
> -		i++;
> -	}
> +		sg_left -= cur_len;
>  
> -	cmd->kmapped_nents = i;
> +		/*
> +		 * The next pfn is mapped from the beginning.
> +		 */
> +		sg_pfn++;
> +		sg_off = 0;
> +	}
>  
> +	BUG_ON(sg_left);
>  	return i;
>  }
>  
>  static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
>  {
> -	u32 i;
>  	struct scatterlist *sg;
> +	u32 data_offset, data_length;
> +	u32 sg_off, sg_left, cur_len;
> +	u32 sg_pfn = 0;
> +
> +	if (!cmd->kmapped_length)
> +		return;
>  
>  	sg = cmd->first_data_sg;
> +	data_offset = cmd->first_data_sg_off - sg->offset;
> +	data_length = cmd->kmapped_length;
> +
> +	/*
> +	 * This loop must mirror exactly what is done in iscsi_map_iovec.
> +	 */
> +	sg_left = 0;
> +	while (data_length) {
> +		if (!sg_left) {
> +			sg_off = sg->offset + data_offset;
> +			sg_pfn = page_to_pfn(sg_page(sg));
> +			sg_pfn += sg_off >> PAGE_SHIFT;
> +			sg_off &= PAGE_SIZE - 1;
> +
> +			sg_left = min(sg->length, data_length);
> +
> +			/*
> +			 * The next scatterlist is mapped from the beginning.
> +			 */
> +			sg++;
> +			data_offset = 0;
> +		}
> +
> +		/*
> +		 * Create an iovec for (a part of) this page.
> +		 */
> +		cur_len = min_t(u32, PAGE_SIZE - sg_off, sg_left);
> +		BUG_ON(!cur_len);
> +
> +		kunmap(pfn_to_page(sg_pfn));
> +		data_length -= cur_len;
> +		sg_left -= cur_len;
> +
> +		/*
> +		 * The next pfn is mapped from the beginning.
> +		 */
> +		sg_pfn++;
> +		sg_off = 0;
> +	}
>  
> -	for (i = 0; i < cmd->kmapped_nents; i++)
> -		kunmap(sg_page(&sg[i]));
> +	BUG_ON(sg_left);
> +	cmd->kmapped_length = 0;
>  }
>  
>  static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
> diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
> index 8a908b2..13bdaf1 100644
> --- a/drivers/target/iscsi/iscsi_target_core.h
> +++ b/drivers/target/iscsi/iscsi_target_core.h
> @@ -472,7 +472,7 @@ struct iscsi_cmd {
>  
>  	struct scatterlist	*first_data_sg;
>  	u32			first_data_sg_off;
> -	u32			kmapped_nents;
> +	u32			kmapped_length;
>  
>  }  ____cacheline_aligned;
>  


