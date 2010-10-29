Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab0J2MIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 08:08:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760589Ab0J2MIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 08:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iV6lO9nZzWYOdTvRJ3d9QUb/d8mTm7N3z4yY0WDQPFjfrPDV8b/Okbv6SIXxqN69vO
         H42qiHF7C58ijHmZ6rfmmN4GrPva/0On2KaF9DKUQCHKeLvCNcEcmbCs3ADqZTzNjnUs
         Q/cVSgt9B8OTkOxcaQtpLCheAWc7pn379bmeI=
MIME-Version: 1.0
In-Reply-To: <AANLkTinh3D8V8UaN8FyCouwUQ98A4RRWEHXU7Tr9XMbs@mail.gmail.com>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
	<201010281422.46687.arnd@arndb.de>
	<AANLkTinh3D8V8UaN8FyCouwUQ98A4RRWEHXU7Tr9XMbs@mail.gmail.com>
Date: Fri, 29 Oct 2010 14:08:11 +0200
Message-ID: <AANLkTimyR7f=PdQbxxBLCnznTA4PT1TWEFiNX3C_qaZo@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz.Rymanowski@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/29 Par-Gunnar Hjalmdahl <pghatwork@gmail.com>:
> 2010/10/28 Arnd Bergmann <arnd@arndb.de>:
>> On Friday 22 October 2010, Par-Gunnar Hjalmdahl wrote:
>>
>>> >
>>> > So - NAK this for the moment, it needs to be split cleanly into ldisc
>>> > (thing which speaks the protocol and eg sees "speed change required" and
>>> > acts on it) and device (thing which knows about the hardware).
>>>
>>> OK. We will try to figure out a new design.
>>> I'm not too happy about putting the ldisc part in Bluetooth though
>>> since it is only partly Bluetooth, it is also GPS and FM. Better could
>>> maybe be under char/?
>>
>> After getting a better idea of what the base mfd driver does, my impression
>> is now that you should not register a second N_HCI line discipline at all,
>> but instead extend the existing line discipline with this number.
>>
>> I'm not sure what happens if you need two modules that try to register
>> the same ldisc number, but I imagine it is not good.
>>
>> Shouldn't you instead be using the drivers/bluetooth/hci_{ldisc,h4} code?
>>
>>        Arnd
>>
>
> We also need the ldisc code to handle events from FM and GPS and since
> that is chip specific we cannot add that to the generic hci_ldisc
> code.
> I agree that we might run into problems if two drivers try to register
> the same line discipline. It might then be better to introduce a new
> line discipline then even though that could cause other problems. I do
> not know if it is possible to add a condition in Kconfig otherwise so
> the CG2900 ldisc cannot be active while the "normal" ldisc driver is
> selected.
>
> /P-G
>

Hi again,

I might have been a bit too quick there.
The actual channel matching and packet creation is done in hci_h4.c
while ldisc registration is done in hci_ldisc.c.
So it might to be enough to create a new hci_h4-cg2900.c (or similar
name) that can separate the right channels. We must however do changes
to hci_ldisc as well since it seems to always register to the
Bluetooth stack here, which we definitely don't want since that is
handled by btcg2900.c.
Also note that this ldisc issue is only valid when using UART as
transport. We will also support SPI and then we will probably run into
completely new, interesting problems. :-)

/P-G
