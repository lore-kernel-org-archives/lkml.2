Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab2FQSWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50123 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757957Ab2FQSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:14 -0400
Message-Id: <20120617175943.482205639@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dimitri Sivanich <sivanich@sgi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 15/69] sched: Fix the relax_domain_level boot parameter
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Sivanich <sivanich@sgi.com>

commit a841f8cef4bb124f0f5563314d0beaf2e1249d72 upstream.

It does not get processed because sched_domain_level_max is 0 at the
time that setup_relax_domain_level() is run.

Simply accept the value as it is, as we don't know the value of
sched_domain_level_max until sched domain construction is completed.

Fix sched_relax_domain_level in cpuset.  The build_sched_domain() routine calls
the set_domain_attribute() routine prior to setting the sd->level, however,
the set_domain_attribute() routine relies on the sd->level to decide whether
idle load balancing will be off/on.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120605184436.GA15668@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: adjust the filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched/core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7429,11 +7429,8 @@
 
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
@@ -7636,7 +7633,6 @@
 	if (!sd)
 		return child;
 
-	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level = child->level + 1;
@@ -7644,6 +7640,7 @@
 		child->parent = sd;
 	}
 	sd->child = child;
+	set_domain_attribute(sd, attr);
 
 	return sd;
 }


