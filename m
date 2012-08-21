Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2HUQHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:07:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2HUQH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:07:27 -0400
Date: Tue, 21 Aug 2012 09:07:02 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-005f92947a0da7eb47b0f1ff611f8fc3d7ab4751@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-13-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-13-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Set symtab_type in dso__load_sym
Git-Commit-ID: 005f92947a0da7eb47b0f1ff611f8fc3d7ab4751
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:07:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  005f92947a0da7eb47b0f1ff611f8fc3d7ab4751
Gitweb:     http://git.kernel.org/tip/005f92947a0da7eb47b0f1ff611f8fc3d7ab4751
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:58 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:33:01 -0300

perf symbols: Set symtab_type in dso__load_sym

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
