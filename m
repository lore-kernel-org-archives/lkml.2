Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1AREPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:15:25 -0500
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:4817
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539Ab1AREPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:15:22 -0500
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 23:15:20 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALOgNE18qSwg/2dsb2JhbACEDKBKc7MsjwyBJIM4dASEbYlvgXI
X-IronPort-AV: E=Sophos;i="4.60,336,1291564800"; 
   d="scan'208";a="193590372"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/3] vfs - fix dentry ref count in do_lookup()
To: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 18 Jan 2011 12:06:10 +0800
Message-ID: <20110118040610.23109.32868.stgit@localhost6.localdomain6>
In-Reply-To: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a ref count problem in fs/namei.c:do_lookup().

When walking in ref-walk mode, if follow_managed() returns a fail the
reference held by path.dentry isn't dropped.
---

 fs/namei.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b753192..dbc36ff 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1272,8 +1272,11 @@ done:
 	path->mnt = mnt;
 	path->dentry = dentry;
 	err = follow_managed(path, nd->flags);
-	if (unlikely(err < 0))
+	if (unlikely(err < 0)) {
+		if (!(nd->flags & LOOKUP_RCU))
+			dput(dentry);
 		return err;
+	}
 	*inode = path->dentry->d_inode;
 	return 0;
 

