Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1JJFpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:45:24 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:52737 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1JJFpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:45:22 -0400
From: Barry Song <Barry.Song@csr.com>
To: <pavel@ucw.cz>, <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>
CC: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <workgroup.linux@csr.com>,
        Barry Song <baohua.song@csr.com>
Subject: [PATCH] PM: HIBERNATION: add resume_delay kernel param as well as resume_delay
Date: Sun, 9 Oct 2011 22:44:12 -0700
Message-ID: <1318225452-10397-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <baohua.song@csr.com>

patch "PM: HIBERNATION: add resume_wait param to support MMC-like devices
as resume file" add resume_wait param. this patch adds resume_delay so that
resume_wait/delay has the same model with root_wait/delay.

Signed-off-by: Barry Song <baohua.song@csr.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 kernel/power/hibernate.c            |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 88a7b19..831bde2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2240,6 +2240,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			in <PAGE_SIZE> units (needed only for swap files).
 			See  Documentation/power/swsusp-and-swap-files.txt
 
+	resumedelay=	[HIBERNATION] Delay (in seconds) to pause before attempting to
+			read the resume files
+
 	resumewait	[HIBERNATION] Wait (indefinitely) for resume device to show up.
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b3da53c..f73a00e 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -33,6 +33,7 @@
 static int nocompress = 0;
 static int noresume = 0;
 static int resume_wait = 0;
+static int resume_delay = 0;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
@@ -726,6 +727,12 @@ static int software_resume(void)
 
 	pr_debug("PM: Checking hibernation image partition %s\n", resume_file);
 
+	if (resume_delay) {
+		printk(KERN_INFO "Waiting %dsec before reading resume device...\n",
+			resume_delay);
+		ssleep(resume_delay);
+	}
+
 	/* Check if the device is there */
 	swsusp_resume_device = name_to_dev_t(resume_file);
 	if (!swsusp_resume_device) {
@@ -1075,8 +1082,15 @@ static int __init resumewait_setup(char *str)
 	return 1;
 }
 
+static int __init resumedelay_setup(char *str)
+{
+	resume_delay = simple_strtoul(str, NULL, 0);
+	return 1;
+}
+
 __setup("noresume", noresume_setup);
 __setup("resume_offset=", resume_offset_setup);
 __setup("resume=", resume_setup);
 __setup("hibernate=", hibernate_setup);
 __setup("resumewait", resumewait_setup);
+__setup("resumedelay=", resumedelay_setup);
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
