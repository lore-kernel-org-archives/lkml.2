Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2IHPHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:07:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36163 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2IHPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:07:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: irina.tirdea@gmail.com, David Ahern <dsahern@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 1/3] perf annotate: make a copy of filename for passing to basename
Date: Sat,  8 Sep 2012 09:06:50 -0600
Message-Id: <1347116812-93646-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

basename may modify the string passed to it, so the string should not be
marked const.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
---
 tools/perf/util/annotate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

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
1.7.10.1

