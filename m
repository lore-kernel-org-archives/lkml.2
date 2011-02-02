Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1BBAob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:49364 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1BBAoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960701"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eparis@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [82/139] inotify: stop kernel memory leak on file creation failure
Message-Id: <20110202004439.984513E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Paris <eparis@redhat.com>

commit a2ae4cc9a16e211c8a128ba10d22a85431f093ab upstream.

If inotify_init is unable to allocate a new file for the new inotify
group we leak the new group.  This patch drops the reference on the
group on file allocation failure.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/notify/inotify/inotify_user.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.35.y.orig/fs/notify/inotify/inotify_user.c
+++ linux-2.6.35.y/fs/notify/inotify/inotify_user.c
@@ -674,6 +674,7 @@ SYSCALL_DEFINE1(inotify_init1, int, flag
 	if (ret >= 0)
 		return ret;
 
+	fsnotify_put_group(group);
 	atomic_dec(&user->inotify_devs);
 out_free_uid:
 	free_uid(user);
