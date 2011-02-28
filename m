Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1B1POp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:14:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1B1POn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:14:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar HJALMDAHL" <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 suppor
Date: Mon, 28 Feb 2011 16:01:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <201101091955.05174.arnd@arndb.de> <AFCDDB4A3EA003429EEF1E7B211FDBBA334A54F4B1@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA334A54F4B1@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Message-Id: <201102281601.10982.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:7ChXBfWA1+wgABMlzzfl9vlb++Muj2jZzU6D8tP6bRK
 kP6H5IPknohR5MGkWI7gbJkzM4lcfVTJQQjAVGRlWHTU+l9sur
 JiyNcv9df/rt+AVGZmv+NixOJANqxX9ZRMyfk+6+9Dsu+FBgWV
 YUCtJCbcsCSvZIHp7ivQ3+f5FMdaCLfT8go1GNkliMJtokz6yL
 W47jYXWIYYb69BuMLwhMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pär-Gunnar,

Sorry for the long delay, this time on my side.

On Thursday 24 February 2011, Par-Gunnar HJALMDAHL wrote:
> I sent the mail below one month ago, but have still not received any answers or further comments.
> Has anyone of you who made comments on the CG2900 patches earlier, any more comments or questions?

I tend to procrastinate replying to emails when it's a lot of work, and
yours dropped off the radar. I have not even read it until now, because
it's too long, has broken line-wraps and does not crop the citations
to a minimum. If you want people to listen to what you have to say, try
following email netiquette and put a little more effort into clear
communication like the rest of us do.

Please excuse my ignorance about topics we have already discussed here,
I don't know much about bluetooth and had to reread all the discussions
and patches.

> It is unclear to me where we stand with the CG2900 patches. I am myself happy with the
> current architecture, but I understand there are differing opinions.
> I would like to know what we need to do in order to get this driver into the Linux Kernel tree.

I have no idea what the current architecture is. In doubt, keep re-posting
the patches until all differences are resolved. If a thread does not
get a new message within a week, you can normally assume that poeple
no longer bother reading, and you should try harder to get feedback,
e.g. by sending a reminder that you are waiting or by resending
the modified patch set.

I still haven't looked at the patches from December, but I assume that
the code has changed in the meantime. Please go ahead and post the
current version again, then we can discuss the new code.

On Monday 17 January 2011, Par-Gunnar HJALMDAHL wrote:
> Arnd Bergmann wrote:
> > 
> > Good point about hciattach, you certainly shouldn't need to use that if
> > the kernel already knows that a tty is connected to an HCI and what the
> > parameters are. Even more so if the HCI is not actually on a rs232 line
> > but something like i2c or spi. Automatically binding to the right line
> > discipline should be easily doable in the drivers though.
> > 
> 
> When having UART as transport you need something to open the UART and set the
> line discipline. If this is hciattach or something else is up to each developer
> to suit what they are doing. I don't see a problem with using hciattach even 
> if you don't use the Bluetooth part (if the exe is part of the system anyway),
> but if a company/developer want to use something else they can do that. It's a
> usage of standard interfaces using open() and ioctl().

That's not what I meant. You don't really need to use the ioctl if the
kernel already knows what the device does. Just call tty_set_ldisc from
an appropriate location in the code.

> I still don't think that you should have a line discipline for other transports
> than UART. If I would look at how I would implement an SPI driver for CG2900,
> there would almost be no code that could be used in common between cg2900_uart 
> and cg2900_spi. SPI doesn't change baud rate, SPI uses commands for sleep/wake
> instead of Break, SPI packets doesn't need extra packetizing, etc.

If you don't want the others to be handled in a line discipline, you should
start out with a patch that splits the hci uart protocol registration from the
line discipline code in drivers/bluetooth/hci_ldisc.c. Today, you can have
multiple HCI drivers in the system, but only the serial one can have
subprotocols.

> > I don't understand the problem with relying on the hci-uart or hci-h4
> > modules. If the hardware uses the H4 protocol, we certainly should use
> > the kernel module that knows how to deal with H4, and we don't want
> > to have two modules implementing the same protocol.
> > 
> 
> I must say I don't understand this problem either. Unless the protocol driver is
> activated through ioctl SET_PROTOCOL, the code will not be executed, and the amount
> of ROM needed is negligible.
> If you look at our submission, the hci-h4 could possibly be reused to some extent.
> Basically the packetizing to the Bluetooth H4 channels 1-4 could be re-used. In order 
> to allow for vendor specific channels to be handled some new registration system on
> top of hci-h4 plus a callback system for data reception would have to be added (in 
> order to facilitate systems that do not want all data to be sent directly to the
> Bluetooth stack such as the CG2900 driver). I'm afraid that we would have a 
> significantly more complex system and larger amount of code if we would try to generalize
> the hci-h4 module. I definitely prefer the current model where a vendor specific driver
> replaces the hci-h4 protocol driver.

Then remove the hci-h4 driver from the kernel and make sure that your driver can
handle all the hardware that h4 can today, using identical user interfaces.

Two infrastructure drivers doing almost the same thing are not acceptable.
We sometimes have device drivers that are meant for the same hardware, but
then one of them is going away over time, when it is shown that the new one
does everything we need. For infrastructure, this is not as easy, because
then you get other people writing new backend for both of them and they
won't be interoperable.
 
> > The one important goal here should be to avoid code duplication.
> > Using the header to get the data structures from separate code
> > means you need to have similar parsing functions in each of the modules
> > using it. Not sharing the header wouldn't help, because then you end
> > up duplicating even more. The real solution, speaking very broadly,
> > must be to have a general module that deals with whatever the more
> > specific modules have in common, and have a header file that defines
> > the interface to it.
> > 
> 
> In general I agree with you, but there are some problems here.
> The most used BT HCI events are Command Status and Command Complete.
> Command Status could be parsed completely in a good way (retrieving op
> code, nbr of commands allowed, and status of command sent).
> Command Complete is however quite complex since the returned data will
> differ depending on command sent. Op code and nbr of commands allowed can
> be retrieved but everything else have to be extracted differently depending
> on command. This means that there is not much that will be saved here. But
> maybe we could extract some parsing into common functions, but I don't
> think you would gain that much.
>
> Moreover, this would lead to a major reimplementation of the hci_core.c and
> related files, since they do not use any exported common functions as it is
> today. I do not know if they (BlueZ community) would want this and I do not
> think that that should be part of the CG2900 driver to do. It should in that
> case be done separately.

No. If hci_core is not sufficient to work with cg2900, the answer is certainly
not to ignore hci_core and roll your own copy. Can you give an example
of how the command complete logic needs to react to different commands?
Can this be done using callbacks into the code that initially sent the
commands?

> For the CG2900 that is not possible. Even if you are running just GPS you
> still must download patches and settings and that is done through HCI
> commands over the Bluetooth command interface. We also use Bluetooth
> commands to identify the controller.

I don't understand. Do you mean the settings are sent over the wireless
interface in order to control devices that are connected directly to
the HCI? Why would you do that instead of just attaching the
GPS to the HCI on the non-bluetooth side?

	Arnd

