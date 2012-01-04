Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2ADCS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:18:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55216 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2ADCSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:18:09 -0500
Date: Wed, 4 Jan 2012 02:17:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20120104021754.GD23916@ZenIV.linux.org.uk>
References: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
 <20120103133942.GC31457@quack.suse.cz>
 <20120103144531.GA23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103144531.GA23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:45:32PM +0000, Al Viro wrote:
> On Tue, Jan 03, 2012 at 02:39:42PM +0100, Jan Kara wrote:
> 
> >   Thanks Stephen! Al, how shall we resolve this? You wrote you can provide
> > a VFS helper like get_super() which will also guarantee that the fs is
> > unfrozen.  That could be used in quotactl_block() and fsync_bdev(). If you
> > plan to do this for 3.3 then I can just remove the quota fix and let you
> > do it.
> 
> I started digging in that area and I really don't like what I'm seeing.
> sget() race fix from Aug 2010 (MS_BORN one) had not covered all cases.
> The thing is, we can get hit with this:
> 	1) mount(2) does sget(), etc. and fails very late in the game - with
> ->s_root already allocated.  For some filesystems such failure exits are
> possible.
> 	2) something crawling through the superblock list finds our new
> sb before we realize it's doomed.  Tries to grab s_umount, gets blocked.
> 	3) in the meanwhile *another* mount(2) does sget() that catches
> the same sb and decides to pick it.  ->s_active is grabbed, we get blocked
> on attempt to get ->s_umount exclusive.
> 	4) the original mount(2) gets to the failure point and does
> deactivate_locked_super().  ->s_active is decremented, ->s_umount unlocked.
> However, because of (3) ->s_active does not reach 0 yet.  Guy stuck in (2)
> gets to run.  ->s_root is non-NULL here.  And fs is not in a good shape...
> 	5) sget() from (3) gets to ->s_umount, notices that MS_BORN hadn't
> been set and does deactivate_locked_super().  Now ->s_active is 0 and
> we get around to shutting the sucker down.  ->kill_sb() gets called, ->s_root
> is dropped, etc. - the whole nine yards.  Caller of sget() had been saved from
> the race.  However, whoever that had been in (2) and (4) still got hit.
> 
> IOW, MS_BORN check is needed in the places that go through the superblock
> list, grab ->s_umount and check ->s_root.  That will close the hole for
> good.
> 
> We also have a problem in get_active_super() caller; again, the missing MS_BORN
> check (in freeze_super(), after getting ->s_umount).

These should be fixed by the patch below; I don't think that it needs
to go in 3.2-final (the three-way race in question is neither new nor
easy to hit and it's a non-issue for most of the filesystem types), but it's
definitely a -stable fodder.  Bugs on failure exits in ->mount() instances
(at the very least, ext4 and minixfs are leaking dentry on some of those)
are separate story; so's dealing with get_super() and user_get_super()
vs. thaw.  Mikulas: adding an extra argument deciding whether we wait for
thaw is no-go - it's worse than splitting get_super() in two functions;
the effect is the same, but misuses are harder to spot.  I'm still not
sure about ->statfs(), BTW - any input on that would be welcome.  Can
it end up blocked on a frozen fs until said fs is thawed?  We either need
to convert ustat(2) to "wait for thaw" semantics (should be interruptible,
BTW) or document that ->statfs() is not allowed to wait for thawing.
It's far too subtle to leave undocumented...

commit a33a3874084823990acc2a857e54a93e0611a7ff
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Jan 3 21:01:29 2012 -0500

    vfs: fix the rest of sget() races
    
    unfortunately, just checking MS_BORN after having grabbed ->s_umount in
    sget() is not enough; places that pick superblock from a list and
    grab s_umount shared need the same check in addition to checking for
    ->s_root; otherwise three-way race between failing mount, sget() and
    such list-walker can leave us with list-walker coming *second*, when
    temporary active ref grabbed by sget() (to be dropped when sget()
    notices that original mount has failed by checking MS_BORN) has
    lead to deactivate_locked_super() from failing ->mount() *not* doing
    ->kill_sb() and just releasing ->s_umount.  Once sget() gets through
    and notices that MS_BORN had never been set it will drop the active
    ref and fs will be shut down and kicked out of all lists, but it's
    too late for something like sync_supers().
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/super.c b/fs/super.c
index e25b2e8..1b0c814 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -340,7 +340,7 @@ bool grab_super_passive(struct super_block *sb)
 	spin_unlock(&sb_lock);
 
 	if (down_read_trylock(&sb->s_umount)) {
-		if (sb->s_root)
+		if (sb->s_root && (sb->s_flags & MS_BORN))
 			return true;
 		up_read(&sb->s_umount);
 	}
@@ -508,7 +508,7 @@ void sync_supers(void)
 			spin_unlock(&sb_lock);
 
 			down_read(&sb->s_umount);
-			if (sb->s_root && sb->s_dirt)
+			if (sb->s_root && sb->s_dirt && (sb->s_flags & MS_BORN))
 				sb->s_op->write_super(sb);
 			up_read(&sb->s_umount);
 
@@ -543,7 +543,7 @@ void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
 		spin_unlock(&sb_lock);
 
 		down_read(&sb->s_umount);
-		if (sb->s_root)
+		if (sb->s_root && (sb->s_flags & MS_BORN))
 			f(sb, arg);
 		up_read(&sb->s_umount);
 
@@ -578,7 +578,7 @@ void iterate_supers_type(struct file_system_type *type,
 		spin_unlock(&sb_lock);
 
 		down_read(&sb->s_umount);
-		if (sb->s_root)
+		if (sb->s_root && (sb->s_flags & MS_BORN))
 			f(sb, arg);
 		up_read(&sb->s_umount);
 
@@ -619,7 +619,7 @@ rescan:
 			spin_unlock(&sb_lock);
 			down_read(&sb->s_umount);
 			/* still alive? */
-			if (sb->s_root)
+			if (sb->s_root && (sb->s_flags & MS_BORN))
 				return sb;
 			up_read(&sb->s_umount);
 			/* nope, got unmounted */
@@ -679,7 +679,7 @@ rescan:
 			spin_unlock(&sb_lock);
 			down_read(&sb->s_umount);
 			/* still alive? */
-			if (sb->s_root)
+			if (sb->s_root && (sb->s_flags & MS_BORN))
 				return sb;
 			up_read(&sb->s_umount);
 			/* nope, got unmounted */
@@ -776,7 +776,8 @@ static void do_emergency_remount(struct work_struct *work)
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_write(&sb->s_umount);
-		if (sb->s_root && sb->s_bdev && !(sb->s_flags & MS_RDONLY)) {
+		if (sb->s_root && sb->s_bdev && (sb->s_flags & MS_BORN) &&
+		    !(sb->s_flags & MS_RDONLY)) {
 			/*
 			 * What lock protects sb->s_flags??
 			 */
@@ -1159,6 +1160,11 @@ int freeze_super(struct super_block *sb)
 		return -EBUSY;
 	}
 
+	if (!(sb->s_flags & MS_BORN)) {
+		up_write(&sb->s_umount);
+		return 0;	/* sic - it's "nothing to do" */
+	}
+
 	if (sb->s_flags & MS_RDONLY) {
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
