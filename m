Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab2FHHyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:54:15 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53696 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab2FHHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:54:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
In-Reply-To: <20120608054838.GO30000@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 8 Jun 2012 06:48:38 +0100")
References: <20120607002914.GB22223@redhat.com>
	<CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
	<20120607011915.GA17566@redhat.com>
	<20120607012900.GE30000@ZenIV.linux.org.uk>
	<20120607193607.GI30000@ZenIV.linux.org.uk>
	<873966n2c2.fsf@xmission.com>
	<CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
	<20120608003604.GK30000@ZenIV.linux.org.uk>
	<20120608005935.GL30000@ZenIV.linux.org.uk>
	<87bokugysl.fsf@xmission.com>
	<20120608054838.GO30000@ZenIV.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Fri, 08 Jun 2012 00:54:00 -0700
Message-ID: <87pq9a9r3b.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19kGW59fGLTOxGiLvuM+vNyfO/aeSrJ7hA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: processes hung after sys_renameat, and 'missing' processes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, Jun 07, 2012 at 10:25:46PM -0700, Eric W. Biederman wrote:
>
>> I am still learly of d_materialise_unique as it allows to create alias's
>> on non-directories.  It isn't a functional problem as d_revalidate will
>> catch the issue and make it look like we have a unlink/link pair instead
>> of a proper rename.  However since it is possible I would like to aim
>> for the higher quality of implemntation and use show renames as renames.
>
> ???
>
> Please, explain.  link/unlink pair in which sense? 

In the sense that if we don't use d_move.  A rename will look to
userspace like a pair of sys_link and sys_unlink operations.

If I happen to have a file open with the old name and the dentry passes
through d_drop.  The /proc/self/fd/N will show the filename as
"...(deleted)".

And in every other way I can think of that is userspace visible this
will look like a pair of link and unlink operations.

> I don't see what kind of *notify hookup do you have in mind.  Anything that
> treats "dentry failed revalidation or got evicted by memory pressure" as
> "unlink" is completely nuts, IMO.

In this case much as it might be convinient to have a *notify report,
what I was thinking of were the much simpler userspace visible aspects,
like what /proc/self/fd/N symlinks report.


In the little corner case user visible details the current state of vfs
support for distributed filesystems looks nuts to me, especially where
we can't apply an appropriate d_move onto a renamed dentry.

The fact that open files, open directories and mount points pin dentries
in memory cause interesting challenges for keeping the local vfs state
in sync with the state of a remote filesystem.

What I would love to be able to do is to replay some kind of journal
that reports what happened to the filesystem outside of the linux vfs
onto the linux vfs so that we can get a more accurate picture of what
really happened to the filesystem.  Which should allow *notify and the
like to actually work.  Would make the /proc/self/fd/* symlinks more
useful, and make allow files that are mount points to be renamed.

But ultimately the change in semantics bugs me.  Using d_move less
often feels user visible and because d_materialise_unique because it
does not handle renames of files feels like a lurking maintenance bomb
for sysfs.

Especially since renames on files with mount points on them should be
treated differently from normal files.

Speaking of I just found a small unhandled case in __d_unalias.  We need
to deny renaming of mount points.

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: dcache: Deny renaming via __d_unalias dentries of mountpoints

Make __d_unalias match vfs_rename_dir and vfs_rename_other and don't
allow renaming mount points.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---
diff --git a/fs/dcache.c b/fs/dcache.c
index 85c9e2b..d236722 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2380,14 +2380,17 @@ static struct dentry *__d_unalias(struct inode *inode,
                struct dentry *dentry, struct dentry *alias)
 {
        struct mutex *m1 = NULL, *m2 = NULL;
-       struct dentry *ret;
+       struct dentry *ret = ERR_PTR(-EBUSY);
+
+       /* Linux does not rename mount points */
+       if (d_mountpoint(alias))
+               goto out_err;
 
        /* If alias and dentry share a parent, then no extra locks required */
        if (alias->d_parent == dentry->d_parent)
                goto out_unalias;
 
        /* See lock_rename() */
-       ret = ERR_PTR(-EBUSY);
        if (!mutex_trylock(&dentry->d_sb->s_vfs_rename_mutex))
                goto out_err;
        m1 = &dentry->d_sb->s_vfs_rename_mutex;
