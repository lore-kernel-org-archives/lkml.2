Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab0KWCiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 21:38:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60620 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab0KWCiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 21:38:09 -0500
Date: Tue, 23 Nov 2010 13:38:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlJpY2hhcmQgUsO2amZvcnMi?= 
	<richard.rojfors@pelagicore.com>
Subject: linux-next: build failure after merge of the final tree (v4l-dvb
 tree related)
Message-Id: <20101123133807.ecadba39.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/media/video/timblogiw.c: In function 'timblogiw_probe':
drivers/media/video/timblogiw.c:749: error: timblogiw_ioctl_ops causes a section type conflict

Caused by commit ef6ce9acc5f87e253c97dfd5301f8036f937f595 ("[media]
[1/2,v4] media: Add timberdale video-in driver") which declared some
structs as const and __devinitdata.  They should use __devinitconst.

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Nov 2010 13:35:17 +1100
Subject: [PATCH] media: const and __devinitdata do not mix

This fixes the following error in PowerPC builds:

drivers/media/video/timblogiw.c: In function 'timblogiw_probe':
drivers/media/video/timblogiw.c:749: error: timblogiw_ioctl_ops causes a section type conflict

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/video/timblogiw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index bddcdb6..cf48aa9 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -746,7 +746,7 @@ static int timblogiw_mmap(struct file *file, struct vm_area_struct *vma)
 
 /* Platform device functions */
 
-static const __devinitdata struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
+static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_querycap		= timblogiw_querycap,
 	.vidioc_enum_fmt_vid_cap	= timblogiw_enum_fmt,
 	.vidioc_g_fmt_vid_cap		= timblogiw_g_fmt,
@@ -768,7 +768,7 @@ static const __devinitdata struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_enum_framesizes		= timblogiw_enum_framesizes,
 };
 
-static const __devinitdata struct v4l2_file_operations timblogiw_fops = {
+static __devinitconst struct v4l2_file_operations timblogiw_fops = {
 	.owner		= THIS_MODULE,
 	.open		= timblogiw_open,
 	.release	= timblogiw_close,
@@ -778,7 +778,7 @@ static const __devinitdata struct v4l2_file_operations timblogiw_fops = {
 	.poll		= timblogiw_poll,
 };
 
-static const __devinitdata struct video_device timblogiw_template = {
+static __devinitconst struct video_device timblogiw_template = {
 	.name		= TIMBLOGIWIN_NAME,
 	.fops		= &timblogiw_fops,
 	.ioctl_ops	= &timblogiw_ioctl_ops,
-- 
1.7.2.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
