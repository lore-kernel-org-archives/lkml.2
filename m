Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab2DKXSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:18:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010Ab2DKXSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:25 -0400
Message-Id: <20120411231031.614375136@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: [ 78/78] cred: copy_process() should clear child->replacement_session_keyring
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 79549c6dfda0603dba9a70a53467ce62d9335c33 upstream.

keyctl_session_to_parent(task) sets ->replacement_session_keyring,
it should be processed and cleared by key_replace_session_keyring().

However, this task can fork before it notices TIF_NOTIFY_RESUME and
the new child gets the bogus ->replacement_session_keyring copied by
dup_task_struct(). This is obviously wrong and, if nothing else, this
leads to put_cred(already_freed_cred).

change copy_creds() to clear this member. If copy_process() fails
before this point the wrong ->replacement_session_keyring doesn't
matter, exit_creds() won't be called.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cred.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -385,6 +385,8 @@ int copy_creds(struct task_struct *p, un
 	struct cred *new;
 	int ret;
 
+	p->replacement_session_keyring = NULL;
+
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&


