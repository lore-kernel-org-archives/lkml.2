Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1FXIDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:03:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57327 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1FXIDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:03:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E0444CA.3080407@jp.fujitsu.com>
Date: Fri, 24 Jun 2011 17:03:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, keithp@keithp.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH] i915: slab shrinker have to return -1 if it can't shrink
 any objects
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, i915_gem_inactive_shrink() should return -1 instead of 0 if it
can't take a lock. Otherwise, vmscan is getting a lot of confusing
because vmscan can't distinguish "can't take a lock temporary" and
"we've shrank all of i915 objects".

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Keith Packard <keithp@keithp.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---

I've found this issue by reviewing. I hope i915 developers confirm this.
Thx.


 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 94c84d7..2f9a9b2 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4104,7 +4104,7 @@ i915_gem_inactive_shrink(struct shrinker *shrinker, struct shrink_control *sc)
 	int cnt;

 	if (!mutex_trylock(&dev->struct_mutex))
-		return 0;
+		return nr_to_scan ? -1 : 0;

 	/* "fast-path" to count number of available objects */
 	if (nr_to_scan == 0) {
-- 
1.7.3.1



