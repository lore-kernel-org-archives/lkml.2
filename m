Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2HGSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:16:58 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:10847 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2HGSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:16:57 -0400
Date: Tue, 7 Aug 2012 20:16:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abraham Arce <x0066660@ti.com>,
        Syed Rafiuddin <rafiuddin.syed@ti.com>
Subject: [PATCH] Input: omap4-keypad - don't leak in omap4_keypad_probe()
Message-ID: <alpine.LNX.2.00.1208072014140.3227@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If omap4_keypad_parse_dt() does not return 0 (zero) in
omap4_keypad_probe() we will leak the memory we allocated for
'keypad_data' with kzalloc() when we return and the variable goes out
of scope.
Fix the leak by jumping to the 'err_free_keypad' label where we
properly free the allocated memory, instead of returning directly.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/input/keyboard/omap4-keypad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 Compile tested only.

diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
index c05f98c..9c2ac87 100644
--- a/drivers/input/keyboard/omap4-keypad.c
+++ b/drivers/input/keyboard/omap4-keypad.c
@@ -281,7 +281,7 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
 	} else {
 		error = omap4_keypad_parse_dt(&pdev->dev, keypad_data);
 		if (error)
-			return error;
+			goto err_free_keypad;
 	}
 
 	res = request_mem_region(res->start, resource_size(res), pdev->name);
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

