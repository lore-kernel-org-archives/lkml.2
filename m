Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2IQKhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:37:34 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55732 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952Ab2IQKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:37:33 -0400
From: Vipul Kumar Samar <vipulkumar.samar@st.com>
To: <grant.likely@secretlab.ca>, <spi-devel-general@lists.sourceforge.net>
Cc: <linux-arm-kernel@lists.infradead.org>, <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@linaro.org>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: [PATCH] spi: pl022:  Add clk_{un}prepare() support in runtime PM
Date: Mon, 17 Sep 2012 16:07:10 +0530
Message-ID: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_{un}prepare is mandatory for platforms using common clock framework. Add
clk_{un}prepare() support for spi-pl022 runtime PM.

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
---
 drivers/spi/spi-pl022.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index f2a80ff..500e75e 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2334,7 +2334,7 @@ static int pl022_runtime_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
 
-	clk_disable(pl022->clk);
+	clk_disable_unprepare(pl022->clk);
 
 	return 0;
 }
@@ -2342,10 +2342,13 @@ static int pl022_runtime_suspend(struct device *dev)
 static int pl022_runtime_resume(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
+	int ret = 0;
 
-	clk_enable(pl022->clk);
+	ret = clk_prepare_enable(pl022->clk);
+	if (ret)
+		dev_err(dev, "could not enable SSP/SPI bus clock\n");
 
-	return 0;
+	return ret;
 }
 #endif
 
-- 
1.7.2.2

