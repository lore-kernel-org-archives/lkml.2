Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2KPV5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:57:15 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51987 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2KPV5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:57:12 -0500
Date: Fri, 16 Nov 2012 13:57:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
In-Reply-To: <50A6AC48.6080102@parallels.com>
Message-ID: <alpine.DEB.2.00.1211161349420.17853@chino.kir.corp.google.com>
References: <20121107105348.GA25549@lizard> <20121107112136.GA31715@shutemov.name> <CAOJsxLHY+3ZzGuGX=4o1pLfhRqjkKaEMyhX0ejB5nVrDvOWXNA@mail.gmail.com> <20121107114321.GA32265@shutemov.name> <alpine.DEB.2.00.1211141910050.14414@chino.kir.corp.google.com>
 <20121115033932.GA15546@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211141946370.14414@chino.kir.corp.google.com> <20121115073420.GA19036@lizard.sbx05977.paloaca.wayport.net> <alpine.DEB.2.00.1211142351420.4410@chino.kir.corp.google.com>
 <20121115085224.GA4635@lizard> <alpine.DEB.2.00.1211151303510.27188@chino.kir.corp.google.com> <50A60873.3000607@parallels.com> <alpine.DEB.2.00.1211161157390.2788@chino.kir.corp.google.com> <50A6AC48.6080102@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012, Glauber Costa wrote:

> > I'm wondering if we should have more than three different levels.
> > 
> 
> In the case I outlined below, for backwards compatibility. What I
> actually mean is that memcg *currently* allows arbitrary notifications.
> One way to merge those, while moving to a saner 3-point notification, is
> to still allow the old writes and fit them in the closest bucket.
> 

Yeah, but I'm wondering why three is the right answer.

> > Umm, why do users of cpusets not want to be able to trigger memory 
> > pressure notifications?
> > 
> Because cpusets only deal with memory placement, not memory usage.

The set of nodes that a thread is allowed to allocate from may face memory 
pressure up to and including oom while the rest of the system may have a 
ton of free memory.  Your solution is to compile and mount memcg if you 
want notifications of memory pressure on those nodes.  Others in this 
thread have already said they don't want to rely on memcg for any of this 
and, as Anton showed, this can be tied directly into the VM without any 
help from memcg as it sits today.  So why implement a simple and clean 
mempressure cgroup that can be used alone or co-existing with either memcg 
or cpusets?

> And it is not that moving a task to cpuset disallows you to do any of
> this: you could, as long as the same set of tasks are mounted in a
> corresponding memcg.
> 

Same thing with a separate mempressure cgroup.  The point is that there 
will be users of this cgroup that do not want the overhead imposed by 
memcg (which is why it's disabled in defconfig) and there's no direct 
dependency that causes it to be a part of memcg.
