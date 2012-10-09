Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2JIUBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:01:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2JIUBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:01:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 0/3] new ARM-soc warning fixes
Date: Tue, 9 Oct 2012 20:01:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>
References: <1349796861-31164-1-git-send-email-arnd@arndb.de> <20121009174631.GA19606@quad.lixom.net>
In-Reply-To: <20121009174631.GA19606@quad.lixom.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201210092001.26947.arnd@arndb.de>
X-Provags-ID: V02:K0:rgt5fgv8/N1lEgAfooEWcBAgC2nedIvNwlG9RE+lHwe
 hWHy+GykL7ZAzIUKI/PKtz/n9s3Kee9KHplu0UlQVOVctAVhyj
 YMkfxb74eLwtnp+TAJ2ZcX5asXAUWgPwEddQ694aYS1UcOZvul
 wXPBi8vzV3IVThu0rnwvFIdOQfcj7CvgEeC7bBoSod3HhzaiuF
 xA2RzpaSGQi7/3w3NJ5nsvC/rIfbUSo85BFR/z1GEjwCrjmTPm
 M8WE41h6AB5V6/ya5M0ykfgDlyLq+Q9q55OnoQjH2kgp0F4G1f
 +5BQ4AE8bBnal7/3c4zPzU6VLvBFIfloF4BENnBquL65HcyeNu
 R26Yos3/rUiW4sjx3I20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Olof Johansson wrote:
> On Tue, Oct 09, 2012 at 05:34:18PM +0200, Arnd Bergmann wrote:
> > Hi Olof,
> > 
> > Here are three more fixes that I'd like to merge through the arm-soc
> > as time permits. All of them should be completely harmless and they
> > only fix harmless gcc warnings.
> > 
> > I don't know what your plans are for sending the next fixes branch.
> > I've uploaded these into a new "fixes2" branch on top of the patches
> > that are already in "fixes". We can either send them all together,
> > or you send the ones that are already queued first and these ones
> > with the next batch. Feel free to rebase if necessary.
> 
> I've pulled it in and will send up with fixes tonight (Tony has OMAP
> fixes coming, others might too).
> 

Ok, thanks!

I just noticed that I was missing yet another one, which I now added
directly. It was part of a longer series I sent last week. I wasn't
really sure whether this one would better be included in arm-soc or
Russell's arm tree and then I ended up not putting it in either series :(

	Arnd

8<----------
>From bfbad32a63fa6287723961f07bcd043dc9c5965c Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 30 Apr 2012 13:34:13 +0000
Subject: [PATCH] ARM: pxa: armcore: fix PCI PIO warnings

The it8152 PCI host used on the pxa/cm_x2xx machines
uses the old-style I/O window registration. This should
eventually get converted to pci_ioremap_io() but for
now, let's cast the IT8152_IO_BASE constant to an integer
type to get rid of the warnings.

Without this patch, building cm_x2xx_defconfig results in:

arch/arm/common/it8152.c: In function 'it8152_pci_setup':
arch/arm/common/it8152.c:287:18: warning: assignment makes integer from pointer without a cast [enabled by default]
arch/arm/common/it8152.c:288:16: warning: assignment makes integer from pointer without a cast [enabled by default]
arch/arm/common/it8152.c:291:17: warning: assignment makes integer from pointer without a cast [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index c4110d1..001f491 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -284,11 +284,17 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 
 int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 {
-	it8152_io.start = IT8152_IO_BASE + 0x12000;
-	it8152_io.end	= IT8152_IO_BASE + 0x12000 + 0x100000;
+	/*
+	 * FIXME: use pci_ioremap_io to remap the IO space here and
+	 * move over to the generic io.h implementation.
+	 * This requires solving the same problem for PXA PCMCIA
+	 * support.
+	 */
+	it8152_io.start = (unsigned long)IT8152_IO_BASE + 0x12000;
+	it8152_io.end	= (unsigned long)IT8152_IO_BASE + 0x12000 + 0x100000;
 
 	sys->mem_offset = 0x10000000;
-	sys->io_offset  = IT8152_IO_BASE;
+	sys->io_offset  = (unsigned long)IT8152_IO_BASE;
 
 	if (request_resource(&ioport_resource, &it8152_io)) {
 		printk(KERN_ERR "PCI: unable to allocate IO region\n");
