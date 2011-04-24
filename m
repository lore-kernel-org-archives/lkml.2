Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab1DXB5p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:57:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55474 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757408Ab1DXB5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:57:15 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18PIqsdIbUPnqAi91HMClSkSpKC9EuWBS5jSThhy2
	XNZD2/bt4pwaPk
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: add engine clock support
Date: Sun, 24 Apr 2011 02:13:19 +0000
Message-Id: <1303611201-8727-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for enabling and configuring the engine on
VIAs IGPs. This is the main clock used for everything but pixel
output.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c        |    1 +
 drivers/video/via/via_clock.c |   51 +++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/via_clock.h |    3 ++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index df84251..e531147 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2289,6 +2289,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 			get_sync(viafbinfo1));
 	}
 
+	clock.set_engine_pll_state(VIA_STATE_ON);
 	clock.set_primary_clock_source(VIA_CLKSRC_X1, true);
 	clock.set_secondary_clock_source(VIA_CLKSRC_X1, true);
 
diff --git a/drivers/video/via/via_clock.c b/drivers/video/via/via_clock.c
index a829a24..af8f26b 100644
--- a/drivers/video/via/via_clock.c
+++ b/drivers/video/via/via_clock.c
@@ -87,6 +87,15 @@ static inline void k800_set_secondary_pll_encoded(u32 data)
 	via_write_reg_mask(VIASR, 0x40, 0x00, 0x04); /* disable reset */
 }
 
+static inline void set_engine_pll_encoded(u32 data)
+{
+	via_write_reg_mask(VIASR, 0x40, 0x01, 0x01); /* enable reset */
+	via_write_reg(VIASR, 0x47, data & 0xFF);
+	via_write_reg(VIASR, 0x48, (data >> 8) & 0xFF);
+	via_write_reg(VIASR, 0x49, (data >> 16) & 0xFF);
+	via_write_reg_mask(VIASR, 0x40, 0x00, 0x01); /* disable reset */
+}
+
 static void cle266_set_primary_pll(struct via_pll_config config)
 {
 	cle266_set_primary_pll_encoded(cle266_encode_pll(config));
@@ -117,6 +126,16 @@ static void vx855_set_secondary_pll(struct via_pll_config config)
 	k800_set_secondary_pll_encoded(vx855_encode_pll(config));
 }
 
+static void k800_set_engine_pll(struct via_pll_config config)
+{
+	set_engine_pll_encoded(k800_encode_pll(config));
+}
+
+static void vx855_set_engine_pll(struct via_pll_config config)
+{
+	set_engine_pll_encoded(vx855_encode_pll(config));
+}
+
 static void set_primary_pll_state(u8 state)
 {
 	u8 value;
@@ -153,6 +172,24 @@ static void set_secondary_pll_state(u8 state)
 	via_write_reg_mask(VIASR, 0x2D, value, 0x0C);
 }
 
+static void set_engine_pll_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x02;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2D, value, 0x03);
+}
+
 static void set_primary_clock_state(u8 state)
 {
 	u8 value;
@@ -247,6 +284,11 @@ static void dummy_set_pll_state(u8 state)
 	printk(KERN_INFO "Using undocumented set PLL state.\n%s", via_slap);
 }
 
+static void dummy_set_pll(struct via_pll_config config)
+{
+	printk(KERN_INFO "Using undocumented set PLL.\n%s", via_slap);
+}
+
 void via_clock_init(struct via_clock *clock, int gfx_chip)
 {
 	switch (gfx_chip) {
@@ -261,6 +303,9 @@ void via_clock_init(struct via_clock *clock, int gfx_chip)
 		clock->set_secondary_clock_source = dummy_set_clock_source;
 		clock->set_secondary_pll_state = dummy_set_pll_state;
 		clock->set_secondary_pll = cle266_set_secondary_pll;
+
+		clock->set_engine_pll_state = dummy_set_pll_state;
+		clock->set_engine_pll = dummy_set_pll;
 		break;
 	case UNICHROME_K800:
 	case UNICHROME_PM800:
@@ -280,6 +325,9 @@ void via_clock_init(struct via_clock *clock, int gfx_chip)
 		clock->set_secondary_clock_source = set_secondary_clock_source;
 		clock->set_secondary_pll_state = set_secondary_pll_state;
 		clock->set_secondary_pll = k800_set_secondary_pll;
+
+		clock->set_engine_pll_state = set_engine_pll_state;
+		clock->set_engine_pll = k800_set_engine_pll;
 		break;
 	case UNICHROME_VX855:
 	case UNICHROME_VX900:
@@ -292,6 +340,9 @@ void via_clock_init(struct via_clock *clock, int gfx_chip)
 		clock->set_secondary_clock_source = set_secondary_clock_source;
 		clock->set_secondary_pll_state = set_secondary_pll_state;
 		clock->set_secondary_pll = vx855_set_secondary_pll;
+
+		clock->set_engine_pll_state = set_engine_pll_state;
+		clock->set_engine_pll = vx855_set_engine_pll;
 		break;
 
 	}
diff --git a/drivers/video/via/via_clock.h b/drivers/video/via/via_clock.h
index f213a7a..88714ae 100644
--- a/drivers/video/via/via_clock.h
+++ b/drivers/video/via/via_clock.h
@@ -53,6 +53,9 @@ struct via_clock {
 	void (*set_secondary_clock_source)(enum via_clksrc src, bool use_pll);
 	void (*set_secondary_pll_state)(u8 state);
 	void (*set_secondary_pll)(struct via_pll_config config);
+
+	void (*set_engine_pll_state)(u8 state);
+	void (*set_engine_pll)(struct via_pll_config config);
 };
 
 
-- 
1.6.3.2

