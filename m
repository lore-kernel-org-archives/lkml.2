Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0JXQdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:33:11 -0400
Received: from mx.treblig.org ([80.68.94.177]:39574 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab0JXQdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:33:10 -0400
Date: Sun, 24 Oct 2010 17:33:09 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: [PATCH] Guard a divide in v4l1 compat layer
Message-ID: <20101024163308.GA6612@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.20-kvm-i386-20100823 (i686)
X-Uptime: 17:22:02 up 60 days, 48 min,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I managed to trigger a divide by 0 in the v4l compat code
with the mem2mem test module; I suspect perhaps it shouldn't
have been returning a 0 pixel wide picture, but either way it seems
right to guard this divide by 0 in the compatibility layer.

Tested on 2.6.36 (ubuntu build, but the code in this is the same as upstream), 
but ***not tested with a real video device***.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
--
diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index 0c2105c..d4ac751 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -645,9 +645,16 @@ static noinline long v4l1_compat_get_picture(
 		goto done;
 	}
 
-	pict->depth   = ((fmt->fmt.pix.bytesperline << 3)
-			 + (fmt->fmt.pix.width - 1))
-			 / fmt->fmt.pix.width;
+	if (fmt->fmt.pix.width)
+	{
+		pict->depth   = ((fmt->fmt.pix.bytesperline << 3)
+				 + (fmt->fmt.pix.width - 1))
+				 / fmt->fmt.pix.width;
+	} else {
+		err = -EINVAL;
+		goto done;
+	}
+
 	pict->palette = pixelformat_to_palette(
 		fmt->fmt.pix.pixelformat);
 done:

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
