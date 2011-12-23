Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1LWNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 08:09:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39411 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab1LWNJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 08:09:53 -0500
Date: Fri, 23 Dec 2011 14:08:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: Fix truncated annotation
Message-ID: <20111223130804.GA24305@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/tools/perf/util/annotate.c
===================================================================
--- linux.orig/tools/perf/util/annotate.c
+++ linux/tools/perf/util/annotate.c
@@ -334,7 +334,7 @@ fallback:
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
-		 map__rip_2objdump(map, sym->end),
+		 map__rip_2objdump(map, sym->end+1),
 		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
 		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
