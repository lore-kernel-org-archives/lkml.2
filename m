Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab2GGTFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 15:05:05 -0400
Received: from fieldses.org ([174.143.236.118]:39964 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2GGTFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 15:05:02 -0400
Date: Sat, 7 Jul 2012 15:04:51 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] locks: prevent side-effects of
 locks_release_private before file_lock is initialized
Message-ID: <20120707190451.GA17049@fieldses.org>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
 <1340761848-1352-1-git-send-email-filbranden@gmail.com>
 <20120705224251.GH3051@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705224251.GH3051@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 06:42:51PM -0400, J. Bruce Fields wrote:
> On Tue, Jun 26, 2012 at 09:50:48PM -0400, Filipe Brandenburger wrote:
> > When calling fcntl(F_SETLEASE) for a second time on the same file descriptor,
> > do_fcntl_add_lease will allocate and initialize a new file_lock to pass to
> > __vfs_setlease. If that function decides to reuse the existing file_lock, it
> > will free the newly allocated one to prevent leaking memory.
> > 
> > However, the newly allocate file_lock was initialized with a valid file
> > descriptor pointer and fl_lmops that contains a lm_release_private function,
> > so calling locks_free_lock will trigger a call to lease_release_private_callback
> > which will clear the fcntl(F_SETOWN) and fcntl(F_SETSIG) settings for the file
> > descriptor even though the lease is not really being cleared at that point (as
> > only the temporary file_lock is being freed.)
> > 
> > This patch will fix this bug by calling kmem_cache_free directly instead of
> > locks_free_lock if the file_lock will not be used. This will end up avoiding
> > the call to lease_release_private_callback.
> > 
> > This bug was tracked in kernel.org Bugzilla database:
> > https://bugzilla.kernel.org/show_bug.cgi?id=43336

Apologies for not taking a closer look till now.

Having done so.... I think the real problem is that we have this
release callback at all.  The fact is, this doesn't really have anything
to do with releasing resources.  And of the places we free a lease, I
believe only one of them actually wants this.

That callback was added without any visible justification by the patch
below, pulled out of one of the historical git repos.  It looks to me
like we could just revert it.

Could you try that?  If it works, could you send in the result with
proper changelog, etc.?

--b.

commit fd08d90925ac99d076382bcf4089085f92992954
Author: William A. Adamson <andros@thnk.citi.umich.edu>
Date:   Tue Oct 19 18:44:22 2004 -0700

    [PATCH] nfs4 lease: move the f_delown processing
    
    Move the f_delown processing from lease_modify() into a new default lock
    manager fl_release_private callback.
    
    Signed-off-by: Andy Adamson <andros@citi.umich.edu>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/fs/locks.c b/fs/locks.c
index e05dffc..1257539 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -397,8 +397,18 @@ static void lease_break_callback(struct file_lock *fl)
 	kill_fasync(&fl->fl_fasync, SIGIO, POLL_MSG);
 }
 
+static void lease_release_private_callback(struct file_lock *fl)
+{
+	if (!fl->fl_file)
+		return;
+
+	f_delown(fl->fl_file);
+	fl->fl_file->f_owner.signum = 0;
+}
+
 struct lock_manager_operations lease_manager_ops = {
 	.fl_break = lease_break_callback,
+	.fl_release_private = lease_release_private_callback,
 };
 
 /*
@@ -1056,13 +1066,8 @@ static int lease_modify(struct file_lock **before, int arg)
 	if (error)
 		return error;
 	locks_wake_up_blocks(fl);
-	if (arg == F_UNLCK) {
-		struct file *filp = fl->fl_file;
-
-		f_delown(filp);
-		filp->f_owner.signum = 0;
+	if (arg == F_UNLCK)
 		locks_delete_lock(before);
-	}
 	return 0;
 }
 
