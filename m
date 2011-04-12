Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1DLOhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:39 -0400
Received: from kroah.org ([198.145.64.141]:57371 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab1DLOhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:48 2011
Message-Id: <20110412143548.900956204@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:33:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>, Takashi Iwai <tiwai@suse.de>
Subject: [009/105] sound/oss/opl3: validate voice and channel indexes
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -849,6 +849,10 @@ static int opl3_load_patch(int dev, int
 
 static void opl3_panning(int dev, int voice, int value)
 {
+
+	if (voice < 0 || voice >= devc->nr_voice)
+		return;
+
 	devc->voc[voice].panning = value;
 }
 
@@ -1066,8 +1070,15 @@ static int opl3_alloc_voice(int dev, int
 
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
 


