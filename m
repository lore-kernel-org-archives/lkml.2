Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AFRE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:04:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61104 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1AFRE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:04:57 -0500
Date: Thu, 6 Jan 2011 18:04:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] dma: shdma: don't register the global die notifier multiple
 times
Message-ID: <Pine.LNX.4.64.1101061759460.1248@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:aakzJfig1cCLda9ipSfLdX97MbUUzY6tEAp2fWv7Q4t
 /LfY2arTbqf0QzKWji5oI1zlKeW46IyVt9XOp1hvMriwe9UYRH
 ks6xdgHwUIbolXf6vE6DZO5+BPpTMK5i1iB23iHz9iC3BW0BjY
 SDjkZ4GTrZU+0vgorAXpqOUTLfEF1vdfMI0ssCCXOsMXehId8i
 5o+DSQCbJLFOUJN2I3ar2IqborxvUJ0JA6zSqRVR18=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch has added a die notifier to the shdma driver, however, 
it registers a static die-notifier object in the probe routine, i.e., 
for each device instance. This is wrong and leads to a system lockup. 
This patch moves the die notifier registration to module init and 
exit routines respectively.

Reported-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This fixes the lock up on sh7372. Patch against current sh-2.6/master.

 drivers/dma/shdma.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index a0069c1..28720d3 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1110,11 +1110,6 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 	list_add_tail_rcu(&shdev->node, &sh_dmae_devices);
 	spin_unlock_irqrestore(&sh_dmae_lock, flags);
 
-	/* Wire up NMI handling before bringing the controller online */
-	err = register_die_notifier(&sh_dmae_nmi_notifier);
-	if (err)
-		goto notifier_err;
-
 	/* reset dma controller */
 	err = sh_dmae_rst(shdev);
 	if (err)
@@ -1218,8 +1213,6 @@ eirqres:
 eirq_err:
 #endif
 rst_err:
-	unregister_die_notifier(&sh_dmae_nmi_notifier);
-notifier_err:
 	spin_lock_irqsave(&sh_dmae_lock, flags);
 	list_del_rcu(&shdev->node);
 	spin_unlock_irqrestore(&sh_dmae_lock, flags);
@@ -1252,8 +1245,6 @@ static int __exit sh_dmae_remove(struct platform_device *pdev)
 	if (errirq > 0)
 		free_irq(errirq, shdev);
 
-	unregister_die_notifier(&sh_dmae_nmi_notifier);
-
 	spin_lock_irqsave(&sh_dmae_lock, flags);
 	list_del_rcu(&shdev->node);
 	spin_unlock_irqrestore(&sh_dmae_lock, flags);
@@ -1296,6 +1287,11 @@ static struct platform_driver sh_dmae_driver = {
 
 static int __init sh_dmae_init(void)
 {
+	/* Wire up NMI handling */
+	int err = register_die_notifier(&sh_dmae_nmi_notifier);
+	if (err)
+		return err;
+
 	return platform_driver_probe(&sh_dmae_driver, sh_dmae_probe);
 }
 module_init(sh_dmae_init);
@@ -1303,6 +1299,8 @@ module_init(sh_dmae_init);
 static void __exit sh_dmae_exit(void)
 {
 	platform_driver_unregister(&sh_dmae_driver);
+
+	unregister_die_notifier(&sh_dmae_nmi_notifier);
 }
 module_exit(sh_dmae_exit);
 
-- 
1.7.2.3

