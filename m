Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2JQI3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:29:05 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64778 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2JQI3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:29:03 -0400
X-AuditID: 9c930179-b7ca6ae000000e33-03-507e6c4b3a90
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] perf probe: convert_name_to_addr() allocated the wrong size buffers for names
Date: Wed, 17 Oct 2012 17:28:16 +0900
Message-Id: <1350462496-20035-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function allocated wrong size buffers for names

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
---
 tools/perf/util/probe-event.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 49a256e..5cd7c42 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2273,6 +2273,8 @@ int show_available_funcs(const char *target, struct strfilter *_filter,
 	return available_user_funcs(target);
 }
 
+#define MAX_ADDRNAME_LEN  (3 + sizeof(unsigned long long) * 2)
+
 /*
  * uprobe_events only accepts address:
  * Convert function and any offset to address
@@ -2332,7 +2334,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 	if (!pev->group) {
 		char *ptr1, *ptr2, *exec_copy;
 
-		pev->group = zalloc(sizeof(char *) * 64);
+		pev->group = zalloc(sizeof(char) * 64);
 		exec_copy = strdup(exec);
 		if (!exec_copy) {
 			ret = -ENOMEM;
@@ -2352,14 +2354,15 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		free(exec_copy);
 	}
 	free(pp->function);
-	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
+	pp->function = zalloc(sizeof(char) * MAX_ADDRNAME_LEN);
 	if (!pp->function) {
 		ret = -ENOMEM;
 		pr_warning("Failed to allocate memory by zalloc.\n");
 		goto out;
 	}
-	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
-	ret = 0;
+	ret = e_snprintf(pp->function, MAX_ADDRNAME_LEN, "0x%llx", vaddr);
+	if (ret > 0)
+		ret = 0;
 
 out:
 	if (map) {
-- 
1.7.10.4

