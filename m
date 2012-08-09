Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2HIWXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:23:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38813 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851Ab2HIWXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:23:06 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 14/16] perf symbol: factor want_symtab out of dso__load_sym()
Date: Thu,  9 Aug 2012 15:18:39 -0700
Message-Id: <1344550721-21024-15-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080922-5930-0000-0000-00000AB4D210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one callsite of dso__load_sym() uses the want_symtab functionality,
so place the logic at the callsite instead of within dso__load_sym().

This sets us up for removal of want_symtab completely once we keep
multiple elf handles (within symsrc's) around.

Setup for the later patch
"perf symbol: use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f8fbde2..83d2276 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1320,8 +1320,7 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 }
 
 static int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
-		         symbol_filter_t filter, int kmodule,
-			 int want_symtab)
+		         symbol_filter_t filter, int kmodule)
 {
 	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
@@ -1346,16 +1345,6 @@ static int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 	sec = ss->symtab;
 	shdr = ss->symshdr;
 
-	if (sec == NULL) {
-		if (want_symtab)
-			goto out_elf_end;
-
-		sec  = ss->dynsym;
-		shdr = ss->dynshdr;
-		if (sec == NULL)
-			goto out_elf_end;
-	}
-
 	opdsec = ss->opdsec;
 	opdshdr = ss->opdshdr;
 	opdidx  = ss->opdidx;
@@ -1947,8 +1936,15 @@ restart:
 		if (symsrc__init(&ss, dso, name, symtab_type) < 0)
 			continue;
 
-		ret = dso__load_sym(dso, map, &ss, filter, 0,
-				    want_symtab);
+		if (want_symtab && !ss.symtab) {
+			symsrc__destroy(&ss);
+			continue;
+		} else if (!want_symtab) {
+			ss.symtab  = ss.dynsym;
+			ss.symshdr = ss.dynshdr;
+		}
+
+		ret = dso__load_sym(dso, map, &ss, filter, 0);
 
 		/*
 		 * Some people seem to have debuginfo files _WITHOUT_ debug
@@ -2253,7 +2249,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type))
 		return -1;
 
-	err = dso__load_sym(dso, map, &ss, filter, 0, 0);
+	err = dso__load_sym(dso, map, &ss, filter, 0);
 	symsrc__destroy(&ss);
 
 	if (err > 0) {
-- 
1.7.11.3

