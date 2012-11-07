Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2KGHNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:13:22 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49722 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2KGHNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:13:20 -0500
Message-ID: <509A0A04.2030503@parallels.com>
Date: Wed, 7 Nov 2012 08:13:08 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 25/29] memcg/sl[au]b: shrink dead caches
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-26-git-send-email-glommer@parallels.com> <20121105164813.2eba5ecb.akpm@linux-foundation.org>
In-Reply-To: <20121105164813.2eba5ecb.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.50.55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 01:48 AM, Andrew Morton wrote:
> On Thu,  1 Nov 2012 16:07:41 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> This means that when we destroy a memcg cache that happened to be empty,
>> those caches may take a lot of time to go away: removing the memcg
>> reference won't destroy them - because there are pending references, and
>> the empty pages will stay there, until a shrinker is called upon for any
>> reason.
>>
>> In this patch, we will call kmem_cache_shrink for all dead caches that
>> cannot be destroyed because of remaining pages. After shrinking, it is
>> possible that it could be freed. If this is not the case, we'll schedule
>> a lazy worker to keep trying.
> 
> This patch is really quite nasty.  We poll the cache once per minute
> trying to shrink then free it?  a) it gives rise to concerns that there
> will be scenarios where the system could suffer unlimited memory windup
> but mainly b) it's just lame.
> 
> The kernel doesn't do this sort of thing.  The kernel tries to be
> precise: in a situation like this we keep track of the number of
> outstanding objects and when that falls to zero, we free their
> container synchronously.  If those objects are normally left floating
> around in an allocated but reclaimable state then we can address that
> by synchronously freeing them if their container has been destroyed.
> 
> Or something like that.  If it's something else then fine, but not this.
> 
> What do we need to do to fix this?
> 
The original patch had a unlikely() test in the free path, conditional
on whether or not the cache is dead, that would then call this is the
cache would now be empty.

I got several requests to remove it and change it to something like
this, because that is a fast path (I myself think an unlikely branch is
not that bad)

If you think such a test is acceptable, I can bring it back and argue in
the basis of "akpm made me do it!". But meanwhile I will give this extra
though to see if there is any alternative way I can do it...
