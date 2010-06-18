Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0FRDIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:08:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54016 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0FRDIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:08:38 -0400
Message-Id: <201006180308.o5I38O34094551@www262.sakura.ne.jp>
Subject: [PATCH 2.6.29.6 - 2.6.35-rc3] CRED: Release spinlock before commit_creds().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jun 2010 12:08:24 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 17062010 #4039886, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reparent_to_kthreadd() is calling commit_creds() with tasklist_lock held. But
commit_creds() calls key_fsuid_changed()/key_fsgid_changed()/proc_id_connector()
which may sleep. Release tasklist_lock before calling commit_creds().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- security-testing-2.6.orig/kernel/exit.c
+++ security-testing-2.6/kernel/exit.c
@@ -348,8 +348,8 @@ static void reparent_to_kthreadd(void)
 	       sizeof(current->signal->rlim));
 
 	atomic_inc(&init_cred.usage);
-	commit_creds(&init_cred);
 	write_unlock_irq(&tasklist_lock);
+	commit_creds(&init_cred);
 }
 
 void __set_special_pids(struct pid *pid)
