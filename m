Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1D0Kdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:33:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43251 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1D0Kdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=cPZN5AlSye9KIMe5qkuTWBW7pM65ue/W2QuPa5rOP+dCuwDLrn3zMdKBTkIpFgXJ1S
         0Q2zCvkk8ntDjHrCiH3j9gzdTqLvJz5kv4wn3zOpVsYoTQhFo6hXww1j7fbWFHAT7Uz0
         v4TUbfU1/N1L8HTVhJaHoNosu2GbC4CS7roUQ=
MIME-Version: 1.0
In-Reply-To: <20110425201417.GB1268@comet.dominikbrodowski.net>
References: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
	<20110425140035.GA27159@comet.dominikbrodowski.net>
	<BANLkTinaCZcxDEwn-z4u1CmQRm2h+Kkocw@mail.gmail.com>
	<20110425201417.GB1268@comet.dominikbrodowski.net>
Date: Wed, 27 Apr 2011 12:33:48 +0200
Message-ID: <BANLkTiks1LaJm_phZYi36z7aSix1fe7TdA@mail.gmail.com>
Subject: Re: PCIE-to-PCI bridge doesn't pass mem resources downstream [Re:
 yenta cardbus problem]
From: =?ISO-8859-1?Q?Germ=E1n_Sanchis?= <eaglecros@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        =?ISO-8859-1?Q?Germ=E1n_Sanchis?= <eaglecros@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

Thanks for forwarding the message to the appropriate list. If there is
any other information you guys would need, or anything else I can do
to help, do let me know and I'll collect it as soon as possible.

Thanks again,

Germán Sanchis Trilles




2011/4/25 Dominik Brodowski <linux@dominikbrodowski.net>:
> Hey,
>
> thanks for the additional debug information. It seems to me to be not a
> bug with the yenta driver, but with the parent PCI bridge instead.
> Therefore, I've added Jesse and the linux-pci list as recipients. Germán's
> problem relates to Ubuntu's 2.6.35-derived kernel; lspci snippets follow.
>
> Let's look at the (grand-)parent bridge: It offers some, if not much I/O and
> memory resources for its childs to be used:
>
> 00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Bus: primary=00, secondary=04, subordinate=09, sec-latency=0
>        I/O behind bridge: 00001000-00001fff
>        Memory behind bridge: d6100000-d70fffff
>        Prefetchable memory behind bridge: 00000000d5100000-00000000d60fffff
>
> The PCI bridge, however, does only pass the I/O resources downstream, but
> _no_ memory at all.
>
> 04:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Bus: primary=04, secondary=05, subordinate=09, sec-latency=0
>        I/O behind bridge: 00001000-00001fff
>        Memory behind bridge: fff00000-000fffff
>
> The CardBus bridge then has I/O resources to use, but cannot enable memory
> resources:
>
> 05:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
>        Memory window 0: 00000000-00000000 [disabled] (prefetchable)
>        Memory window 1: 00000000-00000000 [disabled] (prefetchable)
>        I/O window 0: 00001000-000010ff
>        I/O window 1: 00001400-000014ff
>
> So my question to the PCI folks: why does the PCI bridge fail to pass memory
> regions downstream, and assign them properly to the CardBus bridge?
>
> @Germán: assign_busses won't be needed, AFAICT, and possibly override_bios
> neither (if we get the PCI bridge to work, that is...) -- it gets into
> action much later during yenta_cardbus initialization.
>
> Best,
>        Dominik
>
>
> On Mon, Apr 25, 2011 at 07:13:12PM +0200, Germán Sanchis wrote:
>> Hi again.
>>
>> First of all, thanks for your help.
>>
>> Then, one small note: in my first message, the lspci info might have
>> been slightly incorrect: when I first posted this error in the ubuntu
>> forums, lspci reported the devices as:
>> ...
>> 04:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI
>> Express-to-PCI Bridge (rev 03)
>> 05:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
>>
>> whereas this morning it was reporting them at 05:00.0 and 06:00.0. I
>> changed that part of the post, but didn't think about changing the
>> rest. Right now, and with the assign_busses and override_bios options,
>> lspci is reporting them on 04:00.0 and 05:00.0. Just in case you
>> notice a small inconsistency in that sense.
>>
>> I tried the "override_bios=1" parameter when loading yenta_socket, but
>> that does not seem to help. I did this by:
>>
>> $ echo "options yenta_socket override_bios=1" >
>> /etc/modprobe.d/yenta_socket.conf
>>
>> and rebooted. Just to let you know what was done, since it is the
>> first time I do this and googled for it, so I want to make sure that I
>> am not reporting to have tried something which I might have done
>> incorrectly.
>>
>> I am attaching three files to this email:
>>
>> - A.log is the dmesg output when the switch is in position A
>> - B.log is the dmesg output when the switch is in position B
>> - lspci.log is the output of lspci -vvv with the switch in position A.
>> When the switch is in position B, lspci does not report the devices 04
>> and 05 above.
>>
>> All the files were collected with  'ddebug_query="module yenta_socket
>> +p" pci=assign-busses' kernel options, and with yenta_socket
>> override_bios option.
>>
>> Thanks again for your help,
>>
>> best regards,
>>
>> Germán Sanchis Trilles
>
