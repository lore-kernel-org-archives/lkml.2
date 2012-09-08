Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2IHUhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:37:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2IHUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:37:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf annotate: Make a copy of filename for passing to basename
Date: Sat,  8 Sep 2012 17:36:52 -0300
Message-Id: <1347136614-25598-8-git-send-email-acme@infradead.org>
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
Link: http://lkml.kernel.org/r/1347116812-93646-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 51ef69c..04eafd3 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -984,7 +984,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			    int context)
 {
 	struct dso *dso = map->dso;
-	const char *filename = dso->long_name, *d_filename;
+	char *filename;
+	const char *d_filename;
 	struct annotation *notes = symbol__annotation(sym);
 	struct disasm_line *pos, *queue = NULL;
 	u64 start = map__rip_2objdump(map, sym->start);
@@ -992,6 +993,10 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	int more = 0;
 	u64 len;
 
+	filename = strdup(dso->long_name);
+	if (!filename)
+		return -ENOMEM;
+
 	if (full_paths)
 		d_filename = filename;
 	else
@@ -1042,6 +1047,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 		}
 	}
 
+	free(filename);
+
 	return more;
 }
 
-- 
1.7.1

