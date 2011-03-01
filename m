Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1CASx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:53:29 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:45955 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab1CASx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:53:28 -0500
Date: Tue, 1 Mar 2011 10:53:22 -0800
From: Andres Salomon <dilinger@queued.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH] video/tmiofb: silence warnings introduced by mfd changes
Message-ID: <20110301105322.48754094@debxo>
In-Reply-To: <20110301154230.df32be17.sfr@canb.auug.org.au>
References: <20110301154230.df32be17.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 15:42:30 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64
> allmodconfig) produced these warnings:
> 
> drivers/video/tmiofb.c: In function 'tmiofb_hw_init':
> drivers/video/tmiofb.c:270: warning: initialization discards
> qualifiers from pointer target type drivers/video/tmiofb.c: In
> function 'tmiofb_hw_mode': drivers/video/tmiofb.c:314: warning:
> initialization discards qualifiers from pointer target type
> drivers/video/tmiofb.c:314: warning: unused variable 'cell'
> drivers/video/tmiofb.c: In function 'tmiofb_probe':
> drivers/video/tmiofb.c:683: warning: initialization discards
> qualifiers from pointer target type drivers/video/tmiofb.c: In
> function 'tmiofb_remove': drivers/video/tmiofb.c:811: warning:
> initialization discards qualifiers from pointer target type
> drivers/video/tmiofb.c: In function 'tmiofb_suspend':
> drivers/video/tmiofb.c:941: warning: initialization discards
> qualifiers from pointer target type drivers/video/tmiofb.c: In
> function 'tmiofb_resume': drivers/video/tmiofb.c:973: warning:
> initialization discards qualifiers from pointer target type
> 
> Introduced by commits 2a79bb1d72f5ac22dff96de340d90d512f852ecb ("mfd:
> mfd_cell is now implicitly available to tc6393xb drivers") and
> b6361637190e6cb7acb84509499942ada69e7136 ("fb: Use mfd_data instead of
> driver_data for tmio-fb").
> 

Oops, this should fix that.




From: Andres Salomon <dilinger@queued.net>

This silences warnings such as

drivers/video/tmiofb.c: In function 'tmiofb_hw_init':
drivers/video/tmiofb.c:270: warning: initialization discards qualifiers from pointer target type

These were added by me in commit 2a79bb1d.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/video/tmiofb.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index 7e57d3b..9710bf8 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -267,7 +267,7 @@ static int tmiofb_hw_stop(struct platform_device *dev)
  */
 static int tmiofb_hw_init(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct tmiofb_par *par = info->par;
 	const struct resource *nlcr = &cell->resources[0];
@@ -311,7 +311,6 @@ static int tmiofb_hw_init(struct platform_device *dev)
  */
 static void tmiofb_hw_mode(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	struct fb_videomode *mode = info->mode;
@@ -680,7 +679,7 @@ static struct fb_ops tmiofb_ops = {
 
 static int __devinit tmiofb_probe(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct tmio_fb_data *data = mfd_get_data(dev);
 	struct resource *ccr = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	struct resource *lcr = platform_get_resource(dev, IORESOURCE_MEM, 0);
@@ -808,7 +807,7 @@ err_ioremap_ccr:
 
 static int __devexit tmiofb_remove(struct platform_device *dev)
 {
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	struct fb_info *info = platform_get_drvdata(dev);
 	int irq = platform_get_irq(dev, 0);
 	struct tmiofb_par *par;
@@ -938,7 +937,7 @@ static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 #ifdef CONFIG_FB_TMIO_ACCELL
 	struct tmiofb_par *par = info->par;
 #endif
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	int retval = 0;
 
 	console_lock();
@@ -970,7 +969,7 @@ static int tmiofb_suspend(struct platform_device *dev, pm_message_t state)
 static int tmiofb_resume(struct platform_device *dev)
 {
 	struct fb_info *info = platform_get_drvdata(dev);
-	struct mfd_cell *cell = mfd_get_cell(dev);
+	const struct mfd_cell *cell = mfd_get_cell(dev);
 	int retval = 0;
 
 	console_lock();
-- 
1.7.2.3





