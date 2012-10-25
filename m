Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676Ab2JYNnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:43:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51149 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965599Ab2JYNnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:43:15 -0400
Message-ID: <508941DF.90204@parallels.com>
Date: Thu, 25 Oct 2012 17:42:55 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: JoonSoo Kim <js1304@gmail.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 06/18] consider a memcg parameter in kmem_create_cache
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-7-git-send-email-glommer@parallels.com> <CAAmzW4OJGSpEO2_p3v1MZJrh6G=+NSS5UoGqFDvxeaQ0qryvpw@mail.gmail.com>
In-Reply-To: <CAAmzW4OJGSpEO2_p3v1MZJrh6G=+NSS5UoGqFDvxeaQ0qryvpw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 09:50 PM, JoonSoo Kim wrote:
>> -struct kmem_cache *__kmem_cache_alias(const char *name, size_t size,
>> > -               size_t align, unsigned long flags, void (*ctor)(void *))
>> > +struct kmem_cache *
>> > +__kmem_cache_alias(struct mem_cgroup *memcg, const char *name, size_t size,
>> > +                  size_t align, unsigned long flags, void (*ctor)(void *))
>> >  {
>> >         struct kmem_cache *s;
>> >
>> > -       s = find_mergeable(size, align, flags, name, ctor);
>> > +       s = find_mergeable(memcg, size, align, flags, name, ctor);
>> >         if (s) {
>> >                 s->refcount++;
>> >                 /*
> If your intention is that find_mergeable() works for memcg-slab-caches properly,
> it cannot works properly with this code.
> When memcg is not NULL, slab cache is only added to memcg's slab cache list.
> find_mergeable() only interate on original-slab-cache list.
> So memcg slab cache never be mergeable.

Actually, recent results made me reconsider this.

I split this in multiple lists so we could transverse the lists faster
for /proc/slabinfo.

Turns out, there are many places that will rely on the ability to scan
through *all* caches in the system (root or not). This is one (easily
fixable) example, but there are others, like the hotplug handlers.

That said, I don't think that /proc/slabinfo is *that* performance
sensitive, so it is better to just skip the non-root caches, and just
keep all caches in the global list.

Maybe we would still benefit from a memcg-side list, for example, when
we're destructing memcg, so I'll consider keeping that (with a list
field in memcg_params). But even for that one, is still doable to
transverse the whole list...



