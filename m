Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab0J1PVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:21:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab0J1PVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:21:17 -0400
Date: Thu, 28 Oct 2010 11:20:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, fweisbec@gmail.com, rostedt@goodmis.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] call stop_machine_text_poke() on all cpus
Message-ID: <20101028152026.GB2875@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, text_poke_smp() passes a NULL as the third argument to
__stop_machine(), which will only run stop_machine_text_poke()
on 1 cpu. Change NULL -> cpu_online_mask, as stop_machine_text_poke()
is intended to be run on all cpus.

I actually didn't notice any problems with stop_machine_text_poke()
only being called on 1 cpu, but found this via code inspection.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 9f39a1c..3c3f26f 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -705,6 +705,6 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	atomic_set(&stop_machine_first, 1);
 	wrote_text = 0;
 	/* Use __stop_machine() because the caller already got online_cpus. */
-	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	__stop_machine(stop_machine_text_poke, (void *)&tpp, cpu_online_mask);
 	return addr;
 }
-- 
1.7.1

