Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267Ab1KJE4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:56:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934899Ab1KJDap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:20 2011
Message-Id: <20111109212720.521834665@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerome Glisse <jglisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>
Subject: [198/262] drm/radeon: avoid bouncing connector status btw disconnected & unknown
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 340764465aa4a586ca332e61ae64883e5ad6f183 upstream.

Since force handling rework of d0d0a225e6ad43314c9aa7ea081f76adc5098ad4
we could end up bouncing connector status btw disconnected and unknown.
When connector status change a call to output_poll_changed happen which
in turn ask again for detect but with force set.

So set the load detect flags whenever we report the connector as
connected or unknown this avoid bouncing btw disconnected and unknown.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -755,7 +755,7 @@ radeon_vga_detect(struct drm_connector *
 		if (radeon_connector->dac_load_detect && encoder) {
 			encoder_funcs = encoder->helper_private;
 			ret = encoder_funcs->detect(encoder, connector);
-			if (ret == connector_status_connected)
+			if (ret != connector_status_disconnected)
 				radeon_connector->detected_by_load = true;
 		}
 	}
@@ -996,8 +996,9 @@ radeon_dvi_detect(struct drm_connector *
 					ret = encoder_funcs->detect(encoder, connector);
 					if (ret == connector_status_connected) {
 						radeon_connector->use_digital = false;
-						radeon_connector->detected_by_load = true;
 					}
+					if (ret != connector_status_disconnected)
+						radeon_connector->detected_by_load = true;
 				}
 				break;
 			}


