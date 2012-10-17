Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2JQRUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:20:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:46103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab2JQRUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/11] perf tools: Fix segfault when using srcline sort key
Date: Wed, 17 Oct 2012 14:19:39 -0300
Message-Id: <1350494387-10987-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The srcline sort key is for grouping samples based on their source file
and line number.  It use addr2line tool to get the information but it
requires dso name.  It caused a segfault when a sample does not have the
name by dereferencing a NULL pointer.  Fix it by using raw ip addresses
for those samples.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1350272383-7016-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b5b1b92..dd68f11 100644
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
1.7.1

