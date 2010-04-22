Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab0DVUTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:19:48 -0400
Received: from kroah.org ([198.145.64.141]:59775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab0DVUAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:11 2010
Message-Id: <20100422195411.495062548@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [067/139] drm/radeon/kms: more atom parser fixes (v2)
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 65384a1d41c4e91f0b49d90d11b7f424d6e5c58e upstream.

shr/shl ops need the full dst rather than the pre-masked
version.  Fixes fdo bug 27478 and kernel bug 15738.

v2: remove some unsed vars, add comments

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -881,11 +881,16 @@ static void atom_op_shl(atom_exec_contex
 	uint8_t attr = U8((*ptr)++), shift;
 	uint32_t saved, dst;
 	int dptr = *ptr;
+	uint32_t dst_align = atom_dst_to_src[(attr >> 3) & 7][(attr >> 6) & 3];
 	SDEBUG("   dst: ");
 	dst = atom_get_dst(ctx, arg, attr, ptr, &saved, 1);
+	/* op needs to full dst value */
+	dst = saved;
 	shift = atom_get_src(ctx, attr, ptr);
 	SDEBUG("   shift: %d\n", shift);
 	dst <<= shift;
+	dst &= atom_arg_mask[dst_align];
+	dst >>= atom_arg_shift[dst_align];
 	SDEBUG("   dst: ");
 	atom_put_dst(ctx, arg, attr, &dptr, dst, saved);
 }
@@ -895,11 +900,16 @@ static void atom_op_shr(atom_exec_contex
 	uint8_t attr = U8((*ptr)++), shift;
 	uint32_t saved, dst;
 	int dptr = *ptr;
+	uint32_t dst_align = atom_dst_to_src[(attr >> 3) & 7][(attr >> 6) & 3];
 	SDEBUG("   dst: ");
 	dst = atom_get_dst(ctx, arg, attr, ptr, &saved, 1);
+	/* op needs to full dst value */
+	dst = saved;
 	shift = atom_get_src(ctx, attr, ptr);
 	SDEBUG("   shift: %d\n", shift);
 	dst >>= shift;
+	dst &= atom_arg_mask[dst_align];
+	dst >>= atom_arg_shift[dst_align];
 	SDEBUG("   dst: ");
 	atom_put_dst(ctx, arg, attr, &dptr, dst, saved);
 }


