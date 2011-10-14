Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab1JNRF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:05:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60665 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348Ab1JNRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:05:57 -0400
Message-ID: <4E986B85.6020006@linux.vnet.ibm.com>
Date: Fri, 14 Oct 2011 12:04:05 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: gregkh@suse.de, cascardo@holoscopio.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, rcj@linux.vnet.ibm.com, brking@linux.vnet.ibm.com
Subject: Re: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
References: <1318448460-5930-1-git-send-email-sjenning@linux.vnet.ibm.com> <3e84809b-a45d-4980-b342-c2d671f87f79@default>
In-Reply-To: <3e84809b-a45d-4980-b342-c2d671f87f79@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 03:39 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: [PATCH] staging: zcache: remove zcache_direct_reclaim_lock
>>
>> zcache_do_preload() currently does a spin_trylock() on the
>> zcache_direct_reclaim_lock. Holding this lock intends to prevent
>> shrink_zcache_memory() from evicting zbud pages as a result
>> of a preload.
>>
>> However, it also prevents two threads from
>> executing zcache_do_preload() at the same time.  The first
>> thread will obtain the lock and the second thread's spin_trylock()
>> will fail (an aborted preload) causing the page to be either lost
>> (cleancache) or pushed out to the swap device (frontswap). It
>> also doesn't ensure that the call to shrink_zcache_memory() is
>> on the same thread as the call to zcache_do_preload().
> 
> Yes, this looks to be leftover code from early in kztmem/zcache
> development.  Good analysis.
>  
>> Additional, there is no need for this mechanism because all
>> zcache_do_preload() calls that come down from cleancache already
>> have PF_MEMALLOC set in the process flags which prevents
>> direct reclaim in the memory manager. If the zcache_do_preload()
> 
> Might it be worthwhile to add a BUG/ASSERT for the presence
> of PF_MEMALLOC, or at least a comment in the code?

I was mistaken in my commit comments. Not all cleancache calls have
PF_MEMALLOC set.  One exception is calls from the cgroup code paths.

However, there isn't a way for the code to loop back on itself.

Regardless of whether or not PF_MEMALLOC is set coming into
the preload, the call path only goes one way:

zcache_do_preload()
kmem_cache_alloc()
possibly reclaim and call to shrink_zcache_memory()
zbud_evict_pages()

Nothing done in zbud_evict_pages() can result in a call back to
zcache_do_preload().  So there isn't a threat of recursion.

NOW, if the logic your are trying to implement is: "Don't kick
out zbud pages as the result of preload allocations" then that's
a different story.

If the preload is called with PF_MEMALLOC set, then 
the shrinker will not be run during a kmem_cache_alloc().

However if the preload is called with PF_MEMALLOC being set
then there is a chance that some zbud pages might be reclaimed
as a result.  BUT, I'm not convinced that is a bad thing.

> 
>> call is done from the frontswap path, we _want_ reclaim to be
>> done (which it isn't right now).
>>
>> This patch removes the zcache_direct_reclaim_lock and related
>> statistics in zcache.
>>
>> Based on v3.1-rc8
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> With added code/comment per above...
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 

