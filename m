Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2HMSi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:38:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:45010 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2HMShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:43 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/38] perf symbols: Track symtab_type of vmlinux
Date: Mon, 13 Aug 2012 15:37:12 -0300
Message-Id: <1344883039-13495-32-git-send-email-acme@infradead.org>
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

Previously, symtab_type would have been left at 0, or KALLSYMS, which is
not quite accurate.

Introduce DSO_BINARY_TYPE__VMLINUX[_GUEST].

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-11-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    9 +++++++++
 tools/perf/util/symbol.h |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 96dbf28..8f5cabb 100644
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
1.7.1

