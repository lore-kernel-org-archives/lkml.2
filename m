Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1ABHZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:37193 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1ABHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 257/260] gdth: integer overflow in ioctl
Date: Sun,  2 Jan 2011 02:19:13 -0500
Message-Id: <1293952756-15010-258-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:50.0465 (UTC) FILETIME=[24604110:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit f63ae56e4e97fb12053590e41a4fa59e7daa74a4 upstream.

gdth_ioctl_alloc() takes the size variable as an int.
copy_from_user() takes the size variable as an unsigned long.
gen.data_len and gen.sense_len are unsigned longs.
On x86_64 longs are 64 bit and ints are 32 bit.

We could pass in a very large number and the allocation would truncate
the size to 32 bits and allocate a small buffer.  Then when we do the
copy_from_user(), it would result in a memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/gdth.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 35a4b30..a8da7e8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4175,6 +4175,14 @@ static int ioc_general(void __user *arg, char *cmnd)
     ha = gdth_find_ha(gen.ionode);
     if (!ha)
         return -EFAULT;
+
+    if (gen.data_len > INT_MAX)
+        return -EINVAL;
+    if (gen.sense_len > INT_MAX)
+        return -EINVAL;
+    if (gen.data_len + gen.sense_len > INT_MAX)
+        return -EINVAL;
+
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(ha, gen.data_len + gen.sense_len,
                                      FALSE, &paddr)))
-- 
1.7.3.3

