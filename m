Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0FUPD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:03:28 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48110 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932734Ab0FUPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:03:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Daniel Mack <daniel@caiaq.de>,
       Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH] SOUND: usb/endpoint, fix dangling pointer use
Date: Mon, 21 Jun 2010 17:03:21 +0200
Message-Id: <1277132601-14375-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that in snd_usb_parse_audio_endpoints, there is a
dangling pointer dereference. When snd_usb_parse_audio_format fails,
fp is freed, and continue invoked. On the next loop, there is
"fp && fp->altsetting == 1 && fp->channels == 1" test, but fp is set
from the last iteration (but is bogus) and thus ilegally dereferenced.

Set fp to NULL before "continue".

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/usb/endpoint.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 9593b91..6f6596c 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -427,6 +427,7 @@ int snd_usb_parse_audio_endpoints(struct snd_usb_audio *chip, int iface_no)
 		if (snd_usb_parse_audio_format(chip, fp, format, fmt, stream, alts) < 0) {
 			kfree(fp->rate_table);
 			kfree(fp);
+			fp = NULL;
 			continue;
 		}
 
-- 
1.7.1


