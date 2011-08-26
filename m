Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1HZPha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:37:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1HZPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:37:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Eric B Munson <emunson@mgebm.net>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf symbols: Preserve symbol scope when parsing /proc/kallsyms
Date: Fri, 26 Aug 2011 12:37:09 -0300
Message-Id: <1314373031-6687-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1314373031-6687-1-git-send-email-acme@infradead.org>
References: <1314373031-6687-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

kallsyms__parse capitalises the symbol type, so every symbol is marked
global. Remove this and fix symbol_type__is_a to handle both local and
global symbols.

Cc: Eric B Munson <emunson@mgebm.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110824065243.077125989@samba.org
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f119e85..0d94ddb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -74,11 +74,13 @@ static void dso__set_sorted_by_name(struct dso *dso, enum map_type type)
 
 bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 {
+	symbol_type = toupper(symbol_type);
+
 	switch (map_type) {
 	case MAP__FUNCTION:
 		return symbol_type == 'T' || symbol_type == 'W';
 	case MAP__VARIABLE:
-		return symbol_type == 'D' || symbol_type == 'd';
+		return symbol_type == 'D';
 	default:
 		return false;
 	}
@@ -463,7 +465,7 @@ int kallsyms__parse(const char *filename, void *arg,
 		if (len + 2 >= line_len)
 			continue;
 
-		symbol_type = toupper(line[len]);
+		symbol_type = line[len];
 		len += 2;
 		symbol_name = line + len;
 		len = line_len - len;
-- 
1.6.2.5

