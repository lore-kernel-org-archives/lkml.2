Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1GTN2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:28:13 -0400
Received: from relay.parallels.com ([195.214.232.42]:55325 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1GTN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:28:12 -0400
Message-ID: <4E26D7EA.3000902@parallels.com>
Date: Wed, 20 Jul 2011 17:28:10 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
References: <20110720121612.28888.38970.stgit@localhost6> <alpine.DEB.2.00.1107201611010.3528@tiger>
In-Reply-To: <alpine.DEB.2.00.1107201611010.3528@tiger>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Wed, 20 Jul 2011, Konstantin Khlebnikov wrote:
>> Order of sizeof(struct kmem_cache) can be bigger than PAGE_ALLOC_COSTLY_ORDER,
>> thus there is a good chance of unsuccessful allocation.
>> With __GFP_REPEAT buddy-allocator will reclaim/compact memory more aggressively.
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> ---
>> mm/slab.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index d96e223..53bddc8 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -2304,7 +2304,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>> 		gfp = GFP_NOWAIT;
>>
>> 	/* Get cache's description obj. */
>> -	cachep = kmem_cache_zalloc(&cache_cache, gfp);
>> +	cachep = kmem_cache_zalloc(&cache_cache, gfp | __GFP_REPEAT);
>> 	if (!cachep)
>> 		goto oops;
>
> The changelog isn't that convincing, really. This is kmem_cache_create()
> so I'm surprised we'd ever get NULL here in practice. Does this fix some
> problem you're seeing? If this is really an issue, I'd blame the page
> allocator as GFP_KERNEL should just work.

nf_conntrack creates separate slab-cache for each net-namespace,
this patch of course not eliminates the chance of failure, but makes it more acceptable.

struct kmem_size for slub is more compact, it uses pecpu-pointers instead of dumb NR_CPUS-size array.
probably better to fix this side...

>
>   			Pekka

