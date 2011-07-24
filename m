Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1GXB4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 21:56:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38780 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751795Ab1GXB4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 21:56:17 -0400
Date: Sat, 23 Jul 2011 21:56:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Seth Forshee <seth.forshee@canonical.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
In-Reply-To: <20110723210805.GA25113@thinkpad-t410>
Message-ID: <Pine.LNX.4.44L0.1107232150380.27037-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Seth Forshee wrote:

> After experimenting with this device more I came to the conclusion that
> the normal behavior with this machine is for the card reader to be
> disconnected from the USB bus unless there's a card in the slot. During
> a normal boot with an empty card slot the card reader never shows up on
> the bus.

Weird.  Then the reader would never be usable.  Unless it connects 
itself to the bus when a card is inserted?

>  But for some reason after S4 it shows up, but then some
> transaction errors happen due to no card being present (I can trigger
> the same errors by quickly inserting and removing a card) and the device
> is disconnected. This is only after S4 though -- if I set the
> hibernation mode to reboot or shutdown the errors don't happen. And I do
> not see the errors if I hibernate and then boot up with noresume, so
> it's not something that happens as a result of the restore process.
> 
> So at this point I'm pretty convinced that this is some kind of firmware
> issue and that there isn't much hope of fixing it. It's not even
> something that can be fixed by patching the AML, as no GPEs or AML
> methods are coming into play when all this happens.
> 
> > Maybe it would be better to come up with a freezable version of 
> > wait_for_completion().  You should ask for advice on the linux-pm 
> > mailing list.
> 
> I tried this, and it doesn't work. Well, it works in the sense of
> freezing khubd, but then khubd is frozen holding the mutex for the
> device, and the restore hangs later while trying to suspend devices.

Ah yes.  So much for that idea.

> The only solution I've come up with is to leave usb-stor-scan freezable
> without allowing it to actually freeze. We can request a fake signal be
> sent when freezing and use interruptible sleep to abort the wait early
> and finish up the thread's processing. This is implemented in the patch
> below. Does this approach look reasonable? It's rather subtle, but it
> does seem to work. I done numerous S4 cycles with and without a card
> inserted and didn't get any failures.

This runs the risk of failing to suspend if scanning takes too long.  

On the other hand, many systems nowadays use async scanning anyway.
And that combination of events isn't too likely to happen, whereas 
you're facing a real problem right now.  So I guess this is okay.

Alan Stern

