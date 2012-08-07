Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab2HGC0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:26:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55164 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab2HGCZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:25:28 -0400
From: Palmer Cox <p@lmercox.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, Palmer Cox <p@lmercox.com>
Subject: [PATCH 6/6] cpupower tools: Fix warning and a bug with the cpu package count
Date: Mon,  6 Aug 2012 22:24:48 -0400
Message-Id: <1344306288-12369-7-git-send-email-p@lmercox.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344306288-12369-1-git-send-email-p@lmercox.com>
References: <1344306288-12369-1-git-send-email-p@lmercox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pkgs member of cpupower_topology is being used as the number of
cpu packages. As the comment in get_cpu_topology notes, the package ids
are not guaranteed to be contiguous. So, simply setting pkgs to the value
of the highest physical_package_id doesn't actually provide a count of
the number of cpu packages. Instead, calculate pkgs by setting it to
the number of distinct physical_packge_id values which is pretty easy
to do after the core_info structs are sorted. Calculating pkgs this
way also has the nice benefit of getting rid of a sign comparison warning
that GCC 4.6 was reporting.
---
 tools/power/cpupower/utils/helpers/topology.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/power/cpupower/utils/helpers/topology.c b/tools/power/cpupower/utils/helpers/topology.c
index 4e2b583..fd3cc4d 100644
--- a/tools/power/cpupower/utils/helpers/topology.c
+++ b/tools/power/cpupower/utils/helpers/topology.c
@@ -64,7 +64,7 @@ static int __compare(const void *t1, const void *t2)
  */
 int get_cpu_topology(struct cpupower_topology *cpu_top)
 {
-	int cpu, cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int cpu, last_pkg, cpus = sysconf(_SC_NPROCESSORS_CONF);
 
 	cpu_top->core_info = malloc(sizeof(struct cpuid_core_info) * cpus);
 	if (cpu_top->core_info == NULL)
@@ -78,20 +78,28 @@ int get_cpu_topology(struct cpupower_topology *cpu_top)
 			"physical_package_id",
 			&(cpu_top->core_info[cpu].pkg)) < 0)
 			return -1;
-		if ((int)cpu_top->core_info[cpu].pkg != -1 &&
-		    cpu_top->core_info[cpu].pkg > cpu_top->pkgs)
-			cpu_top->pkgs = cpu_top->core_info[cpu].pkg;
 		if(sysfs_topology_read_file(
 			cpu,
 			"core_id",
 			&(cpu_top->core_info[cpu].core)) < 0)
 			return -1;
 	}
-	cpu_top->pkgs++;
 
 	qsort(cpu_top->core_info, cpus, sizeof(struct cpuid_core_info),
 	      __compare);
 
+	/* Count the number of distinct pkgs values. This works
+	   becuase the primary sort of of the core_info structs was just
+	   done by pkg value. */
+        last_pkg = cpu_top->core_info[0].pkg;
+        for(cpu = 1; cpu < cpus; cpu++) {
+                if(cpu_top->core_info[cpu].pkg != last_pkg) {
+			last_pkg = cpu_top->core_info[cpu].pkg;
+                        cpu_top->pkgs++;
+		}
+        }
+        cpu_top->pkgs++;
+
 	/* Intel's cores count is not consecutively numbered, there may
 	 * be a core_id of 3, but none of 2. Assume there always is 0
 	 * Get amount of cores by counting duplicates in a package
-- 
1.7.9.5

