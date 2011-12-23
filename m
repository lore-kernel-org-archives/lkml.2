Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1LWRjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:39:52 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43293 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab1LWRjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:39:45 -0500
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] drivers/media/video/davinci/vpbe.c: introduce missing kfree
Date: Fri, 23 Dec 2011 18:39:32 +0100
Message-Id: <1324661974-17281-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vpbe_dev needs to be freed before leaving the function in an error case.

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
 drivers/media/video/davinci/vpbe.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c
index d773d30..99658ba 100644
--- a/drivers/media/video/davinci/vpbe.c
+++ b/drivers/media/video/davinci/vpbe.c
@@ -811,8 +811,10 @@ static __devinit int vpbe_probe(struct platform_device *pdev)
 
 	if (cfg->outputs->num_modes > 0)
 		vpbe_dev->current_timings = vpbe_dev->cfg->outputs[0].modes[0];
-	else
+	else {
+		kfree(vpbe_dev);
 		return -ENODEV;
+	}
 
 	/* set the driver data in platform device */
 	platform_set_drvdata(pdev, vpbe_dev);

