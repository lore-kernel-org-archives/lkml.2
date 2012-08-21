Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2HUIbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:31:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2HUIbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:31:35 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
Date: Tue, 21 Aug 2012 08:31:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <502BC31E.4070200@yahoo.es> <201208210744.53370.arnd.bergmann@linaro.org> <CAKohpo=DyQajiE-DmpMiv=gVOVOep1OEECVuw83D2u4VJisEsw@mail.gmail.com>
In-Reply-To: <CAKohpo=DyQajiE-DmpMiv=gVOVOep1OEECVuw83D2u4VJisEsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208210831.32771.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:zG2M3UJChELetFr2dn38jExpl3FdYE8zLtunkcyUT63
 3saD9dQ1xlRYMCigRdzS3797UcmgWt3IiMMwFO/R3QTeHfgEhq
 3MKmgjBE6jt9IzTWpJl6f1u3uBAsrk9T6KVkXLwqweVFlnEXkY
 0lMU2iEfQBhLRIoe+9iFxzYiBTOHn7XZesF6YRSi/yQCxEohn9
 AalIn1QqEuNnNbxqd3x/apxeBIDfU3Q2VkHqssoIqERXKEs4tB
 6yLrF0GrpVmDeD9/DjXkTmYevy85HYKKb6Jd2HBuHpz7ipZGk4
 IghofgWxTiW8gdDsftscrl1fPYU2qpyoItESuvgrHDZhJDBhvg
 rhxO4Cffo8QL2ZoM4vdodEVsnY+c7k0esBuBnyCzB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Viresh Kumar wrote:
> > Is AVR32 a big-endian system? Probably big-endian, that's why values are
> > > getting
> > > swapped. And dw_dmac is the standard one, can call it little endian for
> > the
> > > time being.
> > >
> > > @Arnd: What should we do here?
> >
> > Yes, AVR32 is big-endian. I assume that dw_dmac can be either configured
> > as little-endian or big-endian and that it is configured as big-endian
> > on AVR32.
> >
> 
> Just to understand a bit more on this always confusing endianess concept:
> - For AVR32, readl is calling swab everytime. So whatever we write will get
> swapped.
> - What are the implications of dw_dmac configured in little/big endian?
> 
> When we write something to register of a peripheral, whose endianess
> property decides how it will get written. Processor or Peripheral?

The device decides which accessor we need to use (readl, ioread, ioread_be,
in_be, in_le, ...). The architecture code must ensure that this is
implemented properly based on the CPU endianess. We don't have a proper
accessor function that implements "device has same endianess as CPU".
Using __raw_* is not a replacement for that.

I don't mind adding such an accessor at all, and a number people have
complained about the lack of this for some time, but you should be
aware that a lot of peripherals that are intended to be used in
"CPU-endian" mode eventually end up getting used in "wrong-endian"
mode, e.g. when someone decides to put that peripheral on a PCI
card and someone else sticks it into a machine that has a CPU
with the opposed (or configurable) endianess. It would be nice if
the likes of designware could at least pick one endianess per
device they do, but the reality is that we have to deal with both
variants and only the device driver can find out what it is.

	Arnd
