Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2JRDlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:41:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41492 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2JRDlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:41:23 -0400
Date: Wed, 17 Oct 2012 20:41:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>
cc: Hugh Dickins <hughd@google.com>, Li Zefan <lizefan@huawei.com>,
        Aristeu Rozanski <aris@redhat.com>, Tejun Heo <tj@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch for-3.7] fs, xattr: fix bug when removing a name not in xattr
 list
In-Reply-To: <alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
References: <20121018024317.GA25407@localhost> <alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 38f38657444d ("xattr: extract simple_xattr code from tmpfs") moved
some code from tmpfs but introduced a subtle bug along the way.

If the name passed to simple_xattr_remove() does not exist in the list of
xattrs, then it is possible to call kfree(new_xattr) when new_xattr is
actually initialized to itself on the stack via uninitialized_var().

This causes a BUG() since the memory was not allocated via the slab
allocator and was not bypassed through to the page allocator because it
was too large.

Initialize the local variable to NULL so the kfree() never takes place.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -846,7 +846,7 @@ static int __simple_xattr_set(struct simple_xattrs *xattrs, const char *name,
 			      const void *value, size_t size, int flags)
 {
 	struct simple_xattr *xattr;
-	struct simple_xattr *uninitialized_var(new_xattr);
+	struct simple_xattr *new_xattr = NULL;
 	int err = 0;
 
 	/* value == NULL means remove */
