Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1GEWif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:38:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:35365 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1GEWie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:38:34 -0400
Date: Wed, 6 Jul 2011 00:29:07 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Samuel Ortiz <sameo@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
In-Reply-To: <alpine.LNX.2.00.1107050945330.27127@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107060027280.9158@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net> <20110704173320.GR3021@sortiz-mobl> <alpine.LNX.2.00.1107050945330.27127@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Jesper Juhl wrote:

> On Mon, 4 Jul 2011, Samuel Ortiz wrote:
> 
[...]
> > This is not a memory leak fix. And I actually prefer the == NULL check.
> > Please remove the == NULL check replacement with !* and keep only the memory
> > leak fixing part.
> > 
Here's an updated patch.


From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe

There are a couple of situations where we leak init_data in
drivers/mfd/tps65910.c:tps65910_i2c_probe() - this patch should take
care of them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/mfd/tps65910.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 2229e66..7a3eb2d 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -151,8 +151,10 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	init_data->irq_base = pmic_plat_data->irq;
 
 	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
-	if (tps65910 == NULL)
+	if (tps65910 == NULL) {
+		kfree(init_data);
 		return -ENOMEM;
+	}
 
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
@@ -174,11 +176,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
+	kfree(init_data);
 	return ret;
 
 err:
 	mfd_remove_devices(tps65910->dev);
 	kfree(tps65910);
+	kfree(init_data);
 	return ret;
 }
 
-- 
1.7.6



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

