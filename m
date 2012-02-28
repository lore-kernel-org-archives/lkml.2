Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966008Ab2B1StW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:49:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988Ab2B1StV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:49:21 -0500
Date: Tue, 28 Feb 2012 13:49:01 -0500
From: Jason Baron <jbaron@redhat.com>
Message-Id: <201202281849.q1SIn1p2023270@int-mx10.intmail.prod.int.phx2.redhat.com>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] jump label: Change static_key_enabled() function -> 'static inline'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the jump label enabled case, calling static_key_enabled() results in
a function call. The function returns the results of a compare, so it
really doesn't need the overhead of a full function call. Let's make
it 'static inline' for both the jump label enabled and disabled cases.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |   11 +++++------
 kernel/jump_label.c        |    6 ------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 2172da2..c513a40 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -127,7 +127,6 @@ extern int jump_label_text_reserved(void *start, void *end);
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
-extern bool static_key_enabled(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 extern void
 jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
@@ -198,11 +197,6 @@ static inline int jump_label_text_reserved(void *start, void *end)
 static inline void jump_label_lock(void) {}
 static inline void jump_label_unlock(void) {}
 
-static inline bool static_key_enabled(struct static_key *key)
-{
-	return (atomic_read(&key->enabled) > 0);
-}
-
 static inline int jump_label_apply_nops(struct module *mod)
 {
 	return 0;
@@ -224,4 +218,9 @@ jump_label_rate_limit(struct static_key_deferred *key,
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
 
+static inline bool static_key_enabled(struct static_key *key)
+{
+	return (atomic_read(&key->enabled) > 0);
+}
+
 #endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index bf9dcad..4304919 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -29,12 +29,6 @@ void jump_label_unlock(void)
 	mutex_unlock(&jump_label_mutex);
 }
 
-bool static_key_enabled(struct static_key *key)
-{
-	return (atomic_read(&key->enabled) > 0);
-}
-EXPORT_SYMBOL_GPL(static_key_enabled);
-
 static int jump_label_cmp(const void *a, const void *b)
 {
 	const struct jump_entry *jea = a;
-- 
1.7.7.6

