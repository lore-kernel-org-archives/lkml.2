Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2KZPIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:08:06 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60802 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2KZPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:08:04 -0500
Message-ID: <50B3858D.2060404@linux.vnet.ibm.com>
Date: Mon, 26 Nov 2012 07:06:53 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: Fix return value of capture_free_page
References: <20121121192151.3FFE0A9A@kernel.stglabs.ibm.com> <20121126112350.GI8218@suse.de>
In-Reply-To: <20121126112350.GI8218@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112615-7282-0000-0000-00000F59FC65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 03:23 AM, Mel Gorman wrote:
> On Wed, Nov 21, 2012 at 02:21:51PM -0500, Dave Hansen wrote:
>>
>> This needs to make it in before 3.7 is released.
>>
> 
> This is also required. Dave, can you double check? The surprise is that
> this does not blow up very obviously.
...
> @@ -1422,7 +1422,7 @@ int capture_free_page(struct page *page, int alloc_order, int migratetype)
>  		}
>  	}
> 
> -	return 1UL << order;
> +	return 1UL << alloc_order;
>  }

compact_capture_page() only looks at the boolean return value out of
capture_free_page(), so it wouldn't notice.  split_free_page() does.
But, when it calls capture_free_page(), order==alloc_order, so it
wouldn't make a difference.  So, there's probably no actual bug here,
but it's certainly a wrong return value.

We should probably also fix the set_pageblock_migratetype() loop in
there while we're at it.  I think it's potentially trampling on the
migration type of pages currently in the allocator.  I _think_ that
completes the list of things that need to get audited in there.

