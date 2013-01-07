Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3AGPqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:46:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:32939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3AGPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:46:42 -0500
Date: Mon, 7 Jan 2013 13:46:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
Message-ID: <20130107134605.2825d1b0@infradead.org>
In-Reply-To: <CAOMZO5Cpa2OYd+v=wE4hbw=sjmQk+bP1HrY49PEWmwRyiVD1dg@mail.gmail.com>
References: <1357553025-21094-1-git-send-email-s.hauer@pengutronix.de>
	<CAOMZO5Cpa2OYd+v=wE4hbw=sjmQk+bP1HrY49PEWmwRyiVD1dg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 7 Jan 2013 08:16:02 -0200
Fabio Estevam <festevam@gmail.com> escreveu:

> Hi Sascha,
> 
> On Mon, Jan 7, 2013 at 8:03 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> > location of iram.h, which causes the following build error when building the coda
> > driver:
> >
> > drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> > drivers/media/platform/coda.c: In function 'coda_probe':
> > drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> > drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> > drivers/media/platform/coda.c: In function 'coda_remove':
> > drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free'
> >
> > Since the content of iram.h is not imx specific, move it to
> > include/linux/platform_data/imx-iram.h instead. This is an intermediate solution
> > until the i.MX iram allocator is converted to the generic SRAM allocator.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >
> > Based on an earlier version from Fabio Estevam, but this one moves iram.h
> > to include/linux/platform_data/imx-iram.h instead of include/linux/iram.h
> > which is a less generic name.
> >
> >  arch/arm/mach-imx/iram.h               |   41 --------------------------------
> >  arch/arm/mach-imx/iram_alloc.c         |    3 +--
> >  drivers/media/platform/coda.c          |    2 +-
> >  include/linux/platform_data/imx-iram.h |   41 ++++++++++++++++++++++++++++++++
> >  4 files changed, 43 insertions(+), 44 deletions(-)
> >  delete mode 100644 arch/arm/mach-imx/iram.h
> >  create mode 100644 include/linux/platform_data/imx-iram.h
> 
> It would be better to use git mv /git format-patch -M, so that git can
> detect the file rename.

Agreed. Anyway, I applied here and did a git show -M:

From: Sascha Hauer <s.hauer@pengutronix.de>
Date: Mon, 7 Jan 2013 11:03:45 +0100
Subject: [PATCH] coda: Fix build due to iram.h rename

commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
location of iram.h, which causes the following build error when building the coda
driver:

drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
drivers/media/platform/coda.c: In function 'coda_probe':
drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
drivers/media/platform/coda.c: In function 'coda_remove':
drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free'

Since the content of iram.h is not imx specific, move it to
include/linux/platform_data/imx-iram.h instead. This is an intermediate solution
until the i.MX iram allocator is converted to the generic SRAM allocator.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

diff --git a/arch/arm/mach-imx/iram_alloc.c b/arch/arm/mach-imx/iram_alloc.c
index 6c80424..e05cf40 100644
--- a/arch/arm/mach-imx/iram_alloc.c
+++ b/arch/arm/mach-imx/iram_alloc.c
@@ -22,8 +22,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/genalloc.h>
-
-#include "iram.h"
+#include "linux/platform_data/imx-iram.h"
 
 static unsigned long iram_phys_base;
 static void __iomem *iram_virt_base;
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 2721f83..16a243d 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -23,8 +23,8 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
+#include <linux/platform_data/imx-iram.h>
 
-#include <mach/iram.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/arch/arm/mach-imx/iram.h b/include/linux/platform_data/imx-iram.h
similarity index 100%
rename from arch/arm/mach-imx/iram.h
rename to include/linux/platform_data/imx-iram.h

Cheers,
Mauro
