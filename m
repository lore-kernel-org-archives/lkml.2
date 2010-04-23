Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0DWQc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:32:28 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:39896 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750732Ab0DWQc0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:32:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=blclBRvLGvg3UqzMC01BFOK80Zfk7I7tDTbDGsS47JDpaCCHWl9x1VlSZ9aPXDSLV173eNQMCT5la0QT+3eSN/8QJY8Txt1E87+cLJm51BZzZpOaW+Ikk5hq9377v26k;
Date: Fri, 23 Apr 2010 09:32:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>, eric@anholt.net,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: [PATCH] drm/i915: fix non-Ironlake 965 class crashes
Message-ID: <20100423093223.7adb9861@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My PIPE_CONTROL fix (just sent via Eric's tree) was buggy; I was
testing a whole set of patches together and missed a conversion to the
new HAS_PIPE_CONTROL macro, which will cause breakage on non-Ironlake
965 class chips.  Fortunately, the fix is trivial and has been tested.

Be sure to use the HAS_PIPE_CONTROL macro in i915_get_gem_seqno, or
we'll end up reading the wrong graphics memory, likely causing hangs,
crashes, or worse.

Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 7f52cc1..ef3d91d 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1793,7 +1793,7 @@ i915_get_gem_seqno(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
-	if (IS_I965G(dev))
+	if (HAS_PIPE_CONTROL(dev))
 		return ((volatile u32 *)(dev_priv->seqno_page))[0];
 	else
 		return READ_HWSP(dev_priv, I915_GEM_HWS_INDEX);
