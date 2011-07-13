Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1GMU6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:58:16 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29226 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1GMU6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:58:15 -0400
Date: Wed, 13 Jul 2011 22:58:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media, Micronas dvb-t: Fix mem leaks, don't needlessly zero
 mem, fix spelling
Message-ID: <alpine.LNX.2.00.1107132255450.22281@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/media/dvb/frontends/drxd_hard.c::load_firmware() I see 3
small issues:

 1) When the 'fw' variable goes out of scope we'll leak the memory
 allocated to it by request_firmware() by neglecting to call
 release_firmware().

 2) After a successful request_firmware() we allocate fw->size bytes
 of memory using kzalloc() only to immediately overwrite all that
 memory with memcpy(), so asking for zeroed memory seems like wasted
 effort - just use kmalloc().

 3) In one of the error messages "no memory" lacks a space and is
 written as "nomemory".

This patch fixes all 3 issues.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/dvb/frontends/drxd_hard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index f132e49..0266a83 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -909,14 +909,16 @@ static int load_firmware(struct drxd_state *state, const char *fw_name)
 		return -EIO;
 	}
 
-	state->microcode = kzalloc(fw->size, GFP_KERNEL);
+	state->microcode = kmalloc(fw->size, GFP_KERNEL);
 	if (state->microcode == NULL) {
-		printk(KERN_ERR "drxd: firmware load failure: nomemory\n");
+		release_firmware(fw);
+		printk(KERN_ERR "drxd: firmware load failure: no memory\n");
 		return -ENOMEM;
 	}
 
 	memcpy(state->microcode, fw->data, fw->size);
 	state->microcode_length = fw->size;
+	release_firmware(fw);
 	return 0;
 }
 
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

