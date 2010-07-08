Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0GHKmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:42:44 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59862 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0GHKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:42:42 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 04/11] vfs: Allow handle based open on symlinks
In-Reply-To: <20100707164859.GB9263@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100707164859.GB9263@laptop>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 08 Jul 2010 16:12:36 +0530
Message-ID: <87tyoadzkz.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 02:48:59 +1000, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Jun 15, 2010 at 10:42:54PM +0530, Aneesh Kumar K.V wrote:
> > The patch update may_open to allow handle based open on symlinks.
> > The file handle based API use file descritor returned from open_by_handle_at
> > to do different file system operations. To find the link target name we
> > need to get a file descriptor on symlinks.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/namei.c |   17 ++++++++++++++---
> >  1 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index c2d19c7..417bf53 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1422,7 +1422,7 @@ int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
> >  	return error;
> >  }
> >  
> > -int may_open(struct path *path, int acc_mode, int flag)
> > +static int __may_open(struct path *path, int acc_mode, int flag, int handle)
> >  {
> >  	struct dentry *dentry = path->dentry;
> >  	struct inode *inode = dentry->d_inode;
> > @@ -1433,7 +1433,13 @@ int may_open(struct path *path, int acc_mode, int flag)
> >  
> >  	switch (inode->i_mode & S_IFMT) {
> >  	case S_IFLNK:
> > -		return -ELOOP;
> > +		/*
> > +		 * For file handle based open we should allow
> > +		 * open of symlink.
> > +		 */
> > +		if (!handle)
> > +			return -ELOOP;
> > +		break;
> >  	case S_IFDIR:
> >  		if (acc_mode & MAY_WRITE)
> >  			return -EISDIR;
> > @@ -1473,6 +1479,11 @@ int may_open(struct path *path, int acc_mode, int flag)
> >  	return break_lease(inode, flag);
> >  }
> >  
> > +int may_open(struct path *path, int acc_mode, int flag)
> > +{
> > +	return __may_open(path, acc_mode, flag, 0);
> > +}
> 
> Why don't you just add MAY_OPEN_LNK instead of this ugliness?
> 

Something like the below ?

commit 69787f5ed6c8a7a63ad21ef5d7de0b62f124ff0a
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Jul 6 23:25:57 2010 +0530

    vfs: Allow handle based open on symlinks
    
    The patch update may_open to allow handle based open on symlinks.
    The file handle based API use file descritor returned from open_by_handle_at
    to do different file system operations. To find the link target name we
    need to get a file descriptor on symlinks.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/namei.c b/fs/namei.c
index de40312..2ea5c79 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1456,7 +1456,15 @@ int may_open(struct path *path, int acc_mode, int flag)
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFLNK:
-		return -ELOOP;
+		/*
+		 * Allow only if acc_mode contain
+		 * open link request and read request.
+		 */
+		if (acc_mode != (MAY_OPEN_LINK | MAY_READ))
+			return -ELOOP;
+		if (flag != O_RDONLY)
+			return -ELOOP;
+		break;
 	case S_IFDIR:
 		if (acc_mode & MAY_WRITE)
 			return -EISDIR;
diff --git a/fs/open.c b/fs/open.c
index daf2534..a58837a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1266,8 +1266,15 @@ static long do_sys_open_by_handle(int mountdirfd,
 	 */
 	if (open_flag & __O_SYNC)
 		open_flag |= O_DSYNC;
+	/*
+	 * Handle based API allow open on a symlink
+	 */
+	if (S_ISLNK(path->dentry->d_inode->i_mode))
+		acc_mode = MAY_OPEN_LINK;
+	else
+		acc_mode = MAY_OPEN;
 
-	acc_mode = MAY_OPEN | ACC_MODE(open_flag);
+	acc_mode |= ACC_MODE(open_flag);
 
 	/* O_TRUNC implies we need access checks for write permissions */
 	if (open_flag & O_TRUNC)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cbff4ca..eaf13d1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -53,6 +53,7 @@ struct inodes_stat_t {
 #define MAY_APPEND 8
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
+#define MAY_OPEN_LINK 64
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
