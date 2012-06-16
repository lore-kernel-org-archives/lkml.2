Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2FPElE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 00:41:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:57664 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2FPEko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 00:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157049095"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: wfg@linux.intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] printk: return -EINVAL if the message len is bigger than the buf size
Date: Sat, 16 Jun 2012 12:40:55 +0800
Message-Id: <1339821655-14059-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like what devkmsg_read() does, return -EINVAL if the message len is
bigger than the buf size, or it will trigger a segfault error.

Cc: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/printk.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index d2ddb83..734e2a4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -879,7 +879,9 @@ static int syslog_print(char __user *buf, int size)
 	syslog_seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
 
-	if (len > 0 && copy_to_user(buf, text, len))
+	if (len > size)
+		len = -EINVAL;
+	else if (len > 0 && copy_to_user(buf, text, len))
 		len = -EFAULT;
 
 	kfree(text);
-- 
1.7.3.1

