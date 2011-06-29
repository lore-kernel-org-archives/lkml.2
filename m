Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab1F2XfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:35:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1F2XeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:24 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Sam Liao <phyomh@gmail.com>
Subject: [PATCH 5/6] perf tools: Allow sort dimensions to be registered more than once
Date: Thu, 30 Jun 2011 01:34:07 +0200
Message-Id: <1309390448-9160-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
References: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that the parent sort dimension can be registered twice: once
if we add it as an explicit sort dimension (-s parent) and twice
if we request a parent filter (-p foo).

We'll have only one parent sort dimension in the end but this
allows to override the default parent filter with we gave in "-p"
option. The goal of this is to prepare to allow the use of
"-s parent" and "-p foo" at the same time, ie: sort by filtered
parent.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Sam Liao <phyomh@gmail.com>
---
 tools/perf/util/sort.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f5dba56..401e220 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -260,15 +260,9 @@ int sort_dimension__add(const char *tok)
 	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
 		struct sort_dimension *sd = &sort_dimensions[i];
 
-		if (sd->taken)
-			continue;
-
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
 		if (sd->entry == &sort_parent) {
 			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
 			if (ret) {
@@ -281,6 +275,12 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		}
 
+		if (sd->taken)
+			return 0;
+
+		if (sd->entry->se_collapse)
+			sort__need_collapse = 1;
+
 		if (list_empty(&hist_entry__sort_list)) {
 			if (!strcmp(sd->name, "pid"))
 				sort__first_dimension = SORT_PID;
-- 
1.7.5.4

