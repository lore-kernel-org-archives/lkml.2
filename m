Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab1DYUsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:48:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34220 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab1DYUYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:37 -0400
Message-Id: <20110425200238.036268745@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 116/173] sound/oss/opl3: validate voice and channel indexes
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 4d00135a680727f6c3be78f8befaac009030e4df upstream.

User-controllable indexes for voice and channel values may cause reading
and writing beyond the bounds of their respective arrays, leading to
potentially exploitable memory corruption.  Validate these indexes.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/oss/opl3.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -848,6 +848,10 @@ static int opl3_load_patch(int dev, int
 
 static void opl3_panning(int dev, int voice, int value)
 {
+
+	if (voice < 0 || voice >= devc->nr_voice)
+		return;
+
 	devc->voc[voice].panning = value;
 }
 
@@ -1065,8 +1069,15 @@ static int opl3_alloc_voice(int dev, int
 
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
 


