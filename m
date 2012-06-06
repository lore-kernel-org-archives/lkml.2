Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab2FFQCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:02:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2FFQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:02:42 -0400
Date: Wed, 6 Jun 2012 09:02:09 -0700
From: tip-bot for Arun Sharma <asharma@fb.com>
Message-ID: <tip-302fa4b58ac754a6da13f4f5546f710fecc3b945@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung.kim@lge.com,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung.kim@lge.com,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1334961696-19580-2-git-send-email-asharma@fb.com>
References: <1334961696-19580-2-git-send-email-asharma@fb.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Allow multiple stacks
Git-Commit-ID: 302fa4b58ac754a6da13f4f5546f710fecc3b945
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:02:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  302fa4b58ac754a6da13f4f5546f710fecc3b945
Gitweb:     http://git.kernel.org/tip/302fa4b58ac754a6da13f4f5546f710fecc3b945
Author:     Arun Sharma <asharma@fb.com>
AuthorDate: Fri, 20 Apr 2012 15:41:33 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:07:58 +0200

perf/x86: Allow multiple stacks

Without this patch, applications with two different stack
regions (eg: native stack vs JIT stack) get truncated
callchains even when RBP chaining is present. GDB shows proper
stack traces and the frame pointer chaining is intact.

This patch disables the (fp < RSP) check, hoping that other checks
in the code save the day for us. In our limited testing, this
didn't seem to break anything.

In the long term, we could potentially have userspace advise
the kernel on the range of valid stack addresses, so we don't
spend a lot of time unwinding from bogus addresses.

Signed-off-by: Arun Sharma <asharma@fb.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334961696-19580-2-git-send-email-asharma@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cb60838..e78bc25 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1781,9 +1781,6 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if (bytes != sizeof(frame))
 			break;
 
-		if (fp < compat_ptr(regs->sp))
-			break;
-
 		perf_callchain_store(entry, frame.return_address);
 		fp = compat_ptr(frame.next_frame);
 	}
@@ -1827,9 +1824,6 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		if (bytes != sizeof(frame))
 			break;
 
-		if ((unsigned long)fp < regs->sp)
-			break;
-
 		perf_callchain_store(entry, frame.return_address);
 		fp = frame.next_frame;
 	}
