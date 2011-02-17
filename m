Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab1BQUe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:34:56 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23183 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1BQUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:34:55 -0500
Date: Thu, 17 Feb 2011 21:33:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Matthias Schwarzott <zzam@gentoo.org>
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Patch] Zarlink zl10036 DVB-S: Fix mem leak in zl10036_attach
In-Reply-To: <201102172054.12773.zzam@gentoo.org>
Message-ID: <alpine.LNX.2.00.1102172130360.17697@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102062128391.13593@swampdragon.chaosbits.net> <201102172054.12773.zzam@gentoo.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Matthias Schwarzott wrote:

> On Sunday 06 February 2011, Jesper Juhl wrote:
> > If the memory allocation to 'state' succeeds but we jump to the 'error'
> > label before 'state' is assigned to fe->tuner_priv, then the call to
> > 'zl10036_release(fe)' at the 'error:' label will not free 'state', but
> > only what was previously assigned to 'tuner_priv', thus leaking the memory
> > allocated to 'state'.
> > There are may ways to fix this, including assigning the allocated memory
> > directly to 'fe->tuner_priv', but I did not go for that since the
> > additional pointer derefs are more expensive than the local variable, so I
> > just added a 'kfree(state)' call. I guess the call to 'zl10036_release'
> > might not even be needed in this case, but I wasn't sure, so I left it in.
> > 
> Yeah, that call to zl10036_release can be completely eleminated.
> Another thing is: jumping to the error label only makes sense when memory was 
> already allocated. So the jump in line 471 can be replaced by "return NULL", 
> as the other error handling before allocation:
>         if (NULL == config) {
>                 printk(KERN_ERR "%s: no config specified", __func__);
>                 goto error;
>         }
> 
> I suggest to improve the patch to clean the code up when changing that.
> 
> But I am fine with commiting this patch also if you do not want to change it.
> 

Thank you for your feedback. It makes a lot of sense.
Changing it is not a problem :)
How about the updated patch below?


If the memory allocation to 'state' succeeds but we jump to the 'error' 
label before 'state' is assigned to fe->tuner_priv, then the call to 
'zl10036_release(fe)' at the 'error:' label will not free 'state', but 
only what was previously assigned to 'tuner_priv', thus leaking the memory 
allocated to 'state'.
This patch fixes the leak and also does not jump to 'error:' before mem 
has been allocated but instead just returns. Also some small style 
cleanups.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 zl10036.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/zl10036.c b/drivers/media/dvb/frontends/zl10036.c
index 4627f49..81aa984 100644
--- a/drivers/media/dvb/frontends/zl10036.c
+++ b/drivers/media/dvb/frontends/zl10036.c
@@ -463,16 +463,16 @@ struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 				    const struct zl10036_config *config,
 				    struct i2c_adapter *i2c)
 {
-	struct zl10036_state *state = NULL;
+	struct zl10036_state *state;
 	int ret;
 
-	if (NULL == config) {
+	if (!config) {
 		printk(KERN_ERR "%s: no config specified", __func__);
-		goto error;
+		return NULL;
 	}
 
 	state = kzalloc(sizeof(struct zl10036_state), GFP_KERNEL);
-	if (NULL == state)
+	if (!state)
 		return NULL;
 
 	state->config = config;
@@ -507,7 +507,7 @@ struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 	return fe;
 
 error:
-	zl10036_release(fe);
+	kfree(state);
 	return NULL;
 }
 EXPORT_SYMBOL(zl10036_attach);



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

