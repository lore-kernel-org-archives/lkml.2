Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2FZEPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:15:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55790 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2FZEPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:15:05 -0400
Date: Mon, 25 Jun 2012 23:14:58 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Lukas Anzinger <l.anzinger@gmail.com>, Adam Jackson <ajax@redhat.com>,
        Eric Anholt <eric@anholt.net>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32.y] drm/i915: Attempt to fix watermark setup on 85x (v2)
Message-ID: <20120626041458.GC3010@burratino>
References: <1340625038-11257-1-git-send-email-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340625038-11257-1-git-send-email-stefan.bader@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Jackson <ajax@redhat.com>
Date: Fri, 16 Apr 2010 18:20:57 -0400

commit 8f4695ed1c9e068772bcce4cd4ff03f88d57a008 upstream.

IS_MOBILE() catches 85x, so we'd always try to use the 9xx FIFO sizing;
since there's an explicit 85x version, this seems wrong.

v2: Handle 830m correctly too.

[jn: backport to 2.6.32.y to address
 https://bugzilla.kernel.org/show_bug.cgi?id=42839]

Signed-off-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi Willy,

Lukas Anzinger wrote[1]:

> I've encountered a nasty bug in the drm/i915 part of Debian's stable kernel.
> The code is also present in 2.6.33.20, which is the latest stable upstream
> release of 2.6.33.y at the time of writing.
>
> During a refactoring of the i915 driver a regression has been introduced
> (commit e70236a8d3d0a4c100a0b9f7d394d9bda9c56aca): For some chipsets the wrong
> fifo size is determined which results in lot's of pixel errors when starting
> the xserver and choosing 800x600 as a resolution. If another resolution is used
> (eg. 1024x768 or 1280x1024), I don't encounter this problem.

Linux 2.6.32.y is presumably also affected because the problematic
commit was applied during the 2.6.32 merge window.

 e70236a8d3d0 "drm/i915: split display functions by chip type",
              2009-09-21

Lukas tested the fix against a kernel with 2.6.33.y-based drm
subsystem and found it to work:

 8f4695ed1c9e drm/i915: Attempt to fix watermark setup on 85x (v2),
              2010-04-16

and therefore Stefan is staging this fix for 2.6.32.y+drm33.z
(thanks!).  Newer stable lines work fine already because the fix hit
mainline in v2.6.34-rc6.

The patch applies cleanly to v2.6.32.59 and is included below for
reference.  I don't know if anyone has tested it there, though.  All I
can say for now is that it is tested against 2.6.33-based kernels and
looks obviously correct.  What do you think?

Hope that helps,
Jonathan

[1] https://bugzilla.kernel.org/show_bug.cgi?id=42839

 drivers/gpu/drm/i915/intel_display.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 79cc437af3b8..25b3e903c67c 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4355,17 +4355,18 @@ static void intel_init_display(struct drm_device *dev)
 		dev_priv->display.update_wm = g4x_update_wm;
 	else if (IS_I965G(dev))
 		dev_priv->display.update_wm = i965_update_wm;
-	else if (IS_I9XX(dev) || IS_MOBILE(dev)) {
+	else if (IS_I9XX(dev)) {
 		dev_priv->display.update_wm = i9xx_update_wm;
 		dev_priv->display.get_fifo_size = i9xx_get_fifo_size;
+	} else if (IS_I85X(dev)) {
+		dev_priv->display.update_wm = i9xx_update_wm;
+		dev_priv->display.get_fifo_size = i85x_get_fifo_size;
 	} else {
-		if (IS_I85X(dev))
-			dev_priv->display.get_fifo_size = i85x_get_fifo_size;
-		else if (IS_845G(dev))
+		dev_priv->display.update_wm = i830_update_wm;
+		if (IS_845G(dev))
 			dev_priv->display.get_fifo_size = i845_get_fifo_size;
 		else
 			dev_priv->display.get_fifo_size = i830_get_fifo_size;
-		dev_priv->display.update_wm = i830_update_wm;
 	}
 }
 
-- 
1.7.11.rc3

