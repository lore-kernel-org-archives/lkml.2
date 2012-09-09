Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2IIX1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:27:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51308 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075Ab2IIXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:34 -0400
Message-Id: <20120909224159.084164637@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Igor Murzov <intergalactic.anonymous@gmail.com>,
        Igor Murzov <e-mail@date.by>, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 61/95] drm/radeon: finish getting bios earlier
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Murzov <intergalactic.anonymous@gmail.com>

commit 211fa4fc4e13492151e698d92b0dff56b29928ec upstream.

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
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 


