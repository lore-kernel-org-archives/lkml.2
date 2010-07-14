Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0GNTJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:09:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:43371 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755029Ab0GNTJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:09:37 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX196tAlMWsF6NJX7t2YP4siZGRtpIXLNG4tJvDWDoe
	Ej68Qkoq2perND
From: Sven Joachim <svenjoac@gmx.de>
To: dri-devel@lists.freedesktop.org
Cc: Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: drm: refresh rate down to 60 Hz in 2.6.35-rc5
Date: Wed, 14 Jul 2010 21:09:33 +0200
Message-ID: <87oce9khhu.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resending to the right mailing list.  I looked up in MAINTAINERS, but
  forgot to run "git bisect reset" and got the wrong address for
  dri-devel@.  Apologies to all who receive this twice. ]

After upgrading to 2.6.35-rc5, I noticed that my monitor reports a
refresh rate of 60 Hz when nouveau.ko is loaded, rather than the 75 Hz I
got on 2.6.34.  Graphics card is an NV86 (GeForce 8500 GT), the monitor
is a 1280x1024 TFT (Yakumo 19AL) connected via VGA.

I bisected this to the following commit:

--8<---------------cut here---------------start------------->8---
commit c867df7043b738da4f4d358d7039c243a29b4272
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Mar 29 21:43:21 2010 +0000

    drm/edid: Reshuffle mode list construction to closer match the spec
    
    Also, document what the spec says to do.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 9c4717f..858fedc 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1377,10 +1377,24 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 
 	quirks = edid_get_quirks(edid);
 
-	num_modes += add_established_modes(connector, edid);
-	num_modes += add_standard_modes(connector, edid);
+	/*
+	 * EDID spec says modes should be preferred in this order:
+	 * - preferred detailed mode
+	 * - other detailed modes from base block
+	 * - detailed modes from extension blocks
+	 * - CVT 3-byte code modes
+	 * - standard timing codes
+	 * - established timing codes
+	 * - modes inferred from GTF or CVT range information
+	 *
+	 * We don't quite implement this yet, but we're close.
+	 *
+	 * XXX order for additional mode types in extension blocks?
+	 */
 	num_modes += add_detailed_info(connector, edid, quirks);
 	num_modes += add_detailed_info_eedid(connector, edid, quirks);
+	num_modes += add_standard_modes(connector, edid);
+	num_modes += add_established_modes(connector, edid);
 
 	if (quirks & (EDID_QUIRK_PREFER_LARGE_60 | EDID_QUIRK_PREFER_LARGE_75))
 		edid_fixup_preferred(connector, quirks);
--8<---------------cut here---------------end--------------->8---


How do I get the 75 Hz refresh rate back?  Adding "video=1280x1024@75"
as described in the nouveau wiki¹ has no effect.

Regards,
        Sven


¹ http://nouveau.freedesktop.org/wiki/KernelModeSetting
