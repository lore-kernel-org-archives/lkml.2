Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2AIPtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:49:53 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:52020 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab2AIPtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:49:50 -0500
X-AuditID: c1b4fb3d-b7cfeae000005b81-06-4f0b0c9c6a6a
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <lenb@kernel.org>, <ying.huang@intel.com>, <akpm@linux-foundation.org>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH] ACPI, APEI, EINJ Allow empty Trigger Error Action Table
Date: Mon, 9 Jan 2012 16:49:44 +0100
Message-ID: <1326124184-10084-2-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326124184-10084-1-git-send-email-niklas.soderlund@ericsson.com>
References: <1326124184-10084-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the ACPI spec [1] section 18.6.4 the TRIGGER_ERROR action
table can consists of zero elements.

[1] Advanced Configuration and Power Interface Specification
    Revision 5.0, December 6, 2011
	http://www.acpi.info/DOWNLOADS/ACPIspec50.pdf

Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 drivers/acpi/apei/einj.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 589b96c..94c05ff 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -184,7 +184,7 @@ static int einj_check_trigger_header(struct acpi_einj_trigger *trigger_tab)
 	if (trigger_tab->header_size != sizeof(struct acpi_einj_trigger))
 		return -EINVAL;
 	if (trigger_tab->table_size > PAGE_SIZE ||
-	    trigger_tab->table_size <= trigger_tab->header_size)
+	    trigger_tab->table_size < trigger_tab->header_size)
 		return -EINVAL;
 	if (trigger_tab->entry_count !=
 	    (trigger_tab->table_size - trigger_tab->header_size) /
@@ -225,6 +225,11 @@ static int __einj_error_trigger(u64 trigger_paddr)
 			   "The trigger error action table is invalid\n");
 		goto out_rel_header;
 	}
+
+	/* No action structures in the TRIGGER_ERROR table, nothing to do */
+	if (!trigger_tab->entry_count)
+		goto out_rel_header;
+
 	rc = -EIO;
 	table_size = trigger_tab->table_size;
 	r = request_mem_region(trigger_paddr + sizeof(*trigger_tab),
-- 
1.7.8.3

