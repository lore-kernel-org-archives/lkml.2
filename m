Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab2HXPiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:38:51 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53217 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab2HXPis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:38:48 -0400
X-Auth-Info: XwP+lOczLY0NTnldfQ4grnmOch+MLHJXZi5xLIzdMsE=
From: Marek Vasut <marex@denx.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: SLAVE Side SPI kernel driver development
Date: Fri, 24 Aug 2012 17:38:45 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "Bastelli Carlo (yahoo)" <carlo_bastelli@yahoo.it>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
References: <1345820228.87750.YahooMailNeo@web29604.mail.ird.yahoo.com> <CAOMZO5Ds6NKsTCptQXDGZDJasb119hYWqXMzX8nG5WFArysL7A@mail.gmail.com>
In-Reply-To: <CAOMZO5Ds6NKsTCptQXDGZDJasb119hYWqXMzX8nG5WFArysL7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208241738.45601.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Fabio Estevam,

> On Fri, Aug 24, 2012 at 11:57 AM, Bastelli Carlo (yahoo)

CCing SPI list

> <carlo_bastelli@yahoo.it> wrote:
> > Hello, I'm Carlo, I have a difficult task at work, my boss asked me to
> > develop
> > 
> >  a driver SPI slave side on embedded ARM processor running Linux.
> > 
> > Precisely linux occur on the SPI bus as a slave, not master as required
> > by the hierarchical structure of the current kernel. The new driver
> > will
> > 
> >  receive via interrupt and respond when selected by its chip select.

So a soft-spi ? It's gonna be slow as hell and unstable too.

> >  Can
> >  anyone suggest the best way to develop this driver?

Get a CPU which has SPI-slave capable IP, start from there. If you were to 
implement soft-spi this way, you'd have to use FIQ on ARM, to be able to handle 
stuff with reasonable latency ... check how the ps/2-gpio driver is done in 
Linux ... I tried it, it barely worked, you don't want to go down that road.

> >  Personally, I
> > 
> > have identified two main roads, the first if possible to exploit the
> > structure SPI master driver

Not happening. You'd have to split the parts from the struct spi_master into 
common and master-only parts. That's for starters.

> > with a few tricks that now I can not
> > define. The second most radical, write a driver for a UART like, but
> > managing the SPI device.
> > Thank you for any suggestions or examples.

First of all, the SPI slave mode is COMPLETELY different from the master mode. 
You need to react on incoming CS-low ASAP, which might turn out to be a problem 
on it's own. Then, even if you do, you do not know how long the transfer is 
going to be, so you need to allocate enough buffers as the transfer progresses 
onwards.

In case of your soft-spi, how do you plan to sample the CLK line to sync clock?

> Marek got spi slave running on a mx28. See his patch:
> http://www.spinics.net/lists/arm-kernel/msg190860.html

This was tested (and developed) on this board:
http://www.denx-cs.de/?q=M28

The userland code is really easy too, simply pump it into spidev or read from 
it. But all that is only possible because of the SPI IP in the mx28 is nice.

> Regards,
> 
> Fabio Estevam

Best regards,
Marek Vasut
