Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1ECRxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:53:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1ECRxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:53:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/23] intel_sst: move jack detection related configs to init
 time
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:34:27 +0100
Message-ID: <20110503163424.24853.32241.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Guanqun <guanqun.lu@intel.com>

The old policy will not enable MIC2BIAS on Moorstown platform
by default, it's only enabled when the user selects HS_MIC as input source.
Therefore when user selects DMIC and then inserts the jack,
no interrupt will be generated to notify the driver about the
jack insertion event and to take action to auto mute the speaker.

The new policy will enable this bit by default,
then no matter what the output device is, an interrupt will be generated.

This behaviour is more likely what a user expects.

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |   28 +++++++++++------------
 1 files changed, 13 insertions(+), 15 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 7cae970..6f4caa5 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -114,18 +114,19 @@ static int nc_init_card(void)
 		{VOICEVOL, 0x0e, 0},
 		{HPLVOL, 0x06, 0},
 		{HPRVOL, 0x06, 0},
-		{MICCTRL, 0x41, 0x00},
+		{MICCTRL, 0x51, 0x00},
 		{ADCSAMPLERATE, 0x8B, 0x00},
 		{MICSELVOL, 0x5B, 0x00},
 		{LILSEL, 0x06, 0},
 		{LIRSEL, 0x46, 0},
 		{LOANTIPOP, 0x00, 0},
 		{DMICCTRL1, 0x40, 0},
+		{AUXDBNC, 0xff, 0},
 	};
 	snd_pmic_ops_nc.card_status = SND_CARD_INIT_DONE;
 	snd_pmic_ops_nc.master_mute = UNMUTE;
 	snd_pmic_ops_nc.mute_status = UNMUTE;
-	sst_sc_reg_access(sc_access, PMIC_WRITE, 26);
+	sst_sc_reg_access(sc_access, PMIC_WRITE, 27);
 	pr_debug("init complete!!\n");
 	return 0;
 }
@@ -834,7 +835,7 @@ static int nc_set_selected_input_dev(u8 value)
 		pr_debug("Selecting AMIC\n");
 		sc_access[0].reg_addr = 0x107;
 		sc_access[0].value = 0x40;
-		sc_access[0].mask =  MASK6|MASK4|MASK3|MASK1|MASK0;
+		sc_access[0].mask =  MASK6|MASK3|MASK1|MASK0;
 		sc_access[1].reg_addr = 0x10a;
 		sc_access[1].value = 0x40;
 		sc_access[1].mask = MASK6;
@@ -849,9 +850,9 @@ static int nc_set_selected_input_dev(u8 value)
 
 	case HS_MIC:
 		pr_debug("Selecting HS_MIC\n");
-		sc_access[0].reg_addr = 0x107;
-		sc_access[0].mask =  MASK6|MASK4|MASK3|MASK1|MASK0;
-		sc_access[0].value = 0x10;
+		sc_access[0].reg_addr = MICCTRL;
+		sc_access[0].mask =  MASK6|MASK3|MASK1|MASK0;
+		sc_access[0].value = 0x00;
 		sc_access[1].reg_addr = 0x109;
 		sc_access[1].mask = MASK6;
 		sc_access[1].value = 0x40;
@@ -861,19 +862,16 @@ static int nc_set_selected_input_dev(u8 value)
 		sc_access[3].reg_addr = 0x105;
 		sc_access[3].value = 0x40;
 		sc_access[3].mask = MASK6;
-		sc_access[4].reg_addr = AUXDBNC;
-		sc_access[4].mask = MASK7|MASK6|MASK5|MASK4|MASK3|MASK2|MASK1|MASK0;
-		sc_access[4].value = 0xff;
-		sc_access[5].reg_addr = ADCSAMPLERATE;
-		sc_access[5].mask = MASK7|MASK6|MASK5|MASK4|MASK3;
-		sc_access[5].value = 0xc8;
-		num_val = 6;
+		sc_access[4].reg_addr = ADCSAMPLERATE;
+		sc_access[4].mask = MASK7|MASK6|MASK5|MASK4|MASK3;
+		sc_access[4].value = 0xc8;
+		num_val = 5;
 		break;
 
 	case DMIC:
 		pr_debug("DMIC\n");
-		sc_access[0].reg_addr = 0x107;
-		sc_access[0].mask = MASK6|MASK4|MASK3|MASK1|MASK0;
+		sc_access[0].reg_addr = MICCTRL;
+		sc_access[0].mask = MASK6|MASK3|MASK1|MASK0;
 		sc_access[0].value = 0x0B;
 		sc_access[1].reg_addr = 0x105;
 		sc_access[1].value = 0x80;

