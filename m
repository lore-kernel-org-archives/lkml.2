Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2DRNrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab2DRNrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:47:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Read plt symbols from proper symtab_type binary
Date: Wed, 18 Apr 2012 15:46:58 +0200
Message-Id: <1334756818-6631-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loading symbols from DSO we check multiple paths of DSO binary
until we succeed to load symbols ('.symtab' section). Once symbols
are read we try to load also plt symbols ('.dynsym' section).

During the reading of plt symbols, the dso file is reopened from
location given by dso->long_name. This could be wrong in case we
want process buildid binaries.

The change is to make the plt symbols being read from the DSO path,
that normal symbols were read from.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c0a028c..5988861 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -977,8 +977,9 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
-				       symbol_filter_t filter)
+static int
+dso__synthesize_plt_symbols(char *name, struct dso *dso, struct map *map,
+			    symbol_filter_t filter)
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
@@ -993,10 +994,7 @@ static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
 	char sympltname[1024];
 	Elf *elf;
 	int nr = 0, symidx, fd, err = 0;
-	char name[PATH_MAX];
 
-	snprintf(name, sizeof(name), "%s%s",
-		 symbol_conf.symfs, dso->long_name);
 	fd = open(name, O_RDONLY);
 	if (fd < 0)
 		goto out;
@@ -1703,8 +1701,10 @@ restart:
 			continue;
 
 		if (ret > 0) {
-			int nr_plt = dso__synthesize_plt_symbols(dso, map,
-								 filter);
+			int nr_plt;
+
+			nr_plt = dso__synthesize_plt_symbols(name,
+					dso, map, filter);
 			if (nr_plt > 0)
 				ret += nr_plt;
 			break;
-- 
1.7.7.6

