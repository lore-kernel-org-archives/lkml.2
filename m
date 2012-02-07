Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2BGTfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:35:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2BGTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:34:56 -0500
Date: Tue, 7 Feb 2012 11:34:38 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-7a0153ee15575a4d07b5da8c96b79e0b0fd41a12@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, williams@redhat.com, jolsa@redhat.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eric.dumazet@gmail.com,
        williams@redhat.com, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
References: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix perf stack to non executable on x86_64
Git-Commit-ID: 7a0153ee15575a4d07b5da8c96b79e0b0fd41a12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:34:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a0153ee15575a4d07b5da8c96b79e0b0fd41a12
Gitweb:     http://git.kernel.org/tip/7a0153ee15575a4d07b5da8c96b79e0b0fd41a12
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 6 Feb 2012 18:54:06 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Feb 2012 18:54:06 -0200

perf tools: Fix perf stack to non executable on x86_64

By adding following objects:
  bench/mem-memcpy-x86-64-asm.o
the x86_64 perf binary ended up with executable stack.

The reason was that above object are assembler sourced and is missing the
GNU-stack note section. In such case the linker assumes that the final binary
should not be restricted at all and mark the stack as RWX.

Adding section ".note.GNU-stack" definition to mentioned object, with all
flags disabled, thus omiting this object from linker stack flags decision.

Problem introduced in:

  $ git describe ea7872b
  v2.6.37-rc2-19-gea7872b

Reported-at: https://bugzilla.redhat.com/show_bug.cgi?id=783570
Reported-by: Clark Williams <williams@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/1328100848-5630-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
[ committer note: Backported fix to perf/urgent (3.3-rc2+) ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy-x86-64-asm.S |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index a57b66e..185a96d 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,8 @@
 
 #include "../../../arch/x86/lib/memcpy_64.S"
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
