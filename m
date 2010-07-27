Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0G0VTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 17:19:11 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:51319 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964Ab0G0VTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 17:19:10 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] [resend] cyber2000fb: fix machine hang on module load
Date: Tue, 27 Jul 2010 23:18:55 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201007271529.22520.linux@rainbow-software.org> <20100727162510.GB17099@n2100.arm.linux.org.uk>
In-Reply-To: <20100727162510.GB17099@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007272318.57975.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 July 2010 18:25:11 Russell King - ARM Linux wrote:
> On Tue, Jul 27, 2010 at 03:29:20PM +0200, Ondrej Zary wrote:
> > Hello,
> > I was testing two CyberPro 2000 based PCI cards on x86 and the machine
> > always hanged completely when the cyber2000fb module was loaded. It seems
> > that the card hangs when some registers are accessed too quickly after
> > writing RAMDAC control register. With this patch, both card work.
> >
> > Add delay after RAMDAC control register write to prevent hangs on module
> > load.
>
> This one on the other hand I think is rather too heavy.
>
> What might be better is to re-code the last register write to use
> the x86 outb_p() stuff to slow it down, rather than using udelay().
> Could you try something along those lines please?

Is this better?


I was testing two CyberPro 2000 based PCI cards on x86 and the machine always
hanged completely when the cyber2000fb module was loaded. It seems that the
card hangs when some registers are accessed too quickly after writing RAMDAC
control register. With this patch, both card work.

Add delay after RAMDAC control register write to prevent hangs on module load.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc2-orig/drivers/video/cyber2000fb.c	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-27 23:12:37.000000000 +0200
@@ -436,6 +436,8 @@ static void cyber2000fb_write_ramdac_ctr
 	cyber2000fb_writeb(i | 4, 0x3cf, cfb);
 	cyber2000fb_writeb(val, 0x3c6, cfb);
 	cyber2000fb_writeb(i, 0x3cf, cfb);
+	/* prevent card lock-up observed on x86 with CyberPro 2000 */
+	cyber2000fb_readb(0x3cf, cfb);
 }
 
 static void cyber2000fb_set_timing(struct cfb_info *cfb, struct par_info *hw)



-- 
Ondrej Zary
