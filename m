Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473Ab2I1TDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:03:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030459Ab2I1TD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 190/262] drm/i915: use hsw rps tuning values everywhere on gen6+
Date: Fri, 28 Sep 2012 11:51:59 -0700
Message-Id: <20120928183020.499176264@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 1ee9ae3244c4789f3184c5123f3b2d7e405b3f4c upstream.

James Bottomley reported [1] a massive power regression, due to the
enabling of semaphores by default in 3.5. A workaround for him is to
again disable semaphores. And indeed, his system has a very hard time
to enter rc6 with semaphores enabled.

Ben Widawsky run around with a kill-a-watt a lot and noticed:
- There are indeed a few rare systems that seem to have a hard time
  entering rc6 when desktop-idle.
- One machine, The Indestructible Toshiba regressed in this behaviour
  between 3.5 and 3.6 in a merge commit! So rc6 behaviour with the
  current setting seems to be highly timing dependent and not robust
  at all.
- The behaviour James reported wrt semaphores seems to be a freak
  timing thing that only happens on his specific machine, confirming
  that enabling semaphores shouldn't reduce rc6 residency.

Now furthermore the Google ChromeOS guys reported [2] a while ago that
at least on some machines a simply a blinking cursor can keep the gpu
turbo at the highest frequency. This is because the current rps limits
used on snb/ivb are highly asymmetric.

On the theory that gpu turbo and rc6 tuning values are related, we've
tried whether the much saner looking (since much less asymmetric) rps
tuning values used for hsw would also help entering rc6 more robustly.

And it seems to mostly work, and we don't really have the resources to
through-roughly tune things in any better way: The values from the
ChromeOS ppl seem to fare a bit worse for James' machine, so I guess
we better stick with something vpg (the gpu hw/windows group)
provided, hoping that they've done their jobs.

Reference[1]: http://lists.freedesktop.org/archives/dri-devel/2012-July/025675.html
Reference[2]: http://lists.freedesktop.org/archives/intel-gfx/2012-July/018692.html
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=53393
Tested-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_pm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2431,10 +2431,10 @@ void gen6_enable_rps(struct drm_i915_pri
 	I915_WRITE(GEN6_RP_INTERRUPT_LIMITS,
 		   dev_priv->max_delay << 24 |
 		   dev_priv->min_delay << 16);
-	I915_WRITE(GEN6_RP_UP_THRESHOLD, 10000);
-	I915_WRITE(GEN6_RP_DOWN_THRESHOLD, 1000000);
-	I915_WRITE(GEN6_RP_UP_EI, 100000);
-	I915_WRITE(GEN6_RP_DOWN_EI, 5000000);
+	I915_WRITE(GEN6_RP_UP_THRESHOLD, 59400);
+	I915_WRITE(GEN6_RP_DOWN_THRESHOLD, 245000);
+	I915_WRITE(GEN6_RP_UP_EI, 66000);
+	I915_WRITE(GEN6_RP_DOWN_EI, 350000);
 	I915_WRITE(GEN6_RP_IDLE_HYSTERSIS, 10);
 	I915_WRITE(GEN6_RP_CONTROL,
 		   GEN6_RP_MEDIA_TURBO |


