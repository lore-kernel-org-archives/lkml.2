Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab2EOIL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:11:28 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:22080
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419Ab2EOILY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:11:24 -0400
X-SpamScore: -10
X-BigFish: VS-10(zzc89bh936eK1102I1432N98dKzz1202h1082kzzz2dh2a8h668h839h93fhd25he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4FB2109A.2080505@freescale.com>
Date: Tue, 15 May 2012 16:15:22 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Roland Stigge <stigge@antcom.de>, Bastian Hecht <hechtb@googlemail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Lei Wen <leiwen@marvell.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <dwmw2@infradead.org>, <kevin.wells@nxp.com>, <srinivas.bakki@nxp.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MTD: LPC32xx SLC NAND driver
References: <1336829386-23301-1-git-send-email-stigge@antcom.de> <1337068543.2528.143.camel@sauron.fi.intel.com>
In-Reply-To: <1337068543.2528.143.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年05月15日 15:55, Artem Bityutskiy 写道:
> I am CCing few other guys who take care of several drivers which use
> similar way of busy-waiting - probably you could change it?
>
> Bastian: drivers/mtd/nand/sh_flctl.c
> Lars-Peter: drivers/mtd/nand/jz4740_nand.c
> Huang: drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> Lei Wen: drivers/mtd/nand/pxa3xx_nand.c
>
> On Sat, 2012-05-12 at 15:29 +0200, Roland Stigge wrote:
>> +       /*
>> +        * The DMA is finished, but the NAND controller may still have
>> +        * buffered data. Wait until all the data is sent.
When all the data is sent, is there an interrupt for this?


Best Regards
Huang Shijie

>> +        */
>> +       timeout = LPC32XX_DMA_SIMPLE_TIMEOUT;
>> +       while ((readl(SLC_STAT(host->io_base))&  SLCSTAT_DMA_FIFO)
>> +&&  (timeout>  0))
>> +               timeout--;
>> +       if (!timeout) {
>> +               dev_err(mtd->dev.parent, "FIFO held data too long\n");
>> +               status = -EIO;
>> +       }
> I know the MTD tree is full of this, but this is bad, I think. The
> timeout should be time-backed, not CPU-cycles-backed.
>
> I do not know the best way to do this, hopefully someone in the arm list
> could suggest, but the following pattern is at least better:
>
>
> /* Chip reaction time timeout in milliseconds */
> #define LPC32XX_DMA_TIMEOUT 100
>
> timeout = loops_per_jiffy * msecs_to_jiffies(LPC32XX_DMA_TIMEOUT);
>
> while ((readl(...))&&  timeout-->  0)
> 	cpu_relax();
>
> if (!timeout)
> 	error;
>
>
> So basically I turned your hard-coded iterations count into a time-based
> timeout. I also used cpu_relax() which is commonly used in tight-loops
> like this. Here is a piece of documentation about cpu_relax():
>
> "
> The right way to perform a busy wait is:
>
>      while (my_variable != what_i_want)
>          cpu_relax();
>
> The cpu_relax() call can lower CPU power consumption or yield to a
> hyperthreaded twin processor; it also happens to serve as a compiler
> barrier, so, once again, volatile is unnecessary.  Of course, busy-
> waiting is generally an anti-social act to begin with.
> "
>


