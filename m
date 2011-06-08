Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1FHKZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:25:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60884 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1FHKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:25:10 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/15] staging/gma500: get control from firmware framebuffer
 if conflicts
To: greg@kroah.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 08 Jun 2011 11:12:51 +0100
Message-ID: <20110608101239.9478.21772.stgit@localhost.localdomain>
In-Reply-To: <20110608100411.9478.86672.stgit@localhost.localdomain>
References: <20110608100411.9478.86672.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Chang <mchang@novell.com>

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
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 4e6294c..4b05cdc 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -452,6 +452,16 @@ static int psbfb_create(struct psb_fbdev *fbdev,
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

