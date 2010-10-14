Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0JNDI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 23:08:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46573 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0JNDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 23:08:24 -0400
X-AuditID: b753bd60-aa6d3ba000005dcc-29-4cb674259b2d
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 4/5] [BUGFIX] x86: Use __stop_machine() in text_poke_smp()
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Oct 2010 12:10:36 +0900
Message-ID: <20101014031036.4100.83989.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __stop_machine() in text_poke_smp() because the caller
must get online_cpus before calling text_poke_smp(), but
stop_machine() do it again. We don't need it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
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
 

