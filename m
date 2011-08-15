Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1HOLMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:12:08 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19223 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1HOLMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:12:07 -0400
Message-ID: <4E48FD8A.90401@parallels.com>
Date: Mon, 15 Aug 2011 15:05:46 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <jbottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>	<1313334832-1150-4-git-send-email-glommer@parallels.com>	<CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>	<20110815104656.GG26978@dastard> <CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>
In-Reply-To: <CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 02:58 PM, Pekka Enberg wrote:
> Hi Dave,
> 
> On Mon, Aug 15, 2011 at 1:46 PM, Dave Chinner <david@fromorbit.com> wrote:
>> That's usage for the entire slab, though, and we don't have a dentry
>> slab per superblock so I don't think that helps us. And with slab
>> merging, I think that even if we did have a slab per superblock,
>> they'd end up in the same slab context anyway, right?
> 
> You could add a flag to disable slab merging but there's no sane way
> to fix the per-superblock thing in slab.
> 
> On Mon, Aug 15, 2011 at 1:46 PM, Dave Chinner <david@fromorbit.com> wrote:
>> Ideally what we need is a slab, LRU and shrinkers all rolled into a
>> single infrastructure handle so we can simply set them up per
>> object, per context etc and not have to re-invent the wheel for
>> every single slab cache/LRU/shrinker setup we have in the kernel.
>>
>> I've got a rough node-aware generic LRU/shrinker infrastructure
>> prototype that is generic enough for most of the existing slab
>> caches with shrinkers, but I haven't looked at what is needed to
>> integrate it with the slab cache code. That's mainly because I don't
>> like the idea of having to implement the same thing 3 times in 3
>> different ways and debug them all before anyone would consider it
>> for inclusion in the kernel.
>>
>> Once I've sorted out the select_parent() use-the-LRU-for-disposal
>> abuse and have a patch set that survives a 'rm -rf *' operation,
>> maybe we can then talk about what is needed to integrate stuff into
>> the slab caches....
> 
> Well, now that I really understand what you're trying to do here, it's
> probably best to keep slab as-is and implement "slab accounting" on
> top of it.
> 
> You'd have something like you do now but in slightly more generic form:
> 
>   struct kmem_accounted_cache {
>                   struct kmem_cache *cache;
>                   /* ... statistics... */
>   }
> 
>   void *kmem_accounted_alloc(struct kmem_accounted_cache *c)
>   {
>           if (/* within limits */)
>                   return kmem_cache_alloc(c->cache);
> 
>           return NULL;
>   }
> 
> Does something like that make sense to you?

This will make sense, since the kernel memory management per-cgroup is one of the
things we'd live to have, but this particular idea will definitely not work in case
we keep the containers' files on one partition keeping each container in its own 
chroot environment.

>                         Pekka
> .
> 

