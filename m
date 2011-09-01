Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1IAPnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:43:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43958 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab1IAPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:43:39 -0400
Message-ID: <4E5FA81F.6060607@linux.vnet.ibm.com>
Date: Thu, 01 Sep 2011 10:43:27 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        ngupta@vflare.org, cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: zcache: xcfmalloc memory allocator for zcache
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com> <1314801641-15059-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1314801641-15059-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 09:40 AM, Seth Jennings wrote:

> +static struct xcf_blkdesc *xcf_find_remove_block(struct xcf_pool *pool,
> +	int size, int blocknum)
> +{
> +	int flindex, i;
> +	struct xcf_blkdesc *desc = NULL;
> +
> +	flindex = xcf_size_to_flindex(size + sizeof(struct xcf_blkhdr));
> +
> +	/* look for best fit */
> +	if (pool->freelists[flindex])
> +		goto remove;
> +
> +	/* if this is the last block allowed in the allocation, we shouldn't
> +	 * consider smaller blocks.  it's all or nothing now */
> +	if (blocknum == XCF_MAX_BLOCKS_PER_ALLOC) {

In gathering my performance numbers for Dan, I discovered I introduced
a regression by making a late change in my development.

This line should be:
	if (blocknum != XCF_MAX_BLOCKS_PER_ALLOC) {

This regression actually causes xcfmalloc to have the same fragmentation
issue as xvmalloc.

> +		/* look for largest smaller block */
> +		for (i = flindex; i > 0; i--) {
> +			if (pool->freelists[i]) {
> +				flindex = i;
> +				goto remove;
> +			}
> +		}
> +	}

--
Seth
