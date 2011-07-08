Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1GHIwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:52:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40001 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1GHIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:52:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/12] gma500: Re-order checks and dereferences in
 psb_intel_lvds
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:43:15 +0100
Message-ID: <20110708084309.19581.86654.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Dan Carpenter reports:

Smatch complains about 6a7afe3acc4b "gma500: continue abstracting
platform specific code"

drivers/staging/gma500/psb_intel_lvds.c +579 psb_intel_lvds_set_property(7)
	warn: variable dereferenced before check 'encoder'

--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -575,11 +575,12 @@ int psb_intel_lvds_set_property(struct drm_connector
*connector,
                                       struct drm_property *property,
                                       uint64_t value)
 {
-       struct drm_encoder *pEncoder = connector->encoder;
+       struct drm_encoder *encoder = connector->encoder;
+       struct drm_psb_private *dev_priv = encoder->dev->dev_private;
                                           ^^^^^^^^^^^^
dereference encoder here.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_lvds.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 4a0d234..1e1e788 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -574,9 +574,14 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 				       uint64_t value)
 {
 	struct drm_encoder *encoder = connector->encoder;
-	struct drm_psb_private *dev_priv = encoder->dev->dev_private;
+	struct drm_psb_private *dev_priv;
+	
+	if (!encoder)
+	        return -1;
 
-	if (!strcmp(property->name, "scaling mode") && encoder) {
+	dev_priv = encoder->dev->dev_private;
+
+	if (!strcmp(property->name, "scaling mode")) {
 		struct psb_intel_crtc *pPsbCrtc =
 					to_psb_intel_crtc(encoder->crtc);
 		uint64_t curValue;
@@ -617,7 +622,7 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 						      encoder->crtc->fb))
 				goto set_prop_error;
 		}
-	} else if (!strcmp(property->name, "backlight") && encoder) {
+	} else if (!strcmp(property->name, "backlight")) {
 		if (drm_connector_property_set_value(connector,
 							property,
 							value))
@@ -631,7 +636,7 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
                         }
 #endif
 		}
-	} else if (!strcmp(property->name, "DPMS") && encoder) {
+	} else if (!strcmp(property->name, "DPMS")) {
 		struct drm_encoder_helper_funcs *pEncHFuncs
 						= encoder->helper_private;
 		pEncHFuncs->dpms(encoder, value);

