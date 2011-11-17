Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab1KQPzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:55:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:57756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1KQPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:55:41 -0500
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321544313.6308.25.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 16:56:16 +0100
Message-ID: <1321545376.2495.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:38 +0100, Mike Galbraith wrote:
> On Thu, 2011-11-17 at 02:59 +0100, Mike Galbraith wrote:
> > On Wed, 2011-11-16 at 10:37 -0800, Suresh Siddha wrote:
> 
> > > It should be ok. Isn't it?
> > 
> > Nope, wasn't ok.
> 
> Because you can't get to again: with a single E5620 package, it having
> only SIBLING and MC domains.
>  
> again:
>         for_each_domain(target, sd) {
>                 if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
>                         continue;
> 
>                 if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
>                         if (!smt) {
>                                 smt = 1;
>                                 goto again;
> 

D'0h, indeed.. 

Something like the below maybe, although I'm certain it all can be
written much nicer indeed.

---
 kernel/sched/fair.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd3b642..340e62e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2676,13 +2676,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
 			continue;
 
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
-			if (!smt) {
-				smt = 1;
-				goto again;
-			}
+		if (smt && !(sd->flags & SD_SHARE_CPUPOWER))
+			break;
+
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
-		}
 
 		sg = sd->groups;
 		do {
@@ -2702,6 +2700,10 @@ static int select_idle_sibling(struct task_struct *p, int target)
 			sg = sg->next;
 		} while (sg != sd->groups);
 	}
+	if (!smt) {
+		smt = 1;
+		goto again;
+	}
 done:
 	rcu_read_unlock();
 


