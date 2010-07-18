Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0GRHxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:53:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49036 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0GRHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:53:20 -0400
Message-ID: <4C42B2E4.4040504@cs.helsinki.fi>
Date: Sun, 18 Jul 2010 10:53:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] Use xvmalloc to store compressed chunks
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org> <1279283870-18549-8-git-send-email-ngupta@vflare.org>
In-Reply-To: <1279283870-18549-8-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> @@ -528,17 +581,32 @@ static int zcache_store_page(struct zcache_inode_rb *znode,
>  		goto out;
>  	}
>  
> -	dest_data = kmap_atomic(zpage, KM_USER0);
> +	local_irq_save(flags);

Does xv_malloc() required interrupts to be disabled? If so, why doesn't 
the function do it by itself?

> +	ret = xv_malloc(zpool->xv_pool, clen + sizeof(*zheader),
> +			&zpage, &zoffset, GFP_NOWAIT);
> +	local_irq_restore(flags);
> +	if (unlikely(ret)) {
> +		ret = -ENOMEM;
> +		preempt_enable();
> +		goto out;
> +	}
