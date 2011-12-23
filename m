Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1L0JnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 04:43:15 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:59259 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1L0JnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 04:43:12 -0500
X-AuditID: b753bd60-98392ba000007b1b-f9-4ef992aad9fc
X-AuditID: b753bd60-98392ba000007b1b-f9-4ef992aad9fc
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Subject: [RFC PATCH 1/5][RESEND] livedump: Add notifier-call-chain into
 do_page_fault
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kevin Hilman <khilman@ti.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Michal Marek <mmarek@suse.cz>, Rik van Riel <riel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 23 Dec 2011 22:14:41 +0900
Message-ID: <20111223131441.13217.69129.stgit@t3500.sdl.hitachi.co.jp>
In-Reply-To: <20111223131441.13217.68917.stgit@t3500.sdl.hitachi.co.jp>
References: <20111223131441.13217.68917.stgit@t3500.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds notifier-call-chain that is called in do_page_fault.
This can be used to check whether page fault occurs for the normal reason,
or it is caused by special write protection, for example Live Dump.

Signed-off-by: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@mit.edu>
Cc: Rik van Riel <riel@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
---

 arch/x86/include/asm/traps.h |    2 ++
 arch/x86/mm/fault.c          |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0012d09..7bf6081 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -89,4 +89,6 @@ asmlinkage void smp_thermal_interrupt(void);
 asmlinkage void mce_threshold_interrupt(void);
 #endif
 
+extern struct atomic_notifier_head page_fault_notifier_list;
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 5db0490..2f8e2a9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -985,6 +985,8 @@ static int fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
+ATOMIC_NOTIFIER_HEAD(page_fault_notifier_list);
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -1008,6 +1010,11 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	/* Get the faulting address: */
 	address = read_cr2();
 
+	if (atomic_notifier_call_chain(
+				&page_fault_notifier_list, error_code, regs) &
+			NOTIFY_OK)
+		return;
+
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.

