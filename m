Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2EQPzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:55:55 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40694 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab2EQPzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:55:53 -0400
Message-ID: <4FB51F7D.9070105@cs.wisc.edu>
Date: Thu, 17 May 2012 10:55:41 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ravi Anand <ravi.anand@qlogic.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] qla4xxx: don't free pool that wasn't allocated
References: <20120517071120.GG14660@elgon.mountain>
In-Reply-To: <20120517071120.GG14660@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 02:11 AM, Dan Carpenter wrote:
> In the original code if dma_pool_alloc() fails then we call
> dma_pool_free().  The problem is that "chap_table" is NULL and
> "chap_dma" is uninitialized so it will cause an error.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 7ac21da..21dce92 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -1329,10 +1329,8 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
>  	dma_addr_t chap_dma;
>  
>  	chap_table = dma_pool_alloc(ha->chap_dma_pool, GFP_KERNEL, &chap_dma);
> -	if (chap_table == NULL) {
> -		ret = -ENOMEM;
> -		goto exit_get_chap;
> -	}
> +	if (chap_table == NULL)
> +		return -ENOMEM;
>  
>  	chap_size = sizeof(struct ql4_chap_table);
>  	memset(chap_table, 0, chap_size);

I thought dma_pool_free checked the vaddr/chap_table like how kfree
checks for nulls. You are right. Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
