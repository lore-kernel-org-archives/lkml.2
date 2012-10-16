Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2JPBir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:38:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55164 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2JPBiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:38:46 -0400
X-AuditID: 9c930179-b7ca6ae000000e33-16-507cbaa38fde
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] perf probe: convert_name_to_addr() allocated the wrong size buffer for a function name
Date: Tue, 16 Oct 2012 10:37:32 +0900
Message-Id: <1350351452-9737-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert_name_to_addr() allocated sizeof(char *) * MAX_PROBE_ARGS
bytes for a function name

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
---
 tools/perf/util/probe-event.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 49a256e..bb40ed4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2352,13 +2352,14 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		free(exec_copy);
 	}
 	free(pp->function);
-	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
+	pp->function = zalloc(sizeof(char) *
+			      (3 + sizeof(unsigned long long) * 2));
 	if (!pp->function) {
 		ret = -ENOMEM;
 		pr_warning("Failed to allocate memory by zalloc.\n");
 		goto out;
 	}
-	e_snprintf(pp->function, MAX_PROBE_ARGS, "0x%llx", vaddr);
+	sprintf(pp->function, "0x%llx", vaddr);
 	ret = 0;
 
 out:
-- 
1.7.10.4

