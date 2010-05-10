Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0EJF2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:28:10 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:25034
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab0EJF2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:28:07 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 01:28:06 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOYz50vLzgH5/2dsb2JhbACDF5p9catMgwqMTYEmgwFuBINA
X-IronPort-AV: E=Sophos;i="4.52,359,1270396800"; 
   d="scan'208";a="553921811"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4-2.6.34-rc1 - fix link_count usage
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 10 May 2010 13:18:30 +0800
Message-ID: <20100510051830.10353.31165.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the commit below in 2.6.34-rc1 autofs direct mounts stop
working. This is caused by current->link_count being 0 when
->follow_link() is called from do_filp_open().

I can't work out why this hasn't been seen before Als patch series.

This patch removes the autofs dependence on current->link_count.

1f36f774b22a0ceb7dd33eca626746c81a97b6a5 is the first bad commit
commit 1f36f774b22a0ceb7dd33eca626746c81a97b6a5
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Dec 26 10:56:19 2009 -0500

    Switch !O_CREAT case to use of do_last()

    ... and now we have all intents crap well localized

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

:040000 040000 53c1effc5b22746bb83cdbc6a419bf898067882d 9606f7275fde188a056fd174aa1d622ac0630893 M	fs
---

 fs/autofs4/root.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 109a6c6..a7e04ad 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -177,8 +177,7 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 		}
 	/* Trigger mount for path component or follow link */
 	} else if (ino->flags & AUTOFS_INF_PENDING ||
-			autofs4_need_mount(flags) ||
-			current->link_count) {
+			autofs4_need_mount(flags)) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
 
@@ -262,7 +261,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 
-		status = try_to_fill_dentry(dentry, 0);
+		status = try_to_fill_dentry(dentry, lookup_type);
 		if (status)
 			goto out_error;
 

