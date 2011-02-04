Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1BDSNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:13:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1BDSNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:13:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Fix kernel panic upon security_file_alloc() failure.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Howells <dhowells@redhat.com>
Date: Fri, 04 Feb 2011 18:13:24 +0000
Message-ID: <20110204181324.15313.11611.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

In get_empty_filp() since 2.6.29, file_free(f) is called with f->f_cred == NULL
when security_file_alloc() returned an error.  As a result, kernel will panic()
due to put_cred(NULL) call within RCU callback.

Fix this bug by assigning f->f_cred before calling security_file_alloc().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/file_table.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index c3e89ad..eb36b6b 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -125,13 +125,13 @@ struct file *get_empty_filp(void)
 		goto fail;
 
 	percpu_counter_inc(&nr_files);
+	f->f_cred = get_cred(cred);
 	if (security_file_alloc(f))
 		goto fail_sec;
 
 	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
-	f->f_cred = get_cred(cred);
 	spin_lock_init(&f->f_lock);
 	eventpoll_init_file(f);
 	/* f->f_version: 0 */

