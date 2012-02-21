Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2BUUDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:03:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2BUUDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:03:19 -0500
Date: Tue, 21 Feb 2012 15:03:01 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Message-Id: <7498e58e8b366e7bf1b15e9b6365813d11eda17a.1329851692.git.jbaron@redhat.com>
In-Reply-To: <cover.1329851692.git.jbaron@redhat.com>
References: <cover.1329851692.git.jbaron@redhat.com>
Subject: [PATCH 03/10] jump label: introduce very_unlikely()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'static_branch()' construct can be thought of as stronger
form of 'unlikely()'. Thus, let's rename 'static_branch()' ->
'very_unlikely()'. Leave around 'static_branch()' for a while
until all users are converted, but mark it as deprecated.

It would be nice to locate 'very_unlikely()' in include/linux/compiler.h,
where 'unlikely()' is defined, but I'm afraid there are too
many additional headers that I'd have to pull into compiler.h.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index f7c6958..563c781 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -72,6 +72,12 @@ struct module;
 #define JUMP_LABEL_INIT {ATOMIC_INIT(0), NULL}
 #endif
 
+static __always_inline bool very_unlikely(struct jump_label_key *key)
+{
+	return arch_static_branch(key);
+}
+
+/* Deprecated. Please use 'very_unlikely() instead. */
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	return arch_static_branch(key);
@@ -114,6 +120,14 @@ struct jump_label_key_deferred {
 	struct jump_label_key  key;
 };
 
+static __always_inline bool very_unlikely(struct jump_label_key *key)
+{
+	if (unlikely(atomic_read(&key->enabled)))
+		return true;
+	return false;
+}
+
+/* Deprecated. Please use 'very_unlikely() instead. */
 static __always_inline bool static_branch(struct jump_label_key *key)
 {
 	if (unlikely(atomic_read(&key->enabled)))
-- 
1.7.7.5

