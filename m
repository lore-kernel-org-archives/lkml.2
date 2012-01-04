Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2ADPct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:32:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab2ADPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:32:48 -0500
Date: Wed, 4 Jan 2012 10:32:37 -0500
From: Jason Baron <jbaron@redhat.com>
Message-Id: <201201041532.q04FWbBl022103@int-mx10.intmail.prod.int.phx2.redhat.com>
To: gleb@redhat.com, rostedt@goodmis.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: [PATCH] jump label: close race in jump_label_inc() vs. jump_label_dec()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous fix to ensure that jump_label_inc() does not return until the jump
is completely patched, opened up a race in the inc/dec path. The scenario is:

key->enabled = 0;

	CPU 0					CPU 1
        ----- 					-----

jump_label_inc():			jump_label_dec():

1) if (atomic_read(&key->enabled) == 0)
	jump_label_update(key, JUMP_LABEL_ENABLE);

					 2) if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex))
					 	return;

3) atomic_inc(&key->enabled);

So now, key->enabled = 0, but the jump has been enabled, which is an invalid
state.

Fix this, by returning to the old, atomic inc/dec logic, but adding a check
to see if we are in the middle of an enabling operation, so that we
don't return early.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/jump_label.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 30c3c77..4ae9fa2 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -62,13 +62,22 @@ static void jump_label_update(struct jump_label_key *key, int enable);
 
 void jump_label_inc(struct jump_label_key *key)
 {
-	if (atomic_inc_not_zero(&key->enabled))
+	int not_zero;
+
+	not_zero = atomic_inc_not_zero(&key->enabled);
+	if (not_zero && !mutex_is_locked(&jump_label_mutex))
+		return;
+
+	if (not_zero) {
+		/* prevent from returning before we've switched the branch */
+		jump_label_lock();
+		jump_label_unlock();
 		return;
+	}
 
 	jump_label_lock();
-	if (atomic_read(&key->enabled) == 0)
+	if (atomic_add_return(1, &key->enabled) == 1)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
-	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
 
-- 
1.7.7.3

