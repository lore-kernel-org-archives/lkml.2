Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1A0DnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:43:21 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:3608 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506Ab1A0DnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:43:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAFd4QE15LN5mgWdsb2JhbACkexYBARYiJLt/DYVCBA
Date: Thu, 27 Jan 2011 14:43:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127034314.GI21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com>
 <4D40CDCF.4010301@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40CDCF.4010301@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:43:43PM -0500, Mark Lord wrote:
> On 11-01-26 08:22 PM, Mark Lord wrote:
> > Alex / Christoph,
> > 
> > My mythtv box here uses XFS on a 2TB drive for storing recordings and videos.
> > It is behaving rather strangely though, and has gotten worse recently.
> > Here is what I see happening:
> > 
> > The drive mounts fine at boot, but the very first attempt to write a new file
> > to the filesystem suffers from a very very long pause, 30-60 seconds, during which
> > time the disk activity light is fully "on".
> > 
> > This happens only on the first new file write after mounting.
> >>From then on, the filesystem is fast and responsive as expected.
> > If I umount the filesystem, and then mount it again,
> > the exact same behaviour can be observed.
> > 
> > This of course screws up mythtv, as it causes me to lose the first 30-60
> > seconds of the first recording it attempts after booting.  So as a workaround
> > I now have a startup script to create, sync, and delete a 64MB file before
> > starting mythtv.  This still takes 30-60 seconds, but it all happens and
> > finishes before mythtv has a real-time need to write to the filesystem.
> > 
> > The 2TB drive is fine -- zero errors, no events in the SMART logs,
> > and I've disabled the silly WD head-unload logic on it.
> > 
> > What's happening here?  Why the big long burst of activity?
> > I've only just noticed this behaviour in the past few weeks,
> > running 2.6.35 and more recently 2.6.37.
> > 
> > * * *
> > 
> > The other issue is something I notice at umount time.
> > I have a second big drive used as a backup device for the drive discussed above.
> > I use "mirrordir" (similar to rsync) to clone directories/files from the main
> > drive to the backup drive.  After mirrordir finishes, I then "umount /backup".
> > The umount promptly hangs, disk light on solid, for 30-60 seconds, then finishes.
> > 
> > If I type "sync" just before doing the umount, sync takes about 1 second,
> > and the umount finishes instantly.
> > 
> > Huh? What's happening there?
> > 
> > System is running 2.6.37 from kernel.org, but similar behaviour
> > has been there under 2.6.35 and 2.6.34.  Dunno about earlier.
> > 
> > I can query any info you need from the filesystem.
> 
> 
> Thinking about it some more:  the first problem very much appears as if
> it is due to a filesystem check happening on the already-mounted filesystem,
> if that makes any kind of sense (?).

Not to me.  You can check this simply by looking at the output of
top while the problem is occurring...

> Because.. running xfs_check on the umounted drive takes about the same 30-60
> seconds,
> with the disk activity light fully "on".

Well, yeah - XFS check reads all the metadata in the filesystem, so
of course it's going to thrash your disk when it is run. The fact it
takes the same length of time as whatever problem you are having is
likely to be coincidental.

> The other thought that came to mind:  this behaviour has only been
> noticed recently, probably because I have recently added about
> 1000 new files (hundreds of MB each) to the videos/ directory on
> that filesystem.  Whereas before, it had fewer than 500 (multi-GB)
> files in total.
> 
> So if it really is doing some kind of internal filesystem check,
> then the time required has only recently become 3X larger than
> before.. so the behaviour may not be new/recent, but now is very
> noticeable.

Where does that 3x figure come from? Have you measured it? If so,
what are the numbers?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
