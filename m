Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1FFVIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:08:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45547 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754253Ab1FFVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:08:01 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19ztilGmhxzjrY+q7GfbvclH9eFUaRI0FGTLmXDqq
	D2mlr8/yFJftMc
From: Peter Huewe <peterhuewe@gmx.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>, Jan Glauber <jang@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Blaschka <frank.blaschka@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] s390/qdio_debug: Use kstrtoul_from_user
Date: Mon,  6 Jun 2011 23:07:54 +0200
Message-Id: <1307394474-747-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1307394474-747-1-git-send-email-peterhuewe@gmx.de>
References: <1307394474-747-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an unsigned long from a
userspace buffer by a simple call to kstroul_from_user.
This makes it easier to read and less error prone.

Kernel Version: v3.0-rc2

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/s390/cio/qdio_debug.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index f8b03a6..0e615cb 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -188,19 +188,13 @@ static ssize_t qperf_seq_write(struct file *file, const char __user *ubuf,
 	struct qdio_irq *irq_ptr = seq->private;
 	struct qdio_q *q;
 	unsigned long val;
-	char buf[8];
 	int ret, i;
 
 	if (!irq_ptr)
 		return 0;
-	if (count >= sizeof(buf))
-		return -EINVAL;
-	if (copy_from_user(&buf, ubuf, count))
-		return -EFAULT;
-	buf[count] = 0;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret < 0)
+
+	ret = kstrtoul_from_user(ubuf, count, 10, &val);
+	if (ret)
 		return ret;
 
 	switch (val) {
-- 
1.7.3.4

