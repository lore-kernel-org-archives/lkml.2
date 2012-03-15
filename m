Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030577Ab2COOuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:50:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55023 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2COOuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:50:01 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dennis1.Chen@amd.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/7] module: take rcu_read_lock_sched in module_kallsyms_on_each_symbol()
Date: Thu, 15 Mar 2012 22:48:58 +0800
Message-Id: <1331822941-19938-4-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_kallsyms_on_each_symbol() should iterate the module list
with list_for_each_entry_rcu() after holding rcu_read_lock_sched().

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f210d74..73e1f95 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3271,14 +3271,18 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	unsigned int i;
 	int ret;
 
-	list_for_each_entry(mod, &modules, list) {
+	rcu_read_lock_sched();
+	list_for_each_entry_rcu(mod, &modules, list) {
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
 				 mod, mod->symtab[i].st_value);
-			if (ret != 0)
+			if (ret != 0) {
+				rcu_read_unlock_sched();
 				return ret;
+			}
 		}
 	}
+	rcu_read_unlock_sched();
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
-- 
1.7.7.6

