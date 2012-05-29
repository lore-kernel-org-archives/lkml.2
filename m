Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2E2QBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:01:10 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:36717 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752617Ab2E2QBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:01:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: feJFvTAVM1mIQl9pfal2cfbZLBo8o92a8zNViHJeOtufGAt
 YgOTh2ksB83MfO49MUb8dHzkMyS5ps3T3K_ePp53oLiiYHaQSbORdCNV4dS5
 MDoEEJ6HMUkFB5xSN9D5DgXDTK_7cK79wI21lgsuwonYgvDT0rQlt5gg8Krc
 uXBG55V7TIOxUlZ.fgBKJOAu4wYK9D48Ywi_YnwwTdfv.b.Ag5DdU_SzpMMv
 pZ151svNjoHjJbV0l8qy2M_P6DceX3EhVPsD0hY5R7SD2xVoLJYTgFWrSzr5
 aXS3aStcHy2P2UG_9sMRPHzwMohSIGaTPr5f8cuny3eZrQioaZp1ttgezIoy
 0Vn1lZPmTakQJKFCEiMkGO1hIYCMSK9BPCOHU3RVGoqghRscv1iNZjGv6hN_
 V
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 11:01:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 00/28] kmem limitation for memcg
In-Reply-To: <4FC4EEF6.2050204@parallels.com>
Message-ID: <alpine.DEB.2.00.1205291056440.6723@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <20120525133441.GB30527@tiehlicka.suse.cz> <alpine.DEB.2.00.1205250933170.22597@router.home> <4FC3381C.9020608@parallels.com> <alpine.DEB.2.00.1205290955270.4666@router.home>
 <4FC4EEF6.2050204@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Glauber Costa wrote:

> > I think it may be simplest to only account for the pages used by a slab in
> > a memcg. That code could be added to the functions in the slab allocators
> > that interface with the page allocators. Those are not that performance
> > critical and would do not much harm.
>
> No, I don't think so. Well, accounting the page is easy, but when we do a new
> allocation, we need to match a process to its correspondent page. This will
> likely lead to flushing the internal cpu caches of the slub, for instance,
> hurting performance. That is because once we allocate a page, all objects on
> that page need to belong to the same cgroup.

Matching a process to its page is a complex thing even for pages used by
userspace.

How can you make sure that all objects on a page belong to the same
cgroup? There are various kernel allocations that have uses far beyond a
single context. There is already a certain degree of fuzziness there and
we tolerate that in other contexts as well.


> Also, you talk about intrusiveness, accounting pages is a lot more intrusive,
> since then you need to know a lot about the internal structure of each cache.
> Having the cache replicated has exactly the effect of isolating it better.

Why would you need to know about the internal structure? Just get the
current process context and use the cgroup that is readily available there
to account for the pages.

> > If you need per object accounting then the cleanest solution would be to
> > duplicate the per node arrays per memcg (or only the statistics) and have
> > the kmem_cache structure only once in memory.
>
> No, it's all per-page. Nothing here is per-object, maybe you misunderstood
> something?

There are free/used object counters in each page. You could account for
objects in the l3 lists or kmem_cache_node strcut and thereby avoid
having to deal with the individual objects at the per cpu level.

