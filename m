Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1GSO0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 10:26:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750980Ab1GSO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 10:26:41 -0400
Date: Tue, 19 Jul 2011 10:26:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Seth Forshee <seth.forshee@canonical.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
In-Reply-To: <20110718224458.GD19552@thinkpad-t410>
Message-ID: <Pine.LNX.4.44L0.1107191006450.1895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Seth Forshee wrote:

> On Mon, Jul 18, 2011 at 05:12:35PM -0400, Alan Stern wrote:
> > On Mon, 18 Jul 2011, Seth Forshee wrote:
> > 
> > > The following patch is in response to a consistently reproducible
> > > failure to freeze tasks prior to restoring a hibernation image on a
> > > Toshiba NB505 netbook. This machine has a built-in USB card reader.
> > > Since the usb-stor-scan task is freezable but the code in
> > > quiesce_and_remove_host() that waits for scanning to complete is not,
> > > khubd can fail to freeze when processing the disconnect for the card
> > > reader.
> > 
> > What card-reader disconnect?
> 
> The call trace (below) shows that the code is processing a device
> disconnection when this happens. I don't know what triggers it. I take
> it from your response that this isn't expected (sorry, I'm not really
> all that familiar with USB)?

But why is there a disconnect at this time?  Maybe you could find out 
if you collect the kernel log from the boot kernel (serial console or 
network console).

It appears that you had the bad luck to begin restoring from
hibernation just after the card reader was disconnected!  If the
restore had been started a few seconds later instead, after the
disconnect processing was finished, it would have worked.

> > > It seems that both should either be freezable or not freezable. Since
> > > there doesn't currently seem to be any freezable way to wait on a
> > > completion, I started with the simpler approach of making usb-stor-scan
> > > non-freezable. If it would be preferable to make both freezable I can
> > > take that approach instead.

BTW, I didn't say anything before but this is wrong -- both threads
already _are_ freezable.  The problem is that the khubd thread has to
wait for the usb-stor-scan thread to finish before it can be frozen,
and this doesn't work if usb-stor-scan has already been frozen.

> > I'm not sure what the best approach is.  usb-stor-scan has to be
> > freezable, because the scanning code registers new child device
> > structures, which isn't allowed during suspend or hibernation.
> 
> Unless there's some way to ensure we won't wait on scanning during
> freezing, I don't really see any option besides making the wait
> freezable.

Maybe it would be better to come up with a freezable version of 
wait_for_completion().  You should ask for advice on the linux-pm 
mailing list.

Alan Stern

