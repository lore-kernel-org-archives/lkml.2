Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0D1KZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 06:25:54 -0400
Received: from server78.greatnet.de ([83.133.96.102]:35047 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0D1KZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 06:25:31 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: linux-fbdev@vger.kernel.org
Cc: ralf@linux-mips.org, arnaud.patard@rtp-net.org, jayakumar.lkml@gmail.com,
       gregkh@suse.de, yuasa@linux-mips.org, lethal@linux-sh.org,
       akpm@linux-foundation.org, adobriyan@gmail.com, support@simtec.co.uk,
       ben@simtec.co.uk, linux@simtec.co.uk, jkosina@suse.cz,
       pjones@redhat.com, linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 3/4] s3c2410fb: correct sections
Date: Wed, 28 Apr 2010 12:25:04 +0200
Message-Id: <1272450305-7284-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
References: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the drivers probe calls were changed from .init.text
to .devinit.text in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b
all the function from .init.text should be moved to .devinit.text, too.

The drivers remove calls can also be move from .text to .devexit.text.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
It would be nice if someone with an ARM gcc could test this patch and give
me some feedback if it works the way it should, since atm I'm lacking
a crosscompiler setup.
---
 drivers/video/s3c2410fb.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 2b094de..46b4309 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -631,7 +631,7 @@ static struct fb_ops s3c2410fb_ops = {
  *	cache.  Once this area is remapped, all virtual memory
  *	access to the video memory should occur at the new region.
  */
-static int __init s3c2410fb_map_video_memory(struct fb_info *info)
+static int __devinit s3c2410fb_map_video_memory(struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
 	dma_addr_t map_dma;
@@ -814,7 +814,7 @@ static inline void s3c2410fb_cpufreq_deregister(struct s3c2410fb_info *info)
 
 static char driver_name[] = "s3c2410fb";
 
-static int __init s3c24xxfb_probe(struct platform_device *pdev,
+static int __devinit s3c24xxfb_probe(struct platform_device *pdev,
 				  enum s3c_drv_type drv_type)
 {
 	struct s3c2410fb_info *info;
@@ -1018,7 +1018,7 @@ static int __devinit s3c2412fb_probe(struct platform_device *pdev)
 /*
  *  Cleanup
  */
-static int s3c2410fb_remove(struct platform_device *pdev)
+static int __devexit s3c2410fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
 	struct s3c2410fb_info *info = fbinfo->par;
@@ -1096,7 +1096,7 @@ static int s3c2410fb_resume(struct platform_device *dev)
 
 static struct platform_driver s3c2410fb_driver = {
 	.probe		= s3c2410fb_probe,
-	.remove		= s3c2410fb_remove,
+	.remove		= __devexit_p(s3c2410fb_remove),
 	.suspend	= s3c2410fb_suspend,
 	.resume		= s3c2410fb_resume,
 	.driver		= {
@@ -1107,7 +1107,7 @@ static struct platform_driver s3c2410fb_driver = {
 
 static struct platform_driver s3c2412fb_driver = {
 	.probe		= s3c2412fb_probe,
-	.remove		= s3c2410fb_remove,
+	.remove		= __devexit_p(s3c2410fb_remove),
 	.suspend	= s3c2410fb_suspend,
 	.resume		= s3c2410fb_resume,
 	.driver		= {
-- 
1.7.0

