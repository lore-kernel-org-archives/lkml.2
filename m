Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1BPAaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:30:35 -0500
Received: from kroah.org ([198.145.64.141]:49824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472Ab1BPAZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:49 2011
Message-Id: <20110216001449.678466971@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
Subject: [246/272] drm/radeon/kms: re-emit full context state for evergreen blits
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 1e644d6dce366a7bae22484f60133b61ba322911 upstream.

clear state doesn't seem to work properly in some cases

Fixes hangs in heavy 3D on some evergreen cards reported on
IRC.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=33381
possibly others.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |   39 +++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen_blit_kms.c
+++ b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
@@ -230,7 +230,7 @@ draw_auto(struct radeon_device *rdev)
 
 }
 
-/* emits 30 */
+/* emits 34 */
 static void
 set_default_state(struct radeon_device *rdev)
 {
@@ -243,6 +243,8 @@ set_default_state(struct radeon_device *
 	int num_hs_threads, num_ls_threads;
 	int num_ps_stack_entries, num_vs_stack_entries, num_gs_stack_entries, num_es_stack_entries;
 	int num_hs_stack_entries, num_ls_stack_entries;
+	u64 gpu_addr;
+	int dwords;
 
 	switch (rdev->family) {
 	case CHIP_CEDAR:
@@ -409,6 +411,14 @@ set_default_state(struct radeon_device *
 	radeon_ring_write(rdev, 0x00000000);
 	radeon_ring_write(rdev, 0x00000000);
 
+	/* emit an IB pointing at default state */
+	dwords = ALIGN(rdev->r600_blit.state_len, 0x10);
+	gpu_addr = rdev->r600_blit.shader_gpu_addr + rdev->r600_blit.state_offset;
+	radeon_ring_write(rdev, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
+	radeon_ring_write(rdev, gpu_addr & 0xFFFFFFFC);
+	radeon_ring_write(rdev, upper_32_bits(gpu_addr) & 0xFF);
+	radeon_ring_write(rdev, dwords);
+
 }
 
 static inline uint32_t i2f(uint32_t input)
@@ -439,8 +449,10 @@ static inline uint32_t i2f(uint32_t inpu
 int evergreen_blit_init(struct radeon_device *rdev)
 {
 	u32 obj_size;
-	int r;
+	int r, dwords;
 	void *ptr;
+	u32 packet2s[16];
+	int num_packet2s = 0;
 
 	/* pin copy shader into vram if already initialized */
 	if (rdev->r600_blit.shader_obj)
@@ -448,8 +460,17 @@ int evergreen_blit_init(struct radeon_de
 
 	mutex_init(&rdev->r600_blit.mutex);
 	rdev->r600_blit.state_offset = 0;
-	rdev->r600_blit.state_len = 0;
-	obj_size = 0;
+
+	rdev->r600_blit.state_len = evergreen_default_size;
+
+	dwords = rdev->r600_blit.state_len;
+	while (dwords & 0xf) {
+		packet2s[num_packet2s++] = PACKET2(0);
+		dwords++;
+	}
+
+	obj_size = dwords * 4;
+	obj_size = ALIGN(obj_size, 256);
 
 	rdev->r600_blit.vs_offset = obj_size;
 	obj_size += evergreen_vs_size * 4;
@@ -479,6 +500,12 @@ int evergreen_blit_init(struct radeon_de
 		return r;
 	}
 
+	memcpy_toio(ptr + rdev->r600_blit.state_offset,
+		    evergreen_default_state, rdev->r600_blit.state_len * 4);
+
+	if (num_packet2s)
+		memcpy_toio(ptr + rdev->r600_blit.state_offset + (rdev->r600_blit.state_len * 4),
+			    packet2s, num_packet2s * 4);
 	memcpy(ptr + rdev->r600_blit.vs_offset, evergreen_vs, evergreen_vs_size * 4);
 	memcpy(ptr + rdev->r600_blit.ps_offset, evergreen_ps, evergreen_ps_size * 4);
 	radeon_bo_kunmap(rdev->r600_blit.shader_obj);
@@ -564,7 +591,7 @@ int evergreen_blit_prepare_copy(struct r
 	/* calculate number of loops correctly */
 	ring_size = num_loops * dwords_per_loop;
 	/* set default  + shaders */
-	ring_size += 46; /* shaders + def state */
+	ring_size += 50; /* shaders + def state */
 	ring_size += 10; /* fence emit for VB IB */
 	ring_size += 5; /* done copy */
 	ring_size += 10; /* fence emit for done copy */
@@ -572,7 +599,7 @@ int evergreen_blit_prepare_copy(struct r
 	if (r)
 		return r;
 
-	set_default_state(rdev); /* 30 */
+	set_default_state(rdev); /* 34 */
 	set_shaders(rdev); /* 16 */
 	return 0;
 }


