Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2HOTvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62992 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab2HOTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Paul Fertser <fercerpav@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 095/165] plat-mxc: iomux-v3.h: implicitly enable pull-up/down when that's desired
Date: Wed, 15 Aug 2012 15:47:19 -0400
Message-ID: <1345060109-9187-96-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fertser <fercerpav@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6571534b600b8ca1936ff5630b9e0947f21faf16 upstream.

To configure pads during the initialisation a set of special constants
is used, e.g.
#define MX25_PAD_FEC_MDIO__FEC_MDIO IOMUX_PAD(0x3c4, 0x1cc, 0x10, 0, 0, PAD_CTL_HYS | PAD_CTL_PUS_22K_UP)

The problem is that no pull-up/down is getting activated unless both
PAD_CTL_PUE (pull-up enable) and PAD_CTL_PKE (pull/keeper module
enable) set. This is clearly stated in the i.MX25 datasheet and is
confirmed by the measurements on hardware. This leads to some rather
hard to understand bugs such as misdetecting an absent ethernet PHY (a
real bug i had), unstable data transfer etc. This might affect mx25,
mx35, mx50, mx51 and mx53 SoCs.

It's reasonable to expect that if the pullup value is specified, the
intention was to have it actually active, so we implicitly add the
needed bits.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/plat-mxc/include/mach/iomux-v3.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
index f2f73d3..1f0b102 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -73,11 +73,11 @@ struct pad_desc {
 #define PAD_CTL_HYS			(1 << 8)
 
 #define PAD_CTL_PKE			(1 << 7)
-#define PAD_CTL_PUE			(1 << 6)
-#define PAD_CTL_PUS_100K_DOWN		(0 << 4)
-#define PAD_CTL_PUS_47K_UP		(1 << 4)
-#define PAD_CTL_PUS_100K_UP		(2 << 4)
-#define PAD_CTL_PUS_22K_UP		(3 << 4)
+#define PAD_CTL_PUE			(1 << 6 | PAD_CTL_PKE)
+#define PAD_CTL_PUS_100K_DOWN		(0 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_47K_UP		(1 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_100K_UP		(2 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_22K_UP		(3 << 4 | PAD_CTL_PUE)
 
 #define PAD_CTL_ODE			(1 << 3)
 
-- 
1.7.12.rc2

