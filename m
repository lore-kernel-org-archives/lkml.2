Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934860Ab1ETORT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:17:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab1ETORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=nWsgQLuXpDayxtLthUl3rtxXs8x60fBSuIxGvPpzbpoz65np1OjqBsBzpdKIt2LU/h
         YvC/sHh8PfwNsiSYx5bwFwCu1pFii+h01ENN/QGwHzk8ZFIXTtTAwWhEeVZw+vjKjr8+
         38gMAreQ8zlTrh0MrZFUL5616k1GEyP3vy6aI=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: "viro\@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw\@canonical.com" <apw@canonical.com>,
        "nbd\@openwrt.org" <nbd@openwrt.org>, "neilb\@suse.de" <neilb@suse.de>,
        "hramrach\@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp\@gmail.com" <jordipujolp@gmail.com>
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
	<D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
	<87wrhlah1e.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 20 May 2011 16:17:30 +0200
In-Reply-To: <87wrhlah1e.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Fri, 20 May 2011 10:54:21 +0200")
Message-ID: <87mxihmp6t.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:
>
>> I tried your overlayfs.v9 git repo w/ racer, using two separate ext3
>> filesystems (one for lowerdir and another for upperdir).  I got the
>> WARN_ON in ovl_permission to trigger within about 10 minutes of
>> testing.  Looking at the code, I see a problem in returning w/o
>> cleaning up an dput-ing the alias dentry.  Simple patch enclosed
>> below.
>
> Hmm, thanks.  The more interesting question is: why does that WARN_ON
> trigger?  I'll look into it.

I think I found the cause of all the bug and oopsen you are seeing.

Overlayfs expects upper and lower dentries to be always positive, it
never stores negative dentries there, there's no point, instead it
stores NULL.

There are basically two ways a positive dentry can become negative:

 A) dentry becomes unhashed with d_count == 0

 B) d_delete with d_count == 1

Case A is not possible in our case, since overlayfs keeps a ref on the
upper/lower dentries for the lifetime of the overlayfs dentry.

Case B is however possible, since no extra ref is taken before calling
vfs_unlink/vfs_rmdir.  So it looks like this is being triggered.

This is easy to solve, just grab a ref to upperdentry before
unlink/rmdir.  Equivalent is if we grab an extra reference from the
start.  The below patch does this.

With the patch I can't trigger the bugs anymore.

Erez, could you please also check if reverting your patches and applying
this one fixes all the bugs?

Thanks,
Miklos



commit 9192816148e2c6b1d610226b1fc1c04c36216370
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Fri May 20 16:07:34 2011 +0200

    ovl: don't allow upperdentry to go negative
    
    Upperdentry can become negative if the file/directory is removed,
    since d_delete checks for d_count == 1 (we are the only user of this
    dentry) and changes it to negative in that case.
    
    However users of overlayfs expect upper and lower dentries to be
    either NULL or positive, and finding a negative dentry will trigger a
    WARNING or Oops.
    
    Fix this by keeping double reference on upperdentry which prevents
    d_delete() turning the dentry into negative.
    
    Reported-by: Erez Zadok <ezk@fsl.cs.sunysb.edu>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a9a09a6..c9db954 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -27,6 +27,10 @@ struct ovl_fs {
 };
 
 struct ovl_entry {
+	/*
+	 * Keep "double reference" on upper dentries, so that
+	 * d_delete() doesn't think it's OK to reset d_inode to NULL.
+	 */
 	struct dentry *__upperdentry;
 	struct dentry *lowerdentry;
 	union {
@@ -152,8 +156,9 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 
 	WARN_ON(!mutex_is_locked(&upperdentry->d_parent->d_inode->i_mutex));
 	WARN_ON(oe->__upperdentry);
+	BUG_ON(!upperdentry->d_inode);
 	smp_wmb();
-	oe->__upperdentry = upperdentry;
+	oe->__upperdentry = dget(upperdentry);
 }
 
 void ovl_dentry_version_inc(struct dentry *dentry)
@@ -218,6 +223,7 @@ static void ovl_dentry_release(struct dentry *dentry)
 
 	if (oe) {
 		dput(oe->__upperdentry);
+		dput(oe->__upperdentry);
 		dput(oe->lowerdentry);
 		call_rcu(&oe->rcu, ovl_entry_free);
 	}
@@ -326,7 +332,7 @@ int ovl_do_lookup(struct dentry *dentry)
 	}
 
 	if (upperdentry)
-		oe->__upperdentry = upperdentry;
+		oe->__upperdentry = dget(upperdentry);
 
 	if (lowerdentry)
 		oe->lowerdentry = lowerdentry;
@@ -533,7 +539,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	mntput(upperpath.mnt);
 	mntput(lowerpath.mnt);
 
-	oe->__upperdentry = upperpath.dentry;
+	oe->__upperdentry = dget(upperpath.dentry);
 	oe->lowerdentry = lowerpath.dentry;
 
 	root_dentry->d_fsdata = oe;
