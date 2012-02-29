Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030944Ab2B2KR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:17:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030771Ab2B2KR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:17:57 -0500
Date: Wed, 29 Feb 2012 02:17:21 -0800
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-8eedce996556d7d06522cd3a0e6069141c8dffe0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <201202281849.q1SIn1p2023270@int-mx10.intmail.prod.int.phx2.redhat.com>
References: <201202281849.q1SIn1p2023270@int-mx10.intmail.prod.int.phx2.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] static keys: Inline the static_key_enabled()
  function
Git-Commit-ID: 8eedce996556d7d06522cd3a0e6069141c8dffe0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 29 Feb 2012 02:17:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eedce996556d7d06522cd3a0e6069141c8dffe0
Gitweb:     http://git.kernel.org/tip/8eedce996556d7d06522cd3a0e6069141c8dffe0
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Tue, 28 Feb 2012 13:49:01 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Feb 2012 20:01:08 +0100

static keys: Inline the static_key_enabled() function

In the jump label enabled case, calling static_key_enabled()
results in a function call. The function returns the results of
a compare, so it really doesn't need the overhead of a full
function call. Let's make it 'static inline' for both the jump
label enabled and disabled cases.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/201202281849.q1SIn1p2023270@int-mx10.intmail.prod.int.phx2.redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
