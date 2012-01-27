Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2A0Ewu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:52:50 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56533 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2A0Etg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:49:36 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 23/29] sysctl: Add sysctl_print_dir and use it in get_subdir
Date: Thu, 26 Jan 2012 20:51:59 -0800
Message-Id: <1327639925-12920-23-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Q9Oe5lSN8xy+lNJPYUD5eBhFyUYoDhCA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there are errors it is very nice to know the full sysctl path.
Add a simple function that computes the sysctl path and prints it
out.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 3c0767d..a785565 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -53,6 +53,13 @@ static DEFINE_SPINLOCK(sysctl_lock);
 
 static void drop_sysctl_table(struct ctl_table_header *header);
 
+static void sysctl_print_dir(struct ctl_dir *dir)
+{
+	if (dir->header.parent)
+		sysctl_print_dir(dir->header.parent);
+	printk(KERN_CONT "%s/", dir->header.ctl_table[0].procname);
+}
+
 static int namecmp(const char *name1, int len1, const char *name2, int len2)
 {
 	int minlen;
@@ -822,7 +829,9 @@ found:
 	subdir->header.nreg++;
 failed:
 	if (unlikely(IS_ERR(subdir))) {
-		printk(KERN_ERR "sysctl could not get directory: %*.*s %ld\n",
+		printk(KERN_ERR "sysctl could not get directory: ");
+		sysctl_print_dir(dir);
+		printk(KERN_CONT "/%*.*s %ld\n",
 			namelen, namelen, name, PTR_ERR(subdir));
 	}
 	drop_sysctl_table(&dir->header);
-- 
1.7.2.5

