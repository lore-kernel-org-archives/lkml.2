Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2E2QxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:53:02 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:41656 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753331Ab2E2QxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:53:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KZQQcFkVM1nTuJCFsqLxLYVcvOXmO4ktpYvDcM46KGS.2w.
 SRGI4eZvot0Aiu61xQe9JqlWGTp1ciTnSgyBZpjg28jvnviXZh34XGzV0YdK
 j.VZSqnay49H220tuKAJUO5bgpXlHpAX5o1OKkXWTxQntOqCoIbRL5mub7Uu
 14yN2x8lR2vppHV_draHRSqO59.yv47E6dShnLG6aMnY0np0u9Q2u9Aen1Zq
 PN8y9fjpzJjF3Dk2rMKakasdJRSreSS9uVQMvJO2BCDHjVoOhGJK6nZ__axj
 pb0JRgr6aQioo3YG.60iAADIgI3.JJaboGUIEwsGvWAKvJdFb8h.Lj6D6fHl
 do3Qme2jkTEVyihsYcAcfk60Qk5erq1k1XgUP0In4Y8axfinPDRkHXVqotUk
 6tDKVJFcrQFExyasr2SDxYxDJLuH2puDiQ3jF
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 11:52:55 -0500 (CDT)
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
In-Reply-To: <4FC4FAF6.8060900@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291149280.8406@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290922340.4666@router.home> <4FC4F04F.1070401@parallels.com> <alpine.DEB.2.00.1205291131590.6723@router.home>
 <4FC4FAF6.8060900@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> > How do you detect that someone is touching it?
>
> kmem_alloc_cache will create mem_cgroup_get_kmem_cache.
> (protected by static_branches, so won't happen if you don't have at least
> non-root memcg using it)
>
> * Then it detects which memcg the calling process belongs to,
> * if it is the root memcg, go back to the allocation as quickly as we
>   can
> * otherwise, in the creation process, you will notice that each cache
>   has an index. memcg will store pointers to the copies and find them by
>   the index.
>
> From this point on, all the code of the caches is reused (except for
> accounting the page)

Well kmem_cache_alloc cache is the performance critical hotpath.

If you are already there and doing all of that then would it not be better
to simply count the objects allocated and freed per cgroup? Directly
increment and decrement counters in a cgroup? You do not really need to
duplicate the kmem_cache structure and do not need to modify allocators if
you are willing to take that kind of a performance hit. Put a wrapper
around kmem_cache_alloc/free and count things.




