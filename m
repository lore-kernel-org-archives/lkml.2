Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2IXPbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:31:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2IXPbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:31:07 -0400
Message-ID: <1348500647.11847.69.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 24 Sep 2012 17:30:47 +0200
In-Reply-To: <20120924150048.GB11266@suse.de>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 16:00 +0100, Mel Gorman wrote:
> On Fri, Sep 14, 2012 at 02:42:44PM -0700, Linus Torvalds wrote:
> > On Fri, Sep 14, 2012 at 2:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> > >
> > > as Nikolay says below, we have a regression in 3.6 with pgbench's
> > > benchmark in postgresql.
> > >
> > > I was able to reproduce it on another box here and did a bisection run.
> > > It pointed to the commit below.
> > 
> > Ok. I guess we should just revert it. However, before we do that,
> > maybe Mike can make it just use the exact old semantics of
> > select_idle_sibling() in the update_top_cache_domain() logic.
> > 
> 
> The patch that you being reverted was meant to fix problems with
> commit 4dcfe102 (sched: Avoid SMT siblings in select_idle_sibling() if
> possible). That patch made select_idle_sibling() quite fat and I know it
> is responsible for a 2% regression in a kernel compile benchmark between
> kernel 3.1 and 3.2 on an old AMD Phenom II X4 940. Reverting Mike's patch
> might fix this Postgres regression but it reintroduces the overhead caused
> by commit 4dcfe102 for other cases.  I do not have a suggestion on how to
> make this better, I'm just pointing out that the revert has some downsides.


Something like the below removes a number of cpumask operations, which
on big machines can be quite expensive.

No idea if its sufficient, but its a start.

Anyway, does anybody have any clue as to why AMD and Intel machine
behave significantly different here? Does an Intel box with HT disabled
behave similar to AMD? or is it something about the micro-architecture?

---
 kernel/sched/fair.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..8757097 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2661,17 +2661,29 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
-			if (!cpumask_intersects(sched_group_cpus(sg),
-						tsk_cpus_allowed(p)))
-				goto next;
+			int candidate = nr_cpu_ids;
 
+			/*
+			 * In the SMT case the groups are the SMT-siblings,
+			 * otherwise they're singleton groups.
+			 */
 			for_each_cpu(i, sched_group_cpus(sg)) {
+				if (!cpumask_test_cpu(i, tsk_cpus_allowed(p)))
+					continue;
+
+				/*
+				 * If any of the SMT-siblings are !idle, the
+				 * core isn't idle.
+				 */
 				if (!idle_cpu(i))
 					goto next;
+
+				if (candidate == nr_cpu_ids)
+					candidate = i;
 			}
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
+			target = candidate;
+
 			goto done;
 next:
 			sg = sg->next;

