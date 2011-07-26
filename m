Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1GZI6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 04:58:13 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:58908 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1GZI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 04:58:08 -0400
Date: Tue, 26 Jul 2011 10:58:04 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [git pull] vfs pile 1.5
Message-ID: <20110726085804.GA1639@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
 <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de>
 <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.07.26 at 16:52 +0800, Steven Liu wrote:
> 2011/7/26 Markus Trippelsdorf <markus@trippelsdorf.de>:
> > On 2011.07.25 at 21:52 -0700, Linus Torvalds wrote:
> >> On Mon, Jul 25, 2011 at 8:35 PM, Markus Trippelsdorf
> >> <markus@trippelsdorf.de> wrote:
> >> >
> >> > This breaks the build for "# CONFIG_FS_POSIX_ACL is not set" configs:
> >>
> >> Of course it does. And as usual, my exhaustive testing was for the
> >> allyesconfig case, rather than doing both allyesconfig and allnoconfig
> >> like I should.
> >>
> >> Bah.
> >>
> >> Does the attached trivial patch fix everything for you?
> >
> > Yes, thanks.
> >
> > But now xfs fails to build when CONFIG_FS_POSIX_ACL is not set:
> >
> >  CC      fs/xfs/linux-2.6/xfs_xattr.o
> > fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: ‘xfs_get_acl’ undeclared here (not in a function)
> 
> maybe some one have not use #ifdef CONFIG_FS_POSIX_ACL
> with  fs/xfs/linux-2.6/xfs_iops.c:1025:14

#ifdefs are ugly. The following fixes the issue for me:

diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 2c656ef..39632d9 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -51,7 +51,10 @@ extern int posix_acl_default_exists(struct inode *inode);
 extern const struct xattr_handler xfs_xattr_acl_access_handler;
 extern const struct xattr_handler xfs_xattr_acl_default_handler;
 #else
-# define xfs_get_acl(inode, type)			NULL
+static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
+{
+	return NULL;
+}
 # define xfs_inherit_acl(inode, default_acl)		0
 # define xfs_acl_chmod(inode)				0
 # define posix_acl_access_exists(inode)			0

-- 
Markus
