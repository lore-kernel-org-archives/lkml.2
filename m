Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2DEJcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:32:55 -0400
Received: from shutemov.name ([176.9.204.213]:47349 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2DEJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:32:54 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 05:32:53 EDT
Date: Thu, 5 Apr 2012 13:17:08 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/6] memcg: fix broken boolen expression
Message-ID: <20120405101708.GA13824@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <1324695619-5537-5-git-send-email-kirill@shutemov.name>
 <20120404143403.fd05a284.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404143403.fd05a284.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 02:34:03PM -0700, Andrew Morton wrote:
> On Sat, 24 Dec 2011 05:00:18 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > ---
> >  mm/memcontrol.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index b27ce0f..3833a7b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2100,7 +2100,7 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
> >  		return NOTIFY_OK;
> >  	}
> >  
> > -	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
> > +	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
> >  		return NOTIFY_OK;
> >  
> >  	for_each_mem_cgroup(iter)
> 
> This spent too long in the backlog, sorry.
> 
> I don't want to merge this patch into either mainline or -stable until
> I find out what it does!
> 
> afacit the patch will newly cause the kernel to drain various resource
> counters away from the target CPU when the CPU_DEAD or CPU_DEAD_FROZEN
> events occur for thet CPU, yes?

Yes.

> So the user-visible effects of the bug whcih was just fixed is that
> these counters will be somewhat inaccurate after a CPU is taken down,
> yes?

Correct.

> Why wasn't this bug noticed before?

I guess CPU hotplug is not a usual test case for memcg changes. And the
result of the bug is inaccurate statistics, but not something dramatic
(oops, panic, etc.).

> Has anyone tested the patch and
> confirmed that the numbers are now correct?

I haven't. I found the bug with sparse.

> Given that this bug has been present for 1.5 years and nobody noticed,
> I don't think a backport into -stable is warranted?
> 

-- 
 Kirill A. Shutemov
