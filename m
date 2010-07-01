Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0GASXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:47 -0400
Received: from kroah.org ([198.145.64.141]:40568 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943Ab0GASXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:38 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:13 2010
Message-Id: <20100701173213.471344677@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 079/149] drm/radeon: r100/r200 ums: block ability for userspace app to trash 0 page and beyond
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 566d84d172161cb6c0c4dd834c34abbac6bf7b38 upstream.

radeon's have a special ability to passthrough writes in their internal
memory space directly to PCI, this ability means that if some of the internal
surfaces like the depth buffer point at 0x0, any writes to these will
go directly to RAM at 0x0 via PCI busmastering.

Now mesa used to always emit clears after emitting state, since the
radeon mesa driver was refactored a year or more ago, it was found it
could generate a clear request without ever sending any setup state to the
card. So the clear would attempt to clear the depth buffer at 0x0, which
would overwrite main memory at this point. fs corruption ensues.

Also once one app did this correctly, it would never get set back to 0
making this messy to reproduce.

The kernel should block this from happening as mesa runs without privs,
though it does require the user be connected to the current running X session.

This patch implements a check to make sure the depth offset has been set
before a depth clear occurs and if it finds one it prints a warning and
ignores the depth clear request. There is also a mesa fix to avoid sending
the badness going into mesa.

This only affects r100/r200 GPUs in user modesetting mode.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_cp.c    |    1 +
 drivers/gpu/drm/radeon/radeon_drv.h   |    2 ++
 drivers/gpu/drm/radeon/radeon_state.c |    6 ++++++
 3 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -1646,6 +1646,7 @@ static int radeon_do_resume_cp(struct dr
 	radeon_cp_load_microcode(dev_priv);
 	radeon_cp_init_ring_buffer(dev, dev_priv, file_priv);
 
+	dev_priv->have_z_offset = 0;
 	radeon_do_engine_reset(dev);
 	radeon_irq_set_state(dev, RADEON_SW_INT_ENABLE, 1);
 
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -267,6 +267,8 @@ typedef struct drm_radeon_private {
 
 	u32 scratch_ages[5];
 
+	int have_z_offset;
+
 	/* starting from here on, data is preserved accross an open */
 	uint32_t flags;		/* see radeon_chip_flags */
 	resource_size_t fb_aper_offset;
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -101,6 +101,7 @@ static __inline__ int radeon_check_and_f
 			DRM_ERROR("Invalid depth buffer offset\n");
 			return -EINVAL;
 		}
+		dev_priv->have_z_offset = 1;
 		break;
 
 	case RADEON_EMIT_PP_CNTL:
@@ -876,6 +877,11 @@ static void radeon_cp_dispatch_clear(str
 		if (tmp & RADEON_BACK)
 			flags |= RADEON_FRONT;
 	}
+	if (flags & (RADEON_DEPTH|RADEON_STENCIL)) {
+		if (!dev_priv->have_z_offset)
+			printk_once(KERN_ERR "radeon: illegal depth clear request. Buggy mesa detected - please update.\n");
+		flags &= ~(RADEON_DEPTH | RADEON_STENCIL);
+	}
 
 	if (flags & (RADEON_FRONT | RADEON_BACK)) {
 


