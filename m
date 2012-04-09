Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab2DITEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:04:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab2DITEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:04:12 -0400
Date: Mon, 9 Apr 2012 21:03:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/1] cred: copy_process() should clear
	child->replacement_session_keyring
Message-ID: <20120409190350.GA14716@redhat.com>
References: <20120409190323.GA14712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409190323.GA14712@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/cred.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 97b36ee..e70683d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -386,6 +386,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	struct cred *new;
 	int ret;
 
+	p->replacement_session_keyring = NULL;
+
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
-- 
1.5.5.1


