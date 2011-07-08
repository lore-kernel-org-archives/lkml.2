Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1GHFBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab1GHFB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.098731350@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [024/107] drm/radeon/kms/atom: fix duallink on some early DCE3.2 cards
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 8323fa6ba313ae2664420ec34d56a7fb0bbbe525 upstream.

Certain revisions of the vbios on DCE3.2 cards have a bug
in the transmitter control table which prevents duallink from
being enabled properly on some cards.  The action switch statement
jumps to the wrong offset for the OUTPUT_ENABLE action.  The fix
is to use the ENABLE action rather than the OUTPUT_ENABLE action
on the affected cards.  In fixed version of the vbios, both
actions jump to the same offset, so the change should be safe.

Reported-and-tested-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -1294,7 +1294,11 @@ radeon_atom_encoder_dpms(struct drm_enco
 	if (is_dig) {
 		switch (mode) {
 		case DRM_MODE_DPMS_ON:
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
+			/* some early dce3.2 boards have a bug in their transmitter control table */
+			if ((rdev->family == CHIP_RV710) || (rdev->family == CHIP_RV730))
+				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
+			else
+				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
 			if (atombios_get_encoder_mode(encoder) == ATOM_ENCODER_MODE_DP) {
 				struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
 


