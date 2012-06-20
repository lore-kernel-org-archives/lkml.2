Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab2FTWsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:48:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41373 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2FTWse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:48:34 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 07/15] ARM: etm: Return the entire trace buffer if it is empty after reset
Date: Wed, 20 Jun 2012 18:47:39 -0400
Message-Id: <1340232467-6023-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-7282-0000-0000-00000A239039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

On some SOCs the read and write pointer are reset when the chip
resets, but the trace buffer content is preserved. If the status
bits indicates that the buffer is empty and we have never started
tracing, assume the buffer is full instead. This can be useful
if the system rebooted from a watchdog reset.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 3d21cf6..74444e5 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -45,6 +45,7 @@ struct tracectx {
 	unsigned long	range_end;
 	unsigned long	data_range_start;
 	unsigned long	data_range_end;
+	bool		dump_initial_etb;
 	struct device	*dev;
 	struct clk	*emu_clk;
 	struct mutex	mutex;
@@ -106,6 +107,7 @@ static int trace_start(struct tracectx *t)
 
 	etb_unlock(t);
 
+	t->dump_initial_etb = false;
 	etb_writel(t, 0, ETBR_WRITEADDR);
 	etb_writel(t, 0, ETBR_FORMATTERCTRL);
 	etb_writel(t, 1, ETBR_CTRL);
@@ -312,6 +314,8 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	etb_unlock(t);
 
 	total = etb_getdatalen(t);
+	if (total == 0 && t->dump_initial_etb)
+		total = t->etb_bufsz;
 	if (total == t->etb_bufsz)
 		first = etb_readl(t, ETBR_WRITEADDR);
 
@@ -386,6 +390,7 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
 		goto out_release;
 	}
 
+	t->dump_initial_etb = true;
 	amba_set_drvdata(dev, t);
 
 	etb_unlock(t);
-- 
1.7.9.5

