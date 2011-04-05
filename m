Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1DECKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:10:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:46665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1DECJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:09:58 -0400
Date: Tue, 5 Apr 2011 12:09:44 +1000
From: NeilBrown <neilb@suse.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        dm-devel@redhat.com
Subject: Re: Please revert a91a2785b20
Message-ID: <20110405120944.48d4ee88@notabene.brown>
In-Reply-To: <yq1lizyhwlr.fsf@sermon.lab.mkp.net>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
	<alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
	<20110328230319.GA12790@redhat.com>
	<4D918347.7050500@fusionio.com>
	<20110329132032.GA22921@redhat.com>
	<yq1lizyhwlr.fsf@sermon.lab.mkp.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 09:42:08 -0400 "Martin K. Petersen"
<martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> But I think we have a related issue that needs discussion, given
> Mike> that an integrity profile mismatch will cause MD's assemble to
> Mike> fail (rather than warn and continue to assemble without integrity
> Mike> support).
> 
> Mike> DM doesn't fail to load a DM device due to a integrity profile
> Mike> mismatch; it just emits a warning and continues.
> 
> Mike> In contrast, MD will now disallow adding a normal disk (without
> Mike> integrity support) to an array that has historically had a
> Mike> symmetric integrity profile across all members.
> 
> You would invalidate all your existing integrity metadata, tagging,
> etc. on existing metadevice members. That seems to be a policy decision,
> so if we go down that path it would have to be keyed off a force
> assembly option passed down from userland tooling. Turning off features
> and/or losing metadata really should not be done without the user's
> explicit consent.

I've been distracted by other things for a while so I'm just looking at this
now, and I've never really paid much attention to the 'integrity' stuff
(seems all wrong to me anyway) so I might need some help coming up to
speed...

My reading of data-integrity.txt suggest that the IMD consists of two basic
components.
One is a fixed-format chunk which contains a light-weight checksum possibly
with some other summary information (address?).  This is created at
whichever level doesn't trust the levels below, verified by the drive
firmware, and written to disk (together with whatever much stronger CRC the
drive firmware wants.  It can then be verified on read by anyone who cares.

It seems to me that if one device in the array doesn't support this, then it
cannot be visible above the array but can still be computed and checked below
the array level, which is nearly as safe(??)
So changing an array from homogeneous to mixed just moves where the checksum
is calculated - not a big deal (maybe).

The other component of the IMD is an application tag which is not understood
or checked by the drive firmware (though presumably it is included in the
light-weight checksum so minimal checking is possible).  This is used by the
filesystem to get an extra few bytes of data per-block which is known to be
updated atomically with the rest of the block.
This is currently completely unsupported by any redundant md array as there
is no attempt to copy this info when recovering to a spare etc.

So for this part of the IMD, RAID0 and LINEAR are the only levels that might
support it, and they don't have new devices added while active.  LINEAR can
be extended by adding a device but that is used so rarely that I'm not really
fussed exactly how it gets handled.

So it seem to me there is no justification for disallowing the adding of a
device to an active array just because of some incompatibility with integrity
management.

Am I missing something???


Longer term - it is conceivable that RAID1/RAID10 could be taught to copy
integrity data, and we might even be able to make RAID5/6 handle it, though
the idea certainly doesn't appeal to me.

In that case we really need to know whether the sysadmin is expecting
integrity support or not.  It think it is only justified to refuse an
explicit request to add a device to an array if we know it to be incompatible
with some other request.
I don't know how integrity should be requested - maybe mkfs, maybe mount,
maybe ioctl... maybe an mdadm option.
Once md finds out that it has been explicitly requested the array could be
flagged to say that integrity is in use, and then we could do all the extra
work to provide it, and reject new devices which don't support it.


Does any of that make sense?  Is there something I have completely
misunderstood?

> 
> Also, let's assume you run an integrity-aware app on a DM device and you
> add a non-integrity drive. The DM device is then no longer capable of
> carrying integrity metadata out to storage. What happens to the app?
> What about outstanding writes with metadata attached?
> 
> Good discussion topic for next week, methinks...
> 

Yeah, have fun  - but remember that not all storage people are there :-)

NeilBrown

