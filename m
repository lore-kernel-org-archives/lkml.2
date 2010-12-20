Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0LTJRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:17:04 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:32887 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab0LTJRB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:17:01 -0500
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Mon, 20 Dec 2010 10:15:37 +0100
Subject: RE: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Thread-Topic: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Thread-Index: Acuf0B8/4AfC7fTjQayxd6fgNcIo2wAVFLow
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA3348A3A516@EXDCVYMBSTM005.EQ1STM.local>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<AANLkTimCYea+G7Z+o-2BDCGHbRobM2n+VJLLcDO6g=9d@mail.gmail.com>
 <AANLkTi=J1AdOgxA_S9p9Ts65PL3Mi5NXXWMf0f-=0AwN@mail.gmail.com>
In-Reply-To: <AANLkTi=J1AdOgxA_S9p9Ts65PL3Mi5NXXWMf0f-=0AwN@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> -----Original Message-----
> From: Vitaly Wool [mailto:vitalywool@gmail.com]
> Sent: den 19 december 2010 23:58
> To: Linus Walleij
> Cc: Par-Gunnar HJALMDAHL; Pavan Savoy; Alan Cox; Arnd Bergmann; Samuel
> Ortiz; Marcel Holtmann; linux-kernel@vger.kernel.org; linux-
> bluetooth@vger.kernel.org; Lukasz Rymanowski; Par-Gunnar Hjalmdahl
> Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
> 
> Hi Linus,
> 
> On Sun, Dec 19, 2010 at 10:23 PM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
> > I'm slightly confused by different comment threads on this patch set.
> 
> let me first first repost the part from Arnd's email on the
> architecture of the "shared transport" type of thing:
> 
> > I believe we already agree it should be something like
> >
> >   bt   ti-radio    st-e-radio    ti-gps   st-e-gps  broadcom-radio
> ...
> >   |         |          |            |          |          |         |
> >   +---------+----------+---------+--+----------+----------+---------+
> >                                  |
> >                         common-hci-module
> >                                  |
> >                      +-----------+-----------+
> >                      |        |       |      |
> >                    serial    spi     i2c    ...
> 
> I think an explanation on how the patchset from Par maps to this
> architecture could be a good starting point for confusion minimization
> :)
> 
> Thanks,
>    Vitaly

I would say our design would map like this:
common-hci-module: cg2900_core
serial, spi, i2c,... : cg2900_uart together with hci_ldisc (for other transports it would be different files)
bt, ti-radio, st-e-radio,...: cg2900_chip together with btcg2900 and other users per channel (cg2900_char_devices for users in User space)
So it is not a 1-to-1 mapping for the upper parts. I would draw it like this:

                               bt   st-e-radio  st-e-gps
                                |         |          |
                                +---------+----------+
                                          |
                   ti-xx                st-e cg2900...
                     |                    |
                     +---------+----------+
                               |
                       common-hci-module
                               |
                   +-----------+-----------+
                   |        |       |      |
                 serial    spi     i2c    ...

The reason for this difference I've gone through before. Basically there are so many special behaviors and needed handling that is individual for each chip (like startup and shutdown and in the case of CG2900 flow control over FM and BT channels for audio commands). If you then look at the users I guess it would be possible to have one BT user, but it would have to be modified to handle vendor specific commands (as btcg2900 does with BT_ENABLE command). As Arnd has drawn for FM and GPS the users would be completely individual since they don't have a standardized  interface.

/P-G
