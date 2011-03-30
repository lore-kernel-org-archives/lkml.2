Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418Ab1C3Vps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:45:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:23361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964847Ab1C3VHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237281"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: penguin-kernel@i-love.sakura.ne.jp, penguin-kernel@i-love.sakura.ne.jp,
        dhowells@redhat.com, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [119/275] CRED: Fix kernel panic upon security_file_alloc() failure.
Message-Id: <20110330210558.F27273E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/file_table.c
===================================================================
--- linux-2.6.35.y.orig/fs/file_table.c	2011-03-29 22:51:20.759191992 -0700
+++ linux-2.6.35.y/fs/file_table.c	2011-03-29 23:03:00.692282457 -0700
@@ -123,13 +123,13 @@
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
