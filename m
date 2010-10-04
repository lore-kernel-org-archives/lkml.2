Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0JDMqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:46:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43173 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab0JDMqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:46:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web servers
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Rob Mueller <robm@fastmail.fm>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1009270828510.7000@router.home>
References: <20100927110049.6B31.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009270828510.7000@router.home>
Message-Id: <20101004211112.E8B1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  4 Oct 2010 21:45:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Mon, 27 Sep 2010, KOSAKI Motohiro wrote:
> 
> > > No doubt this is true. The only real difference is that there are more NUMA
> > > machines running mail/web/file servers now than there might have been in the
> > > past. The default made sense once upon a time. Personally I wouldn't mind
> > > the default changing but my preference would be that distribution packages
> > > installing on NUMA machines would prompt if the default should be changed if it
> > > is likely to be of benefit for that package (e.g. the mail, file and web ones).
> >
> > At first impression, I thought this is cute idea. But, after while thinking, I've found some
> > weak point. The problem is, too many package need to disable zone_reclaim_mode.
> > zone_reclaim doesn't works fine if an application need large working set rather than
> > local node size. It mean major desktop applications (e.g. OpenOffice.org, Firefox, GIMP)
> > need to disable zone_reclaim. It mean even though basic package installation require
> > zone_reclaim disabling. Then, this mechanism doesn't works practically. Even though
> > the user hope to use the machine for hpc, disable zone_reclaim will be turn on anyway.
> >
> > Probably, opposite switch (default is zone_reclaim=0, and installation MPI library change
> > to zone_reclaim=1) might works. but I can guess why you don't propose this one.
> 
> The fundamental problem that needs to be addressed is the balancing of a
> memory load in a system with memory ranges that have different performance
> characteristics when running conventional software that does not
> properly balance allocations and that has not been written with these
> new memory balancing issues in mind.

Yeah. page cache often have very long life than processes. then, CPU place
which current process running is not so good heuristics. and kernel don't 
have good statistics to find best node for cache. That's problem.
How do we know future processes work on which cpus?

Also, CPU scheduler have an issue. IO intensive workload often makes
unbalanced process layout. (cpus haven't been so busy yet. why do we
need to make costly cpu migration?). end up, memory consumption also 
become unbalanced. this is also difficult issue. hmm..


> 
> You can switch off zone reclaim of course which means that the
> applications will not be getting memory thats optimal for them to access.
> Given the current minimal NUMA differences in most single server systems
> this is likely not going to matter. In fact the kernel has such a
> mechanism to switch off zone reclaim for such systems (see the definition
> of RECLAIM_DISTANCE). Which seems to have somehow been defeated by the
> ACPI information of those machines which indicate a high latency
> difference between the memory areas. The arch code could be adjusted to
> set a higher RECLAIM_DISTANCE so that this motherboard also will default
> to zone reclaim mode off.

Yup.

> 
> However, the larger the NUMA effects become the more the performance loss
> due to these effect. Its expected that the number of processors and
> therefore also the NUMA effects in coming generations of machines will
> increase. Various API exist to do finer grained memory access control so
> that the performance loss can be isolated to processes or memory ranges.
> 
> F.e. running the application with numactl (using interleave) or a cpuset
> with round robin on could address this issue without changing zone
> reclaim and would allow other processes to allocate faster local memory.
> 
> The problem with zone reclaim mainly is created for large apps whose
> working set is larger than the local node. The special settings are only
> needing for those applications.

In theory, yes. but please talk with userland developers. They always say
"Our software work fine on *BSD, Solaris, Mac, etc etc. that's definitely 
linux problem". /me have no way to persuade them ;-)



> 
> What can be done here is:
> 
> 1. Fix the ACPI information to indicate lower memory access differences
>    (was that info actually acurate?) so that zone reclaim defaults to off.

I think it's accurate. and I don't think this is easy works because
there are many mothorboard vendor in the world and we don't have a way of
communicate them. That's difficulty of the commodity.

> 
> 2. Change the RECLAIM_DISTANCE setting for the arch so that the ACPI
>    information does not trigger zone reclaim to be enabled.

This is one of option. but we don't need to create x86 arch specific
RECLAIM_DISTANCE. Because practical high-end numa machine are either
ia64(SGI, Fujitsu) or Power(IBM) and both platform already have arch
specific definition. then changing RECLAIM_DISTANCE doesn't make any
side effect on such platform. and if possible, x86 shouldn't have
arch specific definition because almost minor arch don't have a lot of
tester and its quality often depend on testing on x86.

attached a patch below.


> 3. Run the application with numactl settings for interleaving of memory
>    accesses (or corresponding cpuset settings).

If the problem was on only few atypical software, this makes sense.
but I don't think this is practical way on current situation.

> 
> 4. Fix the application to be conscious of the effect of memory allocations
>    on a NUMA systems. Use the numa memory allocations API to allocate
>    anonymous memory locally for optimal access and set interleave for the
>    file backed pages.

For performance, this is best way definitely. And MySQL or other DB software
should concern this, I believe.
But, again, the problem is, too many software don't match zone_reclaim_mode.



>From d54928bfb4b2b865bedcff17e9b45dfbb714a5e6 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 14 Oct 2010 13:48:21 +0900
Subject: [PATCH] mm: increase RECLAIM_DISTANCE to 30

Recently, Robert Mueller reported zone_reclaim_mode doesn't work
properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).
He is using Cyrus IMAPd and it's built on a very traditional
single-process model.

  * a master process which reads config files and manages the other
    process
  * multiple imapd processes, one per connection
  * multiple pop3d processes, one per connection
  * multiple lmtpd processes, one per connection
  * periodical "cleanup" processes.

Then, there are thousands of independent processes. The problem is,
recent Intel motherboard turn on zone_reclaim_mode by default and
traditional prefork model software don't work fine on it.
Unfortunatelly, Such model is still typical one even though 21th
century. We can't ignore them.

This patch raise zone_reclaim_mode threshold to 30. 30 don't have
specific meaning. but 20 mean one-hop QPI/Hypertransport and such
relatively cheap 2-4 socket machine are often used for tradiotional
server as above. The intention is, their machine don't use
zone_reclaim_mode.

Note: ia64 and Power have arch specific RECLAIM_DISTANCE definition.
then this patch doesn't change such high-end NUMA machine behavior.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux.com>
Cc: Bron Gondwana <brong@fastmail.fm>
Cc: Robert Mueller <robm@fastmail.fm>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 64e084f..bfbec49 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -60,7 +60,7 @@ int arch_update_cpu_topology(void);
  * (in whatever arch specific measurement units returned by node_distance())
  * then switch on zone reclaim on boot.
  */
-#define RECLAIM_DISTANCE 20
+#define RECLAIM_DISTANCE 30
 #endif
 #ifndef PENALTY_FOR_NODE_WITH_CPUS
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
-- 
1.6.5.2



