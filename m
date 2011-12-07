Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab1LGQ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:29:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab1LGQZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:23 2011
Message-Id: <20111207161223.068872369@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:43 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Baron <jbaron@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [101/104] jump_label: jump_label_inc may return before the code is patched
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit bbbf7af4bf8fc69bc751818cf30521080fa47dcb upstream.

If cpu A calls jump_label_inc() just after atomic_add_return() is
called by cpu B, atomic_inc_not_zero() will return value greater then
zero and jump_label_inc() will return to a caller before jump_label_update()
finishes its job on cpu B.

Link: http://lkml.kernel.org/r/20111018175551.GH17571@redhat.com

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/jump_label.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_ke
 		return;
 
 	jump_label_lock();
-	if (atomic_add_return(1, &key->enabled) == 1)
+	if (atomic_read(&key->enabled) == 0)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
+	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
 


