Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2CMBJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:09:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:46565 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab2CMARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:32 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 010/196] sound/oss/opl3: validate voice and channel indexes
Date: Mon, 12 Mar 2012 20:12:18 -0400
Message-Id: <1331597724-31358-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4d00135a680727f6c3be78f8befaac009030e4df upstream.

User-controllable indexes for voice and channel values may cause reading
and writing beyond the bounds of their respective arrays, leading to
potentially exploitable memory corruption.  Validate these indexes.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/oss/opl3.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index 938c48c..f4ffdff 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -849,6 +849,10 @@ static int opl3_load_patch(int dev, int format, const char __user *addr,
 
 static void opl3_panning(int dev, int voice, int value)
 {
+
+	if (voice < 0 || voice >= devc->nr_voice)
+		return;
+
 	devc->voc[voice].panning = value;
 }
 
@@ -1066,8 +1070,15 @@ static int opl3_alloc_voice(int dev, int chn, int note, struct voice_alloc_info
 
 static void opl3_setup_voice(int dev, int voice, int chn)
 {
-	struct channel_info *info =
-	&synth_devs[dev]->chn_info[chn];
+	struct channel_info *info;
+
+	if (voice < 0 || voice >= devc->nr_voice)
+		return;
+
+	if (chn < 0 || chn > 15)
+		return;
+
+	info = &synth_devs[dev]->chn_info[chn];
 
 	opl3_set_instr(dev, voice, info->pgm_num);
 
-- 
1.7.9.3

