Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab2EIGEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:04:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39182 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899Ab2EIFxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:38 -0400
Message-Id: <20120509055043.705902915@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "he, bo" <bo.he@intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 101/167] [PATCH] sched: Fix OOPS when build_sched_domains() percpu allocation
 fails
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "he, bo" <bo.he@intel.com>

commit fb2cf2c660971bea0ad86a9a5c19ad39eab61344 upstream.

Under extreme memory used up situations, percpu allocation
might fail. We hit it when system goes to suspend-to-ram,
causing a kworker panic:

 EIP: [<c124411a>] build_sched_domains+0x23a/0xad0
 Kernel panic - not syncing: Fatal exception
 Pid: 3026, comm: kworker/u:3
 3.0.8-137473-gf42fbef #1

 Call Trace:
  [<c18cc4f2>] panic+0x66/0x16c
  [...]
  [<c1244c37>] partition_sched_domains+0x287/0x4b0
  [<c12a77be>] cpuset_update_active_cpus+0x1fe/0x210
  [<c123712d>] cpuset_cpu_inactive+0x1d/0x30
  [...]

With this fix applied build_sched_domains() will return -ENOMEM and
the suspend attempt fails.

Signed-off-by: he, bo <bo.he@intel.com>
Reviewed-by: Zhang, Yanmin <yanmin.zhang@intel.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1335355161.5892.17.camel@hebo
[ So, we fail to deallocate a CPU because we cannot allocate RAM :-/
  I don't like that kind of sad behavior but nevertheless it should
  not crash under high memory load. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: change filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -7605,16 +7605,26 @@
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
-			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
-			if (sd && (sd->flags & SD_OVERLAP))
-				free_sched_groups(sd->groups, 0);
-			kfree(*per_cpu_ptr(sdd->sd, j));
-			kfree(*per_cpu_ptr(sdd->sg, j));
-			kfree(*per_cpu_ptr(sdd->sgp, j));
+			struct sched_domain *sd;
+
+			if (sdd->sd) {
+				sd = *per_cpu_ptr(sdd->sd, j);
+				if (sd && (sd->flags & SD_OVERLAP))
+					free_sched_groups(sd->groups, 0);
+				kfree(*per_cpu_ptr(sdd->sd, j));
+			}
+
+			if (sdd->sg)
+				kfree(*per_cpu_ptr(sdd->sg, j));
+			if (sdd->sgp)
+				kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
 		free_percpu(sdd->sd);
+		sdd->sd = NULL;
 		free_percpu(sdd->sg);
+		sdd->sg = NULL;
 		free_percpu(sdd->sgp);
+		sdd->sgp = NULL;
 	}
 }
 


