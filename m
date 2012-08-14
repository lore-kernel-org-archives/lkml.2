Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2HNFz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:55:27 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36570 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2HNFz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:55:26 -0400
Date: Tue, 14 Aug 2012 07:55:24 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: psmouse synaptics: "hardware appears to be different" bail out
Message-ID: <20120814055524.GA14314@rhlx01.hs-esslingen.de>
References: <20120716214453.GA14785@rhlx01.hs-esslingen.de>
 <20120716220718.GA28635@core.coreip.homeip.net>
 <20120720182145.GA14622@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720182145.GA14622@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 20, 2012 at 08:21:45PM +0200, Andreas Mohr wrote:
> Hi,
> 
> On Mon, Jul 16, 2012 at 03:07:19PM -0700, Dmitry Torokhov wrote:
> > On Mon, Jul 16, 2012 at 11:44:53PM +0200, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > just found the following in dmesg after resume
> > > (currently running -rc7):
> > > 
> > > [ 9312.672073] psmouse serio2: synaptics: hardware appears to be
> > > different: id(149271-149271), model(114865-114865), caps(d04771-d04773),
> > > ext(a40000-a40000).
> > > 
> > > Acer Aspire One A110L here.
> > > 
> > > Any clever thoughts about this?
> > > Just thought that it might be useful to report it,
> > > especially since the function (in drivers/input/mouse/synaptics.c)
> > > bails out right after this check/message.
> > 
> > Hmm, we do not really expect the touchpad change it's caracteristics at
> > all during its lifetime, so no clever ideas here... It looks like a
> > single bit error, but KBC should have signalled parity error in this
> > case...
> 
> OK, that might be true in fact.
> I disassembled that device recently (and did quite a bit of work),
> so perhaps the touchpad connection isn't as reliable as I'd want it to
> be...
> 
> 
> Problem is that now (and some other times, too) S2R resume
> ended up with a dead x.org keyboard (synaptics i.e. mouse pointer
> was still working fine).
> Remote login was ok.
> 
> In dmesg, I found:
> 
> [   13.694115] atkbd serio0: Spurious NAK on isa0060/serio0. Some
> program might be trying to access hardware directly.
> 
> and then
> 
> [ 8278.484469] atkbd serio0: Spurious ACK on isa0060/serio0. Some
> program might be trying to access hardware directly.
> 
> which is the one that occurred around the time of the S2R breakage.
> I then triggered a remote pm-suspend,
> and after S2R keyboard WAS FINE AGAIN, with NO dmesg error logged this
> time!!

Hi,

happened again, this time with different but quite ominous messages
("Unable to initialize device."):

[15520.944017] PM: resume of devices complete after 1049.856 msecs
[15520.950597] PM: resume devices took 1.060 seconds
[15520.950787] PM: Finishing wakeup.
[15520.950793] Restarting tasks ... done.
[15520.990705] video LNXVIDEO:00: Restoring backlight state
[15521.107761] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[15521.107774] Bluetooth: BNEP filters: protocol multicast
[15521.287109] Bluetooth: RFCOMM TTY layer initialized
[15521.287158] Bluetooth: RFCOMM socket layer initialized
[15521.287168] Bluetooth: RFCOMM ver 1.11
[15521.347768] atkbd serio0: Spurious ACK on isa0060/serio0. Some
program might be trying to access hardware directly.
[15521.352164] mmc0: new SDHC card at address b368
[15521.357576] mmcblk0: mmc0:b368       14.9 GiB 
[15521.370884]  mmcblk0: p1
[15521.540130] psmouse serio2: synaptics: Unable to initialize device.
[15522.644250] psmouse serio2: synaptics: Touchpad model: 1, fw: 7.2,
id: 0x1c0b1, caps: 0xd04773/0xa40000/0xa0000
[15522.700396] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio2/input/input12
[15523.299199] r8169 0000:02:00.0: eth1: link down

Identical symptoms: touchpad mighty fine, keyboard DEAD. Remote pm-suspend
fixed everything.
This time this occurred at the first suspend after initial kernel bootup
(not sure about previous incidents).

Log of the subsequent second resume that managed to repair the state:

[16584.645148] PM: resume of devices complete after 1052.387 msecs
[16584.648803] PM: resume devices took 1.050 seconds
[16584.648996] PM: Finishing wakeup.
[16584.649002] Restarting tasks ... done.
[16584.684401] video LNXVIDEO:00: Restoring backlight state
[16585.041476] mmc0: new SDHC card at address b368
[16585.055439] mmcblk0: mmc0:b368       14.9 GiB 
[16585.058917]  mmcblk0: p1
[16585.330295] r8169 0000:02:00.0: eth1: link up

Note the large amount of *missing* input device messages (all due to error
condition?) in the non-fatal case.


"Some program might be trying to access hardware directly." - mayhaps
on resume we've got some BIOS DMI handlers fumbling things
that they shouldn't fumble?

Still running -rc7, though (time for upgrade treadmill, I know ;).

Thanks,

Andreas Mohr
