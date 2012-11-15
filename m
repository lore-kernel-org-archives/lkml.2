Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768731Ab2KOS6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:58:52 -0500
Received: from mail.agmk.net ([91.192.224.71]:60211 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768657Ab2KOS6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:58:51 -0500
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 13:58:51 EST
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        arekm@pld-linux.org, baggins@pld-linux.org,
        Daniel Hokka Zakrisson <daniel@hozac.com>
Subject: Re: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs, autofs, vserver)
Date: Thu, 15 Nov 2012 19:48:10 +0100
Message-ID: <3506450.k3Q223DJQc@localhost>
User-Agent: KMail/4.9.1 (Linux/3.7.0-rc5; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20120925050558.GA14685@MAIL.13thfloor.at>
References: <5092540.GORQ1kUuNX@localhost> <87sja7uvy1.fsf@xmission.com> <20120925050558.GA14685@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 of September 2012 07:05:59 Herbert Poetzl wrote:
> On Mon, Sep 24, 2012 at 11:17:42AM -0700, Eric W. Biederman wrote:
> > Herbert Poetzl <herbert@13thfloor.at> writes:
> 
> >> On Mon, Sep 24, 2012 at 07:23:55AM +0200, Paweł Sikora wrote:
> >>> On Sunday 23 of September 2012 18:10:30 Linus Torvalds wrote:
> >>>> On Sat, Sep 22, 2012 at 11:09 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
> 
> >>>>>         br_read_lock(vfsmount_lock);
> 
> >>>> The vfsmount_lock is a "local-global" lock, where a read-lock
> >>>> is rather cheap and takes just a per-cpu lock, but the
> >>>> downside is that a write-lock is *very* expensive, and can
> >>>> cause serious trouble.
> 
> >>>> And the write lock is taken by the [un]mount() paths. Do *not*
> >>>> do crazy things. If you do some insane "unmount and remount
> >>>> autofs" on a 1s granularity, you're doing insane things.
> 
> >>>> Why do you have that 1s timeout? Insane.
> 
> >>> 1s unmount timeout is *only* for fast bug reproduction (in few
> >>> seconds after opteron startup) and testing potential patches.
> >>> normally with 60s timeout it happens in few minutes..hours
> >>> (depends on machine i/o+cpu load) and makes server unusable
> >>> (permament soft-lockup).
> 
> >>> can we redesign vserver's mnt_is_reachable() for better locking
> >>> to avoid total soft-lockup?
> 
> >> currently we do:
> 
> >>         br_read_lock(&vfsmount_lock);
> >>         root = current->fs->root;
> >>         root_mnt = real_mount(root.mnt);
> >>         point = root.dentry;
> 
> >>         while ((mnt != mnt->mnt_parent) && (mnt != root_mnt)) {
> >>                 point = mnt->mnt_mountpoint;
> >>                 mnt = mnt->mnt_parent;
> >>         }
> 
> >>         ret = (mnt == root_mnt) && is_subdir(point, root.dentry);
> >>         br_read_unlock(&vfsmount_lock);
> 
> >> and we have been considering to move the br_read_unlock()
> >> right before the is_subdir() call
> 
> >> if there are any suggestions how to achieve the same
> >> with less locking I'm all ears ...
> 
> > Herbert, why do you need to filter the mounts that show up in a
> > mount namespace at all?
> 
> that is actually a really good question!
> 
> > I would think a far more performant and simpler solution would
> > be to just use mount namespaces without unwanted mounts.
> 
> we had this mechanism for many years, long before the
> mount namespaces existed, and I vaguely remember that
> early versions didn't get the proc entries right either
> 
> I took a quick look at the code and I think we can drop
> the mnt_is_reachable() check and/or make it conditional
> on setups without a mount namespace in place in the near
> future (thanks for the input, really appreciated!)

Hi,

Herbert, can i just drop this mnt_is_reachable() method from vserver patch?
this issue hasn't been solved for several months now. i can live without this
problematic security-through-obscurity feature on my heavy loaded machines. .


> > I'd like to blame this on the silly rcu_barrier in
> > deactivate_locked_super that should really be in the module
> > remove path, but that happens after we drop the br_write_lock.
> 
> > The kernel take br_read_lock(&vfs_mount_lokck) during every rcu
> > path lookup so mnt_is_reachable isn't particular crazy just for
> > taking the lock.
> 
> > I am with Linus on this one. Paweł even 60s for your mount
> > timeout looks too short for your workload. All of the readers
> > that take br_read_lock(&vfsmount_lock) seem to be showing up in
> > your oops. The only thing that seems to make sense is you have
> > a lot of unmount activity running back to back, keeping the
> > lock write held.
> 
> > The only other possible culprit I can see is that it looks like
> > mnt_is_reachable changes reading /proc/mounts to be something
> > worse than linear in the number of mounts and reading /proc/mounts
> > starts taking the vfsmount_lock.  All minor things but when you
> > are pushing things hard they look like things that would add up.
> 
> > Eric
