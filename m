Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1GaLlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 07:41:50 -0400
Received: from relay.parallels.com ([195.214.232.42]:46472 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1GaLln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 07:41:43 -0400
Message-ID: <4E353F6B.1030501@parallels.com>
Date: Sun, 31 Jul 2011 15:41:31 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
References: <20110720121612.28888.38970.stgit@localhost6>	 <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>	 <alpine.DEB.2.00.1107200854390.32737@router.home>	 <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <alpine.DEB.2.00.1107200950270.1472@router.home> <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems someone forgot this patch,
the second one "slab: shrink sizeof(struct kmem_cache)" already in mainline

Eric Dumazet wrote:
> Le mercredi 20 juillet 2011 à 09:52 -0500, Christoph Lameter a écrit :
>> On Wed, 20 Jul 2011, Eric Dumazet wrote:
>>
>>>> Slab's kmem_cache is configured with an array of NR_CPUS which is the
>>>> maximum nr of cpus supported. Some distros support 4096 cpus in order to
>>>> accomodate SGI machines. That array then will have the size of 4096 * 8 =
>>>> 32k
>>>
>>> We currently support a dynamic schem for the possible nodes :
>>>
>>> cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
>>> 	nr_node_ids * sizeof(struct kmem_list3 *);
>>>
>>> We could have a similar trick to make the real size both depends on
>>> nr_node_ids and nr_cpu_ids.
>>>
>>> (struct kmem_cache)->array would become a pointer.
>>
>> We should be making it a per cpu pointer like slub then. I looked at what
>> it would take to do so a couple of month ago but it was quite invasive.
>>
>
> Lets try this first patch, simple enough : No need to setup percpu data
> for a one time use structure...
>
> [PATCH] slab: remove one NR_CPUS dependency
>
> Reduce high order allocations in do_tune_cpucache() for some setups.
> (NR_CPUS=4096 ->  we need 64KB)
>
> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> CC: Pekka Enberg<penberg@kernel.org>
> CC: Christoph Lameter<cl@linux.com>
> ---
>   mm/slab.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index d96e223..862bd12 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3933,7 +3933,7 @@ fail:
>
>   struct ccupdate_struct {
>   	struct kmem_cache *cachep;
> -	struct array_cache *new[NR_CPUS];
> +	struct array_cache *new[0];
>   };
>
>   static void do_ccupdate_local(void *info)
> @@ -3955,7 +3955,8 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
>   	struct ccupdate_struct *new;
>   	int i;
>
> -	new = kzalloc(sizeof(*new), gfp);
> +	new = kzalloc(sizeof(*new) + nr_cpu_ids * sizeof(struct array_cache *),
> +		      gfp);
>   	if (!new)
>   		return -ENOMEM;
>
>
>

