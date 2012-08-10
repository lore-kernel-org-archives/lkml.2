Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249Ab2HJWXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:23:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42566 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2HJWXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:36 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 10/16] perf symbol: track symtab_type of vmlinux
Date: Fri, 10 Aug 2012 15:22:56 -0700
Message-Id: <1344637382-22789-11-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-5930-0000-0000-00000ABD98AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, symtab_type would have been left at 0, or KALLSYMS, which is not
quite accurate.

Introduce DSO_SYMTAB_TYPE__VMLINUX[_GUEST].

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 9 +++++++++
 tools/perf/util/symbol.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 96dbf28..8f5cabbf 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -923,6 +923,7 @@ char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
 		[DSO_BINARY_TYPE__KALLSYMS]		= 'k',
+		[DSO_BINARY_TYPE__VMLINUX]		= 'v',
 		[DSO_BINARY_TYPE__JAVA_JIT]		= 'j',
 		[DSO_BINARY_TYPE__DEBUGLINK]		= 'l',
 		[DSO_BINARY_TYPE__BUILD_ID_CACHE]	= 'B',
@@ -933,6 +934,7 @@ char dso__symtab_origin(const struct dso *dso)
 		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]	= 'K',
 		[DSO_BINARY_TYPE__GUEST_KALLSYMS]	= 'g',
 		[DSO_BINARY_TYPE__GUEST_KMODULE]	= 'G',
+		[DSO_BINARY_TYPE__GUEST_VMLINUX]	= 'V',
 	};
 
 	if (dso == NULL || dso->symtab_type == DSO_BINARY_TYPE__NOT_FOUND)
@@ -1008,7 +1010,9 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 
 	default:
 	case DSO_BINARY_TYPE__KALLSYMS:
+	case DSO_BINARY_TYPE__VMLINUX:
 	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
+	case DSO_BINARY_TYPE__GUEST_VMLINUX:
 	case DSO_BINARY_TYPE__JAVA_JIT:
 	case DSO_BINARY_TYPE__NOT_FOUND:
 		ret = -1;
@@ -1364,6 +1368,11 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	if (fd < 0)
 		return -1;
 
+	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
+		dso->symtab_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
+	else
+		dso->symtab_type = DSO_BINARY_TYPE__VMLINUX;
+
 	err = dso__load_sym(dso, map, symfs_vmlinux, fd, filter, 0, 0);
 	close(fd);
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index c9534fe..37f1ea1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -158,6 +158,8 @@ struct addr_location {
 enum dso_binary_type {
 	DSO_BINARY_TYPE__KALLSYMS = 0,
 	DSO_BINARY_TYPE__GUEST_KALLSYMS,
+	DSO_BINARY_TYPE__VMLINUX,
+	DSO_BINARY_TYPE__GUEST_VMLINUX,
 	DSO_BINARY_TYPE__JAVA_JIT,
 	DSO_BINARY_TYPE__DEBUGLINK,
 	DSO_BINARY_TYPE__BUILD_ID_CACHE,
-- 
1.7.11.3

