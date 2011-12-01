Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1LAIGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:06:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50048 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LAIGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:06:34 -0500
Date: Thu, 1 Dec 2011 09:06:14 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: JBottomley@parallels.com, linux-arm-kernel@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: prevent inlining in arxescsi.c causing build
 failures
Message-ID: <20111201080613.GF26618@pengutronix.de>
References: <1322713611-30003-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322713611-30003-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 11:26:51PM -0500, Paul Gortmaker wrote:
> The following failure is seen in routine coverage builds:
> 
>   CC [M]  drivers/scsi/arm/arxescsi.o
> /tmp/cccEyiO7.s: Assembler messages:
> /tmp/cccEyiO7.s:334: Error: symbol `.loop_1' is already defined
> /tmp/cccEyiO7.s:337: Error: symbol `.loop_2' is already defined
> /tmp/cccEyiO7.s:343: Error: symbol `.loop_3' is already defined
> /tmp/cccEyiO7.s:365: Error: symbol `.loop_1' is already defined
> /tmp/cccEyiO7.s:368: Error: symbol `.loop_2' is already defined
> /tmp/cccEyiO7.s:374: Error: symbol `.loop_3' is already defined
> make[4]: *** [drivers/scsi/arm/arxescsi.o] Error 1
> 
> It is caused by multiple inline of arxescsi_pseudo_dma_write()
> which is responsible for the above labels.  Marking the fcn
> as non-inline fixes the issue.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Is that a compiler or a code issue? If it's the compiler please fix
that. If it's the code, then please document why you added the noinline.

Having said that, "my" compiler compiles drivers/scsi/arm/arxescsi.o
just fine (using rpc_defconfig on v3.2-rc2).

> diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
> index a750aa7..2608a9e 100644
> --- a/drivers/scsi/arm/arxescsi.c
> +++ b/drivers/scsi/arm/arxescsi.c
> @@ -72,7 +72,8 @@ arxescsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
>  	return fasdma_pseudo;
>  }
>  
> -static void arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
> +static noinline void
> +arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
Shouldn't this line get some indention?

>  {
>         __asm__ __volatile__(
>         "               stmdb   sp!, {r0-r12}\n"

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
