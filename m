Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1KGFrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:47:22 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40228 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1KGFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:47:20 -0500
X-AuditID: b753bd60-99661ba00000359c-91-4eb770e5e0e4
X-AuditID: b753bd60-99661ba00000359c-91-4eb770e5e0e4
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 1/5] x86: add user_mode_vm check in stack_overflow_check
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 07 Nov 2011 14:52:35 +0900
Message-ID: <20111107055235.7928.85338.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel stack overflow is checked in stack_overflow_check(),
which may wrongly detect the overflow if the stack pointer
pointed to the kernel stack accidentally.

This patch adds user-mode-vm checking before it to avoid this
misdetection and bails out early if the user stack is used.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/irq_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index acf8fbf..69bca46 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -38,6 +38,9 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
 
+	if (user_mode_vm(regs))
+		return;
+
 	WARN_ONCE(regs->sp >= curbase &&
 		  regs->sp <= curbase + THREAD_SIZE &&
 		  regs->sp <  curbase + sizeof(struct thread_info) +

