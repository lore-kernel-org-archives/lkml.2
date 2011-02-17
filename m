Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1BRAiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:38:21 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46651 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab1BRAiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:38:11 -0500
From: Matt Helsley <matthltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Helsley <matthltc@us.ibm.com>, David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org
Subject: [PATCH] Reduce uidhash lock hold time when lookup succeeds
Date: Thu, 17 Feb 2011 15:52:53 -0800
Message-Id: <caebc7ebaa97599ef72b22d1172dfd2ebe770fce.1297986770.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When lookup succeeds we don't need the "new" user struct which hasn't
been linked into the uidhash. So we can immediately drop the lock and
then free "new" rather than free it with the lock held.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org
---
 kernel/user.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 5c598ca..4ea8e58 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -157,16 +157,18 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 		 */
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
-		if (up) {
+		if (!up) {
+			uid_hash_insert(new, hashent);
+			up = new;
+		}
+		spin_unlock_irq(&uidhash_lock);
+
+		if (up != new) {
 			put_user_ns(ns);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
-		} else {
-			uid_hash_insert(new, hashent);
-			up = new;
 		}
-		spin_unlock_irq(&uidhash_lock);
 	}
 
 	return up;
-- 
1.6.3.3

