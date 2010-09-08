Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0IHCoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:44:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44424 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab0IHCoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:44:12 -0400
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
In-Reply-To: <alpine.DEB.2.00.1009011436390.29305@chino.kir.corp.google.com>
References: <20100830113007.525A.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009011436390.29305@chino.kir.corp.google.com>
Message-Id: <20100907112756.C904.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Sep 2010 11:44:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 30 Aug 2010, KOSAKI Motohiro wrote:
> 
> > > > Current oom_score_adj is completely broken because It is strongly bound
> > > > google usecase and ignore other all.
> > > > 
> > > 
> > > That's wrong, we don't even use this heuristic yet and there is nothing, 
> > > in any way, that is specific to Google.
> > 
> > Please show us an evidence. Big mouth is no good way to persuade us.
> 
> Evidence that Google isn't using this currently?

Of cource, there is simply just zero justification. Who ask google usage?
Every developer have their own debugging and machine administate patches.
Don't you concern why we don't push them into upstream? only one usage is
not good reason to make kernel bloat. Need to generalize.


> 
> > I requested you "COMMUNICATE REAL WORLD USER", do you really realized this?
> > 
> 
> We are certainly looking forward to using this when 2.6.36 is released 
> since we work with both cpusets and memcg.

Could you please be serious? We are not making a sand castle, we are making
a kernel. You have to understand the difference of them. Zero user feature
trial don't have any good reason to make userland breakage.



> > > > 1) Priority inversion
> > > >    As kamezawa-san pointed out, This break cgroup and lxr environment.
> > > >    He said,
> > > > 	> Assume 2 proceses A, B which has oom_score_adj of 300 and 0
> > > > 	> And A uses 200M, B uses 1G of memory under 4G system
> > > > 	>
> > > > 	> Under the system.
> > > > 	> 	A's socre = (200M *1000)/4G + 300 = 350
> > > > 	> 	B's score = (1G * 1000)/4G = 250.
> > > > 	>
> > > > 	> In the cpuset, it has 2G of memory.
> > > > 	> 	A's score = (200M * 1000)/2G + 300 = 400
> > > > 	> 	B's socre = (1G * 1000)/2G = 500
> > > > 	>
> > > > 	> This priority-inversion don't happen in current system.
> > > > 
> > > 
> > > You continually bring this up, and I've answered it three times, but 
> > > you've never responded to it before and completely ignore it.  
> > 
> > Yes, I ignored. Don't talk your dream. I hope to see concrete use-case.
> > As I repeatedly said, I don't care you while you ignore real world end user.
> > ANY BODY DON'T EXCEPT STABILIZATION DEVELOPERS ARE KINDFUL FOR END USER
> > HARMFUL. WE HAVE NO MERCY WHILE YOU CONTINUE TO INMORAL DEVELOPMENT.
> > 
> 
> I'm not ignoring any user with this change, oom_score_adj is an extremely 
> powerful interface for users who want to use it.  I'm sorry that it's not 
> as simple to use as you may like.
> 
> Basically, it comes down to this: few users actually tune their oom 
> killing priority, period.  That's partly because they accept the oom 
> killer's heuristics to kill a memory-hogging task or use panic_on_oom, or 
> because the old interface, /proc/pid/oom_adj, had no unit and no logical 
> way of using it other than polarizing it (either +15 or -17).

Unrelated. We already have oom notifier. we have no reason to add new knob
even though oom_adj is suck. We are not necessary to break userland application.



> 
> For those users who do change their oom killing priority, few are using 
> cpusets or memcg.  Yes, the priority changes depending on the context of 
> the oom, but for users who don't use these cgroups the oom_score_adj unit 
> is static since the amount of system memory (the only oom constraint) is 
> static.
> 
> Now, for the users of both oom_score_adj and cpusets or memcg (in the 
> future this will include Google), these users are interested in oom 
> killing priority relative to other tasks attached to the same set of 
> resources.  For our particular use case, we attach an aggregate of tasks 
> to a cgroup and have a preference on the order in which those tasks are 
> killed whenever that cgroup limit is exhausted.  We also care about 
> protecting vital system tasks so that they aren't targeted before others 
> are killed, such as job schedulers.

memcg limit already have been exposed via /cgroup/memory.limit_in_bytes.
It's clearly userland role.

The fact is, my patch is more powerful than yours because your patch
has fixed oom management policy, but mine don't. It can be custermized
to adjust customer.

More importantly, We already have oom notifier. and It is most powerful
infrastructure. It can be constructed any oom policy freely. It's not 
restricted kernel implementaion.


The fact is, your new interface don't match HPC, Server, Banking systems
and embedded, AFAIK. At least I couldn't find such usercase in my job 
experience of such area. Also, now I'm jourlist theresore I have some
connection of linux user group. but I didn't get positive feedback for
your. instead got some negative feedback. Of cource, I don't know all of
the world theresore I did ask you real world usercase repeatedly. But
I've got no responce. You need to prove your feature improve the world.



> I think the key point your missing in our use case is that we don't 
> necessary care about the system-wide oom condition when we're running with 
> cpusets or memcg.  We can protect tasks with negative oom_score_adj, but 
> we don't care about close tiebreakers on which cpuset or memg is penalized 
> when the entire system is out of memory.  If that's the case, each cpuset 
> and memcg is also, by definition, out of memory, so they are all subject 
> to the oom killer.  This is equivalent to having several tasks with an 
> oom_score_adj of +1000 (or oom_adj of +15) and only one getting killed 
> based on the order of the tasklist.

Unrelated. You are still talking about your policy. Why do we need care it?
I don't inhibit you use your policy.



> So there is actually no "bug" or "regression" in this behavior (especially 
> since the old oom killer had inversion as well because it factored cpuset 
> placement into the heuristic score) and describing it as such is 
> misleading.  It's actually a very powerful interface for those who choose 
> to use it and accurately reflect the way the oom killer chooses tasks: 
> relative to other eligible tasks competing for the same set of resources.

Well, this is clearly bug. oom_adj was changed behavior. and It was deprecated
by mistake, therefore latest kernel output pointless warnings each boot time.

That said, Be serious! otherwise GO AWAY.


