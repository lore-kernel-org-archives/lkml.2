Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1LWRjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:39:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43256 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab1LWRjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:39:40 -0500
From: Julia Lawall <julia@diku.dk>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] drivers/usb/dwc3/dwc3-pci.c: introduce missing kfree
Date: Fri, 23 Dec 2011 18:39:28 +0100
Message-Id: <1324661974-17281-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glue needs to be freed on exiting the function in an error case.
Furthermore, pci, which is the first argument to the probe function should
not be freed before leaveing the function, as it is reused at the call
site.  So the free of pci is changed to free glue instead.

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
 drivers/usb/dwc3/dwc3-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index cd1429f..64e1f7c 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -134,7 +134,7 @@ err2:
 	pci_disable_device(pci);
 
 err1:
-	kfree(pci);
+	kfree(glue);
 
 err0:
 	return ret;

