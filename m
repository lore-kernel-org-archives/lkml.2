Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2BWI1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:27:38 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2BWI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:27:31 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-ed-4f45f86ffccf
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] perf annotate: Add missing newline on error message
Date: Thu, 23 Feb 2012 17:46:24 +0900
Message-Id: <1329986784-4916-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
References: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If perf.data couldn't find vmlinux image for the given build-id,
it would print error message. However it lacked a newline at the
end, so the output looked like below:

 $ perf annotate --stdio
 No vmlinux file with build id 63b554b2e90f14a4bced200008865e757d3e8b36
 was found in the path.

 Please use:

   perf buildid-cache -av vmlinux

 or:

   --vmlinux vmlinux Percent |   Source code & Disassembly of a.out
 ------------------------------------------------
          :
          :
          :
          :      Disassembly of section .text:
          :
          :      00000000004004f4 <foo>:
     0.00 :        4004f4:       push   %rbp
     0.00 :        4004f5:       mov    %rsp,%rbp
     0.00 :        4004f8:       movl   $0x0,-0x4(%rbp)
     0.00 :        4004ff:       jmp    400517 <foo+0x23>
    14.70 :        400501:       mov    0x200b28(%rip),%rax        # 601030 <count>
     0.02 :        400508:       add    $0x1,%rax
     0.01 :        40050c:       mov    %rax,0x200b1d(%rip)        # 601030 <count>
     0.01 :        400513:       addl   $0x1,-0x4(%rbp)
    13.92 :        400517:       cmpl   $0x98967f,-0x4(%rbp)
    71.33 :        40051e:       jle    400501 <foo+0xd>
     0.00 :        400520:       leaveq
     0.00 :        400521:       retq

Fix it by adding a newline at the end of the message. It doesn't affect
the tui output AFAICS. New output will look like this:

 ...
 or:

   --vmlinux vmlinux
  Percent |   Source code & Disassembly of a.out
 ------------------------------------------------
          :
          :
          :
          :      Disassembly of section .text:
 ...

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 011ed2676604..e5a462f1d07c 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -315,7 +315,7 @@ fallback:
 		       "Please use:\n\n"
 		       "  perf buildid-cache -av vmlinux\n\n"
 		       "or:\n\n"
-		       "  --vmlinux vmlinux",
+		       "  --vmlinux vmlinux\n",
 		       sym->name, build_id_msg ?: "");
 		goto out_free_filename;
 	}
-- 
1.7.9

