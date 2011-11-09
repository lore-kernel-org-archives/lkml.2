Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1KIXba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:31:30 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56896 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab1KIXb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:31:29 -0500
From: Andrei Warkentin <andreiw@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Andrei Warkentin <andreiw@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] /dev/mem: Fix wrong error on accessing beyond valid memory addresses.
Date: Wed,  9 Nov 2011 18:31:19 -0500
Message-Id: <1320881479-16711-1-git-send-email-andreiw@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this returns -EFAULT, but it really should be returning 0,
as in - 0 bytes read or written. This is what you would get by
opening a block device, seeking to the end, and trying to read
something. Additionally, make lseek() check the sought-to offset
to pass the valid_phys_addr_range test.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
---
 drivers/char/mem.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8fc04b4..02d0b1a 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -98,7 +98,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 	char *ptr;
 
 	if (!valid_phys_addr_range(p, count))
-		return -EFAULT;
+		return 0;
 	read = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
@@ -156,7 +156,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	void *ptr;
 
 	if (!valid_phys_addr_range(p, count))
-		return -EFAULT;
+		return 0;
 
 	written = 0;
 
@@ -710,6 +710,11 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 	case SEEK_CUR:
 		offset += file->f_pos;
 	case SEEK_SET:
+		if (!valid_phys_addr_range(offset, 0)) {
+			ret = -EINVAL;
+			break;
+		}
+
 		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
 		if ((unsigned long long)offset >= ~0xFFFULL) {
 			ret = -EOVERFLOW;
-- 
1.7.4.1

