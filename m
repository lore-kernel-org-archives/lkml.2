Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2BZQR2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 11:17:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52352 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2BZQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 11:17:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of siddhesh.poyarekar@gmail.com designates 10.68.135.71 as permitted sender) smtp.mail=siddhesh.poyarekar@gmail.com; dkim=pass header.i=siddhesh.poyarekar@gmail.com
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: x86@kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH] x86_64: Record stack pointer before task execution begins
Date: Sun, 26 Feb 2012 21:47:55 +0530
Message-Id: <1330273075-2949-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <CAAHN_R3zjh-xQ9yW57JhQ=AiJG+DV6D_ppveh3BvUYy8NWU3Lg@mail.gmail.com>
References: <CAAHN_R3zjh-xQ9yW57JhQ=AiJG+DV6D_ppveh3BvUYy8NWU3Lg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->thread.usersp is unusable immediately after a binary is exec()'d
until it undergoes a context switch cycle. The start_thread() function
called during execve() saves the stack pointer into pt_regs and into
old_rsp, but fails to record it into task->thread.usersp.

Because of this, KSTK_ESP(task) returns an incorrect value for a
64-bit program until the task is switched out and back in since
switch_to swaps %rsp values in and out into task->thread.usersp.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 arch/x86/kernel/process_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..702a3b9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -341,6 +341,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	loadsegment(es, _ds);
 	loadsegment(ds, _ds);
 	load_gs_index(0);
+	current->thread.usersp	= new_sp;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
 	percpu_write(old_rsp, new_sp);
-- 
1.7.7.4

