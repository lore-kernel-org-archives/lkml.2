Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab0DOJkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 05:40:11 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:60813 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab0DOJkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 05:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I8TwFJyBlYqsBKyuD2Kz7t4enAaWsaJdO2pQvgOqk+kEWQsIN9oW+IYjLd8TlhEWYA
         q2NmK01mYcPQSslYDhfXXsyj+V+wXCjxRM/SlZ1LTDJvuOe7BFoDuZJbs7EDmouDYWBG
         4Wiw8LVffJPvBsCaSS6wdVLu7OVSthTnBDmFI=
MIME-Version: 1.0
In-Reply-To: <4BC6CB30.7030308@kernel.org>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>
	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org>
	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
	 <4BC6BE78.1030503@kernel.org>
	 <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
	 <4BC6CB30.7030308@kernel.org>
Date: Thu, 15 Apr 2010 18:40:09 +0900
Message-ID: <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 5:15 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/15/2010 05:00 PM, Minchan Kim wrote:
>> Yes. I don't like it.
>> With it, someone who does care about API usage uses alloc_pages_exact_node but
>> someone who don't have a time or careless uses alloc_pages_node.
>> It would make API fragmentation and not good.
>> Maybe we can weed out -1 and make new API which is more clear.
>>
>> * struct page *alloc_pages_any_node(gfp_t gfp_mask, unsigned int order);
>> * struct page *alloc_pages_exact_node(int nid, gfp_mask, unsigned int order);
>
> I'm not an expert on that part of the kernel but isn't
> alloc_pages_any_node() identical to alloc_pages_exact_node()?  All

alloc_pages_any_node means user allows allocated pages in any
node(most likely current node)
alloc_pages_exact_node means user allows allocated pages in nid node
if he doesn't use __GFP_THISNODE.

> that's necessary to do now is to weed out callers which pass in
> negative nid to alloc_pages_node(), right?  If so, why not just do a

It might be my final goal. I hope user uses alloc_pages_any_node
instead of nid == -1.

> clean sweep of alloc_pages_node() users and update them so that they
> don't call in w/ -1 nid and add WARN_ON_ONCE() in alloc_pages_node()?
> Is there any reason to keep both variants going forward?  If not,

I am not sure someone still need alloc_pages_node. That's because
sometime he want to allocate page from specific node but sometime not.
I hope it doesn't happen. Anyway I have to identify the situation.

> introducing new API just to weed out invalid usages seems like an
> overkill.

It might be.

It think it's almost same add_to_page_cache and add_to_page_cache_locked.
If user knows the page is already locked, he can use
add_to_page_cache_locked for performance gain and code readability
which we need to lock the page before calling it.
The important point is that user uses it as he is conscious of locked page.
I think if user already know to want page where from specific node, it
would be better to use alloc_pages_exact_node instead of
alloc_pages_node.

If he want to allocate page from any node[current..fallback list], he
have to use alloc_pages_any_node without nid argument. It would make a
little performance gain(reduce passing argument) and good readbility.
:)

Now, most of user uses alloc_pages_exact_node. So I think we can do it.
But someone else also might think of overkill. :)
It's a not urgent issue. So I will take it easy.

Thanks.

-- 
Kind regards,
Minchan Kim
