Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2HTEIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:08:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2HTEA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: =?UTF-8?q?=5B=2018/46=5D=20drm/radeon=3A=20fix=20bank=20tiling=20parameters=20on=20SI?=
Date: Sun, 19 Aug 2012 20:58:54 -0700
Message-Id: <20120820035834.804237874@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <deathsimple@vodafone.de>

commit dca571a6a4edda1f61ba7ecb47431a22245490a3 upstream.

The sixteen bank case wasn't handled here, leading to GPU
crashes because of userspace miscalculation.

Signed-off-by: Christian König <deathsimple@vodafone.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1639,11 +1639,19 @@ static void si_gpu_init(struct radeon_de
 		/* XXX what about 12? */
 		rdev->config.si.tile_config |= (3 << 0);
 		break;
-	}
-	if ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT)
-		rdev->config.si.tile_config |= 1 << 4;
-	else
+	}
+	switch ((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT) {
+	case 0: /* four banks */
 		rdev->config.si.tile_config |= 0 << 4;
+		break;
+	case 1: /* eight banks */
+		rdev->config.si.tile_config |= 1 << 4;
+		break;
+	case 2: /* sixteen banks */
+	default:
+		rdev->config.si.tile_config |= 2 << 4;
+		break;
+	}
 	rdev->config.si.tile_config |=
 		((gb_addr_config & PIPE_INTERLEAVE_SIZE_MASK) >> PIPE_INTERLEAVE_SIZE_SHIFT) << 8;
 	rdev->config.si.tile_config |=


