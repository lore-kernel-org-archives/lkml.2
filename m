Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2JODj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 23:39:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53649 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2JODj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 23:39:56 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-89-507b858a366a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] perf tools: Fix segfault when using srcline sort key
Date: Mon, 15 Oct 2012 12:39:42 +0900
Message-Id: <1350272383-7016-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The srcline sort key is for grouping samples based on their source
file and line number.  It use addr2line tool to get the information
but it requires dso name.  It caused a segfault when a sample does not
have the name by dereferencing a NULL pointer.  Fix it by using raw ip
addresses for those samples.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b5b1b9211960..dd68f115d392 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -260,6 +260,9 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (path != NULL)
 		goto out_path;
 
+	if (!self->ms.map)
+		goto out_ip;
+
 	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
-- 
1.7.11.4

