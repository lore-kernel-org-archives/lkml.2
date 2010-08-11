Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab0HKApH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 20:45:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45600 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0HKApF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 20:45:05 -0400
Date: Wed, 11 Aug 2010 10:45:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Sripathi Kodi <sripathik@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: remove inode_setattr
Message-Id: <20100811104503.4082f68f.sfr@canb.auug.org.au>
In-Reply-To: <20100811101751.1afdded8.sfr@canb.auug.org.au>
References: <201008101859.o7AIx9BM026915@hera.kernel.org>
	<20100810155011.b9657102.akpm@linux-foundation.org>
	<20100811101751.1afdded8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Wed, 11 Aug 2010 10:17:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Reported by me June 22 with a fixup, reminded Aug 4 and yesterday ... it
> needed to be fixed up by Linus when he merged Al's tree ...

I will apply this fix patch to linux-next today ... Al, Christoph, this
is the fix I sent out earlier.  Is it correct enough for Linus to apply
it?

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 22 Jun 2010 11:15:01 +1000
Subject: [PATCH] v9fs: fixup for inode_setattr being removed

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/9p/vfs_inode.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index f027a42..2ec7bfa 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1052,10 +1052,19 @@ static int v9fs_vfs_setattr_dotl(struct dentry *dentry, struct iattr *iattr)
 		return PTR_ERR(fid);
 
 	retval = p9_client_setattr(fid, &p9attr);
-	if (retval >= 0)
-		retval = inode_setattr(dentry->d_inode, iattr);
+	if (retval < 0)
+		return retval;
 
-	return retval;
+	if ((iattr->ia_valid & ATTR_SIZE) &&
+	    iattr->ia_size != i_size_read(dentry->d_inode)) {
+		retval = vmtruncate(dentry->d_inode, iattr->ia_size);
+		if (retval)
+			return retval;
+	}
+
+	setattr_copy(dentry->d_inode, iattr);
+	mark_inode_dirty(dentry->d_inode);
+	return 0;
 }
 
 /**
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
