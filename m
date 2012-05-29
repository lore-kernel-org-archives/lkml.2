Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2E2QdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:33:24 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36682 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751380Ab2E2QdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:33:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: whR2akUVM1lf_CHA4cRijX1OlpDbEqvdc3wKpgkprzXi73E
 oRQ5vAI2a.DFyVn81bcOI5xbuhTvxF8XRU_hj7Yo7AL03aHRNytmx4Birbs7
 4rZEPj016q5uZ9PYVHodsiuvkq53DgBcZdlQDZdNN9Hz5EPJE3ImSTM4ctIi
 5DnQngaj7iTz4Fma1aBC673272fKT7aDK.Zbd75QQENCvCIafNI9N_ObUTYn
 W4PENw.OsCWzfE4QTjbbgXibnRyJBHeTGD1BgA27b1NS2k2bj7lYe9ATEqIh
 7fRbDbt3eez2mUrHgIGrVxRlZLqHi1XHXL_N9_cIDvWADOLuKcwP.q3tRqFJ
 0pf4kERSOMLuFTUiB3_4F5_ziNfZ2307Cs1KV3TtkEecSEeKuPwb37Ukjxxk
 7
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 11:33:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 12/28] slab: pass memcg parameter to
 kmem_cache_create
In-Reply-To: <4FC4F04F.1070401@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291131590.6723@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290922340.4666@router.home> <4FC4F04F.1070401@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> > Ok this only duplicates the kmalloc arrays. Why not the others?
>
> It does duplicate the others.
>
> First it does a while look on the kmalloc caches, then a list_for_each_entry
> in the rest. You probably missed it.

There is no need to separately duplicate the kmalloc_caches. Those are
included on the cache_chain.

> > > @@ -2543,7 +2564,12 @@ kmem_cache_create (const char *name, size_t size,
> > > size_t align,
> > >   	cachep->ctor = ctor;
> > >   	cachep->name = name;
> > >
> > > +	if (g_cpucache_up>= FULL)
> > > +		mem_cgroup_register_cache(memcg, cachep);
> >
> > What happens if a cgroup was active during creation of slab xxy but
> > then a process running in a different cgroup uses that slab to allocate
> > memory? Is it charged to the first cgroup?
>
> I don't see this situation ever happening. kmem_cache_create, when called
> directly, will always create a global cache. It doesn't matter which cgroups
> are or aren't active at this time or any other. We create copies per-cgroup,
> but we create it lazily, when someone will touch it.

How do you detect that someone is touching it?
