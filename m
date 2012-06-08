Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab2FHF0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:26:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59799 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab2FHF0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:26:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
In-Reply-To: <20120608005935.GL30000@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 8 Jun 2012 01:59:35 +0100")
References: <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
	<20120606235403.GC30000@ZenIV.linux.org.uk>
	<20120607002914.GB22223@redhat.com>
	<CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
	<20120607011915.GA17566@redhat.com>
	<20120607012900.GE30000@ZenIV.linux.org.uk>
	<20120607193607.GI30000@ZenIV.linux.org.uk>
	<873966n2c2.fsf@xmission.com>
	<CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
	<20120608003604.GK30000@ZenIV.linux.org.uk>
	<20120608005935.GL30000@ZenIV.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 07 Jun 2012 22:25:46 -0700
Message-ID: <87bokugysl.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/s/OWm+1ET1qIrxw208/KYIdWvDws/2qE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  6.5 URIBL_BLACK Contains an URL listed in the URIBL blacklist
	*      [URIs: kernel.in]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1649]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: processes hung after sys_renameat, and 'missing' processes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Fri, Jun 08, 2012 at 01:36:04AM +0100, Al Viro wrote:
>> Eric, how about this - if nothing else, that makes code in there simpler
>> and less dependent on details of VFS guts:
>
> Argh.  No, it's not enough.  Why are you using ->d_iput()?  You are not
> doing anything unusual with inode; the natural place for that is in
> ->d_release() and then it will get simpler rules wrt setting ->d_fsdata.

No good reason.  We do tie inode numbers to the syfs_dirent but the
inode was changed quite a while ago to hold it's own reference
sysfs_dirent.  So using d_iput looks like sysfs historical baggage.

> As it is, you need to do that exactly after the point where you know
> that it dentry won't be dropped without going through d_add().
>
> OK, I've split that in two commits and put into vfs.git#sysfs; take a look
> and comment, please.  Should get to git.kernel.in a few...

The patches on your sysfs branch look reasonable.

I am still learly of d_materialise_unique as it allows to create alias's
on non-directories.  It isn't a functional problem as d_revalidate will
catch the issue and make it look like we have a unlink/link pair instead
of a proper rename.  However since it is possible I would like to aim
for the higher quality of implemntation and use show renames as renames.

What would be ideal for sysfs is the d_add_singleton function below.  It
does what is needed without the weird d_materialise strangeness that is
in d_materialise_unique.  But if a all singing all dancing all
confusing function is preferable I would not mind.

What I would really like is an interface so that a distrubuted/remote
filesystem can provide an inotify like stream of and we can really
implement inotify in a distributed filesystem.  But since I am too lazy
to do that I am reluctant to give up what progress I have actually made
in that direction.

Eric

diff --git a/fs/dcache.c b/fs/dcache.c
index 85c9e2b..2aab524 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2537,6 +2537,74 @@ out_nolock:
 }
 EXPORT_SYMBOL_GPL(d_materialise_unique);
 
+/**
+ * d_add_singleton - add an inode with only a single dentry
+ * @entry: dentry to instantiate
+ * @inode: inode to attach to this dentry
+ *
+ * Fill in inode information in the entry. On success, it returns NULL.
+ * If an alias of "entry" already exists, then we assume that a rename
+ * has occurred and not been reported so the alias is renamed and we
+ * return the aliased dentry and drop one reference to the inode.
+ *
+ * Note that in order to avoid conflicts with rename() etc, the caller
+ * had better be holding the parent directory semaphore.
+ *
+ * This also assumes that the inode count has been incremented
+ * (or otherwise set) by the caller to indicate that it is now
+ * in use by the dcache.
+ */
+struct dentry *d_add_singleton(struct dentry *entry, struct inode *inode)
+{
+       struct dentry *alias, *actual = entry;
+
+       if (!inode) {
+               __d_instantiate(entry, NULL);
+               d_rehash(entry);
+               goto out_nolock;
+       }
+
+       spin_lock(&inode->i_lock);
+
+       /* Does an aliased dentry already exist? */
+       alias = __d_find_alias(inode);
+       if (alias) {
+               write_seqlock(&rename_lock);
+
+               if (d_ancestor(alias, entry)) {
+                       /* Check for loops */
+                       actual = ERR_PTR(-ELOOP);
+                       spin_unlock(&inode->i_lock);
+               } else {
+                       /* Avoid aliases.  This drops inode->i_lock */
+                       actual = __d_unalias(inode, entry, alias);
+               }
+               write_sequnlock(&rename_lock);
+               if (IS_ERR(actual)) {
+                       if (PTR_ERR(actual) == -ELOOP)
+                               pr_warn_ratelimited(
+                                       "VFS: Lookup of '%s' in %s %s"
+                                       " would have caused loop\n",
+                                       entry->d_name.name,
+                                       inode->i_sb->s_type->name,
+                                       inode->i_sb->s_id);
+                       dput(alias);
+               }
+               goto out_nolock;
+       }
+       __d_instantiate(entry, inode);
+       spin_unlock(&inode->i_lock);
+       d_rehash(entry);
+out_nolock:
+       if (actual == entry ) {
+               security_d_instantiate(entry, inode);
+               return NULL;
+       }
+       iput(inode);
+       return actual;
+}
+
+
 static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 {
        *buflen -= namelen;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 094789f..9613d4c 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -219,6 +219,8 @@ static inline int dname_external(struct dentry *dentry)
 extern void d_instantiate(struct dentry *, struct inode *);
 extern struct dentry * d_instantiate_unique(struct dentry *, struct inode *);
 extern struct dentry * d_materialise_unique(struct dentry *, struct inode *);
+extern struct dentry * d_materialise_unalias(struct dentry *, struct inode *);
+extern struct dentry *d_add_singleton(struct dentry *, struct inode *);
 extern void __d_drop(struct dentry *dentry);
 extern void d_drop(struct dentry *dentry);
 extern void d_delete(struct dentry *);
