Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1AREPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:15:34 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:12899
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab1AREPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:15:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHagNE18qSwg/2dsb2JhbACEDKBKc7MvjwyBJIM4dASEbYlvgXI
X-IronPort-AV: E=Sophos;i="4.60,336,1291564800"; 
   d="scan'208";a="225425377"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/3] autofs4 - fix get_next_positive_dentry()
To: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 18 Jan 2011 12:06:04 +0800
Message-ID: <20110118040604.23109.71500.stgit@localhost6.localdomain6>
In-Reply-To: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization condition in fs/autofs4/expire.c:get_next_positive_dentry()
appears to be incorrect. If prev == NULL I believe that root should be
returned.

Further down, at the current dentry check for it being simple_positive()
it looks like the d_lock for dentry p should be dropped instead of dentry
ret, otherwise when p is assinged to ret we end up with no lock on p and
a lost lock on ret, which leads to a deadlock.
---

 fs/autofs4/expire.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 3ed79d7..f43100b 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -96,7 +96,7 @@ static struct dentry *get_next_positive_dentry(struct dentry *prev,
 	struct dentry *p, *ret;
 
 	if (prev == NULL)
-		return dget(prev);
+		return dget(root);
 
 	spin_lock(&autofs4_lock);
 relock:
@@ -133,7 +133,7 @@ again:
 	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
 	if (!simple_positive(ret)) {
-		spin_unlock(&ret->d_lock);
+		spin_unlock(&p->d_lock);
 		p = ret;
 		goto again;
 	}

