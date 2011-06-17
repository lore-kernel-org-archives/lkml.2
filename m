Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab1FQI5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:57:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324Ab1FQI5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:17 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] Return EOF on out-of-bounds read from /dev/mem
Date: Fri, 17 Jun 2011 10:43:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171043.57138.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The off parameter (type loff_t) may specify an offset that cannot
be represented by a long. Currently, /dev/mem wraps around, which
may to cause applications to read/write incorrect regions of memory
by accident.

Follow the usual file semantics here and return 0 when reading or
-EFBIG when writing beyond the accessible range.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 drivers/char/mem.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8fc04b4..f5cbd4e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -97,6 +97,9 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 	ssize_t read, sz;
 	char *ptr;
 
+	if (p != *ppos)
+		return 0;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 	read = 0;
@@ -155,6 +158,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (p != *ppos)
+		return -EFBIG;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
-- 
1.7.3.4
