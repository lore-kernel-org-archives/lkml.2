Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1ECRw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:52:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab1ECRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:52:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 17/23] intel_sst: MRST can only do 16bit recording
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:35:31 +0100
Message-ID: <20110503163530.24853.31713.stgit@bob.linux.org.uk>
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

	$ arecord -D dsnoop -r 48000 -f S16_LE 1.wav
	ALSA lib pcm_direct.c:980:(snd1_pcm_direct_initialize_slave) unable to install hw params
	ALSA lib pcm_dsnoop.c:604:(snd_pcm_dsnoop_open) unable to initialize slave
	arecord: main:654: audio open error: Interrupted system call

Root cause is, the driver is reporting 32-bit capture capability
that is not supported by the MRST hardware. So the dsnoop plugin
end up requesting 32-bit capture which fails.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 0b9b1b6..cbe09f2 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -339,8 +339,11 @@ static int snd_intelmad_open(struct snd_pcm_substream *substream,
 		/*
 		 * MRST firmware currently denies stereo recording requests.
 		 */
-		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+			runtime->hw.formats = (SNDRV_PCM_FMTBIT_S16 |
+					       SNDRV_PCM_FMTBIT_U16);
 			runtime->hw.channels_max = 1;
+		}
 	}
 	if (intelmaddata->cpu_id == CPU_CHIP_PENWELL) {
 		runtime->hw = snd_intelmad_stream;

