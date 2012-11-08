Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2KHKkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:40:19 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:50633 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2KHKkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:40:16 -0500
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Fix perf DSOs' map address if .text is not the first secion of
 vmlinux
Thread-Topic: Fix perf DSOs' map address if .text is not the first secion of
 vmlinux
Thread-Index: Ac29nWewQONpwdAhQ1+uM+tgsg4v6g==
Date: Thu, 8 Nov 2012 10:40:01 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47A82F5E@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1bacfabf8369764126758bbbea1d3963ac778cce Mon Sep 17 00:00:00 2001
From: Lu Zhigang <zlu@tilera.com>
Date: Thu, 8 Nov 2012 04:31:05 -0500
Subject: [PATCH 1/1] perf symbol: Don't assume .text section is the first
 section of vmlinux

The start address derived from /proc/kallsyms in is the start address of
kernel, but not the start address of .text section of kernel. If the .text
section is not at the beginning of vmlinux, perf will mess up the sections'
address range, thus failing to resolve the kernel symbols.

Verified on TILE architecture whose kernel sections are as following.
Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .intrpt1      00003fe8  fffffff700000000  0000000000000000  00010000  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .text         008485a0  fffffff700020000  0000000000020000  00020000  2**6
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .init.text    00047e88  fffffff700870000  0000000000870000  00870000  2**3
...

Signed-off-by: Lu Zhigang <zlu@tilera.com>
---
 tools/perf/util/symbol-elf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index db0cc92..7fc219b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -645,6 +645,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
        Elf_Scn *sec, *sec_strndx;
        Elf *elf;
        int nr = 0;
+       u64 kernel_start = map->start;
 
        dso->symtab_type = syms_ss->type;
 
@@ -746,6 +747,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
                                goto new_symbol;
 
                        if (strcmp(section_name, ".text") == 0) {
+                               map->start = kernel_start + shdr.sh_offset;
                                curr_map = map;
                                curr_dso = dso;
                                goto new_symbol;
@@ -759,7 +761,7 @@ int dso__load_sym(struct dso *dso, struct map *map,
                                u64 start = sym.st_value;
 
                                if (kmodule)
-                                       start += map->start + shdr.sh_offset;
+                                       start += kernel_start + shdr.sh_offset;
 
                                curr_dso = dso__new(dso_name);
                                if (curr_dso == NULL)
-- 
1.7.10.3
