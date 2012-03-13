Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab2CMSW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab2CMSWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:22:23 -0400
Date: Tue, 13 Mar 2012 14:22:20 -0400
From: Dave Jones <davej@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120313182220.GA11500@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, viro@zeniv.linux.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This size is user controllable, and so it's trivial for someone to trigger a
stream of order:4 page allocation errors.

Signed-off-by: Dave Jones <davej@redhat.com>

--- 
There's also a similar problem in setxattr, but I'm not sure how we want
to pass NOWARN down to memdup_user. Thoughts ?

diff --git a/fs/xattr.c b/fs/xattr.c
index 82f4337..544df90 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -496,7 +496,7 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
-		klist = kmalloc(size, GFP_KERNEL);
+		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
 		if (!klist)
 			return -ENOMEM;
 	}
