Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992654Ab2JYURH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:17:07 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:54923 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2JYURE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:17:04 -0400
Date: Thu, 25 Oct 2012 16:17:01 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v4 5/5] zynq: move static peripheral mappings
Message-ID: <20121025201701.GA18217@elliptictech.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200451.GF6713@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024200451.GF6713@beefymiracle.amer.corp.natinst.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 2012-10-24 15:04 -0500, Josh Cartwright wrote:
> Shifting them up into the vmalloc region prevents the following warning,
> when booting a zynq qemu target with more than 512mb of RAM:
[...]
> -/* For now, all mappings are flat (physical = virtual)
> +/* Static peripheral mappings are mapped at the top of the
> + * vmalloc region
>   */
> -#define UART0_PHYS			0xE0000000
> -#define UART0_VIRT			UART0_PHYS
> +#define UART0_PHYS		0xE0000000
> +#define UART0_SIZE		SZ_4K
> +#define UART0_VIRT		(VMALLOC_END - UART0_SIZE)

Did you test this on any real hardware?  I can't get the ZC702 to work
with the UART mapped at this address (this ends up being mapped at
0xFEFFF000), although I can't for the life of me figure out why the
virtual address even matters.  Note that for the ZC702, the physical
address of the "main" UART is 0xE0001000.

All I end up seeing is "Uncompressing Linux... done, booting the
kernel." with no further messages.  With the UART mapped at
0xF0001000, all printouts make it to the console.  I tried a couple
different virtual addresses and I'm surprised at the results, since
the behaviour seems to vary wildly.  I saw three behaviours depending
only on the virtual address of the static mapping; all results are 100%
reproducible:

   "Works":     all printouts make it to the console
   "Fails":     no printouts make it to the console after decompression
   "Truncated": the first few lines of output do not make it to the
                console, but after that it "Works".  The first line
		successfully printed is always
		  "Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096"

And here are the addresses I tested:

  Address       Result
  -----------------------
  0xf0000000    Truncated
  0xf0001000    Works
  0xf0007000    Truncated
  0xf0008000    Fails
  0xf0009000    Fails
  0xf000e000    Truncated
  0xf000f000    Fails
  0xf8000000    Truncated
  0xf8001000    Works
  0xfef00000    Truncated
  0xfef01000    Works
  0xfef08000    Fails
  0xfef0f000    Fails
  0xfeff0000    Fails
  0xfeff1000    Fails
  0xfeffe000    Fails
  0xfefff000    Fails

Judging by the list, the console seems to only work properly if the
defined virtual address is Fxxx1000 and xxx is not too big...

Confused,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
