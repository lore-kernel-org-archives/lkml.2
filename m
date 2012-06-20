Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab2FTWt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:49:27 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41493 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab2FTWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:49:22 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/15] ARM: etm: Don't try to clear the buffer full status after reading the buffer
Date: Wed, 20 Jun 2012 18:47:35 -0400
Message-Id: <1340232467-6023-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-1780-0000-0000-000006A6DEF2
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00149807; UDB=6.00034058; UTC=2012-06-20
 22:49:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

If the write address was at the end of the buffer, toggling the trace
capture bit would set the RAM-full status instead of clearing it, and
if any of the stop bits in the formatter is set toggling the trace
capture bit may not do anything.

Instead use the read position to find out if the data has already
been returned.

This also fixes the read function so it works when the trace buffer is
larger than the buffer passed in from user space. The old version
would reset the trace buffer pointers after every read, so the second
call to read would always return 0.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |   58 ++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index d7622f9..a51bccc 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -92,6 +92,7 @@ static int trace_start(struct tracectx *t)
 
 	etb_unlock(t);
 
+	etb_writel(t, 0, ETBR_WRITEADDR);
 	etb_writel(t, 0, ETBR_FORMATTERCTRL);
 	etb_writel(t, 1, ETBR_CTRL);
 
@@ -185,24 +186,15 @@ static int trace_stop(struct tracectx *t)
 static int etb_getdatalen(struct tracectx *t)
 {
 	u32 v;
-	int rp, wp;
+	int wp;
 
 	v = etb_readl(t, ETBR_STATUS);
 
 	if (v & 1)
 		return t->etb_bufsz;
 
-	rp = etb_readl(t, ETBR_READADDR);
 	wp = etb_readl(t, ETBR_WRITEADDR);
-
-	if (rp > wp) {
-		etb_writel(t, 0, ETBR_READADDR);
-		etb_writel(t, 0, ETBR_WRITEADDR);
-
-		return 0;
-	}
-
-	return wp - rp;
+	return wp;
 }
 
 /* sysrq+v will always stop the running trace and leave it at that */
@@ -235,14 +227,6 @@ static void etm_dump(void)
 		printk("%08x", cpu_to_be32(etb_readl(t, ETBR_READMEM)));
 	printk(KERN_INFO "\n--- ETB buffer end ---\n");
 
-	/* deassert the overflow bit */
-	etb_writel(t, 1, ETBR_CTRL);
-	etb_writel(t, 0, ETBR_CTRL);
-
-	etb_writel(t, 0, ETBR_TRIGGERCOUNT);
-	etb_writel(t, 0, ETBR_READADDR);
-	etb_writel(t, 0, ETBR_WRITEADDR);
-
 	etb_lock(t);
 }
 
@@ -276,6 +260,10 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	struct tracectx *t = file->private_data;
 	u32 first = 0;
 	u32 *buf;
+	int wpos;
+	int skip;
+	long wlength;
+	loff_t pos = *ppos;
 
 	mutex_lock(&t->mutex);
 
@@ -290,28 +278,34 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	if (total == t->etb_bufsz)
 		first = etb_readl(t, ETBR_WRITEADDR);
 
+	if (pos > total * 4) {
+		skip = 0;
+		wpos = total;
+	} else {
+		skip = (int)pos % 4;
+		wpos = (int)pos / 4;
+	}
+	total -= wpos;
+	first = (first + wpos) % t->etb_bufsz;
+
 	etb_writel(t, first, ETBR_READADDR);
 
-	length = min(total * 4, (int)len);
-	buf = vmalloc(length);
+	wlength = min(total, DIV_ROUND_UP(skip + (int)len, 4));
+	length = min(total * 4 - skip, (int)len);
+	buf = vmalloc(wlength * 4);
 
-	dev_dbg(t->dev, "ETB buffer length: %d\n", total);
+	dev_dbg(t->dev, "ETB read %ld bytes to %lld from %ld words at %d\n",
+		length, pos, wlength, first);
+	dev_dbg(t->dev, "ETB buffer length: %d\n", total + wpos);
 	dev_dbg(t->dev, "ETB status reg: %x\n", etb_readl(t, ETBR_STATUS));
-	for (i = 0; i < length / 4; i++)
+	for (i = 0; i < wlength; i++)
 		buf[i] = etb_readl(t, ETBR_READMEM);
 
-	/* the only way to deassert overflow bit in ETB status is this */
-	etb_writel(t, 1, ETBR_CTRL);
-	etb_writel(t, 0, ETBR_CTRL);
-
-	etb_writel(t, 0, ETBR_WRITEADDR);
-	etb_writel(t, 0, ETBR_READADDR);
-	etb_writel(t, 0, ETBR_TRIGGERCOUNT);
-
 	etb_lock(t);
 
-	length -= copy_to_user(data, buf, length);
+	length -= copy_to_user(data, (u8 *)buf + skip, length);
 	vfree(buf);
+	*ppos = pos + length;
 
 out:
 	mutex_unlock(&t->mutex);
-- 
1.7.9.5

