Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030526Ab2COOtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:49:49 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55023 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2COOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:49:44 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dennis1.Chen@amd.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/7] module: take rcu_read_lock_sched for find_symbol
Date: Thu, 15 Mar 2012 22:48:56 +0800
Message-Id: <1331822941-19938-2-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1331822941-19938-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_symbol() iterates module list with list_for_each_entry_rcu()
should its caller should hold rcu_read_lock_sched().

This patch changes the module_mutex to rcu_read_lock_sched in
resolve_symbol() and adds rcu_read_lock_sched in verify_export_symbols().

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/module.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 6f6a3fd..b31b23f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1174,7 +1174,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
 	const unsigned long *crc;
 	int err;
 
-	mutex_lock(&module_mutex);
+	rcu_read_lock_sched();
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!sym)
@@ -1196,7 +1196,7 @@ getname:
 	/* We must make copy under the lock if we failed to get ref. */
 	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
 unlock:
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock_sched();
 	return sym;
 }
 
@@ -1844,6 +1844,7 @@ static int verify_export_symbols(struct module *mod)
 #endif
 	};
 
+	rcu_read_lock_sched();
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
 			if (find_symbol(s->name, &owner, NULL, true, false)) {
@@ -1851,10 +1852,12 @@ static int verify_export_symbols(struct module *mod)
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
 				       mod->name, s->name, module_name(owner));
+				rcu_read_unlock_sched();
 				return -ENOEXEC;
 			}
 		}
 	}
+	rcu_read_unlock_sched();
 	return 0;
 }
 
-- 
1.7.7.6

