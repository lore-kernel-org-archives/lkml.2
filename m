Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2INROb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:14:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438Ab2INROI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:14:08 -0400
Date: Fri, 14 Sep 2012 19:16:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] uprobes: Move clear_thread_flag(TIF_UPROBE) to
	uprobe_notify_resume()
Message-ID: <20120914171603.GA29652@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171513.GA29599@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move clear_thread_flag(TIF_UPROBE) from do_notify_resume() to
uprobe_notify_resume() for !CONFIG_UPROBES case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/signal.c |    4 +---
 kernel/events/uprobes.c  |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b280908..0041e5a 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -785,10 +785,8 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		mce_notify_process();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
-	if (thread_info_flags & _TIF_UPROBE) {
-		clear_thread_flag(TIF_UPROBE);
+	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
-	}
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4ea0f0b..14c2e99 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1558,6 +1558,8 @@ void uprobe_notify_resume(struct pt_regs *regs)
 {
 	struct uprobe_task *utask;
 
+	clear_thread_flag(TIF_UPROBE);
+
 	utask = current->utask;
 	if (utask && utask->active_uprobe)
 		handle_singlestep(utask, regs);
-- 
1.5.5.1

