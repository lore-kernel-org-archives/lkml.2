Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0CQCt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:49:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57250 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0CQCt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:49:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 06/11] Export fragmentation index via /proc/extfrag_index
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1268412087-13536-7-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie> <1268412087-13536-7-git-send-email-mel@csn.ul.ie>
Message-Id: <20100317114321.4C9A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 11:49:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * A fragmentation index only makes sense if an allocation of a requested
> + * size would fail. If that is true, the fragmentation index indicates
> + * whether external fragmentation or a lack of memory was the problem.
> + * The value can be used to determine if page reclaim or compaction
> + * should be used
> + */
> +int fragmentation_index(unsigned int order, struct contig_page_info *info)
> +{
> +	unsigned long requested = 1UL << order;
> +
> +	if (!info->free_blocks_total)
> +		return 0;
> +
> +	/* Fragmentation index only makes sense when a request would fail */
> +	if (info->free_blocks_suitable)
> +		return -1000;
> +
> +	/*
> +	 * Index is between 0 and 1 so return within 3 decimal places
> +	 *
> +	 * 0 => allocation would fail due to lack of memory
> +	 * 1 => allocation would fail due to fragmentation
> +	 */
> +	return 1000 - ( (1000+(info->free_pages * 1000 / requested)) / info->free_blocks_total);
> +}

Dumb question.

your paper (http://portal.acm.org/citation.cfm?id=1375634.1375641) says

fragmentation_index = 1 - (TotalFree/SizeRequested)/BlocksFree

but your code have extra '1000+'. Why?



Probably, I haven't understand the intention of this calculation.



