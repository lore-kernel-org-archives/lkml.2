Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab0G3RSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:41 -0400
Received: from kroah.org ([198.145.64.141]:51589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab0G3RSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:05 2010
Message-Id: <20100730171504.962424085@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [058/165] sdhci-s3c: add missing remove function
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 9d51a6b2487724e8713cd2794cf09ffeee5f6932 upstream.

System will crash sooner or later once the memory with the code of the
s3c-sdhci.ko module is reused for something else. I really have no idea
how the lack of remove function went unnoticed into the mainline code.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci-s3c.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -372,6 +372,26 @@ static int __devinit sdhci_s3c_probe(str
 
 static int __devexit sdhci_s3c_remove(struct platform_device *pdev)
 {
+	struct sdhci_host *host =  platform_get_drvdata(pdev);
+	struct sdhci_s3c *sc = sdhci_priv(host);
+	int ptr;
+
+	sdhci_remove_host(host, 1);
+
+	for (ptr = 0; ptr < 3; ptr++) {
+		clk_disable(sc->clk_bus[ptr]);
+		clk_put(sc->clk_bus[ptr]);
+	}
+	clk_disable(sc->clk_io);
+	clk_put(sc->clk_io);
+
+	iounmap(host->ioaddr);
+	release_resource(sc->ioarea);
+	kfree(sc->ioarea);
+
+	sdhci_free_host(host);
+	platform_set_drvdata(pdev, NULL);
+
 	return 0;
 }
 


