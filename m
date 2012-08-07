Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2HGCZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 22:25:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64210 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab2HGCZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 22:25:26 -0400
From: Palmer Cox <p@lmercox.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, Palmer Cox <p@lmercox.com>
Subject: [PATCH 4/6] cpupower tools: Fix issues with sysfs_topology_read_file
Date: Mon,  6 Aug 2012 22:24:46 -0400
Message-Id: <1344306288-12369-5-git-send-email-p@lmercox.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344306288-12369-1-git-send-email-p@lmercox.com>
References: <1344306288-12369-1-git-send-email-p@lmercox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a variety of issues with sysfs_topology_read_file:
* The return value of sysfs_topology_read_file function was not properly
  being checked for failure.
* The function was reading int valued sysfs variables and then returning
  their value. So, even if a function was trying to check the return value
  of this function, a caller would not be able to tell an failure code apart
  from reading a negative value. This also conflicted with the comment on the
  function which said that a return value of 0 indicated success.
* The function was parsing int valued sysfs values with strtoul instead of
  strtol.
* The function was non-static even though it was only used in the
  file it was declared in.
---
 tools/power/cpupower/utils/helpers/topology.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/power/cpupower/utils/helpers/topology.c b/tools/power/cpupower/utils/helpers/topology.c
index 4eae2c4..216f3e3 100644
--- a/tools/power/cpupower/utils/helpers/topology.c
+++ b/tools/power/cpupower/utils/helpers/topology.c
@@ -20,9 +20,8 @@
 #include <helpers/sysfs.h>
 
 /* returns -1 on failure, 0 on success */
-int sysfs_topology_read_file(unsigned int cpu, const char *fname)
+static int sysfs_topology_read_file(unsigned int cpu, const char *fname, int *result)
 {
-	unsigned long value;
 	char linebuf[MAX_LINE_LEN];
 	char *endp;
 	char path[SYSFS_PATH_MAX];
@@ -31,10 +30,10 @@ int sysfs_topology_read_file(unsigned int cpu, const char *fname)
 			 cpu, fname);
 	if (sysfs_read_file(path, linebuf, MAX_LINE_LEN) == 0)
 		return -1;
-	value = strtoul(linebuf, &endp, 0);
+	*result = strtol(linebuf, &endp, 0);
 	if (endp == linebuf || errno == ERANGE)
 		return -1;
-	return value;
+	return 0;
 }
 
 struct cpuid_core_info {
@@ -82,13 +81,19 @@ int get_cpu_topology(struct cpupower_topology *cpu_top)
 	for (cpu = 0; cpu < cpus; cpu++) {
 		cpu_top->core_info[cpu].cpu = cpu;
 		cpu_top->core_info[cpu].is_online = sysfs_is_cpu_online(cpu);
-		cpu_top->core_info[cpu].pkg =
-			sysfs_topology_read_file(cpu, "physical_package_id");
+		if(sysfs_topology_read_file(
+			cpu,
+			"physical_package_id",
+			&(cpu_top->core_info[cpu].pkg)) < 0)
+			return -1;
 		if ((int)cpu_top->core_info[cpu].pkg != -1 &&
 		    cpu_top->core_info[cpu].pkg > cpu_top->pkgs)
 			cpu_top->pkgs = cpu_top->core_info[cpu].pkg;
-		cpu_top->core_info[cpu].core =
-			sysfs_topology_read_file(cpu, "core_id");
+		if(sysfs_topology_read_file(
+			cpu,
+			"core_id",
+			&(cpu_top->core_info[cpu].core)) < 0)
+			return -1;
 	}
 	cpu_top->pkgs++;
 
-- 
1.7.9.5

