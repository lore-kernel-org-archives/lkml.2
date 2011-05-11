Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1EKQBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:01:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53701 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756810Ab1EKQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:01:15 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] ASoC: Update cx20442 for TTY API change
Date: Wed, 11 May 2011 16:05:44 +0200
Message-Id: <1305122744-30197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

receive_buf() was recently changed to return the number of bytes
received but the cx20442 driver wasn't updated to match the new API.
I don't have any hardware but since we don't actually appears to be
listening to the data at all just report that we accepted all the data
that was offered to us.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
---

This is a bug fix on top of "tty: make receive_buf() return the amout of
bytes received"

 sound/soc/codecs/cx20442.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cx20442.c b/sound/soc/codecs/cx20442.c
index d68ea53..f8c663d 100644
--- a/sound/soc/codecs/cx20442.c
+++ b/sound/soc/codecs/cx20442.c
@@ -262,14 +262,14 @@ static int v253_hangup(struct tty_struct *tty)
 }
 
 /* Line discipline .receive_buf() */
-static void v253_receive(struct tty_struct *tty,
-				const unsigned char *cp, char *fp, int count)
+static unsigned int v253_receive(struct tty_struct *tty,
+				 const unsigned char *cp, char *fp, int count)
 {
 	struct snd_soc_codec *codec = tty->disc_data;
 	struct cx20442_priv *cx20442;
 
 	if (!codec)
-		return;
+		return count;
 
 	cx20442 = snd_soc_codec_get_drvdata(codec);
 
@@ -281,6 +281,8 @@ static void v253_receive(struct tty_struct *tty,
 		codec->hw_write = (hw_write_t)tty->ops->write;
 		codec->card->pop_time = 1;
 	}
+
+	return count;
 }
 
 /* Line discipline .write_wakeup() */
-- 
1.7.5.1

