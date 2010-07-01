Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0GAVHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:07:09 -0400
Received: from kroah.org ([198.145.64.141]:47781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632Ab0GAUu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:59 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:36 2010
Message-Id: <20100701173436.326689808@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [patch 113/164] drm/i915: Rebind bo if currently bound with incorrect alignment.
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit ac0c6b5ad3b3b513e1057806d4b7627fcc0ecc27 upstream.

Whilst pinning the buffer, check that that its current alignment
matches the requested alignment. If it does not, rebind.

This should clear up any final render errors whilst resuming,
for reference:

  Bug 27070 - [i915] Page table errors with empty ringbuffer
  https://bugs.freedesktop.org/show_bug.cgi?id=27070

  Bug 15502 -  render error detected, EIR: 0x00000010
  https://bugzilla.kernel.org/show_bug.cgi?id=15502

  Bug 13844 -  i915 error: "render error detected"
  https://bugzilla.kernel.org/show_bug.cgi?id=13844

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4183,6 +4183,17 @@ i915_gem_object_pin(struct drm_gem_objec
 	int ret;
 
 	i915_verify_inactive(dev, __FILE__, __LINE__);
+
+	if (obj_priv->gtt_space != NULL) {
+		if (alignment == 0)
+			alignment = i915_gem_get_gtt_alignment(obj);
+		if (obj_priv->gtt_offset & (alignment - 1)) {
+			ret = i915_gem_object_unbind(obj);
+			if (ret)
+				return ret;
+		}
+	}
+
 	if (obj_priv->gtt_space == NULL) {
 		ret = i915_gem_object_bind_to_gtt(obj, alignment);
 		if (ret)


