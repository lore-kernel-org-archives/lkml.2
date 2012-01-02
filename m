Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2ABLw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:52:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2ABLwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:52:25 -0500
Date: Mon, 2 Jan 2012 12:52:22 +0100
From: Jan Kara <jack@suse.cz>
To: Jorge Bastos <mysql.jorge@decimal.pt>
Cc: "'Jan Kara'" <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com
Subject: Re: Reiserfs.c bug in 3.2-rc5
Message-ID: <20120102115222.GA3626@quack.suse.cz>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
 <20111213180707.GI11747@quack.suse.cz>
 <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat 24-12-11 11:55:43, Jorge Bastos wrote:
> > >
> > > What can be done here?
> >   The assertion failing is:
> >         BUG_ON(nblocks > journal->j_trans_max);
> > in do_journal_begin_r(). That means that reiserfs_create() tried to
> > start a
> > transaction with more credits than allowed by the journal.
> > 
> >   When did you started to see this problem? Also do you use SELinux (or
> > generally security labels)?
> > 
> 
> No SELinux, the only change is from 3.1.1 to 3.2-rc5.
> Tried the new 3.2-rc7 and the problem persists.
  OK, so do I understand right that 3.1.1 is OK but 3.2-rc5/rc7 have
the problem?

> Is there a way that the ReiserFS people can commit the fix?
  Sure, we just have to find where the problem is. Can you please run with
the attached debugging patch applied and send me kernel output when the
system crashes? Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--OXfL5xGRrasGEqWY
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-reiserfs-Debugging-patch.patch"

>From 4dd005ac485a6e86e2f81995894e9f8f6a352557 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 2 Jan 2012 12:49:06 +0100
Subject: [PATCH] reiserfs: Debugging patch

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/journal.c |    8 +++++++-
 fs/reiserfs/namei.c   |    7 +++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index eb71106..c7ff04a 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3003,7 +3003,13 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
 	int retval;
 
 	reiserfs_check_lock_depth(sb, "journal_begin");
-	BUG_ON(nblocks > journal->j_trans_max);
+	if (nblocks > journal->j_trans_max) {
+		printk(KERN_ERR "Too many blocks for reiserfs a transaction"
+			" (%lu > %lu)\n", nblocks,
+			(unsigned long)journal->j_trans_max);
+		dump_stack();
+		return -EINVAL;
+	}
 
 	PROC_INFO_INC(sb, journal.journal_being);
 	/* set here for journal_join */
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 80058e8..1a05abe 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -584,6 +584,7 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		 REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb));
 	struct reiserfs_transaction_handle th;
 	struct reiserfs_security_handle security;
+	int security_ret;
 
 	dquot_initialize(dir);
 
@@ -598,11 +599,17 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		drop_new_inode(inode);
 		return retval;
 	}
+	security_ret = retval;
 	jbegin_count += retval;
 	reiserfs_write_lock(dir->i_sb);
 
 	retval = journal_begin(&th, dir->i_sb, jbegin_count);
 	if (retval) {
+		if (retval == -EINVAL) {
+			printk(KERN_ERR "reiserfs_security_init() returned %d"
+				" (dir=%lu)\n", security_ret, dir->i_ino);
+			BUG_ON(1);
+		}
 		drop_new_inode(inode);
 		goto out_failed;
 	}
-- 
1.7.1


--OXfL5xGRrasGEqWY--
