Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2CaTm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:42:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53780 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2CaTm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:42:56 -0400
Date: Sat, 31 Mar 2012 20:42:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs part 2
Message-ID: <20120331194255.GY6589@ZenIV.linux.org.uk>
References: <20120331051906.GU6589@ZenIV.linux.org.uk>
 <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
 <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com>
 <20120331185738.GW6589@ZenIV.linux.org.uk>
 <CA+55aFxtN9j5j6XC9nDf+mNJ06ipgD4cbW6hrZw6+3KfvDSuww@mail.gmail.com>
 <20120331193913.GX6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331193913.GX6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 08:39:13PM +0100, Al Viro wrote:
> On Sat, Mar 31, 2012 at 12:29:41PM -0700, Linus Torvalds wrote:
> > On Sat, Mar 31, 2012 at 11:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Works here... ?OK, that makes selinuxfs one the most likely suspect; let
> > > me check if I can reproduce any crap with that... ?Do you see anything
> > > selinux-related in the call chain, BTW?
> > 
> > Yup.The oops scrolled off my screen, but the call chain was:
> > 
> >  init_sel_fs -> kernel_mount_data -> vfs_kern_mount -> mount_fs ->
> > sel_mount -> mount_single -> (scrolled off)
> > 
> > and then the actual oops happens in d_alloc+0x17, which is
> > "parent->d_sb", so parent was NULL or something (the register state
> > also scrolled off, and I didn't check the fault address, so it could
> > have been some other invalid pointer too).
> 
> Sigh...  sel_make_dir(), last line.  Should be return dentry, is return 0...
> Fixes the problem here (I've managed to reproduce it).

IOW, the incremental is

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 364b784..d7018bf 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1804,7 +1804,7 @@ static struct dentry *sel_make_dir(struct dentry *dir, const char *name,
 	/* bump link count on parent directory, too */
 	inc_nlink(dir->d_inode);
 
-	return 0;
+	return dentry;
 }
 
 static int sel_fill_super(struct super_block *sb, void *data, int silent)
