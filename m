Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230Ab2DKU4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:56:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17192 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740Ab2DKU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:56:11 -0400
Date: Wed, 11 Apr 2012 22:56:10 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: David Dajun Chen <dchen@diasemi.com>, linux-input@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] input: da9052: fix mem leak in da9052_onkey_probe()
Message-ID: <alpine.LNX.2.00.1204112249110.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, in drivers/input/misc/da9052_onkey.c::da9052_onkey_probe(), the
call to either kzalloc() or input_allocate_device() fails then we will
return -ENOMEM from the function without freeing the other allocation
that may have succeeded, thus we leak either the memory allocated for
'onkey' or the memory allocated for 'input_dev' if one succeeds and
the other fails.
Fix that by jumping to the 'err_free_mem' label at the end of the
function that properly cleans up rather than returning directly.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/input/misc/da9052_onkey.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
index 34aebb8..3c843cd 100644
--- a/drivers/input/misc/da9052_onkey.c
+++ b/drivers/input/misc/da9052_onkey.c
@@ -95,7 +95,8 @@ static int __devinit da9052_onkey_probe(struct platform_device *pdev)
 	input_dev = input_allocate_device();
 	if (!onkey || !input_dev) {
 		dev_err(&pdev->dev, "Failed to allocate memory\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_mem;
 	}
 
 	onkey->input = input_dev;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

