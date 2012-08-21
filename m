Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2HUHds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:33:48 -0400
Received: from bosmailout02.eigbox.net ([66.96.185.2]:45756 "EHLO
	bosmailout02.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HUHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:33:45 -0400
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=lghRLfjGutYZE2O92ubooA==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=TNaJx8l5llIA:10 a=8nJEP1OIZ-IA:10 a=ZbotsqAEwLAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=hogF9BWPwK3KbxMoqZkA:9 a=wPNLvfGTeEIA:10
 a=9UqFsMnAB6EOkiq4MrOclQ==:117
X-EN-OrigOutIP: 10.20.18.19
X-EN-IMPSID: pKZi1j0030QhFXN01KZi7S
Message-ID: <50333982.3020201@yahoo.es>
Date: Tue, 21 Aug 2012 15:32:18 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
References: <502BC31E.4070200@yahoo.es> <502BDD0E.4030106@yahoo.es> <502CA8FC.7090705@atmel.com> <502CB89B.4070302@yahoo.es> <502CC326.8020605@atmel.com> <502CC6A0.3050603@atmel.com> <502F52E7.9050804@yahoo.es> <CACiLriS-GZg24TJqJGQ=P04n-Zk3FdHtGgh5VeqGcCMHG6TnMw@mail.gmail.com> <50310F10.2080701@yahoo.es> <CAOh2x=kOxninn=o1i2-HE1is-G8vfi1ER_JjUQY=N0wTYwAotw@mail.gmail.com> <503326CE.40301@yahoo.es> <CAKohponN16krs-WWw6Abh1fLPO3+iYndTaxsPDfeXCoS9OHufQ@mail.gmail.com>
In-Reply-To: <CAKohponN16krs-WWw6Abh1fLPO3+iYndTaxsPDfeXCoS9OHufQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.56.110
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 2:35 PM, Viresh Kumar wrote:
> On 21 August 2012 11:42, Hein Tibosch <hein_tibosch@yahoo.es <mailto:hein_tibosch@yahoo.es>> wrote:
>
>     On 8/21/2012 12:42 PM, viresh kumar wrote:
>     > Ahhhh!! Firstly we can't use __raw* for architectures >= ARMv6. It is not
>     > only for endianess but for memory barriers. Why are they getting swapped
>     > for your case? Does your processor and dw_dmac have different endianess?
>
>     If I'm not wrong: the __raw_* functions will access the i/o memory in native endianess.
>     As far as I know, all AVR32 drivers are currently using the __raw* functions. I never
>     encountered  a problem with that.
>
>
> I don't have the best knowledge in this area :( and so cc-ing Arnd who can help us here.
> So my perception of these routines is:
>
> readl is defined generically as:
>
> #define readl(addr) __le32_to_cpu(__raw_readl(addr))
>
> Which converts to a simple __raw_readl() for little endian systems and
> swapped bytes for a big endian system.
>
> You wrote in the beginning
> >> - After 2.6.39, the registers were accessed using readl/writel
> >>   in stead of the __raw_readl and __raw_writel causing a 16-bit
> >>   swap of all values (little endian access)

It got swapped as 0xAABB.CCDD => 0xCCDD.AABB

> What's this 16-bit swap here? It should be a 8 bit swap by __swab32() routine.
>  
> Is AVR32 a big-endian system? Probably big-endian, that's why values are getting
> swapped. And dw_dmac is the standard one, can call it little endian for the time being.
>
AVR32 (AP700x) is a big-endian system.

It took me many hours to figure out why the DMA controller didn't do
anything at all.

Then I decided to access the i/o memory in different way:

    #include "dmaca_206a.h" // from the AVR32-tools library

    const struct __iomem avr32_dmaca_t *regs =
        (const struct __iomem avr32_dmaca_t *)0xFF200000;

and printk all register values. Each and every u32 field was swapped as
0xAABBCCDD => 0xCCDDAABB

Håvard's comment was: "it's always wrong to use little endian accessors
(i.e. readl/writel) in drivers for chip-internal devices"

Memory barriers: within the AVR32 code, one often sees explicit ways to
introduce memory barriers, e.g.:

    hsmc_readl(hsmc, MODE0); /* I/O barrier */

which means: reading back (just any) register (from the same peripheral)
to assure that the write was successful, especially from within
interrupt handlers.

But as I said, within avr32-linux I never encountered problems
with the __raw* approach, including dw_dmac.c

> @Arnd: What should we do here?

I'm curious too

Hein
