Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1AFVTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:19:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17226 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab1AFVTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:19:48 -0500
Date: Thu, 6 Jan 2011 22:19:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: alsa-devel@alsa-project.org
cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] Don't leak in
 sound/core/oss/pcm_oss.c::snd_pcm_hw_param_near()
Message-ID: <alpine.LNX.2.00.1101062216190.13988@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


snd_pcm_hw_param_near() will leak the memory allocated to 'save' if the 
call to snd_pcm_hw_param_max() returns less than zero.
This patch makes sure we never leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pcm_oss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index b753ec6..a2e4eb3 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -453,8 +453,10 @@ static int snd_pcm_hw_param_near(struct snd_pcm_substream *pcm,
 	} else {
 		*params = *save;
 		max = snd_pcm_hw_param_max(pcm, params, var, max, &maxdir);
-		if (max < 0)
+		if (max < 0) {
+			kfree(save);
 			return max;
+		}
 		last = 1;
 	}
  _end:



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

