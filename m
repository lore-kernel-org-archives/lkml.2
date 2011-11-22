Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1KVXfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:35:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1KVXfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:35:10 -0500
Date: Wed, 23 Nov 2011 00:34:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andrei Warkentin <andreiw@vmware.com>, linux-kernel@vger.kernel.org,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, opensuse-kernel@opensuse.org,
        Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
In-Reply-To: <20111117150549.15528e81.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1111230032200.29085@axis700.grange>
References: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
 <20111117150549.15528e81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:MedCpN9y59qFkg8CKT7yyaO7kkREfPJb5UYuJuLCxzq
 Kw7NGQ4wQSK6r+I9+w5EunXrifr+SW17mB8MYPSPalM9W1vTQk
 XugY21dLZgzvoBi2458jaDIPGQEVCmKzQvUk+OlfCDUSYnf/po
 DeiU8TinDhGsq9iDvhM7ZW7nkf+Nvw/ug2lx9oQ/iJoXaB5lEL
 YlFd4jp7VrEMom8l8j3a5R9JDT32O9uCzLyztQ6sF+IoFYCOG8
 MBhoBLIgOGjywJq0fIoItZGA4uho4hnZbNZ3kVrakI7vQaoR4c
 93xgRz/WJa3OF0ielrUYeaF+OAsF3jS3YfcPoHQEWEc3kEOvP9
 YSJusY+e7joJwufwjde3KJHmQxxyJqueycd5rHnXPpuud/765/
 4H24UQ0TTZWKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Andrew Morton wrote:

[snip]

> drivers/mmc/host/sh_mmcif.c unnecessarily uses __rounddown_pow_of_two()
> then feeds the result into ilog2() in an apparent attempt to
> reimplement fls().

Yeah, I was wondering too, but wasn't sufficiently motivated to patch 
it;-) I'll test this "obvious" patch tomorrow and submit then:

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index c021482..824fee5 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <linux/bitops.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -386,7 +387,7 @@ static void sh_mmcif_clock_control(struct sh_mmcif_host *host, unsigned int clk)
 		sh_mmcif_bitset(host, MMCIF_CE_CLK_CTRL, CLK_SUP_PCLK);
 	else
 		sh_mmcif_bitset(host, MMCIF_CE_CLK_CTRL, CLK_CLEAR &
-			(ilog2(__rounddown_pow_of_two(host->clk / clk)) << 16));
+				((fls(host->clk / clk) - 1) << 16));
 
 	sh_mmcif_bitset(host, MMCIF_CE_CLK_CTRL, CLK_ENABLE);
 }

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
