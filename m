Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2IHUhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:37:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36179 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2IHUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:37:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf probe: Make a copy of exec path for passing to basename
Date: Sat,  8 Sep 2012 17:36:53 -0300
Message-Id: <1347136614-25598-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347136614-25598-1-git-send-email-acme@infradead.org>
References: <1347136614-25598-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The basename function may modify the string passed to it, so the string
should not be marked const.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1347116812-93646-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

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
1.7.1

