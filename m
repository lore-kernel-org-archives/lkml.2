Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1BCCzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:55:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab1BCCzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:55:20 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: etm: Don't trigger another overflow when trying to clear the RAM-full status
Date: Wed,  2 Feb 2011 18:54:21 -0800
Message-Id: <1296701663-12168-3-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the write address was at the end of the buffer, toggling the trace
capture bit would set the RAM-full status instead of clearing it.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 2ea0b7c..7652e9f 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -235,6 +235,7 @@ static void etm_dump(void)
 	printk(KERN_INFO "\n--- ETB buffer end ---\n");
 
 	/* deassert the overflow bit */
+	etb_writel(t, 0, ETBR_WRITEADDR);
 	etb_writel(t, 1, ETBR_CTRL);
 	etb_writel(t, 0, ETBR_CTRL);
 
@@ -300,6 +301,7 @@ static ssize_t etb_read(struct file *file, char __user *data,
 		buf[i] = etb_readl(t, ETBR_READMEM);
 
 	/* the only way to deassert overflow bit in ETB status is this */
+	etb_writel(t, 0, ETBR_WRITEADDR);
 	etb_writel(t, 1, ETBR_CTRL);
 	etb_writel(t, 0, ETBR_CTRL);
 
-- 
1.7.3.1

