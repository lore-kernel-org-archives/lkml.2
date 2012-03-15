Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437Ab2COOum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:50:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50475 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2COOug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:50:36 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dennis1.Chen@amd.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/7] module: add two missing synchronize_sched()
Date: Thu, 15 Mar 2012 22:49:00 +0800
Message-Id: <1331822941-19938-6-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RCU doc, it said synchronize_sched() is used to mark the end
of update, so two synchronize_sched() are missing after
module list add/del.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 06e7dc5..2e7a5c5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1775,6 +1775,7 @@ static void free_module(struct module *mod)
 	mutex_lock(&module_mutex);
 	stop_machine(__unlink_module, mod, NULL);
 	mutex_unlock(&module_mutex);
+	synchronize_sched();
 	mod_sysfs_teardown(mod);
 
 	/* Remove dynamic debug info */
@@ -2928,6 +2929,7 @@ static struct module *load_module(void __user *umod,
 	module_bug_finalize(info.hdr, info.sechdrs, mod);
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
+	synchronize_sched();
 
 	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
-- 
1.7.7.6

