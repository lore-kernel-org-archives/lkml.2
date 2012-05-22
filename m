Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab2EVJrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:47:18 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37968 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2EVJrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:47:16 -0400
Message-ID: <4FBB6028.3020307@parallels.com>
Date: Tue, 22 May 2012 13:45:12 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 07:22 AM, David Rientjes wrote:
>> -	if (setup_cpu_cache(cachep, gfp)) {
>> >  +	/* Can't do strdup while kmalloc is not up */
>> >  +	if (g_cpucache_up>  EARLY)
>> >  +		cachep->name = kstrdup(name, GFP_KERNEL);
>> >  +	else
>> >  +		cachep->name = name;
>> >  +
>> >  +	if (!cachep->name || setup_cpu_cache(cachep, gfp)) {
>> >    		__kmem_cache_destroy(cachep);
>> >    		cachep = NULL;
>> >    		goto oops;
> This doesn't work if you kmem_cache_destroy() a cache that was created
> when g_cpucache_cpu<= EARLY, the kfree() will explode.  That never
> happens for any existing cache created in kmem_cache_init(), but this
> would introduce the first roadblock in doing so.  So you'll need some
> magic to determine whether the cache was allocated statically and suppress
> the kfree() in such a case.

David,

I tried to do something like I was doing for the memcg caches: after 
creation of the kmalloc + cache_cache, I loop through them and duplicate 
the name. So instead of conditionally freeing the late caches - that 
could cause consistency headaches in the future - kfree'ing the name 
string will just work for all of them. I will send it shortly.

Cristoph, I am dropping your ack since this change is quite significant. 
If you agree with it, would you ack it again?

Thanks.
