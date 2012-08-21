Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2HUQGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:06:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2HUQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:06:14 -0400
Date: Tue, 21 Aug 2012 09:05:12 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-21ea4539b4d1b26de7f2eb227b5d1a092b32cc19@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-11-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-11-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Track symtab_type of vmlinux
Git-Commit-ID: 21ea4539b4d1b26de7f2eb227b5d1a092b32cc19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:05:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21ea4539b4d1b26de7f2eb227b5d1a092b32cc19
Gitweb:     http://git.kernel.org/tip/21ea4539b4d1b26de7f2eb227b5d1a092b32cc19
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:56 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:26:18 -0300

perf symbols: Track symtab_type of vmlinux

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
