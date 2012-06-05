Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2FEJrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:47:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36233 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761514Ab2FEJrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:47:40 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 5/8] sound: Use printk_get_level and printk_skip_level
Date: Tue,  5 Jun 2012 02:46:34 -0700
Message-Id: <69c567123040afc72a785fe01af1f0417f38e0cb.1338889067.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1338889066.git.joe@perches.com>
References: <cover.1338889066.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the output logging routine independent of the
KERN_<LEVEL> style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/core/misc.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/core/misc.c b/sound/core/misc.c
index 7681679..30e027e 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -68,6 +68,7 @@ void __snd_printk(unsigned int level, const char *path, int line,
 {
 	va_list args;
 #ifdef CONFIG_SND_VERBOSE_PRINTK
+	int kern_level;
 	struct va_format vaf;
 	char verbose_fmt[] = KERN_DEFAULT "ALSA %s:%d %pV";
 #endif
@@ -81,12 +82,16 @@ void __snd_printk(unsigned int level, const char *path, int line,
 #ifdef CONFIG_SND_VERBOSE_PRINTK
 	vaf.fmt = format;
 	vaf.va = &args;
-	if (format[0] == '<' && format[2] == '>') {
-		memcpy(verbose_fmt, format, 3);
-		vaf.fmt = format + 3;
+
+	kern_level = printk_get_level(format);
+	if (kern_level) {
+		const char *end_of_header = printk_skip_level(format);
+		memcpy(verbose_fmt, format, end_of_header - format);
+		vaf.fmt = end_of_header;
 	} else if (level)
-		memcpy(verbose_fmt, KERN_DEBUG, 3);
+		memcpy(verbose_fmt, KERN_DEBUG, sizeof(KERN_DEBUG) - 1);
 	printk(verbose_fmt, sanity_file_name(path), line, &vaf);
+
 #else
 	vprintk(format, args);
 #endif
-- 
1.7.8.111.gad25c.dirty

