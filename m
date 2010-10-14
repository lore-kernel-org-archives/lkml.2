Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0JNHlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:41:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:37689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284Ab0JNHlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:41:46 -0400
Date: Thu, 14 Oct 2010 07:41:06 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014031036.4100.83989.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031036.4100.83989.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Use __stop_machine() in text_poke_smp()
Message-ID: <tip-3caa37519ccbb200c7fbbf6ff4fb306a30f29425@git.kernel.org>
Git-Commit-ID: 3caa37519ccbb200c7fbbf6ff4fb306a30f29425
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:41:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3caa37519ccbb200c7fbbf6ff4fb306a30f29425
Gitweb:     http://git.kernel.org/tip/3caa37519ccbb200c7fbbf6ff4fb306a30f29425
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Oct 2010 12:10:36 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 08:55:28 +0200

x86: Use __stop_machine() in text_poke_smp()

Use __stop_machine() in text_poke_smp() because the caller
must get online_cpus before calling text_poke_smp(), but
stop_machine() do it again. We don't need it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20101014031036.4100.83989.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index cb0e6d3..a36bb90 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -637,7 +637,8 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	tpp.len = len;
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
-	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	/* Use __stop_machine() because the caller already got online_cpus. */
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 	return addr;
 }
 
