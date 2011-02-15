Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1BOGMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:12:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45219 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1BOGMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:12:01 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] ARM: etm: Return the entire trace buffer if it is empty after reset
Date: Mon, 14 Feb 2011 22:11:15 -0800
Message-Id: <1297750276-12475-7-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some SOCs the read and write pointer are reset when the chip
resets, but the trace buffer content is preserved. If the status
bits indicates that the buffer is empty and we have never started
tracing, assume the buffer is full instead. This can be useful
if the system rebooted from a watchdog reset.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8126beb..4ad1257 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -44,6 +44,7 @@ struct tracectx {
 	unsigned long	range_end;
 	unsigned long	data_range_start;
 	unsigned long	data_range_end;
+	bool		dump_initial_etb;
 	struct device	*dev;
 	struct clk	*emu_clk;
 	struct mutex	mutex;
@@ -105,6 +106,7 @@ static int trace_start(struct tracectx *t)
 
 	etb_unlock(t);
 
+	t->dump_initial_etb = false;
 	etb_writel(t, 0, ETBR_WRITEADDR);
 	etb_writel(t, 0, ETBR_FORMATTERCTRL);
 	etb_writel(t, 1, ETBR_CTRL);
@@ -311,6 +313,8 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	etb_unlock(t);
 
 	total = etb_getdatalen(t);
+	if (total == 0 && t->dump_initial_etb)
+		total = t->etb_bufsz;
 	if (total == t->etb_bufsz)
 		first = etb_readl(t, ETBR_WRITEADDR);
 
@@ -385,6 +389,7 @@ static int __init etb_probe(struct amba_device *dev, struct amba_id *id)
 		goto out_release;
 	}
 
+	t->dump_initial_etb = true;
 	amba_set_drvdata(dev, t);
 
 	etb_unlock(t);
-- 
1.7.3.1

