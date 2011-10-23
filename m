Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1JWGeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1JWGeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:13 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:38 2011
Message-Id: <20111023062538.256497924@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:34 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [06/27] drm/radeon/kms/atom: fix handling of FB scratch indices
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5a6e8482a16e61250a9121fc9ec719ab0529e760 upstream.

FB scratch indices are dword indices, but we were treating
them as byte indices.  As such, we were getting the wrong
FB scratch data for non-0 indices.  Fix the indices and
guard the indexing against indices larger than the scratch
allocation.

Fixes memory corruption on some boards if data was written
past the end of the FB scratch array.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: Dave Airlie <airlied@redhat.com>
Tested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |   15 +++++++++++++--
 drivers/gpu/drm/radeon/atom.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -277,7 +277,12 @@ static uint32_t atom_get_src_int(atom_ex
 	case ATOM_ARG_FB:
 		idx = U8(*ptr);
 		(*ptr)++;
-		val = gctx->scratch[((gctx->fb_base + idx) / 4)];
+		if ((gctx->fb_base + (idx * 4)) > gctx->scratch_size_bytes) {
+			DRM_ERROR("ATOM: fb read beyond scratch region: %d vs. %d\n",
+				  gctx->fb_base + (idx * 4), gctx->scratch_size_bytes);
+			val = 0;
+		} else
+			val = gctx->scratch[(gctx->fb_base / 4) + idx];
 		if (print)
 			DEBUG("FB[0x%02X]", idx);
 		break;
@@ -531,7 +536,11 @@ static void atom_put_dst(atom_exec_conte
 	case ATOM_ARG_FB:
 		idx = U8(*ptr);
 		(*ptr)++;
-		gctx->scratch[((gctx->fb_base + idx) / 4)] = val;
+		if ((gctx->fb_base + (idx * 4)) > gctx->scratch_size_bytes) {
+			DRM_ERROR("ATOM: fb write beyond scratch region: %d vs. %d\n",
+				  gctx->fb_base + (idx * 4), gctx->scratch_size_bytes);
+		} else
+			gctx->scratch[(gctx->fb_base / 4) + idx] = val;
 		DEBUG("FB[0x%02X]", idx);
 		break;
 	case ATOM_ARG_PLL:
@@ -1367,11 +1376,13 @@ int atom_allocate_fb_scratch(struct atom
 
 		usage_bytes = firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb * 1024;
 	}
+	ctx->scratch_size_bytes = 0;
 	if (usage_bytes == 0)
 		usage_bytes = 20 * 1024;
 	/* allocate some scratch memory */
 	ctx->scratch = kzalloc(usage_bytes, GFP_KERNEL);
 	if (!ctx->scratch)
 		return -ENOMEM;
+	ctx->scratch_size_bytes = usage_bytes;
 	return 0;
 }
--- a/drivers/gpu/drm/radeon/atom.h
+++ b/drivers/gpu/drm/radeon/atom.h
@@ -137,6 +137,7 @@ struct atom_context {
 	int cs_equal, cs_above;
 	int io_mode;
 	uint32_t *scratch;
+	int scratch_size_bytes;
 };
 
 extern int atom_debug;


