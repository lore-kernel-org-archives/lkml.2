Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab2ASFcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 00:32:33 -0500
Received: from tundra.namei.org ([65.99.196.166]:36170 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab2ASFcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 00:32:31 -0500
Date: Thu, 19 Jan 2012 16:32:28 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] More security subsystem fixes 
Message-ID: <alpine.LRH.2.00.1201191631040.31730@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull these fixes for 3.3.


The following changes since commit f59e842fc0871cd5baa213dc32e0ce8e5aaf4758:
  Linus Torvalds (1):
        Merge branch 'for-next-merge' of git://git.kernel.org/.../nab/target-pending

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

David Howells (2):
      MPILIB: Add a missing ENOMEM check
      KEYS: Permit key_serial() to be called with a const key pointer

Mimi Zohar (2):
      ima: fix cred sparse warning
      keys: fix user_defined key sparse messages

 include/linux/key.h                 |    2 +-
 lib/mpi/mpicoder.c                  |    2 ++
 security/integrity/ima/ima_policy.c |    3 ++-
 security/keys/user_defined.c        |    6 +++---
 4 files changed, 8 insertions(+), 5 deletions(-)

---

commit 456a8167e94b66f406c27400a46a707b870452b0
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jan 18 10:04:29 2012 +0000

    KEYS: Permit key_serial() to be called with a const key pointer
    
    Permit key_serial() to be called with a const key pointer.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/include/linux/key.h b/include/linux/key.h
index bfc014c..5253471 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -271,7 +271,7 @@ extern int keyring_add_key(struct key *keyring,
 
 extern struct key *key_lookup(key_serial_t id);
 
-static inline key_serial_t key_serial(struct key *key)
+static inline key_serial_t key_serial(const struct key *key)
 {
 	return key ? key->serial : 0;
 }

commit f6b24579d099ebb67f39cd7924a72a7eec0ce6ae
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Wed Jan 18 10:03:14 2012 +0000

    keys: fix user_defined key sparse messages
    
    Replace the rcu_assign_pointer() calls with rcu_assign_keypointer().
    
    Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 69ff52c..2aee3c5 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -59,7 +59,7 @@ int user_instantiate(struct key *key, const void *data, size_t datalen)
 	/* attach the data */
 	upayload->datalen = datalen;
 	memcpy(upayload->data, data, datalen);
-	rcu_assign_pointer(key->payload.data, upayload);
+	rcu_assign_keypointer(key, upayload);
 	ret = 0;
 
 error:
@@ -98,7 +98,7 @@ int user_update(struct key *key, const void *data, size_t datalen)
 	if (ret == 0) {
 		/* attach the new data, displacing the old */
 		zap = key->payload.data;
-		rcu_assign_pointer(key->payload.data, upayload);
+		rcu_assign_keypointer(key, upayload);
 		key->expiry = 0;
 	}
 
@@ -133,7 +133,7 @@ void user_revoke(struct key *key)
 	key_payload_reserve(key, 0);
 
 	if (upayload) {
-		rcu_assign_pointer(key->payload.data, NULL);
+		rcu_assign_keypointer(key, NULL);
 		kfree_rcu(upayload, rcu);
 	}
 }

commit 3db59dd93309710c40aaf1571c607cb0feef3ecb
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Tue Jan 17 22:11:28 2012 -0500

    ima: fix cred sparse warning
    
    Fix ima_policy.c sparse "warning: dereference of noderef expression"
    message, by accessing cred->uid using current_cred().
    
    Changelog v1:
    - Change __cred to just cred (based on David Howell's comment)
    
    Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d661afb..d45061d 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -99,6 +99,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 			    struct inode *inode, enum ima_hooks func, int mask)
 {
 	struct task_struct *tsk = current;
+	const struct cred *cred = current_cred();
 	int i;
 
 	if ((rule->flags & IMA_FUNC) && rule->func != func)
@@ -108,7 +109,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
-	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
+	if ((rule->flags & IMA_UID) && rule->uid != cred->uid)
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc = 0;

commit 4bf1924c008dffdc154f82507b4052e49263a6f4
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jan 18 10:03:54 2012 +0000

    MPILIB: Add a missing ENOMEM check
    
    Add a missing ENOMEM check.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Acked-by: Mimi Zohar <zohar@us.ibm.com>
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index fe84bb9..716802b 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -255,6 +255,8 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 	if (!n)
 		n++;		/* avoid zero length allocation */
 	p = buffer = kmalloc(n, GFP_KERNEL);
+	if (!p)
+		return NULL;
 
 	for (i = a->nlimbs - 1; i >= 0; i--) {
 		alimb = a->d[i];
