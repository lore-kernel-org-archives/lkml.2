Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1E3Gb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:31:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1E3Gb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=g9yZuboFk6URdMY56LZk/u79HoelsQEB27pECOCZezBwzyBWPeBfWAdtn3A+MhZ9QH
         Rj7/AQvv/sjslbSiik5FOtHrYTFz5pvwno+q3Tc/D4zgOPj4xyn9Y3KyupIDCGUW48Ui
         TwERpOKlVND37gyUAHtPPB8bBcutcbG2QY2VQ=
From: Michael Chang <mchang@novell.com>
To: gregkh@suse.de
Cc: alan@linux.intel.com, error27@gmail.com, justinmattock@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Chang <mchang@novell.com>
Subject: [PATCH v2] staging/gma500: get control from firmware framebuffer if conflicts
Date: Mon, 30 May 2011 14:28:25 +0800
Message-Id: <1306736905-25237-1-git-send-email-mchang@novell.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Linux distributions would enable vesafb in order to display
early stage boot splash. In this case, we will get garbled X
Window screen if running X fbdev on psbfb.

This is because fb0 is occupied by vesafb while psbfb is on fb1.
They tried to drive the same pieces of hardware at the same
time. With unmodified X start-up, it would try to use default
fb0 framebuffer device and unfortunately it is now broken
becaues fb1 supersedes it.

We should let psbfb takeover framebuffer control from vesafb
to get around this problem.

See also commit : 4410f3910947dcea8672280b3adecd53cec4e85e

Signed-off-by: Michael Chang <mchang@novell.com>
---
 drivers/staging/gma500/psb_fb.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 99c03a2..084c36b 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -441,6 +441,16 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	info->screen_size = size;
 	memset(info->screen_base, 0, size);
 
+	if (dev_priv->pg->stolen_size) {
+		info->apertures = alloc_apertures(1);
+		if (!info->apertures) {
+			ret = -ENOMEM;
+			goto out_err0;
+		}
+		info->apertures->ranges[0].base = dev->mode_config.fb_base;
+		info->apertures->ranges[0].size = dev_priv->pg->stolen_size;
+	}
+
 	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
 	drm_fb_helper_fill_var(info, &fbdev->psb_fb_helper,
 				sizes->fb_width, sizes->fb_height);
-- 
1.7.3.4

