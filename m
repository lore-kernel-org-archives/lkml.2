Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0LQMoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:44:09 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:49894 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621Ab0LQMoI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:44:08 -0500
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Fri, 17 Dec 2010 13:43:42 +0100
Subject: RE: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Thread-Topic: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Thread-Index: Acud44r8EN6eALs2TXGDvY+MlY2+7wAAo9pQ
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA33489D2B94@EXDCVYMBSTM005.EQ1STM.local>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <AANLkTikboaQGMGTVchXyo6tidtq7c33KDRU2puL1youv@mail.gmail.com>
In-Reply-To: <AANLkTikboaQGMGTVchXyo6tidtq7c33KDRU2puL1youv@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> -----Original Message-----
> From: Vitaly Wool [mailto:vitalywool@gmail.com]
> Sent: den 17 december 2010 13:11
> To: Par-Gunnar HJALMDAHL
> Cc: Pavan Savoy; Alan Cox; Arnd Bergmann; Samuel Ortiz; Marcel
> Holtmann; linux-kernel@vger.kernel.org; linux-
> bluetooth@vger.kernel.org; Lukasz Rymanowski; Linus WALLEIJ; Par-Gunnar
> Hjalmdahl
> Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
> 
> Hi Par,
> 
> On Fri, Dec 17, 2010 at 12:20 PM, Par-Gunnar Hjalmdahl
> <par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> > This is the 3rd patch set for the ST-Ericsson CG2900 connectivity
> > controller. The CG2900 is a combo controller supporting GPS,
> Bluetooth,
> > and FM radio. It uses HCI H:4 protocol to combine different
> functionalities
> > on a common transport, where first byte in the data indicates the
> current
> > channel. Channels 1-4 are standardized in the Bluetooth Core
> specification
> > while the other channels are vendor specific.
> >
> > Compared to 2nd patch set this patch set has the following changes:
> >  * UART handling is moved from mfd to bluetooth folder. It now reuses
> the
> >   existing N_HCI line discipline.
> >  * mfd creation has been moved from cg2900_core into chip specific
> files.
> >  * All information for each channel, including API functions, exist
> in each
> >   MFD devices, making them independent of each other.
> >  * All chip specific information has been moved from cg2900_core into
> the
> >   chip specific files. cg2900_core now only handles registration and
> >   connection between transport and chip driver.
> >  * Fixes for several review comments including use of existing debug
> system.
> 
> this patchset has only multiplied my confusion.
> 
> Not really diving into the details, I'm just trying to understand how
> I'd rewrite the TI shared transport using your approach if I had to.
> It looks like I'd have to, at least:
>  - implement a heavyweight line discipline driver (like cg2900_uart.c)
> half duplicating the functionality in yours;
>  - implement specific MFD driver.
> 
> Actually the reuse of this implementation will be at a level of
> statistics error. The only thing to reuse is actually the approach
> which I'm not really happy about.
> 
> So...
> 
> If you are aiming for a generic solution, then why you get more and
> more things handled in cg2900-specific code (e. g. packet routing
> which is fairly generic)?
> 

You are absolutely correct that there is not much that is generic and the reason for this is that it is not much that is generic. If you for example look at packet routing the method can be considered pretty generic. Check first byte and choose a structure type... But first of all this must be done with minimum overhead since it is done on every packet received. And secondly if you look at number of lines of code, it is not really much you save.
If you look closer at the code for the CG2900 you will see that the majority of the code is things that you could probably never apply to the chip of another vendor. A lot of the code in e.g. cg2900_chip.c is regarding bt_audio and fm_audio, which is really chip specific.
Also, if you want to keep the structure modular and supporting e.g. multiple transports with the same chip driver, you must focus on what is chip specific, what is transport specific, and what is chip and transport specific. When you start to think about it like this it becomes very hard to make too much code generic. Usually what you get with that kind of generic code is a solution way more complex than you started out with.

> If you are solving your particular problems, isn't the change too
> dramatic e. g. when it comes to line discipline drivers and baudrate
> manipulation?
> 

The changes in hci_ldisc.c is not what I would call dramatic. It is quite simple functions. As I've stated earlier, if people object to this, there is no big issue to solve this within cg2900_uart.c instead. But we think that these API functions are a proper extension to the current hci_ldisc API.

> As of now, I really see no reason why anyone would promote this
> solution instead of making something more generic out of ti-st and
> reusing it then.
> 
> Thanks,
>    Vitaly

Just to be clear, I have no problem with having both solutions (our and ti-st) side by side. They are structured quite differently and has different focus. I'm in no way trying to replace ti-st. I'm not trying to force anyone into using our structure.

/P-G

