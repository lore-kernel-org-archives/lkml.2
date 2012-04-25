Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2DYRPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:15:48 -0400
Received: from d1.icnet.pl ([212.160.220.21]:57031 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab2DYRPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:15:46 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v3.4-rc3] MTD: NAND: ams-delta: Fix request_mem_region() failure
Date: Wed, 25 Apr 2012 19:01:14 +0200
Message-ID: <1587089.0XMyH6e1Ic@acer>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <1335366823.6356.11.camel@koala>
References: <1334670557-25640-1-git-send-email-jkrzyszt@tis.icnet.pl> <1335366823.6356.11.camel@koala>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia środa, 25 kwietnia 2012 18:13:38 Artem Bityutskiy pisze:
> On Tue, 2012-04-17 at 15:49 +0200, Janusz Krzysztofik wrote:
> > A call to request_mem_region() has been introduced in the omap-gpio
> > driver recently (commit 96751fcbe5438e95514b025e9cee7a6d38038f40,
> > "gpio/omap: Use devm_ API and add request_mem_region"). This change
> > prevented the Amstrad Delta NAND driver, which was doing the same in
> > order to take control over OMAP MPU I/O lines that the NAND device 
hangs
> > off, from loading successfully.
> > 
> > There is another driver, omap-keypad, which also manipulates OMAP 
MPUIO
> > registers, but has never been calling request_mem_region() on 
startup,
> > so it's not affected by the change in the gpio-omap and works 
correctly.
> > 
> > Drop request_mem_region() call and related bits from ams-delta NAND
> > driver.
> > 
> > Created and tested against linux-3.4-rc3.
> > 
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> How about race conditions? Where is the guarantee that these 2 drivers
> won't affect each other when doing I/O at the same time to the same HW
> resources?

Both drivers use separate subsets of registers that belong to the OMAP1 
MPU I/O device, but are used for controlling different sets of I/O pins. 
The NAND driver reads/writes the folowing registers:
- OMAP_MPUIO_INPUT_LATCH,
- OMAP_MPUIO_OUTPUT,
- OMAP_MPUIO_IO_CNTL,
while the keypad driver - the following:
- OMAP_MPUIO_KBR_LATCH,
- OMAP_MPUIO_KBC,
- OMAP_MPUIO_KBD_MASKIT
- OMAP_MPUIO_GPIO_DEBOUNCING.
Both subsets are non-overlapping, and we rely on the drivers being free 
of bugs and doing their job correctly, not stepping on each others' 
feet, I guess.

Thanks,
Janusz
