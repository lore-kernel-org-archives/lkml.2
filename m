Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab0J2Suf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:50:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12072 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0J2Sud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:50:33 -0400
Date: Fri, 29 Oct 2010 20:40:23 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] USB PCM Sound driver neglects kmalloc return value check
 and may deref NULL.
Message-ID: <alpine.LNX.2.00.1010292032550.24561@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sound/usb/pcm.c::snd_usb_pcm_check_knot() fails to check the return value 
from kmalloc() and may end up dereferencing a null pointer.
The patch below (compile tested only) should take care of that little 
problem.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pcm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index cff3a3c..4132522 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -676,8 +676,10 @@ static int snd_usb_pcm_check_knot(struct snd_pcm_runtime *runtime,
 	if (!needs_knot)
 		return 0;
 
-	subs->rate_list.count = count;
 	subs->rate_list.list = kmalloc(sizeof(int) * count, GFP_KERNEL);
+	if (!subs->rate_list.list)
+		return -ENOMEM;
+	subs->rate_list.count = count;
 	subs->rate_list.mask = 0;
 	count = 0;
 	list_for_each_entry(fp, &subs->fmt_list, list) {


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

