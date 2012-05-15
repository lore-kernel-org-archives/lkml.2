Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2EONVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:21:00 -0400
Received: from antcom.de ([188.40.178.216]:45506 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254Ab2EONU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:20:58 -0400
Message-ID: <4FB25837.2050603@antcom.de>
Date: Tue, 15 May 2012 15:20:55 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: dedekind1@gmail.com, Bastian Hecht <hechtb@googlemail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Lei Wen <leiwen@marvell.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: LPC32xx SLC NAND driver
References: <1336829386-23301-1-git-send-email-stigge@antcom.de> <1337068543.2528.143.camel@sauron.fi.intel.com> <4FB2109A.2080505@freescale.com>
In-Reply-To: <4FB2109A.2080505@freescale.com>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem and Huang,

thank you for your feedback!

On 05/15/2012 10:15 AM, Huang Shijie wrote:
>> On Sat, 2012-05-12 at 15:29 +0200, Roland Stigge wrote:
>>> +       /*
>>> +        * The DMA is finished, but the NAND controller may still have
>>> +        * buffered data. Wait until all the data is sent.
> When all the data is sent, is there an interrupt for this?

Bad news is: No

Good news is: The previous DMA operation finished with an interrupt
which according to the manual should already corresponds to this
condition. Tests show that at this point of sampling:

>>> +       timeout = LPC32XX_DMA_SIMPLE_TIMEOUT;
>>> +       while ((readl(SLC_STAT(host->io_base))&  SLCSTAT_DMA_FIFO)
>>> +&&  (timeout>  0))
>>> +               timeout--;

... the condition is always true and always just jumps over this loop,
at least with my hardware.

>> /* Chip reaction time timeout in milliseconds */
>> #define LPC32XX_DMA_TIMEOUT 100
>>
>> timeout = loops_per_jiffy * msecs_to_jiffies(LPC32XX_DMA_TIMEOUT);
>>
>> while ((readl(...))&&  timeout-->  0)
>>     cpu_relax();

As I understand loops_per_jiffy, this loop will take much longer than
the 100 ms you defined above?

Anyway, I will keep the loop for safety reasons, add an msleep() and add
a warning, should the loop be entered _at all_.

Maybe someone from NXP can give us more insight here? Maybe the
condition check isn't necessary anymore after I ported the driver to
dmaengine (this controller is always wired together with an amba-pl080
in the LPC32xx)?

Thanks in advance,

Roland
