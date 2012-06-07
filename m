Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2FGUni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:43:38 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33446 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2FGUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:43:36 -0400
Date: Thu, 7 Jun 2012 13:43:29 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, elder@inktank.com
Subject: Re: processes hung after sys_renameat, and 'missing' processes
In-Reply-To: <20120607193607.GI30000@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1206071300360.23565@cobra.newdream.net>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk> <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com> <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Thu, 7 Jun 2012, Al Viro wrote:
> [maintainers of assorted code involved Cc'd]
> 
> On Thu, Jun 07, 2012 at 02:29:00AM +0100, Al Viro wrote:
> > On Wed, Jun 06, 2012 at 09:19:15PM -0400, Dave Jones wrote:
> > > On Wed, Jun 06, 2012 at 05:42:35PM -0700, Linus Torvalds wrote:
> > > 
> > >  > So Al meant you to test mutex_is_locked(dentry->d_inode->i_mutex) of
> > >  > the parents.
> > > 
> > > ok, I ended up with..
> > > 
> > >         WARN_ON_ONCE(!mutex_is_locked(&target->d_parent->d_inode->i_mutex));
> > > 
> > >         if (dentry->d_parent != NULL)
> > 			       != dentry)
> > 
> > ->d_parent *never* should be NULL; when dentry is disconnected from the
> > tree (or hadn't been connected to it yet), it points to that dentry itself.
> 
> BTW, I've started to put together some documentation on ->d_parent use.
> And already have found idiocies.
> 
> 0) *all* instances of struct dentry should come from __d_alloc(); never
> embed it into another object or declare variables of type struct dentry.
> AFAICS, that one is satisfied now; any out-of-tree code violating that
> deserves to be broken and *will* be broken.
> 
> 1) For all code outside of fs/dcache.c it's read-only.  Never change it
> directly, period.  Again, satisfied in mainline, out-of-tree code can
> go play in the traffic, for all I care.
> 
> 2) Places that set ->d_parent: __d_alloc(), d_alloc(), __d_move(),
> __d_materialize_dentry().  The first two are doing that to new instance
> of struct dentry with no references to it anywhere in shared data
> structures.  The other two have had dentry passed to dentry_lock_for_move().
> 
> 3) d_alloc(NULL, name) should never happen (will instantly oops in that case).
> 
> 4) ->d_parent is *never* NULL; the only way to stumble across a dentry with
> that not being true is to crawl through the slab page directly and to run
> into an object that has been allocated by not initialized yet.  Don't do
> that (nothing in mainline does, thanks $DEITY).  "No parent" == "dentry
> has ->d_parent pointing to dentry itself".  There's a helper checking that,
> albeit with slightly misleading name - IS_ROOT(dentry).  Doesn't have to
> be fs root - anything still not attached to the tree or already detached
> from it will be that way.  Any code checking that ->d_parent is NULL is
> almost certainly a bug.  And we have a bunch of such places in fs/ceph:
> 	ceph_init_dentry()
> 	ceph_d_prune()
> 	ceph_mdsc_build_path()

The ceph_init_dentry check was added in 92cf7652 in response to getting a 
dentry with null d_parent out of d_obtain_alias().  I suspect it was 
papering over an old bug in that case.  Pushed a patch to the ceph tree to 
clean these checks out, see f3722944a8565edf434ee44bdfa37715ae0d91cd in
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git.  Let 
me know if you want to carry it, otherwise I'll push it in the next 
window.

> a few in fs/cifs:
> 	build_path_from_dentry()
> complete idiocy in fs/debugfs (not only check for NULL ->d_parent, but
> one for ->d_parent being a negative dentry; also can't happen).
> 	debugfs_remove()
> 	debugfs_remove_recursive()
> one in fs/ocfs2:
> 	ocfs2_match_dentry()
> and one in security/inode.c:
> 	securityfs_remove() (nicked from debugfs, at a guess).
> Some of those guys can be simply dropped, but I really wonder what
> ceph_init_dentry/ceph_d_prune intended there.
> 
> Incidentall, build_path_from_dentry() ought to be lifted into fs/dcache.c;
> we have at least three copies and one of them is not an instant roothole
> only because hppfs doesn't follow underlying procfs changes.  And I'm going
> to export is_subdir() - at least gfs2 has grown itself a b0rken copy...
> 
> 5) all assignments to dentry->d_parent after initialization are under
> dentry->d_lock; dentry_lock_for_move() takes care of that.
> 
> 6) all reassignments to dentry->d_parent have ->d_lock held on old and new
> parent.  Again, dentry_lock_for_move() takes care of that and so does
> d_alloc() (that one - for new parent only; old parent is dentry itself
> here and nothing could have seen it yet).
> 
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
> 
> rename-related callers of d_move() (vfs_rename_dir/vfs_rename_other/
> nfs_rename/ocfs2_dentry_move from ocfs2_rename/ceph_rename/v9fs_vfs_rename)
> share the same locking environment; we have both parents + ->s_vfs_rename_mutex
> in case of cross-directory move held.  Pretty much by an accident we have
> one difference between vfs_rename_dir and vfs_rename_other - holding ->i_mutex
> on *victim* of overwriting rename() is not something d_move() cares about.
> We can make that more uniform, but that's really unrelated to that.
> Note that in all these cases both dentries are guaranteed to be attached
> all along.
> 
> Other callers of d_move():
> 	vfat_lookup() does d_move() of an alias; the validity of that
> strongly relies on the lack of anything resembling hardlinks on VFAT;
> the parents will be the same (and parent of target is locked).
> 	sysfs_lookup() plays insane games with d_move(); I _really_
> don't like the look of that code.  It tries to play catch-up after
> sysfs_rename() done its thing.  AFAICS, the parent *can* be changed
> by sysfs_rename().  No lock is held on said parent here; no
> ->s_vfs_rename_mutex either.  Moreover, none of the sysfs_rename() callers
> (kobject_move(), etc.) appear to give a damn about checking if it would
> create a loop.
> 	* debugfs_rename() - imitates what vfs_rename() is doing.  Same
> locking environment.  BTW,
>         trap = lock_rename(new_dir, old_dir);
>         /* Source or destination directories don't exist? */
>         if (!old_dir->d_inode || !new_dir->d_inode)
>                 goto exit;
> is bogus - lock_rename() is taking ->i_mutex on these inodes, for fsck sake!
> If this can be called with old_dir or new_dir negative, it's buggered.
> 	* ceph_fill_trace() in CEPH_MDS_OP_RENAME case.  Seems to be
> done while ceph_rename() is being executed; i.e. the usual locking
> environment holds.  No idea why it feels the need to grab references
> to old_dentry and new_dentry in ceph_rename(), though - if that thing
> can outlive ceph_rename(), we have a bad trouble.  And if it can't, there's
> no reasons to pin them down that way.

The references are owned by the request struct, which can outlive 
ceph_rename() in the case of ^C or whatever.  When that happens, the 
request is marked aborted and the ceph_fill_trace() code doesn't run 
(since the locks are no longer held).  It still needs the refs to maintain 
its own sanity, however.

> 	* d_splice_alias() - broken.  Called without any locking on the
> old directory, nevermind ->s_vfs_rename_mutex.  I really believe that
> this pair of commits needs to be reverted.  The earlier code used to
> guarantee that alias would be detached.
> 
> d_materialise_unique(dentry, inode) must be called with dentry->d_parent
> having its ->d_inode->i_mutex held.  AFAICS, that's satisfied for all
> callers - they come either from ->lookup() or from ->readdir(), both
> having the parent inode locked.  ceph is a possible exceptions; it's
> damn hard to trace back to the places triggering ceph_fill_trace() in
> general ;-/

I know, sorry about that.  :)

ceph_fill_trace() runs on the struct ceph_mds_request, which as an 
r_locked_dir member that is verified before calling splice_dentry() -> 
d_materialise_unique().  I just double-checked and it looks like all call 
sites are safe.

If ceph_rename() (or a similar method who is holding the dir i_mutex) 
aborts, ceph_mdsc_do_request() marks the aborted flag under r_fill_mutex 
to avoid races with ceph_fill_trace(), so we can rely on those locks being 
held for the duration.

Does that clear things up?
sage


> 
> __d_unalias(), in case we are asked for cross-directory move, grabs
> ->s_vfs_rename_mutex first (with trylock).  That makes ->d_parent of
> alias stable; then it grabs ->i_mutex on that parent (again with trylock)
> and we are all set.
> 
> __d_materialise_dentry(dentry, alias) is called only when alias is
> unattached.  That looks like potential race, BTW - what's to prevent it
> from becoming attached right under us?  We do have __d_materialise_dentry()
> and __d_ualias serialized by alias->d_inode->i_lock, but... there's another
> way for that unattached alias to get attached - d_splice_alias().  And
> it's done without ->i_lock there.  OTOH, it's not a problem to extend
> the protection of ->i_lock to that spot as well.
> 
> I'll continue this series in a couple of hours - there's more.  In the
> meanwhile, I'd like to hear from ceph, sysfs and nfsd folks - see above
> for the reasons.
> 
> 
