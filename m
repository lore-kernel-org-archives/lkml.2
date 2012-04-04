Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2DDEyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 00:54:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53020 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab2DDEyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 00:54:45 -0400
Date: Wed, 4 Apr 2012 06:54:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Alessandro Rubini <rubini@cvml.unipv.it>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: psmouse serio4: bad data from KBC - timeout
Message-ID: <20120404045440.GB28344@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	Alessandro Rubini <rubini@ipvvis.unipv.it>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120403094324.GA3346@gere.osrc.amd.com>
 <20120403170659.GF24832@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120403170659.GF24832@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Apr 03, 2012 at 10:06:59AM -0700, Dmitry Torokhov wrote:
> > I'm running 3.4-rc1 on a thinkpad x121e and it builds and boots just
> > fine. However, after resuming from disk I get (this is the tail of
> > dmesg):
> > 
> > [  905.857412] i8042: failed to resume active multiplexor, mouse won't work
> > [  905.965568] usb 3-2: reset low-speed USB device number 2 using ohci_hcd
> > [  907.626998] psmouse serio4: bad data from KBC - timeout
> > [  907.675385] PM: restore of devices complete after 2358.155 msecs
> > [  908.227481] Restarting tasks ... done.
> > [  908.266229] video LNXVIDEO:01: Restoring backlight state
> > [  917.628792] psmouse serio4: Failed to deactivate mouse on isa0060/serio4
> > [  917.880639] psmouse serio4: Failed to enable mouse on isa0060/serio4
> > [  919.867982] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input19
> > [  947.277011] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
> > [  996.231116] Bluetooth: Core ver 2.16
> > [  996.231262] NET: Registered protocol family 31
> > [  996.231273] Bluetooth: HCI device and connection manager initialized
> > [  996.231559] Bluetooth: HCI socket layer initialized
> > [  996.231575] Bluetooth: L2CAP socket layer initialized
> > [  996.231630] Bluetooth: SCO socket layer initialized
> > 
> > and after that the keyboard and the mouse touchpad don't work. The
> > connected USB mouse works fine though.
> 
> There weren't any changes to i8042 for a while so I'd look into recent
> ACPI/PM merges. You can also try booting with i8042.nomux to see if it
> will work better with i8042 in legacy multiplexing mode.

thanks for looking into this.

So, I just tested the "i8042.nomux" command line option and it seems to
work. Even the touchpad went on after rubbing on it a couple of times
initially.

Then, I booted back into 3.4-rc1 without the above option and here's
what I got again:

[    0.924424] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    0.928313] i8042: Detected active multiplexing controller, rev 1.1
[    0.929966] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.930628] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.930890] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.931175] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.931343] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.971523] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.086110] psmouse serio4: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x121c00
[    2.086378] psmouse serio4: synaptics: serio: Synaptics pass-through port at isa0060/serio4/input0
[    2.127547] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input1
[    7.880045] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input2
[  193.757348] i8042: failed to resume active multiplexor, mouse won't work

It seems the mux controller doesn't resume properly (doh, it says so
:)) so not only mousepad but keyboard is not working too.

Actually, that's not 100% correct: the keyboard does work for a short
period of time (a couple of seconds, judging by the printk timestamps
below) right after I resume and then it stops ...

[  195.526425] psmouse serio4: bad data from KBC - timeout
[  205.532397] psmouse serio4: Failed to deactivate mouse on isa0060/serio4
[  205.772260] psmouse serio4: Failed to enable mouse on isa0060/serio4
[  207.447644] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input15

.. with the above being the last line on dmesg.

So, I'm ready for suggestions.

Thanks.

-- 
Regards/Gruss,
    Boris.
