Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2LNII5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 03:08:57 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30101 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2LNIIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 03:08:55 -0500
From: Adrian Huang <adrian.huang@hp.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Adrian Huang <adrian.huang@hp.com>
Subject: [PATCH 1/1] ACPI/APEI: Fix the returned value in erst_dbg_read
Date: Fri, 14 Dec 2012 16:08:34 +0800
Message-Id: <1355472514-8172-1-git-send-email-adrian.huang@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the persistent store is empty initially, the function 'erst_dbg_read'
returns a nonzero value. The better way is to return a zero indicating the
read operation reaches EOF.

Tested on two different servers.

Signed-off-by: Adrian Huang <adrian.huang@hp.com>
---
 drivers/acpi/apei/erst-dbg.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/erst-dbg.c b/drivers/acpi/apei/erst-dbg.c
index 903549d..04ab5c9 100644
--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -111,8 +111,17 @@ retry_next:
 	if (rc)
 		goto out;
 	/* no more record */
-	if (id == APEI_ERST_INVALID_RECORD_ID)
+	if (id == APEI_ERST_INVALID_RECORD_ID) {
+		/*
+		 * If the persistent store is empty initially, the function
+		 * 'erst_read' below will return "-ENOENT" value. This causes
+		 * 'retry_next' label is entered again. The returned value
+		 * should be zero indicating the read operation is EOF.
+		 */
+		len = 0;
+
 		goto out;
+	}
 retry:
 	rc = len = erst_read(id, erst_dbg_buf, erst_dbg_buf_len);
 	/* The record may be cleared by others, try read next record */
-- 
1.7.10.4

