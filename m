Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0KXLfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:35:20 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0KXLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=K9MBFeRVKzCu0S/JM+bP/1UE3VsajkL8ge2TQMVBfPcT/Jjrfbw0z3UAj83+VA9IHK
         YRxB8aCTggMqHLtm/UBzFyDqLi7gUNOjLRuMCQR704ZDi77QQ4VvjyNvLxCZYUpcfEJ8
         eINxtBeATRpx+wQfGJJnmt3DZxWsHvip0P6Tc=
From: tom.leiming@gmail.com
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf:tools: avoid to create much more maps for kernel symbols on ARM
Date: Wed, 24 Nov 2010 19:35:02 +0800
Message-Id: <1290598502-31727-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

On ARM, module addresss space is ahead of kernel space,
so the module symbols are handled before kernel symbol
in dso__split_kallsyms, then cause one map is created
for each kernel symbol.

This patch fixes the issue by restoring to original kernel
map in dso__split_kallsyms() to avoid create unnecessary maps
for kernel symbols when starting to handle kenel symbol maps
but after module symbol maps are handled over.

Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 tools/perf/util/symbol.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0500895..c5b4ccb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -520,6 +520,53 @@ static int dso__load_all_kallsyms(struct dso *self, const char *filename,
 	return kallsyms__parse(filename, &args, map__process_kallsym_symbol);
 }
 
+static int map_for_module(struct map *map, struct machine *self)
+{
+	char *line = NULL;
+	FILE *file;
+	const char *modules;
+	char name[PATH_MAX];
+	int ret = 0;
+
+	if (machine__is_default_guest(self))
+		modules = symbol_conf.default_guest_modules;
+	else {
+		sprintf(name, "%s/proc/modules", self->root_dir);
+		modules = name;
+	}
+
+	file = fopen(modules, "r");
+	if (file == NULL)
+		return ret;
+
+	/*strip [] of map->dso->short_name*/
+	strncpy(name, map->dso->short_name + 1,
+			strlen(map->dso->short_name) - 2);
+	name[strlen(map->dso->short_name) - 3] = '\0';
+
+	while (!feof(file)) {
+		int line_len;
+		size_t n;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			break;
+
+		line[line_len-1] = '\0'; /* \n */
+
+		if (strstr(line, name)) {
+			ret = 1;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(file);
+	return ret;
+}
 /*
  * Split the symbols into maps, making sure there are no overlaps, i.e. the
  * kernel range is broken in several maps, named [kernel].N, as we don't have
@@ -590,6 +637,16 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *dso;
 
+			/*
+			 * If module symbol is ahead of kernel symbol like ARM,
+			 * restore to original kernel map to avoid create many
+			 * unnecessary maps for kernel symbols.
+			 */
+			if (map_for_module(curr_map, machine)) {
+				curr_map = map;
+				goto operate_map;
+			}
+
 			if (self->kernel == DSO_TYPE_GUEST_KERNEL)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
@@ -616,6 +673,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			++kernel_range;
 		}
 
+operate_map:
 		if (filter && filter(curr_map, pos)) {
 discard_symbol:		rb_erase(&pos->rb_node, root);
 			symbol__delete(pos);
-- 
1.7.3

