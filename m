Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1KGWSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:18:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1KGWSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:18:50 -0500
Date: Mon, 7 Nov 2011 23:18:48 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] oom: do not kill tasks with oom_score_adj
 OOM_SCORE_ADJ_MIN
Message-ID: <20111107221847.GA7985@tiehlicka.suse.cz>
References: <20111104143145.0F93B8B45E@mx2.suse.de>
 <alpine.DEB.2.00.1111071353140.27419@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111071353140.27419@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-11-11 13:54:38, David Rientjes wrote:
> On Fri, 4 Nov 2011, Michal Hocko wrote:
> 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index e916168..4883514 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -185,6 +185,9 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
> >  	if (!p)
> >  		return 0;
> >  
> > +	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> > +		return 0;
> > +
> >  	/*
> >  	 * The memory controller may have a limit of 0 bytes, so avoid a divide
> >  	 * by zero, if necessary.
> 
> This leaves p locked, you need to do task_unlock(p) first.

Yes, right you are. Thanks for spotting this out.

> 
> Once that's fixed, please add my
> 
> 	Acked-by: David Rientjes <rientjes@google.com>

Thanks.

> and resubmit to Andrew for the 3.2 rc series.  Thanks!

Andrew, could you push this for 3.2 (bugfix for post 3.1 kernel).

---
>From 10e06e7c0682af58236055ed38bfab58f7935253 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 4 Nov 2011 12:59:44 +0100
Subject: [PATCH] oom: do not kill tasks with oom_score_adj OOM_SCORE_ADJ_MIN
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org,
    linux-kernel@vger.kernel.org,
    Oleg Nesterov <oleg@redhat.com>,
    Ying Han <yinghan@google.com>,
    KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
    Andrew Morton <akpm@linux-foundation.org>

c9f01245 (oom: remove oom_disable_count) has removed oom_disable_count
counter which has been used for early break out from oom_badness so we
could never select a task with oom_score_adj set to OOM_SCORE_ADJ_MIN
(oom disabled).

Now that the counter is gone we are always going through heuristics
calculation and we always return a non zero positive value.  This
means that we can end up killing a task with OOM disabled because it is
indistinguishable from regular tasks with 1% resp. CAP_SYS_ADMIN tasks
with 3% usage of memory or tasks with oom_score_adj set but OOM enabled.

Let's break out early if the task should have OOM disabled.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index e916168..4465fb8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -185,6 +185,11 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	if (!p)
 		return 0;
 
+	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+		task_unlock(p);
+		return 0;
+	}
+
 	/*
 	 * The memory controller may have a limit of 0 bytes, so avoid a divide
 	 * by zero, if necessary.
-- 
1.7.7.1

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
