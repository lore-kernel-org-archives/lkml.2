Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0IDKMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 06:12:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46088 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0IDKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 06:12:04 -0400
From: Julia Lawall <julia@diku.dk>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Vitaly Bordug <vbordug@ru.mvista.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/2] drivers/net/fs_enet/fs_enet-main.c: Add of_node_put to avoid memory leak
Date: Sat,  4 Sep 2010 12:12:43 +0200
Message-Id: <1283595164-29146-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case, a device_node structure is stored in another structure that
is then freed without first decrementing the reference count of the
device_node structure.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression x;
identifier f;
position p1,p2;
@@

x@p1->f = \(of_find_node_by_path\|of_find_node_by_name\|of_find_node_by_phandle\|of_get_parent\|of_get_next_parent\|of_get_next_child\|of_find_compatible_node\|of_match_node\|of_find_node_by_type\|of_find_node_with_property\|of_find_matching_node\|of_parse_phandle\|of_node_get\)(...);
... when != of_node_put(x)
kfree@p2(x)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@
cocci.print_main("call",p1)
cocci.print_secs("free",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/fs_enet/fs_enet-main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index d6e3111..d684f18 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -1036,7 +1036,7 @@ static int __devinit fs_enet_probe(struct platform_device *ofdev,
 	ndev = alloc_etherdev(privsize);
 	if (!ndev) {
 		ret = -ENOMEM;
-		goto out_free_fpi;
+		goto out_put;
 	}
 
 	SET_NETDEV_DEV(ndev, &ofdev->dev);
@@ -1099,6 +1099,7 @@ out_cleanup_data:
 out_free_dev:
 	free_netdev(ndev);
 	dev_set_drvdata(&ofdev->dev, NULL);
+out_put:
 	of_node_put(fpi->phy_node);
 out_free_fpi:
 	kfree(fpi);

