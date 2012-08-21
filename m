Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2HUOPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:15:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36320 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2HUOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:15:08 -0400
MIME-Version: 1.0
X-Originating-IP: [24.23.139.102]
In-Reply-To: <201208210831.32771.arnd.bergmann@linaro.org>
References: <502BC31E.4070200@yahoo.es>
	<201208210744.53370.arnd.bergmann@linaro.org>
	<CAKohpo=DyQajiE-DmpMiv=gVOVOep1OEECVuw83D2u4VJisEsw@mail.gmail.com>
	<201208210831.32771.arnd.bergmann@linaro.org>
Date: Tue, 21 Aug 2012 07:15:07 -0700
Message-ID: <CACiLriQPs5torFCG8PuwY5nZmw86SzJTNT4-Vt2tSLJHnF8iuw@mail.gmail.com>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
From: Havard Skinnemoen <havard@skinnemoen.net>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 1:31 AM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> On Tuesday 21 August 2012, Viresh Kumar wrote:
>> > Is AVR32 a big-endian system? Probably big-endian, that's why values are
>> > > getting
>> > > swapped. And dw_dmac is the standard one, can call it little endian for
>> > the
>> > > time being.
>> > >
>> > > @Arnd: What should we do here?
>> >
>> > Yes, AVR32 is big-endian. I assume that dw_dmac can be either configured
>> > as little-endian or big-endian and that it is configured as big-endian
>> > on AVR32.
>> >
>>
>> Just to understand a bit more on this always confusing endianess concept:
>> - For AVR32, readl is calling swab everytime. So whatever we write will get
>> swapped.
>> - What are the implications of dw_dmac configured in little/big endian?
>>
>> When we write something to register of a peripheral, whose endianess
>> property decides how it will get written. Processor or Peripheral?
>
> The device decides which accessor we need to use (readl, ioread, ioread_be,
> in_be, in_le, ...). The architecture code must ensure that this is
> implemented properly based on the CPU endianess. We don't have a proper
> accessor function that implements "device has same endianess as CPU".
> Using __raw_* is not a replacement for that.
>
> I don't mind adding such an accessor at all, and a number people have
> complained about the lack of this for some time, but you should be
> aware that a lot of peripherals that are intended to be used in
> "CPU-endian" mode eventually end up getting used in "wrong-endian"
> mode, e.g. when someone decides to put that peripheral on a PCI
> card and someone else sticks it into a machine that has a CPU
> with the opposed (or configurable) endianess. It would be nice if
> the likes of designware could at least pick one endianess per
> device they do, but the reality is that we have to deal with both
> variants and only the device driver can find out what it is.

A native-endian accessor would really help in this case. Back in 2006
when I did the AVR32 port, that's what I thought __raw_ was, but I
suspect I was both wrong, and the semantics of the I/O accessors have
changed slightly over time. But since __raw_ did exactly what was
needed on both AVR32 (big endian) and AT91 ARM (little endian)
devices, I ended up using it for all on-chip devices.

read[bwl] on the other hand was implemented for external device
access. Since the SMC controller on AP7000 is really bizarre
(basically big endian data with little endian addressing), these
accessors became pretty weird too.

Anyway, if we want to purge all those inappropriate __raw accesses
from the Atmel drivers, we're going to need a replacement for internal
native-endian access. Right now, we don't have any.

Havard
