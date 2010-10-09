Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0JIMGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:06:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53175 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab0JIMGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:06:06 -0400
Date: Sat, 9 Oct 2010 13:05:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        Han Jonghun <jonghun79.han@gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009120537.GD20975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com> <201010091311.26335.arnd@arndb.de> <20101009114444.GL29673@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101009114444.GL29673@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 01:44:44PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Sat, Oct 09, 2010 at 01:11:26PM +0200, Arnd Bergmann wrote:
> > When you say that "many drivers broken", can you list the ones you know
> > about? It would probably help resolve this the right way.
> I know about the camera stuff on mx3/pcm037.  See
> pcm037_camera_alloc_dma in arch/arm/mach-mx3/mach-pcm037.c.

dma_alloc_coherent, stuffing that into dma_declare_coherent_memory,
which then ioremaps the memory obtained from dma_alloc_coherent, and
is then handed out via a subsequent dma_alloc_coherent call.

So what we end up with is the kernel mapping (normal memory, cacheable),
the DMA coherent mapping (normal memory, non-cacheable) but with the
same shared-ness as the kernel mapping, and finally the ioremap mapping
(device, shared).  So three aliasing mappings all with different
attributes.
