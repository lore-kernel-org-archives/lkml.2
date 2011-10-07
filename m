Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab1JGKRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:17:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab1JGKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:17:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 13/26] ARM: pxa: use correct __iomem annotations
Date: Fri, 7 Oct 2011 12:16:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-14-git-send-email-arnd@arndb.de> <CAMPhdO_CGvoc8GZQS3TWpv0gqOXhmHyEbamcQr28K5iLgOBnuw@mail.gmail.com>
In-Reply-To: <CAMPhdO_CGvoc8GZQS3TWpv0gqOXhmHyEbamcQr28K5iLgOBnuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110071216.50783.arnd@arndb.de>
X-Provags-ID: V02:K0:QF1y8Bp4ZUENaWoE4WsrpcCrAIRUFvobblYRb9kmrRQ
 UynCHC7QplvOzNudRcjip8GVybWQJYdnzy0YkblzeEXDik4v+S
 Nz6C4h7wu00gzuUr8V92I9ADFSko48zVZCnK0wjPz4NH+GGDSd
 BHc9LcdnJakb5a3vcL3HqkCxRq1kmcB0qHgZwMUDFuzvBhoveD
 KHtmorm4BfmYdnRxC3Kh+vVTL/FW5XjSISUgSDN11otipn/OSx
 JVGhYNVOqzEJs6Q/TKZtMXTkyMo+62Y/4ylmi5VARQr6GqtRdN
 CbrjDSMLL3flXTe0GhsxfoRw5A/vYO0UOs7NQzlHR8LEZTKNtJ
 COD+jhAfxM08fICkzOZU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 October 2011, Eric Miao wrote:
> > @@ -18,11 +24,11 @@
> >  * peripherals on APB, let's count it into the ABP mapping area.
> >  */
> >  #define APB_PHYS_BASE          0xd4000000
> > -#define APB_VIRT_BASE          0xfe000000
> > +#define APB_VIRT_BASE          IOMEM(0xfe000000)
> 
> To be honest, I'd really like to keep the *_VIRT_BASE definitions to be
> type independent.
> 
> And have the actual register definitions to be casted to void __iomem *
> when being defined, e.g.
> 
> #define APBC_REG(x)     IOMEM(APBC_VIRT_BASE + (x))
> 
> #define APBC_UART1      APBC_REG(0x000)
> 
> Arnd, do we have some standard guidelines on this for all SoCs
> to follow? As I know, it's currently still being a mess.

We don't have any formal guidelines yet, but I'd really love to get
rid of all the arbitrary type casts to make use of the built-in
type checking of the compiler and sparse. A virtual base address
for registers is conventionally an __iomem pointer, so defining it
as something else is completely bogus. I have started making patches
for a number of platforms for this.

Ideally we should have very little code directly using, but the fact
is that they are there and we won't remove them all anytime soon, so
we should at least use the correct types here.

Another issue that goes together with this is that right now our
readl/writel macros accept any input type (pointer, __iomem pointer,
unsigned long, unsigned int), and I have a patch to make that stricter
but that requires fixing up all the places where we do a
readl(APBC_VIRT_BASE + x) that Russell mentioned.

The only place where this requires adding extra type casts right now is
the iotable setup, which I hope we can also fix eventually by splitting
the static I/O mapping setup from other static mappings (MT_MEMORY,
MT_MEMORY_NONCACHED, ...).

	Arnd
