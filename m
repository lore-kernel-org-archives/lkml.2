Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2HYTnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:43:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61623 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2HYTn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:43:29 -0400
Date: Sat, 25 Aug 2012 23:43:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/9] procfs: Move /proc/pid/fd[info] handling code to
 fd.[ch]
Message-ID: <20120825194325.GG19184@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
 <20120825173958.GC19184@moon>
 <20120825175504.GU23464@ZenIV.linux.org.uk>
 <20120825185829.GE19184@moon>
 <20120825191218.GV23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825191218.GV23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 08:12:18PM +0100, Al Viro wrote:
> On Sat, Aug 25, 2012 at 10:58:29PM +0400, Cyrill Gorcunov wrote:
> > On Sat, Aug 25, 2012 at 06:55:04PM +0100, Al Viro wrote:
> > > > Well, this could be simplified indeed, if I understand you correctly
> > > > you propose just save f_mode in flexible array and use it instead
> > > > of struct file, right? (which will require to rewrite code a bit)
> > > 
> > > Yes.  FWIW, proc_fill_cache() is really atrocious ;-/  Not to mention
> > 
> > OK, thanks. I'm putting this cleanup task in my big todo list. Hope I'll
> > manage on the next week with it.
> > 
> > > anything else, if we ever get a negative dentry there, we have a dentry
> > > leak.  I don't think it's possible in practice, but...  Furthermore,
> > 
> > could you please elaborate, you mean this string?
> 
> I mean that if we get to that if (... || !child->d_inode) and end up
> evaluating the last part at all, we have acquired a reference to that
> struct dentry.  And if that last part ends up being true (i.e. if it's
> a negative dentry), we'll return from function without having dropped
> the reference we'd acquired.

Would the patch below improve the code? Look, I've not dropped
find_inode_number call since it's a bit unclear for me what
would happen if !child case hit

	child = d_lookup(dir, &qname);
	if (!child) {
		struct dentry *new = d_alloc(dir, &qname);
		if (new) {
			child = instantiate(dir->d_inode, new, task, ptr);
			if (child)
				dput(new);
			else
				child = new;
		}
	}

can we be sure that i_ino won't be zero here?
---
 fs/proc/base.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -1650,7 +1650,6 @@ int proc_fill_cache(struct file *filp, v
 	instantiate_t instantiate, struct task_struct *task, const void *ptr)
 {
 	struct dentry *child, *dir = filp->f_path.dentry;
-	struct inode *inode;
 	struct qstr qname;
 	ino_t ino = 0;
 	unsigned type = DT_UNKNOWN;
@@ -1661,8 +1660,7 @@ int proc_fill_cache(struct file *filp, v
 
 	child = d_lookup(dir, &qname);
 	if (!child) {
-		struct dentry *new;
-		new = d_alloc(dir, &qname);
+		struct dentry *new = d_alloc(dir, &qname);
 		if (new) {
 			child = instantiate(dir->d_inode, new, task, ptr);
 			if (child)
@@ -1671,19 +1669,20 @@ int proc_fill_cache(struct file *filp, v
 				child = new;
 		}
 	}
-	if (!child || IS_ERR(child) || !child->d_inode)
-		goto end_instantiate;
-	inode = child->d_inode;
-	if (inode) {
-		ino = inode->i_ino;
-		type = inode->i_mode >> 12;
-	}
+	if (IS_ERR_OR_NULL(child))
+		goto err;
+	if (!child->d_inode)
+		goto err_put;
+	ino = child->d_inode->i_ino;
+	type = child->d_inode->i_mode >> 12;
+err_put:
 	dput(child);
-end_instantiate:
-	if (!ino)
+err:
+	if (!ino) {
 		ino = find_inode_number(dir, &qname);
-	if (!ino)
-		ino = 1;
+		if (!ino)
+			ino = 1;
+	}
 	return filldir(dirent, name, len, filp->f_pos, ino, type);
 }
 
