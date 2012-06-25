Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2FYODm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:03:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55153 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756873Ab2FYODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:03:41 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+3+k5aFnu35nXZ9Ovm4vWgDsYYRGtqk/TGkfxqXr
	RAMmO6HyeFU7DK
From: Sven Joachim <svenjoac@gmx.de>
To: dri-devel@lists.freedesktop.org, Adam Jackson <ajax@redhat.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>, Dave Airlie <airlied@redhat.com>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Bogus video resolution in Linux 3.5-rc4
Date: Mon, 25 Jun 2012 16:03:36 +0200
Message-ID: <874npzebev.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

After upgrading to Linux 3.5-rc4 from 3.4.4, I noticed that my monitor
switched to a resolution of 1280x960 rather than the native 1280x1024,
and nouveau has set up a framebuffer of 1680x945.  It goes without
saying that the result looks terrible.

Bisecting shows that the problem started with commit cb21aafe1:

--8<---------------cut here---------------start------------->8---
commit cb21aafe121b1c3ad4c77cc5c22320163f16ba42
Author: Adam Jackson <ajax@redhat.com>
Date:   Fri Apr 13 16:33:36 2012 -0400

    drm/edid: Do drm_dmt_modes_for_range() for all range descriptor types
    
    EDID 1.4 retcons the meaning of the "GTF feature" bit to mean "is
    continuous frequency", and moves the set of supported timing formulas
    into the range descriptor itself.  In any event, the range descriptor
    can act as a filter on the DMT list without regard to a specific timing
    formula.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Tested-by: Takashi Iwai <tiwai@suse.de>
    Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index cb40611..9363349 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1042,12 +1042,13 @@ do_inferred_modes(struct detailed_timing *timing, void *c)
 {
 	struct detailed_mode_closure *closure = c;
 	struct detailed_non_pixel *data = &timing->data.other_data;
-	int gtf = (closure->edid->features & DRM_EDID_FEATURE_DEFAULT_GTF);
 
-	if (gtf && data->type == EDID_DETAIL_MONITOR_RANGE)
-		closure->modes += drm_dmt_modes_for_range(closure->connector,
-							  closure->edid,
-							  timing);
+	if (data->type != EDID_DETAIL_MONITOR_RANGE)
+		return;
+
+	closure->modes += drm_dmt_modes_for_range(closure->connector,
+						  closure->edid,
+						  timing);
 }
 
 static int
--8<---------------cut here---------------end--------------->8---

With a kernel from this commit nouveau sets up a resolution of
1400x1050; kernels built from commits cffd754 and fc48f16 complain about
an invalid EDID and use the 1024x768 fallback.

Attached is the /sys/class/drm/card0-DVI-I-1/edid file from a working
kernel; in 3.5-rc4 it is identical.

Cheers,
       Sven


--=-=-=
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=edid
Content-Transfer-Encoding: base64

AP///////wBCkxkDZSgAACgNAQMIJh6WKGdVpVtHnCUeT1Q/7wAxQEVAYUCBgDFPRU9hT4GPMCoA
mFEAKkAwcBMAeC0RAAAeAAAA/wAxMDM0MQogICAgICAgAAAA/ABQUy05NzYKICAgICAgAAAA/QA4
TB5RDgAKICAgICAgAAw=
--=-=-=--
