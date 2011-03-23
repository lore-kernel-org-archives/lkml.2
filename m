Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1CWWUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:20:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33440 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756795Ab1CWWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:20:05 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19xscsiA4Bx2XHiK0cJWry/2Lkihr8zISq4YpA8Ax
	dCrsU5MCJYXNjd
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: add clock source selection and PLL power management support
Date: Wed, 23 Mar 2011 22:35:34 +0000
Message-Id: <1300919734-3931-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300919734-3931-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some support for clock source selection as well as
PLL power management. The code is unused at the moment but was
successfully tested as far as possible.
The implementation is according to the documentation for VX700,
VX800, VX855, VX900. Probably the source selection works like this
starting with K800 and the power managemennt at least since VX700.
(guessed based on the initialization in viamode.c)

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index bd28e13..b38d3b4 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1409,6 +1409,42 @@ void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active)
 
 }
 
+static void set_primary_pll_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x20;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2D, value, 0x30);
+}
+
+static void set_secondary_pll_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x08;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2D, value, 0x08);
+}
+
 static u32 cle266_encode_pll(struct pll_config pll)
 {
 	return (pll.multiplier << 8)
@@ -1494,6 +1530,58 @@ static void vx855_set_secondary_pll(struct pll_config config)
 	k800_set_secondary_pll_encoded(vx855_encode_pll(config));
 }
 
+enum via_clksrc {
+	VIA_CLKSRC_X1 = 0,
+	VIA_CLKSRC_TVX1,
+	VIA_CLKSRC_TVPLL,
+	VIA_CLKSRC_DVP1TVCLKR,
+	VIA_CLKSRC_CAP0,
+	VIA_CLKSRC_CAP1,
+};
+
+static inline u8 set_clock_source_common(enum via_clksrc source, bool use_pll)
+{
+	u8 data = 0;
+
+	switch (source) {
+	case VIA_CLKSRC_X1:
+		data = 0x00;
+		break;
+	case VIA_CLKSRC_TVX1:
+		data = 0x02;
+		break;
+	case VIA_CLKSRC_TVPLL:
+		data = 0x04; /* 0x06 should be the same */
+		break;
+	case VIA_CLKSRC_DVP1TVCLKR:
+		data = 0x0A;
+		break;
+	case VIA_CLKSRC_CAP0:
+		data = 0xC;
+		break;
+	case VIA_CLKSRC_CAP1:
+		data = 0x0E;
+		break;
+	}
+
+	if (!use_pll)
+		data |= 1;
+
+	return data;
+}
+
+static void set_primary_clock_source(enum via_clksrc source, bool use_pll)
+{
+	u8 data = set_clock_source_common(source, use_pll) << 4;
+	via_write_reg_mask(VIACR, 0x6C, data, 0xF0);
+}
+
+static void set_secondary_clock_source(enum via_clksrc source, bool use_pll)
+{
+	u8 data = set_clock_source_common(source, use_pll);
+	via_write_reg_mask(VIACR, 0x6C, data, 0x0F);
+}
+
 static inline u32 get_pll_internal_frequency(u32 ref_freq,
 	struct pll_config pll)
 {
-- 
1.6.3.2

