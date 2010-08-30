Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0H3C61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 22:58:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60501 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0H3C60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 22:58:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2][BUGFIX] oom: remove totalpage normalization from oom_badness()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1008250300500.13300@chino.kir.corp.google.com>
References: <20100825184001.F3EF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1008250300500.13300@chino.kir.corp.google.com>
Message-Id: <20100830113007.525A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 30 Aug 2010 11:58:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 25 Aug 2010, KOSAKI Motohiro wrote:
> 
> > Current oom_score_adj is completely broken because It is strongly bound
> > google usecase and ignore other all.
> > 
> 
> That's wrong, we don't even use this heuristic yet and there is nothing, 
> in any way, that is specific to Google.

Please show us an evidence. Big mouth is no good way to persuade us.
I requested you "COMMUNICATE REAL WORLD USER", do you really realized this?

> 
> > 1) Priority inversion
> >    As kamezawa-san pointed out, This break cgroup and lxr environment.
> >    He said,
> > 	> Assume 2 proceses A, B which has oom_score_adj of 300 and 0
> > 	> And A uses 200M, B uses 1G of memory under 4G system
> > 	>
> > 	> Under the system.
> > 	> 	A's socre = (200M *1000)/4G + 300 = 350
> > 	> 	B's score = (1G * 1000)/4G = 250.
> > 	>
> > 	> In the cpuset, it has 2G of memory.
> > 	> 	A's score = (200M * 1000)/2G + 300 = 400
> > 	> 	B's socre = (1G * 1000)/2G = 500
> > 	>
> > 	> This priority-inversion don't happen in current system.
> > 
> 
> You continually bring this up, and I've answered it three times, but 
> you've never responded to it before and completely ignore it.  

Yes, I ignored. Don't talk your dream. I hope to see concrete use-case.
As I repeatedly said, I don't care you while you ignore real world end user.
ANY BODY DON'T EXCEPT STABILIZATION DEVELOPERS ARE KINDFUL FOR END USER
HARMFUL. WE HAVE NO MERCY WHILE YOU CONTINUE TO INMORAL DEVELOPMENT.

I'm waiting ome more day. Pray! anyone join to this discussion and
explain real use instead you. We don't ignore end-user. But nobody
except you reponce this even though I don't care your , I definitely 
will sent this patch to mainline.



> I really 
> hope and expect that you'll participate more in the development process 
> and not continue to reinterate your talking points when you have no answer 
> to my response.
> 
> You're wrong, especially with regard to cpusets, which was formally part 
> of the heuristic itself.
> 
> Users bind an aggregate of tasks to a cgroup (cpusets or memcg) as a means 
> of isolation and attach a set of resources (memory, in this case) for 
> those tasks to use.  The user who does this is fully aware of the set of 
> tasks being bound, there is no mystery or unexpected results when doing 
> so.  So when you set an oom_score_adj for a task, you don't necessarily 
> need to be aware of the set of resources it has available, which is 
> dynamic and an attribute of the system or cgroup, but rather the priority 
> of that task in competition with other tasks for the same resources.

That is YOUR policy. The problem is IT'S NO GENERIC.

> 
> _That_ is what is important in having a userspace influence on a badness 
> heursitic: how those badness scores compare relative to other tasks that 
> share the same resources.  That's how a task is chosen for oom kill, not 
> because of a static formula such as you're introducing here that outputs a 
> value (and, thus, a priority) regardless of the context in which the task 
> is bound.
> 
> That also means that the same task is not necessarily killed in a 
> cpuset-constrained oom compared to a system-wide oom.  If you bias a task 
> by 30% of available memory, which Kame did in his example above, it's 
> entirely plausible that task A should be killed because it's actual usage 
> is only 1/20th of the machine.  When its cpuset is oom, and the admin has 
> specifically bound that task to only 2G of memory, we'd natually want to 
> kill the memory hogger, that is using 50% of the total memory available to 
> it.

I agree your implementation works fine if admins have the same policy
with you. I oppose you assume you can change all admins in the world.



> > 2) Ratio base point don't works large machine
> >    oom_score_adj normalize oom-score to 0-1000 range.
> >    but if the machine has 1TB memory, 1 point (i.e. 0.1%) mean
> >    1GB. this is no suitable for tuning parameter.
> >    As I said, proposional value oriented tuning parameter has
> >    scalability risk.
> > 
> 
> So you'd rather use the range of oom_adj from -17 to +15 instead of 
> oom_score_adj from -1000 to +1000 where each point is 68GB?  I don't 
> understand your point here as to why oom_score_adj is worse.

No. As I said,
 - If you want to solve minority issue, you have to keep no regression
   for majority user.
 - If you want to solve major isssue and making bug change. Investigate
   world wide use case carefully. and refrect it.

oom_score_adj was pointed out it overlook a lot of use case. then I
request 1) remake all, or 2) kill existing code change.



> But, yes, in reality we don't really care about the granularity so much 
> that we need to prioritize a task using 512MB more memory than another to 
> break the tie on a 1TB machine, 1/2048th of its memory.
> 
> > 3) No reason to implement ABI breakage.
> >    old tuning parameter mean)
> > 	oom-score = oom-base-score x 2^oom_adj
> 
> Everybody knows this is useless beyond polarizing a task for kill or 
> making it immune.
> 
> >    new tuning parameter mean)
> > 	oom-score = oom-base-score + oom_score_adj / (totalram + totalswap)
> 
> This, on the other hand, has an actual unit (proportion of available 
> memory) that can be used to prioritize tasks amongst those competing for 
> the same set of shared resources and remains constant even when a task 
> changes cpuset, its memcg limit changes, etc.
> 
> And your equation is wrong, it's
> 
> 	((rss + swap) / (available ram + swap)) + oom_score_adj
> 
> which is completely different from what you think it is.

you equetion can be changed 

	(rss + swap)  + oom_score_adj x (available ram + swap)
	-----------------------------------------------------------
		(available ram + swap)

That said, same oom_score_adj can be calculated.



> >    but "oom_score_adj / (totalram + totalswap)" can be calculated in
> >    userland too. beucase both totalram and totalswap has been exporsed by
> >    /proc. So no reason to introduce funny new equation.
> > 
> 
> Yup, it definitely can, which is why as I mentioned to Kame (who doesn't 
> have strong feelings either way, even though you quote him as having these 
> strong objections) that you can easily convert oom_score_adj into a 
> stand-alone memory quantity (biasing or forgiving 512MB of a task's 
> memory, for example) in the context it is currently attached to with 
> simple arithemetic in userspace.  That's why oom_score_adj is powerful.

I already said I disagree. 


> 
> > 4) totalram based normalization assume flat memory model.
> >    example, the machine is assymmetric numa. fat node memory and thin
> >    node memory might have another wight value.
> >    In other word, totalram based priority is a one of policy. Fixed and
> >    workload depended policy shouldn't be embedded in kernel. probably.
> > 
> 
> I don't know what this means, and this was your criticism before I changed 
> the denominator during the revision of the patchset, so it's probably 
> obsoleted.  oom_score_adj always operates based on the proportion of 
> memory available to the application which is how the new oom killer 
> determines which tasks to kill: relative to the importance (if defined by 
> userspace) and memory usage compared to other tasks competing for it.

I already explained asymmetric numa issue in past. again, don't assuem
you policy and your machine if you want to change kernel core code.



> 
> > Then, this patch remove *UGLY* total_pages suck completely. Googler
> > can calculate it at userland!
> > 
> 
> Nothing specific about any of this to Google.  Users who actually setup 
> their machines to use mempolicies, cpusets, or memcgs actually do want a 
> powerful interface from userspace to tune the priorities in terms of both 
> business goals and also importance of the task.  That is done much more 
> powerfully now with oom_score_adj than the previous implementation.  Users 
> who don't use these cgroups, especially desktop users, can see 
> oom_score_adj in terms of a memory quantity that remains static: they 
> aren't going to encounter changing memcg limits, cpuset mems, etc.
> 
> That said, I really don't know why you keep mentioning "Google this" and 
> "Google that" when the company I'm working for is really irrelevant to 
> this discussion.

Please don't talk your imazine. You have to talk about concrete use-case.



> With that, I respectfully nack your patch.

Sorry, I don't care this. Please fix you.

Thanks.



