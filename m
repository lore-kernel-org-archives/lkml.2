Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2JEUlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:41:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47059 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2JEUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:41:34 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: wg@grandegger.com
Cc: mkl@pengutronix.de, davem@davemloft.net, jj@chaosbits.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 3/20 V2] drivers/net/can/sja1000/peak_pci.c: fix error return code
Date: Fri,  5 Oct 2012 22:41:05 +0200
Message-Id: <1349469667-6137-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349469667-6137-1-git-send-email-peter.senna@gmail.com>
References: <1349469667-6137-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

The function peak_pci_probe() return 0 for success and negative value
for most of its internal tests failures. There are two exceptions
that are error cases going to failure_*:. Fore this two cases the
function abort its success execution path, but returns non negative
value, making it dificult for a caller function to notice the error.

This patch fixes the error cases that do not return negative values.

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
Change from V1:
	Updated commit message. See: 
	http://www.kernelhub.org/?p=2&msg=139319

 drivers/net/can/sja1000/peak_pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index f0a1296..f5b82ae 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -583,12 +583,14 @@ static int __devinit peak_pci_probe(struct pci_dev *pdev,
 	cfg_base = pci_iomap(pdev, 0, PEAK_PCI_CFG_SIZE);
 	if (!cfg_base) {
 		dev_err(&pdev->dev, "failed to map PCI resource #0\n");
+		err = -ENOMEM;
 		goto failure_release_regions;
 	}
 
 	reg_base = pci_iomap(pdev, 1, PEAK_PCI_CHAN_SIZE * channels);
 	if (!reg_base) {
 		dev_err(&pdev->dev, "failed to map PCI resource #1\n");
+		err = -ENOMEM;
 		goto failure_unmap_cfg_base;
 	}
 

