Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab1GSRVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 13:21:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56614 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1GSRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 13:21:33 -0400
Date: Tue, 19 Jul 2011 12:21:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
Message-ID: <20110719172125.GA27236@thinkpad-t410>
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

I'm not sure which kernel you mean by 'boot' kernel. The machine doesn't
have a serial port, and network console seems to stop too early to get
any interesting data during hibernation. I took photographs of the
console on the LCD as the machine hibernated, but I didn't really see
anything interesting there.

Getting logs after the failed restore is easy though, and that log looks
more interesting. There are some errors, followed later by an status
change event showing that the PORT_CONNECT and PORT_PE bits have been
cleared. Here's the relevant secton of the log. These errors and the
disconnect don't appear in a normal boot.

[    1.900069] usb 1-8: new high speed USB device number 3 using ehci_hcd
[    1.960234] ehci_hcd 0000:00:1d.7: port 8 high speed
[    1.960247] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    1.960802]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.962122] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.964697] Initializing USB Mass Storage driver...
[    1.964827] usb-storage 1-4:1.0: usb_probe_interface
[    1.964852] usb-storage 1-4:1.0: usb_probe_interface - got id
[    1.964922] usbcore: registered new interface driver usb-storage
[    1.964930] USB Mass Storage support registered.
[    1.967261] ums-realtek 1-4:1.0: usb_probe_interface
[    1.967274] ums-realtek 1-4:1.0: usb_probe_interface - got id
[    1.984640] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 1
[    1.984739] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 2
[    1.984871] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 3
[    1.984995] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 4
[    1.985120] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 5
[    1.985246] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 6
[    1.985370] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 7
[    1.985496] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 8
[    1.985619] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 9
[    1.985746] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 10
[    1.985869] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 11
[    1.985996] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 12
[    1.986120] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 13
[    1.986246] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 14
[    1.986371] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 15
[    1.986496] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 16
[    1.986620] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 17
[    1.986746] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 18
[    1.986870] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 19
[    1.986997] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 20
[    1.987120] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 21
[    1.987246] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 22
[    1.987370] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 23
[    1.987496] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 24
[    1.987620] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 25
[    1.987746] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 26
[    1.987870] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 27
[    1.987996] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 28
[    1.988120] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 29
[    1.988246] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 30
[    1.988370] ehci_hcd 0000:00:1d.7: detected XactErr len 0/13 retry 31
[    1.988496] ehci_hcd 0000:00:1d.7: devpath 4 ep2in 3strikes
[    1.988635] scsi4 : usb-storage 1-4:1.0
[    1.988983] usbcore: registered new interface driver ums-realtek
[    2.290054] usb usb2: suspend_rh (auto-stop)
[    2.290086] usb usb4: suspend_rh (auto-stop)
[    2.290112] usb usb3: suspend_rh (auto-stop)
[    2.290138] usb usb5: suspend_rh (auto-stop)
[    2.527488] PM: Starting manual resume from disk
[    2.527498] PM: Hibernation image partition 8:6 present
[    2.527503] PM: Looking for hibernation image.
[    2.614099] PM: Image signature found, resuming
[    2.615567] PM: Marking nosave pages: 000000000009d000 - 0000000000100000
[    2.615580] PM: Basic memory bitmaps created
[    2.615586] PM: Preparing processes for restore.
[    2.615591] Freezing user space processes ... (elapsed 0.01 seconds) done.
[    2.630126] Freezing remaining freezable tasks ... 
[    2.899934] usb 1-8: skipped 1 descriptor after configuration
[    2.899947] usb 1-8: skipped 5 descriptors after interface
[    2.899959] usb 1-8: skipped 1 descriptor after endpoint
[    2.899973] usb 1-8: skipped 17 descriptors after interface
[    2.901022] usb 1-8: default language 0x0409
[    2.911410] usb 1-8: udev 3, busnum 1, minor = 2
[    2.911422] usb 1-8: New USB device found, idVendor=0bda, idProduct=5801
[    2.911432] usb 1-8: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    2.911443] usb 1-8: Product: USB Camera
[    2.911451] usb 1-8: Manufacturer: XTB5SFGS
[    2.911459] usb 1-8: SerialNumber: 200901010001
[    2.911676] usb 1-8: usb_probe_device
[    2.911685] usb 1-8: configuration #1 chosen from 1 choice
[    2.916408] usb 1-8: adding 1-8:1.0 (config #1, interface 0)
[    2.917762] usb 1-8: adding 1-8:1.1 (config #1, interface 1)
[    2.917874] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.917893] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    2.917902] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0010
[    2.917919] ehci_hcd 0000:00:1d.7: GetStatus port:4 status 001002 0  ACK POWER sig=se0 CSC
[    2.917935] hub 1-0:1.0: port 4, status 0100, change 0001, 12 Mb/s
[    2.917943] usb 1-4: USB disconnect, device number 2
[    2.917948] usb 1-4: unregistering device
[    2.917954] usb 1-4: unregistering interface 1-4:1.0
[   22.650106] 
[   22.650122] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):

> It appears that you had the bad luck to begin restoring from
> hibernation just after the card reader was disconnected!  If the
> restore had been started a few seconds later instead, after the
> disconnect processing was finished, it would have worked.

It's definitely a case of unfortunate timing.

> > > > It seems that both should either be freezable or not freezable. Since
> > > > there doesn't currently seem to be any freezable way to wait on a
> > > > completion, I started with the simpler approach of making usb-stor-scan
> > > > non-freezable. If it would be preferable to make both freezable I can
> > > > take that approach instead.
> 
> BTW, I didn't say anything before but this is wrong -- both threads
> already _are_ freezable.  The problem is that the khubd thread has to
> wait for the usb-stor-scan thread to finish before it can be frozen,
> and this doesn't work if usb-stor-scan has already been frozen.

Right, what I meant was to make the wait on the completion freezable. I
should have been clearer.

> > > I'm not sure what the best approach is.  usb-stor-scan has to be
> > > freezable, because the scanning code registers new child device
> > > structures, which isn't allowed during suspend or hibernation.
> > 
> > Unless there's some way to ensure we won't wait on scanning during
> > freezing, I don't really see any option besides making the wait
> > freezable.
> 
> Maybe it would be better to come up with a freezable version of 
> wait_for_completion().  You should ask for advice on the linux-pm 
> mailing list.

That's what I'm planning to look into as soon as I get a chance.

Thanks for your help.
