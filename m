Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1JZHsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:48:21 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:49849 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab1JZHsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:48:20 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] hda_hwdep: Fix possible buffer overflow
Date: Wed, 26 Oct 2011 09:48:12 +0200
Message-Id: <1319615292-27396-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a line in the firmware file is larger than the given buffer size (and
so the firmware file size), size is set to a value larger than the actual
buffer size. This results in an overflow in the buffer passed.
Fix this by copying only up to 127 chars per line.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 sound/pci/hda/hda_hwdep.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_hwdep.c b/sound/pci/hda/hda_hwdep.c
index bf3ced5..61da08d 100644
--- a/sound/pci/hda/hda_hwdep.c
+++ b/sound/pci/hda/hda_hwdep.c
@@ -745,6 +745,7 @@ static int parse_line_mode(char *buf, struct hda_bus *bus)
  * if successfully copied a line
  *
  * the spaces at the beginning and the end of the line are stripped
+ * lines read are clamped to 127 chars
  */
 static int get_line_from_fw(char *buf, int size, struct firmware *fw)
 {
@@ -756,8 +757,6 @@ static int get_line_from_fw(char *buf, int size, struct firmware *fw)
 	}
 	if (!fw->size)
 		return 0;
-	if (size < fw->size)
-		size = fw->size;
 
 	for (len = 0; len < fw->size; len++) {
 		if (!*p)
@@ -768,7 +767,8 @@ static int get_line_from_fw(char *buf, int size, struct firmware *fw)
 			break;
 		}
 		if (len < size)
-			*buf++ = *p++;
+			*buf++ = *p;
+		p++;
 	}
 	*buf = 0;
 	fw->size -= len;
-- 
1.7.3.4

