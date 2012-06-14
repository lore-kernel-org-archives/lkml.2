Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2FOAAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab2FOAAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:47 -0400
Message-Id: <20120614235627.174581502@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:57:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dimitri Sivanich <sivanich@sgi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 37/42] sched: Fix the relax_domain_level boot parameter
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6230,11 +6230,8 @@ int sched_domain_level_max;
 
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
@@ -6439,7 +6436,6 @@ struct sched_domain *build_sched_domain(
 	if (!sd)
 		return child;
 
-	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level = child->level + 1;
@@ -6447,6 +6443,7 @@ struct sched_domain *build_sched_domain(
 		child->parent = sd;
 	}
 	sd->child = child;
+	set_domain_attribute(sd, attr);
 
 	return sd;
 }


