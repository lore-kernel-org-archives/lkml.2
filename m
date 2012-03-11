Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2CKKyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:54:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42138 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2CKKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:54:46 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [V2 PATCH 3/3] module: dd missing synchronize_sched()
Date: Sun, 11 Mar 2012 18:54:15 +0800
Message-Id: <1331463255-31019-3-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331463255-31019-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331463255-31019-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure about this patch, my understanding is that
after every list del/add, we should call synchronize_sched()
to mark the end of update. Does this patch make sense?

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index db402a8..e1d8fae 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1785,6 +1785,7 @@ static void free_module(struct module *mod)
 	mutex_lock(&module_mutex);
 	stop_machine(__unlink_module, mod, NULL);
 	mutex_unlock(&module_mutex);
+	synchronize_sched();
 	mod_sysfs_teardown(mod);
 
 	/* Remove dynamic debug info */
@@ -2935,6 +2936,7 @@ static struct module *load_module(void __user *umod,
 	module_bug_finalize(info.hdr, info.sechdrs, mod);
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
+	synchronize_sched();
 
 	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
-- 
1.7.7.6

