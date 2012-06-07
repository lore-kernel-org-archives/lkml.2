Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab2FGXNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:13:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58898 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2FGXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:13:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk>
	<20120606194233.GA1537@redhat.com>
	<CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
	<20120606230040.GA18089@redhat.com>
	<CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
	<20120606235403.GC30000@ZenIV.linux.org.uk>
	<20120607002914.GB22223@redhat.com>
	<CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
	<20120607011915.GA17566@redhat.com>
	<20120607012900.GE30000@ZenIV.linux.org.uk>
	<20120607193607.GI30000@ZenIV.linux.org.uk>
Date: Thu, 07 Jun 2012 16:12:45 -0700
In-Reply-To: <20120607193607.GI30000@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 7 Jun 2012 20:36:07 +0100")
Message-ID: <873966n2c2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19jDE26EQTjMJFGo2d9hQTQHPtf3Ihamu4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1472]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
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

> [maintainers of assorted code involved Cc'd]

> 7) attached dentry moving away from old parent must have ->i_mutex on
> that old parent held.
> 
> 8) dentry getting attached to a new parent must have ->i_mutex held on
> that new parent.
> 
> 9) attached dentry getting moved to a new parent must have ->s_vfs_rename_mutex
> held.
> 
> Now, (7--9) are interesting; the call graph looks so:
> __d_move()
> 	<- d_move()
> 	<- __d_unalias()
> 		<- d_materialise_unique()
> __d_materialise_dentry()
> 	<- d_materialise_unique()

So at least for filesystems that don't implement 
inode->i_op->rename like sysfs I don't see where you get your
rules 7-9 for d_move.

We take the approprate dentry locks in the approparite order so d_move
and the dcache should not care in the slightest about the inode
mutecies.

If we need the inode mutecies to make the dcache bits safe then
something really is insane.  There may be subtle insanities in the
vfs that require the inode muticies of the parents in d_move but I am
certainly not seeing them.  At least as I read it the code in __d_move
only touches and modifies dentry fields.

For any distributed filesystem and for sysfs in particular all of the
vfs inode mutex locking in the case of rename is absolutely useless as
the renames don't go through vfs, and the vfs simply does not have
enough information to use generic locks.

> 	sysfs_lookup() plays insane games with d_move(); I _really_
> don't like the look of that code.  It tries to play catch-up after
> sysfs_rename() done its thing.  AFAICS, the parent *can* be changed
> by sysfs_rename().  No lock is held on said parent here; no
> ->s_vfs_rename_mutex either.  Moreover, none of the sysfs_rename() callers
> (kobject_move(), etc.) appear to give a damn about checking if it would
> create a loop.

Can sysfs_lookup cause the weird renameat problems we are seeing? No.

We don't leave any locks hanging and locks are all take in the order
the vfs expects them to be taken and in the proper nesting orders.

Your complaints about the inode muticies and of the parent directories
and  s_vfs_rename_mutex seem to be completely irrelevant as those
locks mean nothing to sysfs.

All sysfs_lookup is doing is opportunistically updating the dcache
to reflect reality if we happen to come accross a sysfs_dirent that
has been renamed, and since it is just the dcache that is being
updated the locks that d_move takes appear completely sufficient
for that to be safe.

Can sysfs_rename change the sysfs_dirent parent?  yes

Do we have sufficient locking in sysfs_rename? yes we
take the sysfs_mutex, that it overkill but it serializes all
sysfs_dirent changes.

Is there loop prevention for sysfs_rename?  No.  However there
are only 5 callers of device_move and all of them are known
not to create loops.

It is probably worth it someday to get around to adding a test in
sysfs_rename to be double check and verify that loops are not added.

For purposes of analyzing sysfs_lookup we can assume that there are no
in renames, as that would imply a bug in sysfs_rename.

The interactions between the vfs and sysfs are indeed insane.  Because
of the way the vfs is designed the vfs must tell lies about deleted
files and directories when there are submounts involved.

Additionally lies also get told to the vfs about renames because the vfs
implements an on-demand consistency model with respect to remote
filesystems.  With the result that frequently we don't have full
knowledge about renames when we are revalidating directories so make a
rename look like unlink+link pair instead.

So I believe you are asking is sysfs_lookup safe? yes

What syfs_lookup is doing is if it happens to have sufficient knowledge
to detect a rename happened in the past is:

- Each sysfs_dirent has at most one struct dentry per super block.

- If d_find_alias finds a dirent then I know that the dirent for my
  inode is in the wrong place in the dcache.

- d_move performs all of the necessary dcache locking, to ensure moving
  a dentry is safe even if the parent is renamed, at least with respect
  to the dcache.

- I hold sysfs_mutex over the whole thing which guarantees that the
  sysfs directory structure does not change during this time.

> I'll continue this series in a couple of hours - there's more.  In the
> meanwhile, I'd like to hear from ceph, sysfs and nfsd folks - see above
> for the reasons.

I hope my explanations help.

I'd like to hear why you happen to think s_vfs_rename_mutex and the
inode muticies of the parent directories are at all interesting in the
case of d_move and in the case of sysfs.

Eric

