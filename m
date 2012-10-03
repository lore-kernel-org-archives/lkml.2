Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab2JCPuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:50:12 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56493 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898Ab2JCPuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:50:09 -0400
Message-ID: <506C5E73.6080503@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 21:19:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4] mm, slab: release slab_mutex earlier in kmem_cache_destroy()
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <20121002170149.GC2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz> <20121002233138.GD2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030142570.23544@pobox.suse.cz> <20121003001530.GF2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030227430.23544@pobox.suse.cz> <0000013a26fb253a-fb5df733-ad41-47c1-af1d-3d6739e417de-000000@email.amazonses.com> <alpine.LNX.2.00.1210031631150.23544@pobox.suse.cz> <506C52FC.4040305@linux.vnet.ibm.com> <alpine.LNX.2.00.1210031703500.23544@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1210031703500.23544@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100315-1618-0000-0000-000002953D5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 08:35 PM, Jiri Kosina wrote:
> On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
> 
>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>> index 9c21725..90c3053 100644
>>> --- a/mm/slab_common.c
>>> +++ b/mm/slab_common.c
>>> @@ -166,6 +166,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>>>  	s->refcount--;
>>>  	if (!s->refcount) {
>>>  		list_del(&s->list);
>>> +		mutex_unlock(&slab_mutex);
>>>
>>>  		if (!__kmem_cache_shutdown(s)) {
>>
>> __kmem_cache_shutdown() calls __cache_shrink(). And __cache_shrink() has this
>> comment over it:
>> /* Called with slab_mutex held to protect against cpu hotplug */
>>
>> So, I guess the question is whether to modify your patch to hold the slab_mutex
>> while calling this function, or to update the comment on top of this function
>> saying that we are OK to call this function (even without slab_mutex) when we
>> are inside a get/put_online_cpus() section.
>>
>>>  			if (s->flags & SLAB_DESTROY_BY_RCU)
>>> @@ -179,8 +180,9 @@ void kmem_cache_destroy(struct kmem_cache *s)
>>>  				s->name);
>>>  			dump_stack();
>>
>> There is a list_add() before this dump_stack(). I assume we need to hold the
>> slab_mutex while calling it.
> 
> Gah, of course it is, thanks for spotting this.
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] mm, slab: release slab_mutex earlier in kmem_cache_destroy()
> 
> Commit 1331e7a1bbe1 ("rcu: Remove _rcu_barrier() dependency on
> __stop_machine()") introduced slab_mutex -> cpu_hotplug.lock
> dependency through kmem_cache_destroy() -> rcu_barrier() ->
> _rcu_barrier() -> get_online_cpus().
> 
> Lockdep thinks that this might actually result in ABBA deadlock,
> and reports it as below:
> 
[...]
> This patch therefore moves the unlock of slab_mutex so that rcu_barrier()
> is being called with it unlocked. It has two advantages:
> 
> - it slightly reduces hold time of slab_mutex; as it's used to protect
>   the cachep list, it's not necessary to hold it over kmem_cache_free()
>   call any more
> - it silences the lockdep false positive warning, as it avoids lockdep ever
>   learning about slab_mutex -> cpu_hotplug.lock dependency
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Hmm.. We can't do much about readability I guess... :(

Regards,
Srivatsa S. Bhat

> ---
>  mm/slab_common.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 9c21725..069a24e6 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -168,6 +168,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  		list_del(&s->list);
> 
>  		if (!__kmem_cache_shutdown(s)) {
> +			mutex_unlock(&slab_mutex);
>  			if (s->flags & SLAB_DESTROY_BY_RCU)
>  				rcu_barrier();
> 
> @@ -175,12 +176,14 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  			kmem_cache_free(kmem_cache, s);
>  		} else {
>  			list_add(&s->list, &slab_caches);
> +			mutex_unlock(&slab_mutex);
>  			printk(KERN_ERR "kmem_cache_destroy %s: Slab cache still has objects\n",
>  				s->name);
>  			dump_stack();
>  		}
> +	} else {
> +		mutex_unlock(&slab_mutex);
>  	}
> -	mutex_unlock(&slab_mutex);
>  	put_online_cpus();
>  }
>  EXPORT_SYMBOL(kmem_cache_destroy);
> 

