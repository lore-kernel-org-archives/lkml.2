Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0DGOOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864Ab0DGOOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:14:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Fix an RCU warning
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Wed, 07 Apr 2010 15:14:10 +0100
Message-ID: <20100407141409.15200.53705.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 security/keys/request_key.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 03fe63e..544e932 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -112,10 +112,13 @@ static int call_sbin_request_key(struct key_construction *cons,
 	if (cred->tgcred->process_keyring)
 		prkey = cred->tgcred->process_keyring->serial;
 
-	if (cred->tgcred->session_keyring)
+	if (cred->tgcred->session_keyring) {
+		rcu_read_lock();
 		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
-	else
+		rcu_read_unlock();
+	} else {
 		sskey = cred->user->session_keyring->serial;
+	}
 
 	sprintf(keyring_str[2], "%d", sskey);
 

