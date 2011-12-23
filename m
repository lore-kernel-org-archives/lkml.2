Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1LWRl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:41:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43271 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab1LWRjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:39:41 -0500
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 5/9] drivers/usb/host/isp1760-if.c: introduce missing kfree
Date: Fri, 23 Dec 2011 18:39:30 +0100
Message-Id: <1324661974-17281-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drvdata needds to be freed before leaving the function in an error case.

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
 drivers/usb/host/isp1760-if.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
index b605224..61de62c 100644
--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -56,14 +56,18 @@ static int of_isp1760_probe(struct platform_device *dev)
 		return -ENOMEM;
 
 	ret = of_address_to_resource(dp, 0, &memory);
-	if (ret)
-		return -ENXIO;
+	if (ret) {
+		ret = -ENXIO;
+		goto free_data;
+	}
 
 	res_len = resource_size(&memory);
 
 	res = request_mem_region(memory.start, res_len, dev_name(&dev->dev));
-	if (!res)
-		return -EBUSY;
+	if (!res) {
+		ret = -EBUSY;
+		goto free_data;
+	}
 
 	if (of_irq_map_one(dp, 0, &oirq)) {
 		ret = -ENODEV;
@@ -125,6 +129,7 @@ free_gpio:
 		gpio_free(drvdata->rst_gpio);
 release_reg:
 	release_mem_region(memory.start, res_len);
+free_data:
 	kfree(drvdata);
 	return ret;
 }

