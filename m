Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2DTQxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:53:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41447 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:53:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf symbols: Read plt symbols from proper symtab_type binary
Date: Fri, 20 Apr 2012 13:53:07 -0300
Message-Id: <1334940787-16174-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334940787-16174-1-git-send-email-acme@infradead.org>
References: <1334940787-16174-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

When loading symbols from DSO we check multiple paths of DSO binary
until we succeed to load symbols ('.symtab' section). Once symbols are
read we try to load also plt symbols.

During the reading of plt symbols, the dso file is reopened from
location given by dso->long_name. This could be wrong in case we want
process buildid binaries.

The change is to make the plt symbols being read from the DSO path, that
normal symbols were read from.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334756818-6631-1-git-send-email-jolsa@redhat.com
[ committer note: moved dso to be the first parameter of that function ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c0a028c..ab9867b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -977,8 +977,9 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
-				       symbol_filter_t filter)
+static int
+dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
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
@@ -1703,8 +1701,9 @@ restart:
 			continue;
 
 		if (ret > 0) {
-			int nr_plt = dso__synthesize_plt_symbols(dso, map,
-								 filter);
+			int nr_plt;
+
+			nr_plt = dso__synthesize_plt_symbols(dso, name, map, filter);
 			if (nr_plt > 0)
 				ret += nr_plt;
 			break;
-- 
1.7.9.2.358.g22243

