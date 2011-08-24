Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1HXLCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:02:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61663 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab1HXLCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:02:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6447"; a="112526925"
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "j@w1.fi" <j@w1.fi>
X-IronPort-AV: E=Sophos;i="4.68,273,1312182000"; 
   d="scan'208";a="64222036"
Message-ID: <4E54DA38.1000408@qca.qualcomm.com>
Date: Wed, 24 Aug 2011 14:02:16 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [RFC 0/4] sdhci: few patches for ENE 712 support
References: <1300486320-23607-1-git-send-email-lrodriguez@atheros.com> <20110319091544.GA16635@pengutronix.de> <20110330011629.GA15578@tux> <20110330074713.GA2232@pengutronix.de>
In-Reply-To: <20110330074713.GA2232@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.234.11.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

going back to an old thread from March:

https://lkml.org/lkml/2011/3/18/433

Background:

Luis had problems with ath6kl (driver for ar6003 wifi chip using sdio)
and PCI ENE 712 SDIO extender and he had to use few ugly patches to get
it working. Later this year I inherited all this. I have been using the
hack patches until now but finally I started debugging this and I can
provide more information.

On 03/30/2011 10:47 AM, Wolfram Sang wrote:
>
>> I just tried this, it does not work, in fact my own my patches don't
work too,
>> only the original crap does though for some odd magical reason.
>>
>> Then again, what I tried was:
>>
>> insmod ./sdhci.ko debug_quirks=0x8028
>>
>> Was that what you wanted me to try?
>
> Yes. I assume this would have helped also (assuming that the original
> patchset was working), but looks like more investigation is needed.

I tried 0x8028 as well and it didn't help. But what I noticed was that
enabling SDHCI_QUIRK_FORCE_1_BIT_DATA with 0x00400038 makes it work.

Also I did some debugging on the hack patches and found out that the
hack patch below also makes ath6kl work with my ENE card. As suspected,
rest of the changes from the patches Luis sent were not needed.

http://www.valot.fi/kalle/tmp/sdhci-ene/sdhci-ene-idle-1bit-1.patch

So only needed change was to force 1 bit mode while the bus is idle. Any
ideas what would be the best way to fix this?

I'm currently using 3.1.0-rc2-wl+ from ath6kl.git which is based on
wireless-testing on an x86 32bit box. I can provide more information and
logs.

>> 03:0a.1 0805: 1524:0750
>
> Okay, so you have PCI_DEVICE_ID_ENE_CB714_SD and not
> PCI_DEVICE_ID_ENE_CB714_SD_2 (just in case they need to be dealt
> differently).

This is the device I have, it should be similar (if not the same) as Luis':

03:02.1 SD Host controller [0805]: ENE Technology Inc ENE PCI SmartMedia
/ xD Card Reader Controller [1524:0750] (prog-if 01)
        Subsystem: ENE Technology Inc ENE PCI SmartMedia / xD Card
Reader Controller [1524:0750]
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: sdhci-pci
00: 24 15 50 07 02 00 10 02 00 01 05 08 08 40 80 00
10: 00 f8 bf fe 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 24 15 50 07
30: 00 00 00 00 80 00 00 00 00 00 00 00 05 01 20 48

>>> And does it make a difference if you use the SDIO-WLAN card or a
standard SD
>>> memory card?
>>
>> Um, I don't have physical access to the box, Naveen or Vipin would
have to
>> test this.
>
> Might be worth.

I tried with my 1GB SD card from my camera and oddly enough I didn't see
any new devices in /dev/sd*. But I don't know if I was missing some
important kernel config options, I have used this ENE card only with
ath6kl. I will retest this later.

Kalle
