Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0HXUUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:20:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39974 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab0HXUUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:20:47 -0400
Date: Tue, 24 Aug 2010 22:20:45 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/char/agp: Eliminate memory leak
In-Reply-To: <20100824171644.GL29330@bicker>
Message-ID: <Pine.LNX.4.64.1008242220170.14009@ask.diku.dk>
References: <Pine.LNX.4.64.1008241639130.15172@ask.diku.dk>
 <20100824171644.GL29330@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

alloc_pci_dev allocates some memory, so that memory should be freed before
leaving the function in an error case.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = alloc_pci_dev(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/agp/parisc-agp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/agp/parisc-agp.c b/drivers/char/agp/parisc-agp.c
index 1c12921..17e380f 100644
--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -358,8 +358,12 @@ parisc_agp_setup(void __iomem *ioc_hpa, void __iomem *lba_hpa)
 	bridge->dev = fake_bridge_dev;
 
 	error = agp_add_bridge(bridge);
+	if (error)
+		goto fail;
+	return 0;
 
 fail:
+	kfree(fake_bridge_dev);
 	return error;
 }
 
