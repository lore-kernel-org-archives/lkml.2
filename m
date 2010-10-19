Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0JSSNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:13:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37223 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0JSSNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:13:14 -0400
Date: Tue, 19 Oct 2010 19:12:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@google.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101019181249.GA9789@n2100.arm.linux.org.uk>
References: <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com> <20101011152516.GF27153@n2100.arm.linux.org.uk> <AANLkTikZAt-KWFF_MXxXGruia-=AieStQgird2XWgr6y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikZAt-KWFF_MXxXGruia-=AieStQgird2XWgr6y@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:13:36AM -0700, Colin Cross wrote:
> If memblock_remove is used on the end of memory with this patch,
> mem_init accesses off the end of the array of page structures because
> of the discrepancy between memblock.memory and membank on the number
> of the last pfn.   memblock.memory is used to determine the memory
> zones in arm_bootmem_free, which eventually  is used to create the
> array of page structures, but mem_init iterates over membank and calls
> pfn_to_page on pfns up to bank_pfn_end.
> 
> Converting show_mem and mem_init to use memblock.memory fixes it:

I intentionally did not do this because it won't work.  membank
information is purposely not coalesced together when you have full
sparsemem regions - which may result in

	pfn_to_page(pfn) != pfn_to_page(pfn + 1) - 1

However, memblock information is coalesced, and so will cross these
boundaries.  This means using memblock instead of membank will make
things go pop.
