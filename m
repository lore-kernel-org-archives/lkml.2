Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2HWE3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:29:30 -0400
Received: from bosmailout20.eigbox.net ([66.96.185.20]:45084 "EHLO
	bosmailout20.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2HWE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:29:27 -0400
X-Greylist: delayed 2461 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 00:29:26 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=Ag8sXjOgi3ulG269ENDe/w==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=TNaJx8l5llIA:10 a=8nJEP1OIZ-IA:10 a=ZbotsqAEwLAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=KKAkSRfTAAAA:8 a=wFaEK3txAAAA:8
 a=99Kj4SjmDi-KjNA3bPwA:9 a=wPNLvfGTeEIA:10 a=Zg8YByZ41L0A:10
 a=WwgC8nHKvroA:10 a=aq7iBExxaGnQUwH9:21 a=hzGulCorWicnVxCw:21
 a=jcMFiYeD4Gz02xRQ37rMPA==:117
X-EN-OrigOutIP: 10.20.18.4
X-EN-IMPSID: q3oN1j00305GATN013oN5G
Message-ID: <5035A7B4.8040309@yahoo.es>
Date: Thu, 23 Aug 2012 11:47:00 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Havard Skinnemoen <havard@skinnemoen.net>
CC: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, egtvedt@samfundet.no,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
References: <502BC31E.4070200@yahoo.es> <201208210744.53370.arnd.bergmann@linaro.org> <CAKohpo=DyQajiE-DmpMiv=gVOVOep1OEECVuw83D2u4VJisEsw@mail.gmail.com> <201208210831.32771.arnd.bergmann@linaro.org> <CACiLriQPs5torFCG8PuwY5nZmw86SzJTNT4-Vt2tSLJHnF8iuw@mail.gmail.com>
In-Reply-To: <CACiLriQPs5torFCG8PuwY5nZmw86SzJTNT4-Vt2tSLJHnF8iuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.60.202
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 10:15 PM, Havard Skinnemoen wrote:
> On Tue, Aug 21, 2012 at 1:31 AM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
>> On Tuesday 21 August 2012, Viresh Kumar wrote:
>>>> Is AVR32 a big-endian system? Probably big-endian, that's why values are
>>>>> getting
>>>>> swapped. And dw_dmac is the standard one, can call it little endian for
>>>> the
>>>>> time being.
>>>>>
>>>>> @Arnd: What should we do here?
>>>> Yes, AVR32 is big-endian. I assume that dw_dmac can be either configured
>>>> as little-endian or big-endian and that it is configured as big-endian
>>>> on AVR32.
>>>>
>>> Just to understand a bit more on this always confusing endianess concept:
>>> - For AVR32, readl is calling swab everytime. So whatever we write will get
>>> swapped.
>>> - What are the implications of dw_dmac configured in little/big endian?
>>>
>>> When we write something to register of a peripheral, whose endianess
>>> property decides how it will get written. Processor or Peripheral?
>> The device decides which accessor we need to use (readl, ioread, ioread_be,
>> in_be, in_le, ...). The architecture code must ensure that this is
>> implemented properly based on the CPU endianess. We don't have a proper
>> accessor function that implements "device has same endianess as CPU".
>> Using __raw_* is not a replacement for that.
>>
>> I don't mind adding such an accessor at all, and a number people have
>> complained about the lack of this for some time, but you should be
>> aware that a lot of peripherals that are intended to be used in
>> "CPU-endian" mode eventually end up getting used in "wrong-endian"
>> mode, e.g. when someone decides to put that peripheral on a PCI
>> card and someone else sticks it into a machine that has a CPU
>> with the opposed (or configurable) endianess. It would be nice if
>> the likes of designware could at least pick one endianess per
>> device they do, but the reality is that we have to deal with both
>> variants and only the device driver can find out what it is.
> A native-endian accessor would really help in this case. Back in 2006
> when I did the AVR32 port, that's what I thought __raw_ was, but I
> suspect I was both wrong, and the semantics of the I/O accessors have
> changed slightly over time. But since __raw_ did exactly what was
> needed on both AVR32 (big endian) and AT91 ARM (little endian)
> devices, I ended up using it for all on-chip devices.
>
> read[bwl] on the other hand was implemented for external device
> access. Since the SMC controller on AP7000 is really bizarre
> (basically big endian data with little endian addressing), these
> accessors became pretty weird too.
>
> Anyway, if we want to purge all those inappropriate __raw accesses
> from the Atmel drivers, we're going to need a replacement for internal
> native-endian access. Right now, we don't have any.

If I may summarize: Viresh replaced the __raw* accessor functions with
readl/writel, because they will enforce a correct ordering of instructions
exchanged with the peripheral.

On the ARM configurations this worked ok, because both the device and the
CPU are little endian.

However, for AVR32 the driver got broken: readl/writel are little endian
accessors.

I looked up an earlier thread "MMIO and gcc re-ordering issue"*, in which
Havard wrote:

> <cut> I don't think adding barriers is the
> right thing to do because they won't do anything useful in practice, so
> it's hard to tell whether they are used "correctly". And it will hurt
> performance at least on AVR32 since wmb() evaluates to a "sync"
> instruction, which flushes the write buffer to RAM. Since MMIO writes
> are unbuffered, that's pure overhead.

Four years later, we still don't have a generic native-endian MMIO-access
API which also introduce proper memory barriers.

So for the moment, do we have a better solution than this:

#ifdef CONFIG_AVR32
+#define dma_readl(dw, name) \
+	__raw_readl(&(__dw_regs(dw)->name))
+#define dma_writel(dw, name, val) \
+	__raw_writel((val), &(__dw_regs(dw)->name))
+#else
 #define dma_readl(dw, name) \
 	readl(&(__dw_regs(dw)->name))
 #define dma_writel(dw, name, val) \
 	writel((val), &(__dw_regs(dw)->name))
+#endif

and do the same for channel_readl/writel ?

Hein

*http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-05/msg13776.html
