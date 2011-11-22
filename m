Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1KVIq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:46:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:30361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1KVIqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:46:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78694519"
Date: Tue, 22 Nov 2011 16:46:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] hda - fail ELD reading early
Message-ID: <20111122084623.GA30050@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the ELD repoll mechanism, we can (and should) fail the ELD reading
immediately when find something obviously wrong and let the caller retry
after some delay.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 sound/pci/hda/hda_eld.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- linux.orig/sound/pci/hda/hda_eld.c	2011-11-22 16:02:58.000000000 +0800
+++ linux/sound/pci/hda/hda_eld.c	2011-11-22 16:36:10.000000000 +0800
@@ -347,18 +347,28 @@ int snd_hdmi_get_eld(struct hdmi_eld *el
 
 	for (i = 0; i < size; i++) {
 		unsigned int val = hdmi_get_eld_data(codec, nid, i);
+		/*
+		 * Graphics driver might be writing to ELD buffer right now.
+		 * Just abort. The caller will repoll after a while.
+		 */
 		if (!(val & AC_ELDD_ELD_VALID)) {
-			if (!i) {
-				snd_printd(KERN_INFO
-					   "HDMI: invalid ELD data\n");
-				ret = -EINVAL;
-				goto error;
-			}
 			snd_printd(KERN_INFO
 				  "HDMI: invalid ELD data byte %d\n", i);
-			val = 0;
-		} else
-			val &= AC_ELDD_ELD_DATA;
+			ret = -EINVAL;
+			goto error;
+		}
+		val &= AC_ELDD_ELD_DATA;
+		/*
+		 * The first byte cannot be zero. This can happen on some DVI
+		 * connections. Some Intel chips may also need some 250ms delay
+		 * to return non-zero ELD data, even when the graphics driver
+		 * correctly writes ELD content before setting ELD_valid bit.
+		 */
+		if (!val && !i) {
+			snd_printdd(KERN_INFO "HDMI: 0 ELD data\n");
+			ret = -EINVAL;
+			goto error;
+		}
 		buf[i] = val;
 	}
 
