Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2FZJQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:16:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50505 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab2FZJQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:16:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,476,1336320000"; 
   d="scan'208";a="5266068"
Message-ID: <4FE97EEC.6060008@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 17:20:44 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 4/8] donot allow to eject the memory device if it is being
 used
References: <4FE97DD5.6030205@cn.fujitsu.com>
In-Reply-To: <4FE97DD5.6030205@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:16:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:16:32,
	Serialize complete at 2012/06/26 17:16:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We eject the memory device even if it is in use. It is very dangerous,
and it will cause the kernel panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index a325bb9..2e5d5ab 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -78,6 +78,7 @@ struct acpi_memory_info {
 	unsigned short caching;	/* memory cache attribute */
 	unsigned short write_protect;	/* memory read/write attribute */
 	unsigned int enabled:1;
+	unsigned int failed:1;
 };
 
 struct acpi_memory_device {
@@ -251,9 +252,19 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 			node = memory_add_physaddr_to_nid(info->start_addr);
 
 		result = add_memory(node, info->start_addr, info->length);
-		if (result)
+
+		/*
+		 * If the memory block has been used by the kernel, add_memory()
+		 * returns -EEXIST. If add_memory() returns the other error, it
+		 * means that this memory block is not used by the kernel.
+		 */
+		if (result && result != -EEXIST) {
+			info->failed = 1;
 			continue;
-		info->enabled = 1;
+		}
+
+		if (!result)
+			info->enabled = 1;
 		num_enabled++;
 	}
 	if (!num_enabled) {
@@ -317,11 +328,20 @@ static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
 	 * Note: Assume that this function returns zero on success
 	 */
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
-		if (info->enabled) {
-			result = remove_memory(info->start_addr, info->length);
-			if (result)
-				return result;
-		}
+		if (info->failed)
+			/* The kernel does not use this memory block */
+			continue;
+
+		if (!info->enabled)
+			/*
+			 * The kernel uses this memory block, but it may be not
+			 * managed by us.
+			 */
+			return -EBUSY;
+
+		result = remove_memory(info->start_addr, info->length);
+		if (result)
+			return result;
 		list_del(&info->list);
 		kfree(info);
 	}
-- 
1.7.1

