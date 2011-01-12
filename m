Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab1ALEQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:16:05 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40241 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932791Ab1ALEQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:16:02 -0500
X-Sasl-enc: EshH4J3opvJ0uxJsUlym38Mb4ujZFGPixKmFz99HOlN3 1294805761
Subject: Re: [announce] vfs-scale git tree update
From: Ian Kent <raven@themaw.net>
To: aelder@sgi.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1294804776.2821.4.camel@perseus>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink>  <1294804776.2821.4.camel@perseus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 12:15:55 +0800
Message-ID: <1294805755.2821.6.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 11:59 +0800, Ian Kent wrote:
> On Tue, 2011-01-11 at 11:57 -0600, Alex Elder wrote:
> > On Tue, 2011-01-11 at 08:51 -0800, Linus Torvalds wrote:
> > > On Tue, Jan 11, 2011 at 8:34 AM, Alex Elder <aelder@sgi.com> wrote:
> > > >
> > > > FYI, when using this code, as merged by Linus, I hit the
> > > > BUG_ON() at the beginning of d_set_d_op() when it's called
> > > > by autofs4_dir_mkdir().  I managed to work around it by
> > > > just commenting out those BUG_ON() calls but it's something
> > > > that ought to get addressed properly.
> > > 
> > > Yeah, removing the BUG_ON() isn't the right thing to do - it means
> > > that autofs4 is obviously setting the dentry ops twice for the same
> > > dentry.
> > > 
> > > Possibly the thing could be relaxed to allow setting the _same_ d_op
> > > pointer, ie do something like
> > > 
> > >    if (dentry->d_op == op)
> > >       return;
> > > 
> > > at the top of that function. But looking at it, I don't think that
> > > fixes the autofs4 issue.
> > 
> > That's easy enough, but it seems everybody else ensures
> > this gets done just once per dentry, and it would be nice
> > to preserve that "tightness" if possible.
> > 
> > > The fact that autofs4 does "d_add()" before it sets the d_ops (or
> > > other dentry state, for that matter) looks a bit scary. To me that
> > > smells like it might get a  dentry lookup hit before it's actually
> > > fully done.
> > 
> > Agreed.
> 
> Isn't the parent i_mutex held during mkdir()?
> Still the order can be changed, of course.
> 
> > 
> > > Does it make any difference if you move the various d_add() calls down
> > > to the end of the functions to when the "dentry" has really been
> > > instantiated?
> > 
> > Looking at it quickly, I don't think that would matter for
> > the case at hand.  I.e., that might be safer but it doesn't
> > address the fact that these fields are getting initialized
> > multiple times.
> 
> Yeah, a hangover from changes done over time.
> Not setting the dentry op in ->lookup() should fix this.

Could you try this patch please.

autofs4 - dont set dentry op in ->lookup()

From: Ian Kent <raven@themaw.net>

With the introduction of the vfs-scale patch series setting dentry
operations more than once (or changing them) triggers a BUG_ON().

Also, move the d_add() in ->symlink() and ->mkdir() to the end of
the function.
---

 fs/autofs4/root.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 651e4ef..a9a41eb 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -568,19 +568,6 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
 		ino = autofs4_dentry_ino(dentry);
 	} else {
 		/*
-		 * Mark the dentry incomplete but don't hash it. We do this
-		 * to serialize our inode creation operations (symlink and
-		 * mkdir) which prevents deadlock during the callback to
-		 * the daemon. Subsequent user space lookups for the same
-		 * dentry are placed on the wait queue while the daemon
-		 * itself is allowed passage unresticted so the create
-		 * operation itself can then hash the dentry. Finally,
-		 * we check for the hashed dentry and return the newly
-		 * hashed dentry.
-		 */
-		d_set_d_op(dentry, &autofs4_root_dentry_operations);
-
-		/*
 		 * And we need to ensure that the same dentry is used for
 		 * all following lookup calls until it is hashed so that
 		 * the dentry flags are persistent throughout the request.
@@ -714,7 +701,6 @@ static int autofs4_dir_symlink(struct inode *dir,
 			kfree(ino);
 		return -ENOMEM;
 	}
-	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		d_set_d_op(dentry, &autofs4_root_dentry_operations);
@@ -732,6 +718,8 @@ static int autofs4_dir_symlink(struct inode *dir,
 	ino->u.symlink = cp;
 	dir->i_mtime = CURRENT_TIME;
 
+	d_add(dentry, inode);
+
 	return 0;
 }
 
@@ -849,7 +837,6 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 			kfree(ino);
 		return -ENOMEM;
 	}
-	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
 		d_set_d_op(dentry, &autofs4_root_dentry_operations);
@@ -866,6 +853,8 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inc_nlink(dir);
 	dir->i_mtime = CURRENT_TIME;
 
+	d_add(dentry, inode);
+
 	return 0;
 }
 


