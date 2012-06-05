Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2FESoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:44:39 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51005 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755980Ab2FESoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:44:38 -0400
Date: Tue, 5 Jun 2012 13:44:36 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix relax_domain_level interface
Message-ID: <20120605184436.GA15668@sgi.com>
References: <20120601210348.GA22471@sgi.com>
 <1338824262.28282.87.camel@twins>
 <20120604181614.GA22172@sgi.com>
 <20120605183439.GA16819@sgi.com>
 <1338921419.2749.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338921419.2749.31.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 08:36:59PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 13:34 -0500, Dimitri Sivanich wrote:
> > 
> > I'll submit a patch shortly that should return these back to what appears to
> > be their intended functionality. 
> 
> I guess removing the max check in the paramater parsing is the easiest
> thing.
My thoughts exactly.



Fix the relax_domain_level boot parameter. It does not get processed because
sched_domain_level_max is 0 at the time that setup_relax_domain_level()
is run.  Simply accept the value as it is, as we don't know the value
of sched_domain_level_max until sched domain construction is completed.

Fix sched_relax_domain_level in cpuset.  The build_sched_domain() routine calls
the set_domain_attribute() routine prior to setting the sd->level, however,
the set_domain_attribute() routine relies on the sd->level to decide whether
idle load balancing will be off/on.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 kernel/sched/core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux/kernel/sched/core.c
===================================================================
--- linux.orig/kernel/sched/core.c
+++ linux/kernel/sched/core.c
@@ -6165,11 +6165,8 @@ int sched_domain_level_max;
 
 static int __init setup_relax_domain_level(char *str)
 {
-	unsigned long val;
-
-	val = simple_strtoul(str, NULL, 0);
-	if (val < sched_domain_level_max)
-		default_relax_domain_level = val;
+	if (kstrtoint(str, 0, &default_relax_domain_level))
+		pr_warn("Unable to set relax_domain_level\n");
 
 	return 1;
 }
@@ -6543,7 +6540,6 @@ struct sched_domain *build_sched_domain(
 	if (!sd)
 		return child;
 
-	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level = child->level + 1;
@@ -6551,6 +6547,7 @@ struct sched_domain *build_sched_domain(
 		child->parent = sd;
 	}
 	sd->child = child;
+	set_domain_attribute(sd, attr);
 
 	return sd;
 }
