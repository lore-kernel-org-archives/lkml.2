Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1KOStt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:49:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34439 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1KOSts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:49:48 -0500
Subject: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Keith Packard <keithp@keithp.com>,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 00:49:28 +0600
Message-ID: <1321382968.8791.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A call to i915_add_request() has been made in function i915_gem_busy_ioctl(). i915_add_request can fail,
so in it's exit path previously allocated memory needs to be freed.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d18b07a..2dc24ab 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3512,9 +3512,11 @@ i915_gem_busy_ioctl(struct drm_device *dev, void *data,
 			 * so emit a request to do so.
 			 */
 			request = kzalloc(sizeof(*request), GFP_KERNEL);
-			if (request)
+			if (request) {
 				ret = i915_add_request(obj->ring, NULL, request);
-			else
+				if (ret)
+					kfree(request);
+			} else
 				ret = -ENOMEM;
 		}
 


