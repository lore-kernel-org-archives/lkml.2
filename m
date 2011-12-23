Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab1LWRjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:39:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43261 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab1LWRjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:39:41 -0500
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] drivers/mfd/88pm860x-i2c.c: introduce missing kfree
Date: Fri, 23 Dec 2011 18:39:26 +0100
Message-Id: <1324661974-17281-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code following a kzalloc should free the allocated data.  At
this point, chip has been allocated and some fields have been initialized,
but it has not been stored anywhere, so it should be freed before leaving
the function.

A simplified version of the semantic match that finds the problem is as
follows: (http://coccinelle.lip6.fr)

// <smpl>
@r exists@
local idexpression x;
statement S;
identifier f1;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
x->f1
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mfd/88pm860x-i2c.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index 630f1b5..f93dd95 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -286,6 +286,7 @@ static int __devinit pm860x_probe(struct i2c_client *client,
 		ret = PTR_ERR(chip->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
 				ret);
+		kfree(chip);
 		return ret;
 	}
 	chip->client = client;

