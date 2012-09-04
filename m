Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2IDP4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329Ab2IDPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:55:44 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 06/11] Restrict /dev/mem and /dev/kmem in secure boot setups
Date: Tue,  4 Sep 2012 11:55:12 -0400
Message-Id: <1346774117-2277-7-git-send-email-mjg@redhat.com>
In-Reply-To: <1346774117-2277-1-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing users to write to address space makes it possible for the kernel
to be subverted. Restrict this when we need to protect the kernel.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8f5f872..c1de8e1 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -158,6 +158,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -530,6 +533,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (!capable(CAP_SECURE_FIRMWARE))
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-- 
1.7.11.4

