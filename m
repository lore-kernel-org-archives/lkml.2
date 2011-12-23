Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1LWVxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:53:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab1LWVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/15] perf tools: Fix truncated annotation
Date: Fri, 23 Dec 2011 19:53:08 -0200
Message-Id: <1324677198-5191-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

I get such truncated annotation results in 'perf top':

         :        Disassembly of section .text:                                                   ▒
         :                                                                                        ▒
         :        ffffffff810966a8 <nr_iowait_cpu>:                                               ▒
    4.94 :        ffffffff810966a8:       movslq %edi,%rdi                                        ▒
    3.70 :        ffffffff810966ab:       mov    $0x13700,%rax                                    ▒
    0.00 :        ffffffff810966b2:       add    -0x7e32cb00(,%rdi,8),%rax                        ▒
    8.64 :        ffffffff810966ba:       mov    0x7e0(%rax),%eax                                 ▒
   82.72 :        ffffffff810966c0:       cltq                                                    ▒

Note the missing 'retq' which is there in the original function:

ffffffff810966a8 <nr_iowait_cpu>:
ffffffff810966a8:       48 63 ff                movslq %edi,%rdi
ffffffff810966ab:       48 c7 c0 00 37 01 00    mov    $0x13700,%rax
ffffffff810966b2:       48 03 04 fd 00 35 cd    add    -0x7e32cb00(,%rdi,8),%rax
ffffffff810966b9:       81
ffffffff810966ba:       8b 80 e0 07 00 00       mov    0x7e0(%rax),%eax
ffffffff810966c0:       48 98                   cltq
ffffffff810966c2:       c3                      retq

ffffffff810966c3 <this_cpu_load>:

I'm using a fairly recent binutils:

  GNU objdump version 2.21.51.0.6-2.fc16 20110118

AFAICS the bug is simply that sym->end points to the last byte
of the symbol in question - while objdump's --stop-address
expects the last byte plus 1 to disassemble the full range.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111223130804.GA24305@elte.hu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 376e643..011ed26 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -334,7 +334,7 @@ fallback:
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
-		 map__rip_2objdump(map, sym->end),
+		 map__rip_2objdump(map, sym->end+1),
 		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
 		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
-- 
1.7.8.rc0.35.gee6df

