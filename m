Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab1BSF6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 00:58:14 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:51110 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1BSF6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 00:58:12 -0500
Message-ID: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
Date: Sat, 19 Feb 2011 06:58:06 +0100 (CET)
Subject: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        indan@nul.nu
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 2394e6fd9f1e9f86011669f8146dc264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since 2.6.38-rc I get screen corruption (mostly horizontal grabage stripes on
the right side of the screen). After a long time bisecting the offending commit
ends up being:

commit a00b10c360b35d6431a94cbf130a4e162870d661
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Sep 24 21:15:47 2010 +0100

    drm/i915: Only enforce fence limits inside the GTT.

    So long as we adhere to the fence registers rules for alignment and no
    overlaps (including with unfenced accesses to linear memory) and account
    for the tiled access in our size allocation, we do not have to allocate
    the full fenced region for the object. This allows us to fight the bloat
    tiling imposed on pre-i965 chipsets and frees up RAM for real use. [Inside
    the GTT we still suffer the additional alignment constraints, so it doesn't
    magic allow us to render larger scenes without stalls -- we need the
    expanded GTT and fence pipelining to overcome those...]

    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

This commit caused other problems too, which Daniel tried to fix with commits:

5e78330126e23e00950 drm/i915: fix relaxed tiling for gen <= 3 && !g33
75e9e9158f38e5cb21e drm/i915: kill mappable/fenceable disdinction
818f2a3cc34b0673dcc drm/i915: revert pageflip/mappable related abi breakage

But those don't fix my screen corruption.

Unfortunately, it's a big commit and it doesn't revert cleanly, and its size
makes it unclear what the source of the problem is. Daniel's commits don't
revert cleanly either, so reverting all of them didn't work.

I'll start poking at it and see if I can find anything.

Greetings,

Indan


