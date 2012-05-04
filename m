Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2EDTsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:48:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab2EDTsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:48:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
Date: Fri, 4 May 2012 19:47:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, horms@verge.net.au,
        olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <20120503144654.6390.56399.sendpatchset@w520> <201205041307.46080.arnd@arndb.de>
In-Reply-To: <201205041307.46080.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041947.38375.arnd@arndb.de>
X-Provags-ID: V02:K0:G8pJ54Ftp9sLQNGGakWWNPqioNi7JB5VpahUGEeTcvL
 oKv39O+Fi9LNkcdH9LA5y8OQcYjyUD5bpA5uugnp+rfs51pzJ7
 /FJRPAhPxdyaCf2EdJNdqoBWlfr4/S7o5Il4R7sYhiMvYd22Mj
 o1Sp1D5AAdgLFVSF6AVzKlmoP8J25bOgiC+9Sdoq1DJlUwlnYN
 Xm9qw+93rvqvtXPL+OWyeBpDHVTmSI9pEIeynm349KQiHBgfbU
 0o0SD1WodnIGGsF5DeaaAoWnLq4lDefW27roxIIyqfakkJg0yv
 K8oaTF4rA6jGv0Dm44i+EzAv4Ms8U76ZQG9q61Hz9sLO9MS1RY
 sq9NXw6zvgRNZRKI7Lws=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Arnd Bergmann wrote:
> 
> On Thursday 03 May 2012, Magnus Damm wrote:
> 
> > +
> > +/* EMEV2 SMU registers */
> > +#define USIAU0_RSTCTRL 0xe0110094
> > +#define USIBU1_RSTCTRL 0xe01100ac
> > +#define USIBU2_RSTCTRL 0xe01100b0
> > +#define USIBU3_RSTCTRL 0xe01100b4
> > +#define STI_RSTCTRL 0xe0110124
> > +#define USIAU0GCLKCTRL 0xe01104a0
> > +#define USIBU1GCLKCTRL 0xe01104b8
> > +#define USIBU2GCLKCTRL 0xe01104bc
> > +#define USIBU3GCLKCTRL 0xe01104c0
> > +#define STIGCLKCTRL 0xe0110528
> > +#define USIAU0SCLKDIV 0xe011061c
> > +#define USIB2SCLKDIV 0xe011065c
> > +#define USIB3SCLKDIV 0xe0110660
> > +#define STI_CLKSEL 0xe0110688
> 
> Please cast to __iomem* here, e.g. using the IOMEM() macro, as these are
> virtual addresses.

I should revise that: there is no excuse to hardcode these virtual address
here at all. Just use call ioremap() on the physical address for the
clock registers (0xe0110000) and use the resulting pointer with an
offset that you define locally in this file.

It is safe to call ioremap when you get to emev2_clock_init()
and you will still get a large page mapping with the recent
code reworks for map_desc.

Regarding the iotable that is currently defined as

+static struct map_desc emev2_io_desc[] __initdata = {
+       /* 128K entity map for 0xe0020000 (GIC) */
+       {
+               .virtual        = 0xe0020000,
+               .pfn            = __phys_to_pfn(0xe0020000),
+               .length         = SZ_128K,
+               .type           = MT_UNCACHED
+       },
+       /* 128K entity map for 0xe0100000 (SMU) */
+       {
+               .virtual        = 0xe0100000,
+               .pfn            = __phys_to_pfn(0xe0100000),
+               .length         = SZ_128K,
+               .type           = MT_DEVICE
+       },
+};

I would recommend just mapping the entire 16MB page around this, or at least
2 MB, so you can benefit from the larger mappings. If you don't do that,
better remove the entire iotable registration and rely on ioremap, the
result will be the same and you can be prevent any hacks from creeping in
that rely on the virtual address being the same as the physical address.

	Arnd
