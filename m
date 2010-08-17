Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0HQA5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 20:57:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41727 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0HQA5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 20:57:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C69DEA5.1020902@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 09:58:13 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] [Patch-next] ACPI, APEI, HEST Fix the unsuitable usage
 of platform_data.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_data in hest_parse_ghes() is used for saving the address of entry
information of erst_tab. When the device is failed to be added, platform_data
will be freed by platform_device_put(). But the value saved in platform_data
should not be freed here. If it is done, it will make system panic.

So I think platform_data should save the address of allocated memory
which saves entry information of erst_tab.

This patch fixed it and I confirmed it on x86_64 next-tree.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 drivers/acpi/apei/ghes.c |    2 +-
 drivers/acpi/apei/hest.c |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 385a605..b35c622 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -302,7 +302,7 @@ static int __devinit ghes_probe(struct platform_device *ghes_dev)
 	struct ghes *ghes = NULL;
 	int rc = -EINVAL;
 
-	generic = ghes_dev->dev.platform_data;
+	generic = *(struct acpi_hest_generic **)(ghes_dev->dev.platform_data);
 	if (!generic->enabled)
 		return -ENODEV;
 
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 343168d..5a65e2a 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -137,20 +137,29 @@ static int hest_parse_ghes_count(struct acpi_hest_header *hest_hdr, void *data)
 
 static int hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)
 {
-	struct acpi_hest_generic *generic;
+	void **platform_data;
 	struct platform_device *ghes_dev;
 	struct ghes_arr *ghes_arr = data;
 	int rc;
 
 	if (hest_hdr->type != ACPI_HEST_TYPE_GENERIC_ERROR)
 		return 0;
-	generic = (struct acpi_hest_generic *)hest_hdr;
-	if (!generic->enabled)
+
+	platform_data = kmalloc(sizeof(void *), GFP_KERNEL);
+	if (!platform_data)
+		return -ENOMEM;
+
+	*platform_data = hest_hdr;
+	if (!((struct acpi_hest_generic *)*platform_data)->enabled)
 		return 0;
+
 	ghes_dev = platform_device_alloc("GHES", hest_hdr->source_id);
-	if (!ghes_dev)
+	if (!ghes_dev) {
+		kfree(platform_data);
 		return -ENOMEM;
-	ghes_dev->dev.platform_data = generic;
+	}
+
+	ghes_dev->dev.platform_data = platform_data;
 	rc = platform_device_add(ghes_dev);
 	if (rc)
 		goto err;
-- 
1.7.1.1


