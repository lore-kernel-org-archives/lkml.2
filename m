Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2BJWph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:45:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65316 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab2BJWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:27 -0500
MIME-Version: 1.0
Message-Id: <20120210223442.398053107@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 24/55] ASoC: Ensure we generate a driver name
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit f0e8ed858edb327802ee65fd695cc1538286226f upstream.

Commit 873bd4c (ASoC: Don't set invalid name string to snd_card->driver
field) broke generation of a driver name for all ASoC cards relying on the
automatic generation of one. Fix this by using the old default with spaces
replaced by underscores.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -30,6 +30,7 @@
 #include <linux/bitops.h>
 #include <linux/debugfs.h>
 #include <linux/platform_device.h>
+#include <linux/ctype.h>
 #include <linux/slab.h>
 #include <sound/ac97_codec.h>
 #include <sound/core.h>
@@ -1931,9 +1932,20 @@ static void snd_soc_instantiate_card(str
 		 "%s", card->name);
 	snprintf(card->snd_card->longname, sizeof(card->snd_card->longname),
 		 "%s", card->long_name ? card->long_name : card->name);
-	if (card->driver_name)
-		strlcpy(card->snd_card->driver, card->driver_name,
-			sizeof(card->snd_card->driver));
+	snprintf(card->snd_card->driver, sizeof(card->snd_card->driver),
+		 "%s", card->driver_name ? card->driver_name : card->name);
+	for (i = 0; i < ARRAY_SIZE(card->snd_card->driver); i++) {
+		switch (card->snd_card->driver[i]) {
+		case '_':
+		case '-':
+		case '\0':
+			break;
+		default:
+			if (!isalnum(card->snd_card->driver[i]))
+				card->snd_card->driver[i] = '_';
+			break;
+		}
+	}
 
 	if (card->late_probe) {
 		ret = card->late_probe(card);


