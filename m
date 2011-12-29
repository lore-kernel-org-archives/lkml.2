Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1L2Utm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:49:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1L2Uti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:49:38 -0500
Date: Thu, 29 Dec 2011 12:49:15 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-f41612f43be9575e1160460b08c3a760e6e27e1b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111223130804.GA24305@elte.hu>
References: <20111223130804.GA24305@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix truncated annotation
Git-Commit-ID: f41612f43be9575e1160460b08c3a760e6e27e1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:49:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f41612f43be9575e1160460b08c3a760e6e27e1b
Gitweb:     http://git.kernel.org/tip/f41612f43be9575e1160460b08c3a760e6e27e1b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 23 Dec 2011 14:08:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:39:19 -0200

perf tools: Fix truncated annotation

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
