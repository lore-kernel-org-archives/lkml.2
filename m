Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2EGI0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:26:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32883 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2EGI0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:26:14 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-d0-4fa787244400
Message-id: <4FA78724.5000401@samsung.com>
Date: Mon, 07 May 2012 17:26:12 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] PM / Hibernate : Add wait for disk detection if
 resume_file is MAJOR:MINOR style
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

name_to_dev_t is not enough to check device detection when the resume_file is
MAJOR:MINOR format. get_gendisk is needed in that case.

Signed-off-by: Minho Ban <mhban@samsung.com>
---
 kernel/power/hibernate.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e09dfbf..27efaef 100644
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
@@ -749,6 +751,14 @@ static int software_resume(void)
 		}
 	}
 
+	/* name_to_dev_t is ineffective if resume_file comes in major:minor
+	 * format */
+	if (isdigit(resume_file[0]) && resume_wait) {
+		int partno;
+		while (!get_gendisk(swsusp_resume_device, &partno))
+			msleep(10);
+	}
+
  Check_image:
 	pr_debug("PM: Hibernation image partition %d:%d present\n",
 		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
-- 
1.7.5.4

