Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2AVOrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 09:47:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37457 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2AVOrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 09:47:35 -0500
Date: Sun, 22 Jan 2012 18:47:28 +0400
From: Igor Murzov <intergalactic.anonymous@gmail.com>
To: Igor Murzov <e-mail@date.by>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Sergey V <sftp.mtuci@gmail.com>
Subject: [PATCH 2/2] drm/radeon: finish getting bios earlier
Message-ID: <20120122184728.5df82ac2@garik>
In-Reply-To: <20120122184325.74528207@garik>
References: <20120122184325.74528207@garik>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4a57f34f6ebc3adac143a329327f69cb0469c2e2 Mon Sep 17 00:00:00 2001
From: Igor Murzov <e-mail@date.by>
Date: Sun, 22 Jan 2012 19:05:13 +0400
Subject: [PATCH 2/2] drm/radeon: finish getting bios earlier

Return a number of bytes read in radeon_atrm_get_bios_chunk() and
properly check this value in radeon_atrm_get_bios().
If radeon_atrm_get_bios_chunk() read less bytes then were requested,
it means that it finished reading bios data.

Prior to this patch, condition in radeon_atrm_get_bios() was always
equivalent to "if (ATRM_BIOS_PAGE <= 0)", so it was always false,
thus radeon_atrm_get_bios() was trying to read past the bios data
wasting boot time.

On my lenovo ideapad u455 laptop this patch drops bios reading time
from ~5.5s to ~1.5s.

Signed-off-by: Igor Murzov <e-mail@date.by>
---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    2 +-
 drivers/gpu/drm/radeon/radeon_bios.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index c666a5b..13ac63b 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -60,7 +60,7 @@ static int radeon_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 	obj = (union acpi_object *)buffer.pointer;
 	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
 	kfree(buffer.pointer);
-	return len;
+	return obj->buffer.length;
 }
 
 bool radeon_atrm_supported(struct pci_dev *pdev)
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 229a20f..501f488 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -120,7 +120,7 @@ static bool radeon_atrm_get_bios(struct radeon_device *rdev)
 		ret = radeon_atrm_get_bios_chunk(rdev->bios,
 						 (i * ATRM_BIOS_PAGE),
 						 ATRM_BIOS_PAGE);
-		if (ret <= 0)
+		if (ret < ATRM_BIOS_PAGE)
 			break;
 	}
 
-- 
1.7.5.1

