Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1AEM5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 07:57:45 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:35768 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab1AEM5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 07:57:43 -0500
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Vitaly Wool <vitalywool@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Wed, 5 Jan 2011 13:56:43 +0100
Subject: RE: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Thread-Topic: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Thread-Index: Acuijv9861BBvPLIRlKKpnY70eU2kAKRRdXQ
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA3348BA7DD2@EXDCVYMBSTM005.EQ1STM.local>
References: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<AANLkTimCYea+G7Z+o-2BDCGHbRobM2n+VJLLcDO6g=9d@mail.gmail.com>
	<AANLkTi=J1AdOgxA_S9p9Ts65PL3Mi5NXXWMf0f-=0AwN@mail.gmail.com>
	<AFCDDB4A3EA003429EEF1E7B211FDBBA3348A3A516@EXDCVYMBSTM005.EQ1STM.local>
 <AANLkTikxnWZNwf7AO0XnD0Y59Sdk9DMCsGtmap=H_gNk@mail.gmail.com>
In-Reply-To: <AANLkTikxnWZNwf7AO0XnD0Y59Sdk9DMCsGtmap=H_gNk@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p05Cvtfu017201

Hi Pavan,

Sorry for not answering sooner. I've been on Christmas and New Year vacation.

> -----Original Message-----
> From: Pavan Savoy [mailto:pavan_savoy@sify.com]
> Sent: den 23 december 2010 11:49
> To: Par-Gunnar HJALMDAHL
> Cc: Vitaly Wool; Linus Walleij; Alan Cox; Arnd Bergmann; Samuel Ortiz;
> Marcel Holtmann; linux-kernel@vger.kernel.org; linux-
> bluetooth@vger.kernel.org; Lukasz Rymanowski; Par-Gunnar Hjalmdahl
> Subject: Re: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
> 
> P-G, Vitaly,
> 
> >
> > I would say our design would map like this:
> > common-hci-module: cg2900_core
> > serial, spi, i2c,... : cg2900_uart together with hci_ldisc (for other
> transports it would be different files)
> > bt, ti-radio, st-e-radio,...: cg2900_chip together with btcg2900 and
> other users per channel (cg2900_char_devices for users in User space)
> > So it is not a 1-to-1 mapping for the upper parts. I would draw it
> like this:
> >
> >                               bt   st-e-radio  st-e-gps
> >                                |         |          |
> >                                +---------+----------+
> >                                          |
> >                   ti-xx                st-e cg2900...
> >                     |                    |
> >                     +---------+----------+
> >                               |
> >                       common-hci-module
> >                               |
> >                   +-----------+-----------+
> >                   |        |       |      |
> >                 serial    spi     i2c    ...
> 
> regarding the architecture above suggested...
> Is having the common-hci-module, only way ?
> Why is this dependency on bluetooth at all?
> 

The reason I use Bluetooth is that it is the only standardized Host-Controller interface in these controllers (at least in the CG2900 which I'm primarily addressing).

> for example: today I don't compile my kernel with BT support, but
> still want to use
> the chip for FM & GPS, It should be possible correct ?

Yes, I use the header files from the Bluetooth files inside the driver (for packet structures and protocol IDs). I do not use the BT binaries at all in the common-hci-module or in the st-e cg2900 module. So it should be OK to configure this out. The header files will be there any way.

> Even in TI case, although the firmware download is HCI-VS way, we
> don't use hci_core
> to interpret the responses...
> 

We don't use that either. We just use the structs and defines in the BT headers. The dependency is only in btcg2900.c which is only included if BT is configuration enabled.

> instead of common-hci-module, why not create a algo-driver layer 'ala
> i2c ? where individual drivers can register their receive handlers for
> data interpretation ?
> 

In some way you then run into the same problem has I had in previous patch sets. The functionalities supported is really determined by each chip. You might or might not have for example GPS in a certain chip. So you do not want a central module to expose all possible channels to the stacks on top. You only want the actually supported features to be exposed to upper layers. Then the MFD system is pretty nice. It's easy and modularized to expose the different channels as MFD cells.

Also note that the common-hci-module is only really used until the connected chip has been detected. The chip handler will then set the callback functions so actual data transmissions never pass the common-hci-module. They go directly from transport to chip handler. That is not really shown in the picture above. Just imagine that common-hci-module is removed after a chip has been connected and a chip handler has been determined.

I hope I haven't misunderstood your question. I do not know much about the I2C system, but I tried to understand your question as best as I could.

/P-G

���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
