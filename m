Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1LFUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:16:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1LFUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:16:56 -0500
Date: Tue, 6 Dec 2011 12:16:30 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-p40e3yj21b68y03z1yv825e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, jbaron@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label: Provide jump_label_key initializers
Git-Commit-ID: ac99b862fb98a36929831791da31714f709c2aa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:16:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac99b862fb98a36929831791da31714f709c2aa8
Gitweb:     http://git.kernel.org/tip/ac99b862fb98a36929831791da31714f709c2aa8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 6 Jul 2011 14:20:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:41:03 +0100

jump_label: Provide jump_label_key initializers

Provide two initializers for jump_label_key that initialize it enabled
or disabled. Also modify all jump_label code to allow for jump_labels to be
initialized enabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jason Baron <jbaron@redhat.com>
Link: http://lkml.kernel.org/n/tip-p40e3yj21b68y03z1yv825e7@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/jump_label.h |    3 +++
 kernel/jump_label.c        |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index a1e7f90..5ce8b14 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -128,4 +128,7 @@ static inline void jump_label_rate_limit(struct jump_label_key_deferred *key,
 }
 #endif	/* HAVE_JUMP_LABEL */
 
+#define jump_label_key_enabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(1), })
+#define jump_label_key_disabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(0), })
+
 #endif	/* _LINUX_JUMP_LABEL_H */
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 3fb7b79..30c3c77 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -248,8 +248,13 @@ void jump_label_apply_nops(struct module *mod)
 	if (iter_start == iter_stop)
 		return;
 
-	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
+				JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+	}
 }
 
 static int jump_label_add_module(struct module *mod)
@@ -289,8 +294,7 @@ static int jump_label_add_module(struct module *mod)
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, iter_stop,
-					    JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
 	}
 
 	return 0;
