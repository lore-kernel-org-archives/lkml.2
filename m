Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2IQIFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:05:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55405 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2IQIFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:05:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@infradead.org
Cc: leonidsbox@gmail.com, peter.senna@gmail.com, thomas@m3y3r.de,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cx25821: Cleanup filename assignment code
Date: Mon, 17 Sep 2012 10:04:58 +0200
Message-Id: <1347869098-2236-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347869098-2236-1-git-send-email-peter.senna@gmail.com>
References: <1347869098-2236-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pasting the original code and my proposal on the commit message for
make it easy to compare the two versions.

Line 62 of cx25821-audio-upstream.h contains:
char *_defaultAudioName = "/root/audioGOOD.wav";

Original code after replace kmemdup for kstrdup, and after fix return error
code:
if (dev->input_audiofilename) {
	dev->_audiofilename = kstrdup(dev->input_audiofilename,
				      GFP_KERNEL);
	if (!dev->_audiofilename) {
		err = -ENOMEM;
		goto error;
	}

	/* Default if filename is empty string */
	if (strcmp(dev->input_audiofilename, "") == 0)
		dev->_audiofilename = "/root/audioGOOD.wav";
} else {
	dev->_audiofilename = kstrdup(_defaultAudioName,
				      GFP_KERNEL);

	if (!dev->_audiofilename) {
		err = -ENOMEM;
		goto error;
	}
}

Code proposed in this patch:
if ((dev->input_audiofilename) &&
    (strcmp(dev->input_audiofilename, "") != 0))
	dev->_audiofilename = kstrdup(dev->input_audiofilename,
				      GFP_KERNEL);
else
	dev->_audiofilename = kstrdup(_defaultAudioName,
				      GFP_KERNEL);

if (!dev->_audiofilename) {
	err = -ENOMEM;
	goto error;
}

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 1cc797e..83316a8 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -728,26 +728,17 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	dev->_audio_lines_count = LINES_PER_AUDIO_BUFFER;
 	_line_size = AUDIO_LINE_SIZE;
 
-	if (dev->input_audiofilename) {
+	if ((dev->input_audiofilename) &&
+	    (strcmp(dev->input_audiofilename, "") != 0))
 		dev->_audiofilename = kstrdup(dev->input_audiofilename,
 					      GFP_KERNEL);
-
-		if (!dev->_audiofilename) {
-			err = -ENOMEM;
-			goto error;
-		}
-
-		/* Default if filename is empty string */
-		if (strcmp(dev->input_audiofilename, "") == 0)
-			dev->_audiofilename = "/root/audioGOOD.wav";
-	} else {
+	else
 		dev->_audiofilename = kstrdup(_defaultAudioName,
 					      GFP_KERNEL);
 
-		if (!dev->_audiofilename) {
-			err = -ENOMEM;
-			goto error;
-		}
+	if (!dev->_audiofilename) {
+		err = -ENOMEM;
+		goto error;
 	}
 
 	cx25821_sram_channel_setup_upstream_audio(dev, sram_ch,
-- 
1.7.11.4

