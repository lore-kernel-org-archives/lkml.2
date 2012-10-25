Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2JYWlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:41:12 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:44280 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2JYWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:41:11 -0400
Date: Thu, 25 Oct 2012 18:41:08 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v4 5/5] zynq: move static peripheral mappings
Message-ID: <20121025224108.GA30705@elliptictech.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200451.GF6713@beefymiracle.amer.corp.natinst.com>
 <20121025201701.GA18217@elliptictech.com>
 <20121025212902.GX20593@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025212902.GX20593@beefymiracle.amer.corp.natinst.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-25 16:29 -0500, Josh Cartwright wrote:
> On Thu, Oct 25, 2012 at 04:17:01PM -0400, Nick Bowler wrote:
> > Did you test this on any real hardware?  I can't get the ZC702 to work
> > with the UART mapped at this address (this ends up being mapped at
> > 0xFEFFF000), although I can't for the life of me figure out why the
> > virtual address even matters.  Note that for the ZC702, the physical
> > address of the "main" UART is 0xE0001000.
> 
> Ugh, not yet;  My testing has been on a qemu model.  I also
> unfortunately neglected to mention I am carrying a qemu patch that
> forces RX_EN/TX_EN of the uarts out of reset.  There is an (incomplete)
> thread on qemu-devel discussing whose responsibility it really is to
> enable the uarts:
> 
>    http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg03779.html
> 
> Clearly, though, if you are seeing the "Uncompressing Linux..."
> messages, then the uart is enabled, so I don't think that's the problem.

Yes, the uart is presumably enabled by u-boot.

> >    "Works":     all printouts make it to the console
> >    "Fails":     no printouts make it to the console after decompression
> >    "Truncated": the first few lines of output do not make it to the
> >                 console, but after that it "Works".  The first line
> > 		successfully printed is always
> > 		  "Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096"
> 
> Odd, I'm wondering the uart gets into a weird state, and some bits get
> knocked loose at console_initcall() time, when the console driver comes
> up (Assuming CONFIG_SERIAL_XILINX_PS_UART)?

While I am using that driver, it is not initialized until relatively
late in the boot process.  If I were to guess, I would guess that,
except for when it "Works", the really really early printk stuff isn't
actually hitting the uart at all.  The "Fails" case would then be due to
the stray writes crashing the board, and the "Truncated" case due to the
stray writes being (ostensibly) benign.

But I really have no way right now to test this hypothesis, since I
can't print anything in the failing case.

> > And here are the addresses I tested:
> > 
> >   Address       Result
> >   -----------------------
> >   0xf0000000    Truncated
> >   0xf0001000    Works
[...]
> >   0xfefff000    Fails
> > 
> > Judging by the list, the console seems to only work properly if the
> > defined virtual address is Fxxx1000 and xxx is not too big...
> 
> Very odd.  Do you mind sending out your patch allowing the selection of
> the secondary uart for DEBUG_LL?

I will follow up with the version that applies on top of your series in
a moment.  I'm confident that the UART works on the ZC702 when mapped at
0xf0001000, since I've been running with that since I first got my hands
on one of these boards.

But you don't need any patch to do the same tests I was doing above:
you can just change UART0_PHYS to 0xe0001000 and then set UART0_VIRT
accordingly (you may need to move the TTC/SCU mappings depending where
you put the UART, of course).

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
