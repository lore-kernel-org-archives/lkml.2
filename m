Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab1CWPnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:43:09 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:61653 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1CWPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:43:07 -0400
Subject: [PATCH] sound/oss/opl3: validate voice and channel indexes
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, security@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 11:42:57 -0400
Message-ID: <1300894977.1968.37.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User-controllable indexes for voice and channel values may cause reading
and writing beyond the bounds of their respective arrays, leading to
potentially exploitable memory corruption.  Validate these indexes.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
---
 sound/oss/opl3.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index 938c48c..e9d443e 100644
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
 



