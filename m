Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1BFUfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:35:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22038 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1BFUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:35:06 -0500
Date: Sun, 6 Feb 2011 21:33:50 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-media@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
        Tejun Heo <tj@kernel.org>, Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [Patch] Zarlink zl10036 DVB-S: Fix mem leak in zl10036_attach
Message-ID: <alpine.LNX.2.00.1102062128391.13593@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the memory allocation to 'state' succeeds but we jump to the 'error' 
label before 'state' is assigned to fe->tuner_priv, then the call to 
'zl10036_release(fe)' at the 'error:' label will not free 'state', but 
only what was previously assigned to 'tuner_priv', thus leaking the memory 
allocated to 'state'.
There are may ways to fix this, including assigning the allocated memory 
directly to 'fe->tuner_priv', but I did not go for that since the 
additional pointer derefs are more expensive than the local variable, so I 
just added a 'kfree(state)' call. I guess the call to 'zl10036_release' 
might not even be needed in this case, but I wasn't sure, so I left it in.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 zl10036.c |    1 +
 1 file changed, 1 insertion(+)

 compile tested only.

diff --git a/drivers/media/dvb/frontends/zl10036.c b/drivers/media/dvb/frontends/zl10036.c
index 4627f49..b4fb8e8 100644
--- a/drivers/media/dvb/frontends/zl10036.c
+++ b/drivers/media/dvb/frontends/zl10036.c
@@ -508,6 +508,7 @@ struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 
 error:
 	zl10036_release(fe);
+	kfree(state);
 	return NULL;
 }
 EXPORT_SYMBOL(zl10036_attach);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

