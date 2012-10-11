Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2JKKci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:32:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53478 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab2JKKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:32:26 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] efivarfs: efivarfs_file_read ensure we free data in error paths
Date: Thu, 11 Oct 2012 11:32:17 +0100
Message-Id: <1349951541-20498-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349951541-20498-1-git-send-email-apw@canonical.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
 <1349951541-20498-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/firmware/efivars.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 4b12a8fd..ae50d2f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -766,7 +766,7 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	unsigned long datasize = 0;
 	u32 attributes;
 	void *data;
-	ssize_t size;
+	ssize_t size = 0;
 
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
@@ -784,13 +784,13 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize,
 					    (data + 4));
-
 	if (status != EFI_SUCCESS)
-		return 0;
+		goto out_free;
 
 	memcpy(data, &attributes, 4);
 	size = simple_read_from_buffer(userbuf, count, ppos,
 					data, datasize + 4);
+out_free:
 	kfree(data);
 
 	return size;
-- 
1.7.9.5

