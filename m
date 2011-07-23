Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab1GWVIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 17:08:17 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38178 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1GWVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 17:08:14 -0400
Date: Sat, 23 Jul 2011 16:08:05 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
Message-ID: <20110723210805.GA25113@thinkpad-t410>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
References: <20110718224458.GD19552@thinkpad-t410>
 <Pine.LNX.4.44L0.1107191006450.1895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107191006450.1895-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 10:26:39AM -0400, Alan Stern wrote:
> On Mon, 18 Jul 2011, Seth Forshee wrote:
> 
> > On Mon, Jul 18, 2011 at 05:12:35PM -0400, Alan Stern wrote:
> > > On Mon, 18 Jul 2011, Seth Forshee wrote:
> > > 
> > > > The following patch is in response to a consistently reproducible
> > > > failure to freeze tasks prior to restoring a hibernation image on a
> > > > Toshiba NB505 netbook. This machine has a built-in USB card reader.
> > > > Since the usb-stor-scan task is freezable but the code in
> > > > quiesce_and_remove_host() that waits for scanning to complete is not,
> > > > khubd can fail to freeze when processing the disconnect for the card
> > > > reader.
> > > 
> > > What card-reader disconnect?
> > 
> > The call trace (below) shows that the code is processing a device
> > disconnection when this happens. I don't know what triggers it. I take
> > it from your response that this isn't expected (sorry, I'm not really
> > all that familiar with USB)?
> 
> But why is there a disconnect at this time?  Maybe you could find out 
> if you collect the kernel log from the boot kernel (serial console or 
> network console).

After experimenting with this device more I came to the conclusion that
the normal behavior with this machine is for the card reader to be
disconnected from the USB bus unless there's a card in the slot. During
a normal boot with an empty card slot the card reader never shows up on
the bus. But for some reason after S4 it shows up, but then some
transaction errors happen due to no card being present (I can trigger
the same errors by quickly inserting and removing a card) and the device
is disconnected. This is only after S4 though -- if I set the
hibernation mode to reboot or shutdown the errors don't happen. And I do
not see the errors if I hibernate and then boot up with noresume, so
it's not something that happens as a result of the restore process.

So at this point I'm pretty convinced that this is some kind of firmware
issue and that there isn't much hope of fixing it. It's not even
something that can be fixed by patching the AML, as no GPEs or AML
methods are coming into play when all this happens.

> Maybe it would be better to come up with a freezable version of 
> wait_for_completion().  You should ask for advice on the linux-pm 
> mailing list.

I tried this, and it doesn't work. Well, it works in the sense of
freezing khubd, but then khubd is frozen holding the mutex for the
device, and the restore hangs later while trying to suspend devices.

The only solution I've come up with is to leave usb-stor-scan freezable
without allowing it to actually freeze. We can request a fake signal be
sent when freezing and use interruptible sleep to abort the wait early
and finish up the thread's processing. This is implemented in the patch
below. Does this approach look reasonable? It's rather subtle, but it
does seem to work. I done numerous S4 cycles with and without a card
inserted and didn't get any failures.

Thanks,
Seth


>From a80c164b558ae4bceabda8c3f25d9dcafe772727 Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Fri, 22 Jul 2011 16:39:31 -0500
Subject: [PATCH] usb_storage: Don't freeze in usb-stor-scan

Scanning cannot be run during suspend or hibernation, but if
usb-stor-scan freezes another thread waiting on scanning to
complete may fail to freeze.

However, if usb-stor-scan is left freezable without ever actually
freezing then the freezer will wait on it to exit, and threads
waiting for scanning to finish will no longer be blocked. One
problem with this approach is that usb-stor-scan has a delay to
wait for devices to settle (which is currently the only point where
it can freeze). To work around this we can request that the freezer
send a fake signal when freezing, then use interruptible sleep to
wake the thread early when freezing happens.

To make this happen, the following changes are made to
usb-stor-scan:

 * Use set_freezable_with_signal() instead of set_freezable() to
   request a fake signal when freezing

 * Use wait_event_interruptible_timeout() instead of
   wait_event_freezable_timeout() to avoid freezing

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/usb/storage/usb.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 0ca0958..c325e69 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -831,12 +831,22 @@ static int usb_stor_scan_thread(void * __us)
 
 	dev_dbg(dev, "device found\n");
 
-	set_freezable();
-	/* Wait for the timeout to expire or for a disconnect */
+	set_freezable_with_signal();
+	/*
+	 * Wait for the timeout to expire or for a disconnect
+	 *
+	 * We can't freeze in this thread or we risk causing khubd to
+	 * fail to freeze, but we can't be non-freezable either. Nor can
+	 * khubd freeze while waiting for scanning to complete as it may
+	 * hold the device lock, causing a hang when suspending devices.
+	 * So we request a fake signal when freezing and use
+	 * interruptible sleep to kick us out of our wait early when
+	 * freezing happens.
+	 */
 	if (delay_use > 0) {
 		dev_dbg(dev, "waiting for device to settle "
 				"before scanning\n");
-		wait_event_freezable_timeout(us->delay_wait,
+		wait_event_interruptible_timeout(us->delay_wait,
 				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
 				delay_use * HZ);
 	}
-- 
1.7.4.1

