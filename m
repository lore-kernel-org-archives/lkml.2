Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab2HIWZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:25:30 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35949 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854Ab2HIWWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:22:21 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 12/16] perf symbol: set symtab_type in dso__load_sym
Date: Thu,  9 Aug 2012 15:18:37 -0700
Message-Id: <1344550721-21024-13-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344550721-21024-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080922-9360-0000-0000-00000947276F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain cases, dso__load requires dso->symbol_type to be set prior to
calling it. With the introduction of symsrc*, the symtab_type is now
stored in a symsrc which is then passed to dso__load_sym().

Change dso__load_sym() to use the symtab_type from them symsrc (setting
dso->symtab_type as well).

Setup for later patch
"perf symbol: use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 00a8226..61b9cdb 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1350,6 +1350,8 @@ static int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 	int nr = 0;
 	size_t opdidx = 0;
 
+	dso->symtab_type = ss->type;
+
 	elf = ss->elf;
 	ehdr = ss->ehdr;
 	sec = ss->symtab;
@@ -1946,14 +1948,14 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 restart:
 	for (i = 0; i < DSO_BINARY_TYPE__SYMTAB_CNT; i++) {
 
-		dso->symtab_type = binary_type_symtab[i];
+		enum dso_binary_type symtab_type = binary_type_symtab[i];
 
-		if (dso__binary_type_file(dso, dso->symtab_type,
+		if (dso__binary_type_file(dso, symtab_type,
 					  root_dir, name, PATH_MAX))
 			continue;
 
 		/* Name is now the name of the next image to try */
-		if (symsrc__init(&ss, dso, name, dso->symtab_type) < 0)
+		if (symsrc__init(&ss, dso, name, symtab_type) < 0)
 			continue;
 
 		ret = dso__load_sym(dso, map, &ss, filter, 0,
@@ -2247,16 +2249,17 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	int err = -1;
 	struct symsrc ss;
 	char symfs_vmlinux[PATH_MAX];
+	enum dso_binary_type symtab_type;
 
 	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
 		 symbol_conf.symfs, vmlinux);
 
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
-		dso->symtab_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
+		symtab_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
 	else
-		dso->symtab_type = DSO_BINARY_TYPE__VMLINUX;
+		symtab_type = DSO_BINARY_TYPE__VMLINUX;
 
-	if (symsrc__init(&ss, dso, symfs_vmlinux, dso->symtab_type))
+	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type))
 		return -1;
 
 	err = dso__load_sym(dso, map, &ss, filter, 0, 0);
-- 
1.7.11.3

