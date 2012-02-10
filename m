Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab2BJRjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:39:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2BJRjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:39:35 -0500
Date: Fri, 10 Feb 2012 18:32:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Chris Evans <scarybeasts@gmail.com>,
        Indan Zupancic <indan@nul.nu>
Subject: [PATCH 1/2] ptrace: the killed tracee should not enter the syscall
Message-ID: <20120210173259.GG8908@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <20120210173237.GF8908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210173237.GF8908@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another old/known problem. If the tracee is killed after it reports
syscall_entry, it starts the syscall and debugger can't control this.
This confuses the users and this creates the security problems for
ptrace jailers.

Change tracehook_report_syscall_entry() to return non-zero if killed,
this instructs syscall_trace_enter() to abort the syscall.

Reported-by: Chris Evans <scarybeasts@gmail.com>
Tested-by: Indan Zupancic <indan@nul.nu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/tracehook.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index a71a292..51bd91d 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -54,12 +54,12 @@ struct linux_binprm;
 /*
  * ptrace report for syscall entry and exit looks identical.
  */
-static inline void ptrace_report_syscall(struct pt_regs *regs)
+static inline int ptrace_report_syscall(struct pt_regs *regs)
 {
 	int ptrace = current->ptrace;
 
 	if (!(ptrace & PT_PTRACED))
-		return;
+		return 0;
 
 	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
 
@@ -72,6 +72,8 @@ static inline void ptrace_report_syscall(struct pt_regs *regs)
 		send_sig(current->exit_code, current, 1);
 		current->exit_code = 0;
 	}
+
+	return fatal_signal_pending(current);
 }
 
 /**
@@ -96,8 +98,7 @@ static inline void ptrace_report_syscall(struct pt_regs *regs)
 static inline __must_check int tracehook_report_syscall_entry(
 	struct pt_regs *regs)
 {
-	ptrace_report_syscall(regs);
-	return 0;
+	return ptrace_report_syscall(regs);
 }
 
 /**
-- 
1.5.5.1


