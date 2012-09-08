Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2IHPHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:07:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab2IHPHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:07:08 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: irina.tirdea@gmail.com, David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/3] perf probe: make a copy of exec path for passing to basename
Date: Sat,  8 Sep 2012 09:06:51 -0600
Message-Id: <1347116812-93646-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

basename may modify the string passed to it, so the string should not be
marked const.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
---
 tools/perf/util/probe-event.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0dda25d..e8c72de 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2307,10 +2307,17 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		function = NULL;
 	}
 	if (!pev->group) {
-		char *ptr1, *ptr2;
+		char *ptr1, *ptr2, *exec_copy;
 
 		pev->group = zalloc(sizeof(char *) * 64);
-		ptr1 = strdup(basename(exec));
+		exec_copy = strdup(exec);
+		if (!exec_copy) {
+			ret = -ENOMEM;
+			pr_warning("Failed to copy exec string.\n");
+			goto out;
+		}
+
+		ptr1 = strdup(basename(exec_copy));
 		if (ptr1) {
 			ptr2 = strpbrk(ptr1, "-._");
 			if (ptr2)
@@ -2319,6 +2326,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 					ptr1);
 			free(ptr1);
 		}
+		free(exec_copy);
 	}
 	free(pp->function);
 	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
-- 
1.7.10.1

