Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2HAQKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:10:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab2HAQKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:10:18 -0400
Message-ID: <1343837499.18359.7.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: Oops in audit_copy_inode
From: Miklos Szeredi <mszeredi@suse.cz>
To: Peter Moody <pmoody@google.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>,
        viro@zeniv.linux.org.uk, Eric Paris <eparis@redhat.com>,
        miklos@szeredi.hu
Date: Wed, 01 Aug 2012 18:11:39 +0200
In-Reply-To: <CALnj_=5qfAxtKN_T+eoAPCswZPrWmKmOK5HSTwCNZV0s08f_qw@mail.gmail.com>
References: <CALnj_=4r0qdrNUbXmS=q=sk11PZ-Q0z=wPO5wR_DzR4HjnMdqw@mail.gmail.com>
	 <CALnj_=5qfAxtKN_T+eoAPCswZPrWmKmOK5HSTwCNZV0s08f_qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for the report.

Here's a patch.  I haven't tested it but I'm pretty confident that it
fixes the bug.

Thanks,
Miklos


Subject: vfs: fix audit_inode on negative dentry
From: Miklos Szeredi <mszeredi@suse.cz>

Peter Moody reported an oops in audit_copy_inode() and bisected it to commit
7157486541 (vfs: do_last(): common slow lookup).

The problem is that audit_inode() in do_last() is called with a negative dentry.

Previously the non-O_CREAT case didn't call audit_inode() here, but now both
O_CREAT and non-O_CREAT opens are handled by the same code.

I really have no idea why this audit_inode() is needed here at all but am afaid
to remove this for fear of breaking audit somehow.  So just fix this case by
checking for a negative dentry.

Reported-by: Peter Moody <pmoody@google.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@vger.kernel.org
---
 fs/namei.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2012-08-01 17:47:28.000000000 +0200
+++ linux-2.6/fs/namei.c	2012-08-01 17:49:26.000000000 +0200
@@ -2607,10 +2607,12 @@ static int do_last(struct nameidata *nd,
 		goto finish_open_created;
 	}
 
-	/*
-	 * It already exists.
-	 */
-	audit_inode(pathname, path->dentry);
+	if (path->dentry->d_inode) {
+		/*
+		 * It already exists.
+		 */
+		audit_inode(pathname, path->dentry);
+	}
 
 	/*
 	 * If atomic_open() acquired write access it is dropped now due to


