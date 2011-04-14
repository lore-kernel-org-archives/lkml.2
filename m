Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab1DNS1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:27:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:38072 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042Ab1DNRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 048/209] viafb: use proper register for colour when doing fill ops
Date: Thu, 14 Apr 2011 13:41:18 -0400
Message-Id: <1302803039-9400-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit efd4f6398dc92b5bf392670df862f42a19f34cf2 upstream.

The colour was written to a wrong register for fillrect operations.
This sometimes caused empty console space (for example after 'clear')
to have a different colour than desired. Fix this by writing to the
correct register.
Many thanks to Daniel Drake and Jon Nettleton for pointing out this
issue and pointing me in the right direction for the fix.

Fixes http://dev.laptop.org/ticket/9323

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/via/accel.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index d5077df..4400f91 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -277,11 +277,12 @@ static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
 		writel(tmp, engine + 0x1C);
 	}
 
-	if (op != VIA_BITBLT_COLOR)
+	if (op == VIA_BITBLT_FILL) {
+		writel(fg_color, engine + 0x58);
+	} else if (op == VIA_BITBLT_MONO) {
 		writel(fg_color, engine + 0x4C);
-
-	if (op == VIA_BITBLT_MONO)
 		writel(bg_color, engine + 0x50);
+	}
 
 	if (op == VIA_BITBLT_FILL)
 		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
-- 
1.7.4.4

