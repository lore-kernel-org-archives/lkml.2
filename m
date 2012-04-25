Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab2DYNxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:53:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2DYNxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:53:05 -0400
Date: Wed, 25 Apr 2012 06:52:29 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-33ff581eddf744ea91a50d46c2f0961b375a9595@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1334756818-6631-1-git-send-email-jolsa@redhat.com>
References: <1334756818-6631-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Read plt symbols from proper symtab_type binary
Git-Commit-ID: 33ff581eddf744ea91a50d46c2f0961b375a9595
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:52:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33ff581eddf744ea91a50d46c2f0961b375a9595
Gitweb:     http://git.kernel.org/tip/33ff581eddf744ea91a50d46c2f0961b375a9595
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 18 Apr 2012 15:46:58 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 13:34:49 -0300

perf symbols: Read plt symbols from proper symtab_type binary

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
 1 files changed, 6 insertions(+), 7 deletions(-)

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
