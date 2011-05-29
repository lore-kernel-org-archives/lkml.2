Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1E2CWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 22:22:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1E2CWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 22:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rM+fOMhMpdd8LKccbJle5AN8NAIqLgVGS84gxXXYucdNC9owYHnq9R8Mrp9aT8tzc7
         X8qRVy1ARTHO2sY9KP+w==
Date: Sat, 28 May 2011 19:22:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
In-Reply-To: <20110528234614.GV24876@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1105281913490.15709@chino.kir.corp.google.com>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <20110528234614.GV24876@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011, Russell King - ARM Linux wrote:

> > The driver is attempting to allocate DMA memory and you have 
> > CONFIG_ZONE_DMA disabled, which is the only reason you would get this 
> > warning.  If the allocation did not fail as a result of a197b59ae6e8, the 
> > page allocator may return any memory in a higher zone that the driver may 
> > not be expecting.  If you had never noticed a problem before, it may be 
> > possible that the driver doesn't actually have any zone restrictions and 
> > GFP_DMA can be removed, but this code is pretty old.  Otherwise, it'll 
> > need to depend on ZONE_DMA in the Kconfig.
> > 
> > Let's cc Nicolas and Russell as well.
> 
> Ouch.  We're probably going to have a pile of work to do to check that
> the DMA masks on all our devices are correct for the unrestricted case
> then.  That's probably going to be a very _big_ patch.
> 

There are probably a lot of drivers that are requesting DMA but don't 
explicitly require its support.  ARM has always been one of the exceptions 
when it comes to enabling CONFIG_ZONE_DMA, most archs do by default (x86 
_just_ made it configurable during this merge window), so this probably 
isn't the last report you'll get now that it fails the allocation and 
emits a warning.

	$ grep -r GFP_DMA drivers/* | wc -l
	299



arm, pxa2xx: enable DMA support for pxa2xx IRDA interface

The pxa2xx-ir driver allocates with GFP_DMA, so it must always have 
ZONE_DMA.

Reported-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/net/irda/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -374,6 +374,7 @@ config VIA_FIR
 config PXA_FICP
 	tristate "Intel PXA2xx Internal FICP"
 	depends on ARCH_PXA && IRDA
+	select ZONE_DMA
 	help
 	  Say Y or M here if you want to build support for the PXA2xx
 	  built-in IRDA interface which can support both SIR and FIR.
