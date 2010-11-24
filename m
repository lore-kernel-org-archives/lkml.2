Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0KXOto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:49:44 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43552 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750894Ab0KXOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:49:42 -0500
Date: Wed, 24 Nov 2010 09:49:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@suse.de>
cc: ltuikov@yahoo.com, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
In-Reply-To: <1290593429.14652.33.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.1011240945260.1513-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, James Bottomley wrote:

> On Wed, 2010-11-24 at 01:02 -0800, Luben Tuikov wrote:
> > I doubt this as very unlikely. Has anyone actually seen a device that
> > sends mode parameter data with faux Caching mode page or corrupted
> > data that is in fact interpreted as a Caching mode page? Is such a
> > device fully operational sans the faux Caching mode page, or does it
> > just not work? Is it common to have devices having a faux Caching mode
> > page or corrupted mode parameter data resulting in a Caching mode page
> > with random data?
> > 
> > Undoubtedly, as the usb-storage maintainer, you must have variety of
> > devices, some broken some not. Could you apply this patch to your tree
> > and test some of the devices you have? My tests indicate a stable
> > behavior.
> 
> The basic problem isn't devices lying ... the worst we'll do is current
> behaviour (not SYNC when we should).  The problem is devices that get
> confused (or worse simply crash the firmware).  The best way to avoid
> the crashing firmware problem ... if we can assume that modern USB
> devices are better is to key off the SCSI version.  Unfortunately, in
> spite of several attempts, we've never managed to stop usbstorage lying
> about this:
> 
> 		/* Some devices report a SCSI revision level above 2 but are
> 		 * unable to handle the REPORT LUNS command (for which
> 		 * support is mandatory at level 3).  Since we already have
> 		 * a Get-Max-LUN request, we won't lose much by setting the
> 		 * revision level down to 2.  The only devices that would be
> 		 * affected are those with sparse LUNs. */
> 		if (sdev->scsi_level > SCSI_2)
> 			sdev->sdev_target->scsi_level =
> 					sdev->scsi_level = SCSI_2;
> 
> Untangling all of this would be rather complex, I fear.

Quite likely.

> The final question is is it worth it?  Since USB devices are supposed to
> be hot unpluggable, surely a USB device with a write back cache would be
> a disaster: no-one will SYNC the cache on a surprise unplug anyway ...
> therefore there shouldn't really be any of them surviving in the wild
> (famous last words, I suppose).

Well, hot unpluggable doesn't mean it's okay to unplug the device at 
any time.  For example, under Windows you're not supposed to unplug a 
USB drive without first going through the "Safely remove hardware" 
applet.  And of course, you can easily guess what command that applet 
sends to the device...

On the whole, I'm with Luben on this.  The likelihood of introducing
bad behavior because of devices sending incorrect cache-page
information seems very small.

Alan Stern

