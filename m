Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1CREJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:09:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56635 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1CREJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:09:26 -0400
Message-ID: <4D82DB5B.9000302@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:11:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/36] security,rcu: convert call_rcu(user_update_rcu_disposal)
 to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:07:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:07:59,
	Serialize complete at 2011-03-18 12:07:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback user_update_rcu_disposal() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(user_update_rcu_disposal).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 security/keys/user_defined.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 02807fb..71e538a 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -69,18 +69,6 @@ error:
 EXPORT_SYMBOL_GPL(user_instantiate);
 
 /*
- * dispose of the old data from an updated user defined key
- */
-static void user_update_rcu_disposal(struct rcu_head *rcu)
-{
-	struct user_key_payload *upayload;
-
-	upayload = container_of(rcu, struct user_key_payload, rcu);
-
-	kfree(upayload);
-}
-
-/*
  * update a user defined key
  * - the key's semaphore is write-locked
  */
@@ -114,7 +102,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 		key->expiry = 0;
 	}
 
-	call_rcu(&zap->rcu, user_update_rcu_disposal);
+	kfree_rcu(zap, rcu);
 
 error:
 	return ret;
@@ -145,7 +133,7 @@ void user_revoke(struct key *key)
 
 	if (upayload) {
 		rcu_assign_pointer(key->payload.data, NULL);
-		call_rcu(&upayload->rcu, user_update_rcu_disposal);
+		kfree_rcu(upayload, rcu);
 	}
 }
 
-- 
1.7.4
