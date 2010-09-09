Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0IIJDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:03:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38328 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0IIJDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:03:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] exec: don't turn PF_KTHREAD off when command not found
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100909180236.C94C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Sep 2010 18:03:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, do_execve() turn PF_KTHREAD off before search_binary_handler().
It has theorical risk of PF_KTHREAD lost. When ENOEXEC case, we don't
have to turn PF_KTHREAD off.

This patch move this flag modification after founding execution file.

I guess this is only theorical issue because now any kthread don't
call do_execve() directly. but anyway fixing would be better.

Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/exec.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ef8b9dc..81d0d06 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1011,7 +1011,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;		/* We're using it now */
 	set_exec_mm(NULL);
 
-	current->flags &= ~PF_RANDOMIZE;
+	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 
@@ -1421,7 +1421,6 @@ int do_execve(const char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->flags &= ~PF_KTHREAD;
 	retval = search_binary_handler(bprm,regs);
 	if (retval < 0)
 		goto out;
-- 
1.6.5.2



