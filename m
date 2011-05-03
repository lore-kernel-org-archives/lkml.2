Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab1ECRxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:53:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1ECRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:52:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/23] intel_sst: Headphone Automute support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:34:13 +0100
Message-ID: <20110503163409.24853.74450.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xingchao <xingchao.wang@intel.com>

When detected a Jack event, Audio sound routes between internal speaker
and headphone/headset automatically.

Signed-off-by: xingchao <xingchao.wang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_v2_control.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 3d90f45..7cae970 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -996,6 +996,19 @@ static int nc_get_vol(int dev_id, int *value)
 	return retval;
 }
 
+static void hp_automute(enum snd_jack_types type, int present)
+{
+	u8 in = DMIC;
+	u8 out = INTERNAL_SPKR;
+	if (present) {
+		if (type == SND_JACK_HEADSET)
+			in = HS_MIC;
+		out = STEREO_HEADPHONE;
+	}
+	nc_set_selected_input_dev(in);
+	nc_set_selected_output_dev(out);
+}
+
 static void nc_pmic_irq_cb(void *cb_data, u8 intsts)
 {
 	u8 value = 0;
@@ -1016,6 +1029,7 @@ static void nc_pmic_irq_cb(void *cb_data, u8 intsts)
 		present = (value == 0x1) ? 1 : 0;
 		jack_event_flag = 1;
 		mjack->jack.type = SND_JACK_HEADSET;
+		hp_automute(SND_JACK_HEADSET, present);
 	}
 
 	if (intsts & 0x2) {
@@ -1024,6 +1038,7 @@ static void nc_pmic_irq_cb(void *cb_data, u8 intsts)
 		present = (value == 0x2) ? 1 : 0;
 		jack_event_flag = 1;
 		mjack->jack.type = SND_JACK_HEADPHONE;
+		hp_automute(SND_JACK_HEADPHONE, present);
 	}
 
 	if (intsts & 0x4) {

