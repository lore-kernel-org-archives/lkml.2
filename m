Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2AKKFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:05:50 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:37977 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594Ab2AKKFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:05:49 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rjw@sisk.pl>, <grant.likely@secretlab.ca>, <baruch@tkos.co.il>
Cc: <linux-kernel@vger.kernel.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] gpio/gpio-pl061: No need of thaw and poweroff routines for hibernate
Date: Wed, 11 Jan 2012 15:25:20 +0530
Message-ID: <7662253849428ce018fb7f7359e0585fca9fb597.1326274467.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pl061 uses same routines for suspend/freeze/poweroff and resume/thaw/restore.
We are only saving and restoring register values on these routines.

During hibernation, in freeze() we take a snapshot of gpio registers. In thaw()
we don't actually need to restore these registers, as power was never shut down
till now. Similarly, in poweroff() we don't need to take snapshot of these
registers again, as it was done during freeze() and by now the image is already
saved on disk.

This patch passes poweroff() and thaw() routines as NULL to avoid this extra
work done.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/gpio/gpio-pl061.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index 84ba1dd..45b884b 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -430,7 +430,12 @@ static int pl061_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(pl061_dev_pm_ops, pl061_suspend, pl061_resume);
+static const struct dev_pm_ops pl061_dev_pm_ops = {
+	.suspend = pl061_suspend,
+	.resume = pl061_resume,
+	.freeze = pl061_suspend,
+	.restore = pl061_resume,
+};
 #endif
 
 static struct amba_id pl061_ids[] = {
-- 
1.7.8.110.g4cb5d

