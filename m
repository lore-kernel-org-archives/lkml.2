Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1ALO0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:26:10 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36681 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab1ALO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:26:08 -0500
To: Nick Piggin <npiggin@gmail.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <AANLkTik-=LqSHQ=7zDznx9oCJFViPpp406Yz7J5Z-quj@mail.gmail.com>
	(message from Nick Piggin on Wed, 12 Jan 2011 15:37:32 +1100)
Subject: Re: [PATCH] fuse: make fuse_permission() RCU aware
References: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu> <AANLkTik-=LqSHQ=7zDznx9oCJFViPpp406Yz7J5Z-quj@mail.gmail.com>
Message-Id: <E1Pd1eC-0001hR-LW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 12 Jan 2011 15:26:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Nick Piggin wrote:
> On Tue, Jan 11, 2011 at 11:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > Only bail out of fuse_permission() on IPERM_FLAG_RCU when it is
> > actually necessary.
> 
> Great, thanks for taking a look... How about d_revalidate?

Yeah, here's the patch

Do you want to collect these patches from fs maintainers, or should I
submit to Linus directly?

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@suse.cz>
Subject: fuse: make fuse_dentry_revalidate() RCU aware

Only bail out of fuse_dentry_revalidate() on LOOKUP_RCU when blocking
is actually necessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2011-01-12 13:06:04.000000000 +0100
+++ linux-2.6/fs/fuse/dir.c	2011-01-12 13:07:30.000000000 +0100
@@ -158,9 +158,6 @@ static int fuse_dentry_revalidate(struct
 {
 	struct inode *inode;
 
-	if (nd->flags & LOOKUP_RCU)
-		return -ECHILD;
-
 	inode = entry->d_inode;
 	if (inode && is_bad_inode(inode))
 		return 0;
@@ -177,6 +174,9 @@ static int fuse_dentry_revalidate(struct
 		if (!inode)
 			return 0;
 
+		if (nd->flags & LOOKUP_RCU)
+			return -ECHILD;
+
 		fc = get_fuse_conn(inode);
 		req = fuse_get_req(fc);
 		if (IS_ERR(req))
