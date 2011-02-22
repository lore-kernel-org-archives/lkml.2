Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1BVWd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:33:27 -0500
Received: from kroah.org ([198.145.64.141]:46681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab1BVWVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221839.479261714@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Howells <dhowells@redhat.com>
Subject: [24/70] CRED: Fix kernel panic upon security_file_alloc() failure.
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 78d2978874e4e10e97dfd4fd79db45bdc0748550 upstream.

In get_empty_filp() since 2.6.29, file_free(f) is called with f->f_cred == NULL
when security_file_alloc() returned an error.  As a result, kernel will panic()
due to put_cred(NULL) call within RCU callback.

Fix this bug by assigning f->f_cred before calling security_file_alloc().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


