Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab1ECRyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:54:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1ECRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:52:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 16/23] intel_sst: MRST can only do mono recording
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:35:19 +0100
Message-ID: <20110503163506.24853.84700.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <wfg@linux.intel.com>

Fix bug

	$ arecord -Dplughw -c2
	Recording WAVE 'stdin' : Unsigned 8 bit, Rate 8000 Hz, Stereo
	arecord: set_params:1116: Unable to install hw params:
	ACCESS:  RW_INTERLEAVED
	FORMAT:  U8
	SUBFORMAT:  STD
	SAMPLE_BITS: 8
	FRAME_BITS: 16
	CHANNELS: 2
	[...]

Root cause is, the driver is reporting 2-channel capture capability
that is not supported by the MRST hardware. So the plughw plugin
end up requesting 2-channel capture which fails.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 61ef4a6..0b9b1b6 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -335,6 +335,13 @@ static int snd_intelmad_open(struct snd_pcm_substream *substream,
 	runtime = substream->runtime;
 	/* set the runtime hw parameter with local snd_pcm_hardware struct */
 	runtime->hw = snd_intelmad_stream;
+	if (intelmaddata->cpu_id == CPU_CHIP_LINCROFT) {
+		/*
+		 * MRST firmware currently denies stereo recording requests.
+		 */
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			runtime->hw.channels_max = 1;
+	}
 	if (intelmaddata->cpu_id == CPU_CHIP_PENWELL) {
 		runtime->hw = snd_intelmad_stream;
 		runtime->hw.rates = SNDRV_PCM_RATE_48000;

