Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab0D3RRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab0D3RRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:17:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/7] KEYS: call_sbin_request_key() must write lock keyrings
	before modifying them
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 30 Apr 2010 14:32:23 +0100
Message-ID: <20100430133223.2126.77304.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_sbin_request_key() creates a keyring and then attempts to insert a link to
the authorisation key into that keyring, but does so without holding a write
lock on the keyring semaphore.

It will normally get away with this because it hasn't told anyone that the
keyring exists yet.  The new keyring, however, has had its serial number
published, which means it can be accessed directly by that handle.

This was found by a previous patch that adds RCU lockdep checks to the code
that reads the keyring payload pointer, which includes a check that the keyring
semaphore is actually locked.

Without this patch, the following command:

	keyctl request2 user b a @s

will provoke the following lockdep warning is displayed in dmesg:

	===================================================
	[ INFO: suspicious rcu_dereference_check() usage. ]
	---------------------------------------------------
	security/keys/keyring.c:727 invoked rcu_dereference_check() without protection!

	other info that might help us debug this:


	rcu_scheduler_active = 1, debug_locks = 0
	2 locks held by keyctl/2076:
	 #0:  (key_types_sem){.+.+.+}, at: [<ffffffff811a5b29>] key_type_lookup+0x1c/0x71
	 #1:  (keyring_serialise_link_sem){+.+.+.}, at: [<ffffffff811a6d1e>] __key_link+0x4d/0x3c5

	stack backtrace:
	Pid: 2076, comm: keyctl Not tainted 2.6.34-rc6-cachefs #54
	Call Trace:
	 [<ffffffff81051fdc>] lockdep_rcu_dereference+0xaa/0xb2
	 [<ffffffff811a6d1e>] ? __key_link+0x4d/0x3c5
	 [<ffffffff811a6e6f>] __key_link+0x19e/0x3c5
	 [<ffffffff811a5952>] ? __key_instantiate_and_link+0xb1/0xdc
	 [<ffffffff811a59bf>] ? key_instantiate_and_link+0x42/0x5f
	 [<ffffffff811aa0dc>] call_sbin_request_key+0xe7/0x33b
	 [<ffffffff8139376a>] ? mutex_unlock+0x9/0xb
	 [<ffffffff811a5952>] ? __key_instantiate_and_link+0xb1/0xdc
	 [<ffffffff811a59bf>] ? key_instantiate_and_link+0x42/0x5f
	 [<ffffffff811aa6fa>] ? request_key_auth_new+0x1c2/0x23c
	 [<ffffffff810aaf15>] ? cache_alloc_debugcheck_after+0x108/0x173
	 [<ffffffff811a9d00>] ? request_key_and_link+0x146/0x300
	 [<ffffffff810ac568>] ? kmem_cache_alloc+0xe1/0x118
	 [<ffffffff811a9e45>] request_key_and_link+0x28b/0x300
	 [<ffffffff811a89ac>] sys_request_key+0xf7/0x14a
	 [<ffffffff81052c0b>] ? trace_hardirqs_on_caller+0x10c/0x130
	 [<ffffffff81394fb9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
	 [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/request_key.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index d737cea..d8c1a6a 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -94,7 +94,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	}
 
 	/* attach the auth key to the session keyring */
-	ret = __key_link(keyring, authkey);
+	ret = key_link(keyring, authkey);
 	if (ret < 0)
 		goto error_link;
 

