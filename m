Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2EIKXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:23:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40846 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2EIKXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:23:21 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-63-4faa45972f43
Message-id: <4FAA4597.7060302@samsung.com>
Date: Wed, 09 May 2012 19:23:19 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH] PM / Hibernate : Use get_gendisk to verify partition if
 resume_file is integer format
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes resume= parameter comes in integer style (e.g. major:minor) then
name_to_dev_t can not detect partition properly. (especially async device like
usb, mmc)
This patch calls get_gendisk if resumewait is true and resume_file is in integer
format.

Signed-off-by: Minho Ban <mhban@samsung.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/power/hibernate.c            |   13 +++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..5900b49 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2372,6 +2372,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	resume=		[SWSUSP]
 			Specify the partition device for software suspend
+			Format:
+			{/dev/<dev> | PARTUUID=<uuid> | <int>:<int> | <hex>}
 
 	resume_offset=	[SWSUSP]
 			Specify the offset from the beginning of the partition
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e09dfbf..8b53db3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -25,6 +25,8 @@
 #include <linux/freezer.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
+#include <linux/ctype.h>
+#include <linux/genhd.h>
 #include <scsi/scsi_scan.h>
 
 #include "power.h"
@@ -722,6 +724,17 @@ static int software_resume(void)
 
 	/* Check if the device is there */
 	swsusp_resume_device = name_to_dev_t(resume_file);
+
+	/*
+	 * name_to_dev_t is ineffective to verify parition if resume_file is in
+	 * integer format. (e.g. major:minor)
+	 */
+	if (isdigit(resume_file[0]) && resume_wait) {
+		int partno;
+		while (!get_gendisk(swsusp_resume_device, &partno))
+			msleep(10);
+	}
+
 	if (!swsusp_resume_device) {
 		/*
 		 * Some device discovery might still be in progress; we need
-- 
1.7.5.4

