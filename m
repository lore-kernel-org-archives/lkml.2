Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0IWVpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:45:49 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:35420 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753954Ab0IWVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:45:48 -0400
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: arjan@linux.intel.com, nhorman@tuxdriver.com
Cc: tomk@rgmadvisors.com, danb@rgmadvisors.com, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH 1/2] Fix detection of CPUs in sysfs
Date: Thu, 23 Sep 2010 16:38:06 -0500
Message-Id: <1285277887-14190-2-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1285277887-14190-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1285277887-14190-1-git-send-email-sbohrer@rgmadvisors.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only count directories that match /sys/devices/system/cpu/cpu[0-9]+ as
CPUs.  Previously any directory that started with cpu was counted which
caused cpufreq and cpuidle to be counted as CPUs.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 cputree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/cputree.c b/cputree.c
index 3b0c982..b879785 100644
--- a/cputree.c
+++ b/cputree.c
@@ -25,6 +25,7 @@
  */
 
 #include "config.h"
+#include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -321,7 +322,7 @@ void parse_cpu_tree(void)
 		return;
 	do {
 		entry = readdir(dir);
-                if (entry && strlen(entry->d_name)>3 && strstr(entry->d_name,"cpu")) {
+                if (entry && !strncmp(entry->d_name,"cpu", 3) && isdigit(entry->d_name[3])) {
 			char new_path[PATH_MAX];
 			sprintf(new_path, "/sys/devices/system/cpu/%s", entry->d_name);
 			do_one_cpu(new_path);
-- 
1.6.5.2

