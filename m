Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1DSUQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:16:49 -0400
Received: from kroah.org ([198.145.64.141]:47532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1DSUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:43 2011
Message-Id: <20110419201043.510943951@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [03/70] drm/radeon/kms: fix suspend on rv530 asics
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 71e16bfbd2b1c63d4d97cc5059694c9346aee340 upstream.

Apparently only rv515 asics need the workaround
added in f24d86f1a49505cdea56728b853a5d0a3f8e3d11
(drm/radeon/kms: fix resume regression for some r5xx laptops).

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=34709

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -32,6 +32,7 @@
 #include "atom.h"
 #include "atom-names.h"
 #include "atom-bits.h"
+#include "radeon.h"
 
 #define ATOM_COND_ABOVE		0
 #define ATOM_COND_ABOVEOREQUAL	1
@@ -101,7 +102,9 @@ static void debug_print_spaces(int n)
 static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 				 uint32_t index, uint32_t data)
 {
+	struct radeon_device *rdev = ctx->card->dev->dev_private;
 	uint32_t temp = 0xCDCDCDCD;
+
 	while (1)
 		switch (CU8(base)) {
 		case ATOM_IIO_NOP:
@@ -112,7 +115,8 @@ static uint32_t atom_iio_execute(struct
 			base += 3;
 			break;
 		case ATOM_IIO_WRITE:
-			(void)ctx->card->ioreg_read(ctx->card, CU16(base + 1));
+			if (rdev->family == CHIP_RV515)
+				(void)ctx->card->ioreg_read(ctx->card, CU16(base + 1));
 			ctx->card->ioreg_write(ctx->card, CU16(base + 1), temp);
 			base += 3;
 			break;


