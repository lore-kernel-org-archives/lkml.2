Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2B0GSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:18:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2B0GSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:18:08 -0500
Date: Sun, 26 Feb 2012 22:17:35 -0800
From: tip-bot for Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Message-ID: <tip-42dfc43ee5999ac64284476ea0ac6c937587cf2b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        siddhesh.poyarekar@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, siddhesh.poyarekar@gmail.com
In-Reply-To: <1330273075-2949-1-git-send-email-siddhesh.poyarekar@gmail.com>
References: <1330273075-2949-1-git-send-email-siddhesh.poyarekar@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/process] x86_64:
  Record stack pointer before task execution begins
Git-Commit-ID: 42dfc43ee5999ac64284476ea0ac6c937587cf2b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 26 Feb 2012 22:17:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42dfc43ee5999ac64284476ea0ac6c937587cf2b
Gitweb:     http://git.kernel.org/tip/42dfc43ee5999ac64284476ea0ac6c937587cf2b
Author:     Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
AuthorDate: Sun, 26 Feb 2012 21:47:55 +0530
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 26 Feb 2012 12:59:04 -0800

x86_64: Record stack pointer before task execution begins

task->thread.usersp is unusable immediately after a binary is exec()'d
until it undergoes a context switch cycle. The start_thread() function
called during execve() saves the stack pointer into pt_regs and into
old_rsp, but fails to record it into task->thread.usersp.

Because of this, KSTK_ESP(task) returns an incorrect value for a
64-bit program until the task is switched out and back in since
switch_to swaps %rsp values in and out into task->thread.usersp.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Link: http://lkml.kernel.org/r/1330273075-2949-1-git-send-email-siddhesh.poyarekar@gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1fd94bc..eb54dd0 100644
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
