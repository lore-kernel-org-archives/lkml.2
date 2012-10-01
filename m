Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab2JAXY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:24:27 -0400
Received: from 1wt.eu ([62.212.114.60]:35328 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871Ab2JAXBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:17 -0400
Message-Id: <20121001225159.902084886@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 054/180] cred: copy_process() should clear child->replacement_session_keyring
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 79549c6dfda0603dba9a70a53467ce62d9335c33 upstream

keyctl_session_to_parent(task) sets ->replacement_session_keyring,
it should be processed and cleared by key_replace_session_keyring().

However, this task can fork before it notices TIF_NOTIFY_RESUME and
the new child gets the bogus ->replacement_session_keyring copied by
dup_task_struct(). This is obviously wrong and, if nothing else, this
leads to put_cred(already_freed_cred).

change copy_creds() to clear this member. If copy_process() fails
before this point the wrong ->replacement_session_keyring doesn't
matter, exit_creds() won't be called.

Cc: <stable@vger.kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/cred.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 0b5b5fc..9c06d10 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -443,6 +443,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 
 	mutex_init(&p->cred_guard_mutex);
 
+	p->replacement_session_keyring = NULL;
+
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
-- 
1.7.2.1.45.g54fbc



