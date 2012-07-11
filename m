Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2GKHnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:43:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26996 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab2GKHnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:43:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,566,1336320000"; 
   d="scan'208";a="5371807"
Message-ID: <4FFD2FA6.3060101@cn.fujitsu.com>
Date: Wed, 11 Jul 2012 15:47:50 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/7 v2] free memory device if acpi_memory_enable_device()
 failed
References: <4FFD2F1E.10006@cn.fujitsu.com>
In-Reply-To: <4FFD2F1E.10006@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 15:43:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 15:43:07,
	Serialize complete at 2012/07/11 15:43:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If acpi_memory_enable_device() fails, acpi_memory_enable_device() will
return a non-zero value, which means we fail to bind the memory device
to this driver. So we should free memory device before acpi_memory_device_add()
returns.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index fe699ec..260a9c4 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -457,9 +457,11 @@ static int acpi_memory_device_add(struct acpi_device *device)
 	if (!acpi_memory_check_device(mem_device)) {
 		/* call add_memory func */
 		result = acpi_memory_enable_device(mem_device);
-		if (result)
+		if (result) {
 			printk(KERN_ERR PREFIX
 				"Error in acpi_memory_enable_device\n");
+			acpi_memory_device_free(mem_device);
+		}
 	}
 	return result;
 }
-- 
1.7.1

