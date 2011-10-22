Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1JVILH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 04:11:07 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:35303
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab1JVILG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 04:11:06 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 04:11:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAEt3ok7LO9hf/2dsb2JhbABChHWkLIEFghgEUigNAhgOAkkWE6kfkUSBMIV8gRQEiASRUIMeiH8
X-IronPort-AV: E=Sophos;i="4.69,390,1315152000"; 
   d="scan'208";a="734556596"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] vfs - fix automount should ignore LOOKUP_FOLLOW
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 22 Oct 2011 16:01:47 +0800
Message-ID: <20111022080147.11165.52913.stgit@perseus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent patch by Miklos Szeredi that was meant to restore the original
behavior of not triggering automounts on stat(2) and other symlink following
syscalls also eliminated the unconditional triggering of automounts for
intermediate path components by eliminating the LOOKUP_CONTUNUE flag from
the check in fs/namei.c:follow_automount().

This introduces a regression itself because it alters the original behaviour
which was to unconditionally automount on intermediate path components.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0b3138d..e4eee7c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -732,7 +732,7 @@ static int follow_automount(struct path *path, unsigned flags,
 	 * as being automount points.  These will need the attentions
 	 * of the daemon to instantiate them before they can be used.
 	 */
-	if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
+	if (!(flags & (LOOKUP_PARENT | LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
 		     LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
 	    path->dentry->d_inode)
 		return -EISDIR;

