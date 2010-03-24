Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0CXJMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:12:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0CXJMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:12:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Don't need to use RCU in keyring_read() as semaphore is
	held
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 24 Mar 2010 09:10:39 +0000
Message-ID: <20100324091039.29436.17207.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keyring_read() doesn't need to use rcu_dereference() to access the keyring
payload as the caller holds the key semaphore to prevent modifications from
happening whilst the data is read out.

This should solve the following warning:

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
security/keys/keyring.c:204 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
1 lock held by keyctl/2144:
 #0:  (&key->sem){+++++.}, at: [<ffffffff81177f7c>] keyctl_read_key+0x9c/0xcf

stack backtrace:
Pid: 2144, comm: keyctl Not tainted 2.6.34-rc2-cachefs #113
Call Trace:
 [<ffffffff8105121f>] lockdep_rcu_dereference+0xaa/0xb2
 [<ffffffff811762d5>] keyring_read+0x4d/0xe7
 [<ffffffff81177f8c>] keyctl_read_key+0xac/0xcf
 [<ffffffff811788d4>] sys_keyctl+0x75/0xb9
 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 840be66..8fa2df0 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -201,7 +201,7 @@ static long keyring_read(const struct key *keyring,
 	int loop, ret;
 
 	ret = 0;
-	klist = rcu_dereference(keyring->payload.subscriptions);
+	klist = keyring->payload.subscriptions;
 
 	if (klist) {
 		/* calculate how much data we could return */

