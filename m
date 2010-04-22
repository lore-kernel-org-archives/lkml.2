Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0DVTyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:54:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41866 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655Ab0DVTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:54:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/3] KEYS: Fix an RCU warning in the reading of user keys
Date: Thu, 22 Apr 2010 12:54:06 -0700
Message-Id: <1271966047-9701-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100422195345.GA9639@linux.vnet.ibm.com>
References: <20100422195345.GA9639@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix an RCU warning in the reading of user keys:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
security/keys/user_defined.c:202 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by keyctl/3637:
 #0:  (&key->sem){+++++.}, at: [<ffffffff811a80ae>] keyctl_read_key+0x9c/0xcf

stack backtrace:
Pid: 3637, comm: keyctl Not tainted 2.6.34-rc5-cachefs #18
Call Trace:
 [<ffffffff81051f6c>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff811aa55f>] user_read+0x47/0x91
 [<ffffffff811a80be>] keyctl_read_key+0xac/0xcf
 [<ffffffff811a8a06>] sys_keyctl+0x75/0xb7
 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 security/keys/user_defined.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 7c687d5..e9aa079 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -199,7 +199,8 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
 	struct user_key_payload *upayload;
 	long ret;
 
-	upayload = rcu_dereference(key->payload.data);
+	upayload = rcu_dereference_protected(
+		key->payload.data, rwsem_is_locked(&((struct key *)key)->sem));
 	ret = upayload->datalen;
 
 	/* we can return the data as is */
-- 
1.7.0

