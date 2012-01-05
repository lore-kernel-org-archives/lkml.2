Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab2AEUlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:41:01 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36447 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2AEUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:41:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with unregistration]
References: <m1ehvecf23.fsf@fess.ebiederm.org>
	<Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
	<20120105182752.GC26382@thunk.org> <20120105183602.GE18486@google.com>
Date: Thu, 05 Jan 2012 12:43:11 -0800
In-Reply-To: <20120105183602.GE18486@google.com> (Tejun Heo's message of "Thu,
	5 Jan 2012 10:36:02 -0800")
Message-ID: <m1d3axc23k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+6BpLNYY17sE8Gz6N5P/mJNCRm6z8LDmo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Ted.
>
> On Thu, Jan 05, 2012 at 01:27:52PM -0500, Ted Ts'o wrote:
>> So it's really more of a filesystem force-umount method.  I could
>> imagine that this could also be used to extend the functionality of
>> umount(2) so that the MNT_FORCE flag could be used with non-NFS file
>> systems as well as NFS file systems.
>
> I think these are two separate mechanisms.  Filesystems need to be
> able to handle IO errors no matter what and underlying device going
> away is the same situation.  There's no reason to mix that with force
> unmount.  That's a separate feature and whether to force unmount
> filesystem on device removal or permanent failure is a policy decision
> which belongs to userland - ie. if such behavior is desired, it should
> be implemented via udev/udisk instead of hard coded logic in kernel.
>
> I don't know enough to decide whether such forced unmount is a useful
> feature tho.  It can be neat for development but is there any real
> necessity for the feature?
>
>> [1] Interesting question: do we convert an mmap region to an anonymous
>> region and perhaps notify the user out of band this has happened?  Or
>> do we just make the mapping disappear and nuke the process with a SEGV
>> if it attempts to access it?
>
> FWIW, I vote for SIGBUS similarly to the way we handle mmap
> vs. truncate.

Agreed.  SIGBUS is documented as the mapping exists but the backing
store has gone away, which seems to describe hotunplug very well.
Additionally we already do this for sysfs and it works well.

So it appears that on a hotunplug it is desirable to wake all poll
waiters of a filesystem, invalidate all mmaps, and probably notify
all inotify watchers.  And in general scream to userspace that the
filesystem is gone leave it alone.

That does require a notification from the block device going away
to the filesystem.  Tejun is there an existing mechanism that we
can plug into or do we need to implement something new?

Ted we can scream that the filesystem is going away without freeing
all of the filesystem data structures.  To userspace there would
effectively be no difference but internal to the kernel it should
allows to skip the expensive logic of tracking every time a filesystem
method is invoked, allowing us to not penalize the fast path.

If I don't have to provide a zero cost ability to track which filesystem
methods are active at any given time I think I can whip up something
that is usable in a couple of days.

Eric
