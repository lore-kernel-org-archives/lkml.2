Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1G1Tsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 15:48:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13414 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1G1Ts3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 15:48:29 -0400
Date: Thu, 28 Jul 2011 21:48:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Joe Perches <joe@perches.com>,
        Eliot Blennerhassett <eblennerhassett@audioscience.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        support@audioscience.com
Subject: [PATCH] Sound: AudioScience HPI: Don't leak firmware if mem alloc
 fails
Message-ID: <alpine.LNX.2.00.1107282145230.20477@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We leak the memory allocated to 'firmware' when we fail to
release_firmware() after a kmalloc() failure in hpi_dsp_code_open().
This patch should take care of the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/asihpi/hpidspcd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

	Build tested only.

diff --git a/sound/pci/asihpi/hpidspcd.c b/sound/pci/asihpi/hpidspcd.c
index 3a7afa3..8d261ef 100644
--- a/sound/pci/asihpi/hpidspcd.c
+++ b/sound/pci/asihpi/hpidspcd.c
@@ -85,8 +85,10 @@ short hpi_dsp_code_open(u32 adapter, void *os_data, struct dsp_code *dsp_code,
 
 	HPI_DEBUG_LOG(DEBUG, "dsp code %s opened\n", fw_name);
 	dsp_code->pvt = kmalloc(sizeof(*dsp_code->pvt), GFP_KERNEL);
-	if (!dsp_code->pvt)
+	if (!dsp_code->pvt) {
+		release_firmware(firmware);
 		return HPI_ERROR_MEMORY_ALLOC;
+	}
 
 	dsp_code->pvt->dev = dev;
 	dsp_code->pvt->firmware = firmware;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

