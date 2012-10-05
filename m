Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2JEUmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:42:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57811 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2JEUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:41:32 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: davem@davemloft.net
Cc: romieu@fr.zoreil.com, rick.jones2@hp.com, netdev@pradeepdalvi.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/20 V2] drivers/net/ethernet/natsemi/natsemi.c: fix error return code
Date: Fri,  5 Oct 2012 22:41:04 +0200
Message-Id: <1349469667-6137-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349469667-6137-1-git-send-email-peter.senna@gmail.com>
References: <1349469667-6137-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

The function natsemi_probe1() return 0 for success and negative value
for most of its internal tests failures. There is one exception
that is error case going to err_create_file:. Fore this error case the
function abort its success execution path, but returns non negative value, 
making it difficult for a caller function to notice the error.

This patch fixes the error case that do not return negative value.

This was found by Coccinelle, but the code change was made by hand.
This patch is not robot generated.

A simplified version of the semantic match that finds this problem is
as follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
Changes from V1:
	Updated commit message. See:
	http://www.kernelhub.org/?p=2&msg=139319

 drivers/net/ethernet/natsemi/natsemi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 5b61d12..dbaaa99 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -947,8 +947,8 @@ static int __devinit natsemi_probe1 (struct pci_dev *pdev,
 	i = register_netdev(dev);
 	if (i)
 		goto err_register_netdev;
-
-	if (NATSEMI_CREATE_FILE(pdev, dspcfg_workaround))
+	i = NATSEMI_CREATE_FILE(pdev, dspcfg_workaround);
+	if (i)
 		goto err_create_file;
 
 	if (netif_msg_drv(np)) {

