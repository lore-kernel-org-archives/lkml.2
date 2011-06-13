Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1FMMUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:20:04 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41852 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab1FMMTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:19:52 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 5/5] staging/easycap: Fix bytesperline calculation
Date: Mon, 13 Jun 2011 16:18:32 +0400
Message-Id: <bcbeb6b7c5ab7624ea59b072f74347fa8e6a6350.1307967011.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described above fillin_formats()

"""
    /*
     *  THE 16-BIT easycap_format.mask HAS MEANING:
     *    (least significant) BIT  0:     0 => PAL, 25 FPS;   1 => NTSC, 30 FPS
     *                        BITS 2-4:   RESERVED FOR DIFFERENTIATING STANDARDS
     *                        BITS 5-7:   NUMBER OF BYTES PER PIXEL
     *                        BIT  8:     0 => NATIVE BYTE ORDER;  1 => SWAPPED
     *                        BITS 9-10:  RESERVED FOR OTHER BYTE PERMUTATIONS
     *                        BIT 11:     0 => UNDECIMATED;    1 => DECIMATED
     *                        BIT 12:     0 => OFFER FRAMES;   1 => OFFER FIELDS
     *                        BIT 13:     0 => FULL FRAMERATE; 1 => REDUCED
     *     (most significant) BITS 14-15: RESERVED FOR OTHER FIELD/FRAME OPTIONS
     *  IT FOLLOWS THAT:
     *     bytesperpixel IS         ((0x00E0 & easycap_format.mask) >> 5)
     *     byteswaporder IS true IF (0 != (0x0100 & easycap_format.mask))
     *
     *     decimatepixel IS true IF (0 != (0x0800 & easycap_format.mask))
     *
     *       offerfields IS true IF (0 != (0x1000 & easycap_format.mask))
     */
"""

bytes-per-pixel is stored in bits 5-7 of calculated mask.

But when calculating bytes-per-line we were extracting wrong value
instead of bytes-per-pixel, which was usually 2 times bigger -- e.g. for
PAL YUV 422 I was getting ((mask3 & 0x00F0) >> 4) = 4 bytes instead of 2.

The error here is that even in comments there is a line saying

     *     bytesperpixel IS         ((0x00E0 & easycap_format.mask) >> 5)

but we were using
                                    ((0x00F0 & easycap_format.mask) >> 4)

With 2 times bigger bytesperpixel and automatically bytesperline, the
video was shown halfheight'ed, which is understandable if we look at
video-memory layout:

    <------- bytesperline -------->
    <- real bpl ->

    x0----------y0  x1-----------y1
    x2----------y2  x3-----------y3

    xn----------yn  xn-----------yn
    <garbage>

for each line, we should display width pixels, then move to next line
with bytesperline, and oops, if bytesperline = 2*real-bytesperlin, we'll
skip one line and move to next-next line, and so only half lines will be
shown.

Initially I've debugged the problem with my video application[1], but
I've checked that after this patch both rawv (mine app) and tvtime work
correctly.

[1] http://repo.or.cz/w/rawv.git

P.S. why at all we use those mask/shifts? Why not use bitfields?

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/staging/easycap/easycap_settings.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/easycap/easycap_settings.c b/drivers/staging/easycap/easycap_settings.c
index 898559d..70f59b1 100644
--- a/drivers/staging/easycap/easycap_settings.c
+++ b/drivers/staging/easycap/easycap_settings.c
@@ -567,7 +567,7 @@ int fillin_formats(void)
 				default:
 					return -3;
 				}
-				bytesperline = width * ((mask3 & 0x00F0) >> 4);
+				bytesperline = width * ((mask3 & 0x00E0) >> 5);
 				sizeimage =  bytesperline * height;
 
 				for (m = 0; m < INTERLACE_MANY; m++) {
-- 
1.7.6.rc1

