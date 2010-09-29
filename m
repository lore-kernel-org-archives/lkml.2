Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0I2LyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:54:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0I2LyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="559001994"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 1/5] ACPI, APEI, Fix APEI related table size checking
Date: Wed, 29 Sep 2010 19:53:51 +0800
Message-Id: <1285761235-4751-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Huang Ying's machine:

erst_tab->header_length == sizeof(struct acpi_table_einj)

but Yinghai reported that on his machine,

erst_tab->header_length == sizeof(struct acpi_table_einj) -
sizeof(struct acpi_table_header)

To make erst table size checking code works on all systems, both
testing are treated as PASS.

Same situation applies to einj_tab->header_length, so corresponding
table size checking is changed in similar way too.

v2:

- Treat both table size as valid

Originally-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/einj.c |    4 +++-
 drivers/acpi/apei/erst.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -426,7 +426,9 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fop
 
 static int einj_check_table(struct acpi_table_einj *einj_tab)
 {
-	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
+	if ((einj_tab->header_length !=
+	     (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))
+	    && (einj_tab->header_length != sizeof(struct acpi_table_einj)))
 		return -EINVAL;
 	if (einj_tab->header.length < sizeof(struct acpi_table_einj))
 		return -EINVAL;
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -750,7 +750,9 @@ __setup("erst_disable", setup_erst_disab
 
 static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
-	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
+	if ((erst_tab->header_length !=
+	     (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
+	    && (erst_tab->header_length != sizeof(struct acpi_table_einj)))
 		return -EINVAL;
 	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
 		return -EINVAL;
