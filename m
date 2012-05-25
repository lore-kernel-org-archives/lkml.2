Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2EYJaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:30:08 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:56045 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2EYJaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:30:05 -0400
X-AuditID: b753bd60-9b106ba000007aa1-a8-4fbf4c8c610c
X-AuditID: b753bd60-9b106ba000007aa1-a8-4fbf4c8c610c
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 1/4 V2] livedump: Add notifier-call-chain into
 do_page_fault
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Vivek Goyal" <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Cc: "Andy Lutomirski" <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@redhat.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Kees Cook" <keescook@chromium.org>, "Kevin Hilman" <khilman@ti.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Prarit Bhargava" <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Tejun Heo" <tj@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 25 May 2012 18:12:07 +0900
Message-ID: <20120525091207.10256.15550.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds notifier-call-chain that is called in do_page_fault.
Livedump uses this to check if page fault is caused by livedump, and if so,
the fault is handled by livedump's handler function. Otherwise, it is
handled by the original page fault handler.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@mit.edu>
Cc: Kees Cook <keescook@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/include/asm/traps.h |    2 ++
 arch/x86/mm/fault.c          |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..dcd5318 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -114,4 +114,6 @@ enum {
 	X86_TRAP_IRET = 32,	/* 32, IRET Exception */
 };
 
+extern struct atomic_notifier_head page_fault_notifier_list;
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3ecfd1a..f7460e2 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -995,6 +995,8 @@ static int fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
+ATOMIC_NOTIFIER_HEAD(page_fault_notifier_list);
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -1018,6 +1020,11 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	/* Get the faulting address: */
 	address = read_cr2();
 
+	if (atomic_notifier_call_chain(
+				&page_fault_notifier_list, error_code, regs)
+			== NOTIFY_STOP)
+		return;
+
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.

