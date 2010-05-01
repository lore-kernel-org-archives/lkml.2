Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab0EAA0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:26:31 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59101 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab0EAA0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:26:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 02/10] KEYS: Fix an RCU warning
Date: Fri, 30 Apr 2010 17:26:06 -0700
Message-Id: <1272673574-27797-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100501002548.GA27375@linux.vnet.ibm.com>
References: <20100501002548.GA27375@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix the following RCU warning:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
security/keys/request_key.c:116 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by keyctl/5372:
 #0:  (key_types_sem){.+.+.+}, at: [<ffffffff811a4e3d>] key_type_lookup+0x1c/0x70

stack backtrace:
Pid: 5372, comm: keyctl Not tainted 2.6.34-rc3-cachefs #150
Call Trace:
 [<ffffffff810515f8>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff811a9220>] call_sbin_request_key+0x156/0x2b6
 [<ffffffff811a4c66>] ? __key_instantiate_and_link+0xb1/0xdc
 [<ffffffff811a4cd3>] ? key_instantiate_and_link+0x42/0x5f
 [<ffffffff811a96b8>] ? request_key_auth_new+0x17b/0x1f3
 [<ffffffff811a8e00>] ? request_key_and_link+0x271/0x400
 [<ffffffff810aba6f>] ? kmem_cache_alloc+0xe1/0x118
 [<ffffffff811a8f1a>] request_key_and_link+0x38b/0x400
 [<ffffffff811a7b72>] sys_request_key+0xf7/0x14a
 [<ffffffff81052227>] ? trace_hardirqs_on_caller+0x10c/0x130
 [<ffffffff81393f5c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

This was caused by doing:

	[root@andromeda ~]# keyctl newring fred @s
	539196288
	[root@andromeda ~]# keyctl request2 user a a 539196288
	request_key: Required key not available

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 security/keys/request_key.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 03fe63e..ea97c31 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -68,7 +68,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 {
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
-	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
+	struct key *key = cons->key, *authkey = cons->authkey, *keyring,
+		*session;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
 	char key_str[12], keyring_str[3][12];
 	char desc[20];
@@ -112,10 +113,12 @@ static int call_sbin_request_key(struct key_construction *cons,
 	if (cred->tgcred->process_keyring)
 		prkey = cred->tgcred->process_keyring->serial;
 
-	if (cred->tgcred->session_keyring)
-		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
-	else
-		sskey = cred->user->session_keyring->serial;
+	rcu_read_lock();
+	session = rcu_dereference(cred->tgcred->session_keyring);
+	if (!session)
+		session = cred->user->session_keyring;
+	sskey = session->serial;
+	rcu_read_unlock();
 
 	sprintf(keyring_str[2], "%d", sskey);
 
-- 
1.7.0

