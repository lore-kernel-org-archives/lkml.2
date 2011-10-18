Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1JRR4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:56:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JRR4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:56:04 -0400
Date: Tue, 18 Oct 2011 19:55:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] jump_label_inc may return before the code is patched
Message-ID: <20111018175551.GH17571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cpu A calls jump_label_inc() just after atomic_add_return() is
called by cpu B, atomic_inc_not_zero() will return value greater then
zero and jump_label_inc() will return to a caller before jump_label_update()
finishes its job on cpu B.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..e6f1f24 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
 		return;
 
 	jump_label_lock();
-	if (atomic_add_return(1, &key->enabled) == 1)
+	if (atomic_read(&key->enabled) == 0)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
+	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
 
--
			Gleb.
