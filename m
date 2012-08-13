Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2HMSqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:46:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2HMShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/38] perf symbols: Set symtab_type in dso__load_sym
Date: Mon, 13 Aug 2012 15:37:14 -0300
Message-Id: <1344883039-13495-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

In certain cases, dso__load requires dso->symbol_type to be set prior to
calling it. With the introduction of symsrc*, the symtab_type is now
stored in a symsrc which is then passed to dso__load_sym().

Change dso__load_sym() to use the symtab_type from them symsrc (setting
dso->symtab_type as well).

Setup for later patch

"perf symbols: Use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-13-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c |    2 ++
 tools/perf/util/symbol.c     |   13 +++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6974b2a..3a9c38a 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -645,6 +645,8 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 	int nr = 0;
 	size_t opdidx = 0;
 
+	dso->symtab_type = ss->type;
+
 	elf = ss->elf;
 	ehdr = ss->ehdr;
 	sec = ss->symtab;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index afec3f0..2b3495a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1079,14 +1079,14 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
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
@@ -1361,16 +1361,17 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
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
1.7.1

