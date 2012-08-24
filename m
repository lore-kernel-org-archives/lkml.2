Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab2HXTUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:20:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57200 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2HXTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:20:13 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH drm-next v2] drm: udl: usb: Fix recursive Kconfig dependency
Date: Fri, 24 Aug 2012 21:20:03 +0200
Message-Id: <1345836003-18541-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/usb/Kconfig "config USB_ARCH_HAS_HCD" is within "if USB_SUPPORT"
statement.

In drivers/gpu/drm/Kconfig "config DRM_USB" depends on USB_ARCH_HAS_HCD
but selects USB_SUPPORT which leads to the error for udl Kconfig:

$ yes "" | make oldconfig
scripts/kconfig/conf --oldconfig Kconfig
drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
drivers/gpu/drm/udl/Kconfig:1:  symbol DRM_UDL depends on USB_ARCH_HAS_HCD
drivers/usb/Kconfig:76: symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
drivers/usb/Kconfig:58: symbol USB_SUPPORT is selected by DRM_USB
drivers/gpu/drm/Kconfig:22:     symbol DRM_USB is selected by DRM_UDL

Fix this by changing from select to depends on USB_SUPPORT in
"config DRM_USB".

This is a follow-up fix to df0b344300724e00db9fff7eb6406eb91f450b91
in Dave's drm-next GIT branch.

[ v2: Restore old status, but change from select to depends on USB_SUPPORT ]

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/gpu/drm/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 3a8c683..0cbdc45 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -22,9 +22,8 @@ menuconfig DRM
 config DRM_USB
 	tristate
 	depends on DRM
-	depends on USB_ARCH_HAS_HCD
+	depends on USB_SUPPORT && USB_ARCH_HAS_HCD
 	select USB
-	select USB_SUPPORT
 
 config DRM_KMS_HELPER
 	tristate
-- 
1.7.9.5

