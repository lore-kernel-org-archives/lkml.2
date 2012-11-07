Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2KGMiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:38:07 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44589 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab2KGMiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:38:04 -0500
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 20:38:04 +0800
Message-ID: <CAPgLHd_=OTwu-3tVXT0o8+x=N_9dZOkQ4A7HFr0SNdUiyAy_yw@mail.gmail.com>
Subject: [PATCH -next] ACPI: fix missing unlock on error in acpi_memory_remove_memory()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lenb@kernel.org, rjw@sisk.pl, wency@cn.fujitsu.com
Cc: yongjun_wei@trendmicro.com.cn, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing mutex_unlock() before return from function
acpi_memory_remove_memory() in the error handling case.

Introduce by commit 85fcb3758c10e063a2a30dfad75017097999deed
'ACPI / memory-hotplug: introduce a mutex lock to protect the list in acpi_memory_device'

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/acpi/acpi_memhotplug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 92c973a..e573e87 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -325,8 +325,10 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (info->enabled) {
 			result = remove_memory(info->start_addr, info->length);
-			if (result)
+			if (result) {
+				mutex_unlock(&mem_device->list_lock);
 				return result;
+			}
 		}
 
 		list_del(&info->list);


