Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2L0JMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:12:51 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59226 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2L0JMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:31 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-18-50dc10fcfb02
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/10] perf sort: Check return value of strdup()
Date: Thu, 27 Dec 2012 18:11:44 +0900
Message-Id: <1356599507-14226-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When setup_sorting() is called, 'str' is passed to strtok_r() but it's
not checked to have a valid pointer.  As strtok_r() accepts NULL
pointer on a first argument and use the third argument in that case,
it can cause a trouble since our third argument, tmp, is not
initialized.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index c02964cabdd0..9f827e25a2b5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -552,6 +552,11 @@ void setup_sorting(const char * const usagestr[], const struct option *opts)
 {
 	char *tmp, *tok, *str = strdup(sort_order);
 
+	if (str == NULL) {
+		error("Not enough memory to setup sort keys");
+		exit(-1);
+	}
+
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		if (sort_dimension__add(tok) < 0) {
-- 
1.7.11.7

