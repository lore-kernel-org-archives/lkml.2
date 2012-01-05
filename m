Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2AEPuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:50:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41404 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2AEPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:49:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with unregistration]
References: <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
Date: Thu, 05 Jan 2012 07:52:05 -0800
In-Reply-To: <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 5 Jan 2012 10:13:31 -0500 (EST)")
Message-ID: <m1mxa2cfkq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Q68cQaV1waVTgGkHxXDQ5AP5p5aufgBU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 4 Jan 2012, Eric W. Biederman wrote:
>
>> > Ted Ts'o has been talking about something similar but not the same -- a
>> > way to revoke an entire filesystem.  For example, see commit
>> > 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
>> > kludge to avoid an oops after the disk disappears).
>> >
>> > The use case for that is obvious and widespread: Somebody yanks out a
>> > USB drive without unmounting it first.
>> 
>> Agreed.  The best I have at the moment is a library that can wrap
>> filesystem methods to implement the hotplug bits.
>> 
>> Do you know how hard it is to remove event up to the filesystem that
>> sits on top of a block device?
>
> I don't have a clear idea of what's involved (in particular, how to go
> from a block_device structure to a mounted filesystem).  But the place
> to do it would probably be block/genhd.c:invalidate_partition().  Ted
> can tell you if there's a better alternative.

Interesting.  That sounds like a good place to look.  Thanks.

>> Do you know how hard it is to detect at mount time if a block device
>> might be hot-plugable?  We can always use a mount option here and
>> make userspace figure it out, but being to have a good default would
>> be nice.
>
> I don't think it's possible to tell if a device is hot-unpluggable.  
> For example, the device itself might not be removable from its parent, 
> but the parent might be hot-unpluggable.  You'll probably have to 
> assume that every device can potentially be unplugged, one way or 
> another.
>
> Also, even devices that aren't hot-unpluggable can fail.  The end 
> result should be pretty much the same.

True, and ultimately I agree with you.  Unfortunately solving the
full general case right now looks like perfection being the enemy
of the good.

When the requirement becomes add the ability to tear down the data
structures and to remove the modules we have to track while we
are in a filesystem method and to add the ability to wait for
us to stop being in all filesystem methods.

That tracking is hard to make free.  So implementing it for everyone
out of the gate is a hard sell.

However if we can pick those cases where we care more about doing
the right thing on hot-unplug than we care about performance we should
be able to go forward with a good enough method now.

But since there are performance implications for very common path system
calls it makes sense to make this for the first pass something like
mount -o sync.   Something that you can opt into when it makes sense,
but that you don't have to opt into.

So the practical option that I see is either we autodetect block devices
that are setup to be hotpluggable or that we require a mount option.

>> If it isn't too hard to get the event up from the block device to the
>> filesystem when the block device is uncermoniously removed I might just
>> make the time to have hotunplug trigger a filesystem wide revoke on a
>> filesystem like ext4.
>> 
>> In addition to sysfs we need the same logic in proc, sysctl, and uio.
>> So it makes sense to move towards a common library that can do all of
>> the hard bits.
>
> Ted mentioned the need for a new "device removed" superblock method.  
> Then each filesystem can add its own implementation as people get
> around to it.

Yeah.  If we can get the "device removed" aka "revokefs" superblock
it isn't too hard to build a library that filesystems can use to
wrap their normal filesystem methods and implement revokefs.

Eric
