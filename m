Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0JSFaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:30:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34671 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0JSFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:30:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [resend][PATCH] exec: don't turn PF_KTHREAD off when a target command was not found
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Message-Id: <20101019142736.A1F2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 14:30:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, do_execve() turn PF_KTHREAD off before search_binary_handler().
It has theorical risk of PF_KTHREAD lost. We don't have to turn 
PF_KTHREAD off when ENOEXEC case.

This patch move this flag modification after founding execution file.

this is only theorical issue because now any kthread don't
call do_execve() directly. but anyway fixing would be better.

Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/exec.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index fcbd39e..6469c26 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1009,7 +1009,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;		/* We're using it now */
 
-	current->flags &= ~PF_RANDOMIZE;
+	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 
@@ -1412,7 +1412,6 @@ int do_execve(const char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->flags &= ~PF_KTHREAD;
 	retval = search_binary_handler(bprm,regs);
 	if (retval < 0)
 		goto out;
-- 
1.6.5.2



