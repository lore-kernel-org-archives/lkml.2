Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0GCWQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:16:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab0GCWPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:15:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
Subject: [PATCH 1/6] ia64/perfmon: convert to unlocked_ioctl
Date: Sun,  4 Jul 2010 00:15:05 +0200
Message-Id: <1278195310-25590-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278195310-25590-1-git-send-email-arnd@arndb.de>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/yC/203wnONfIHN3W+4I7FO1OoPWvOWo4jBSx
 xF+3moSEHiqIs7YAMVBYN3NhfS5JOKX86sPBwlIstdw1kKJd2n
 ZxVv/sNloRzOack7D65Zw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl function in this driver does not
do anything that requires the BKL, so make
it use unlocked_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/perfmon.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index ab985f7..7443290 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -1696,8 +1696,8 @@ pfm_poll(struct file *filp, poll_table * wait)
 	return mask;
 }
 
-static int
-pfm_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long
+pfm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	DPRINT(("pfm_ioctl called\n"));
 	return -EINVAL;
@@ -2174,15 +2174,15 @@ pfm_no_open(struct inode *irrelevant, struct file *dontcare)
 
 
 static const struct file_operations pfm_file_ops = {
-	.llseek   = no_llseek,
-	.read     = pfm_read,
-	.write    = pfm_write,
-	.poll     = pfm_poll,
-	.ioctl    = pfm_ioctl,
-	.open     = pfm_no_open,	/* special open code to disallow open via /proc */
-	.fasync   = pfm_fasync,
-	.release  = pfm_close,
-	.flush	  = pfm_flush
+	.llseek		= no_llseek,
+	.read		= pfm_read,
+	.write		= pfm_write,
+	.poll		= pfm_poll,
+	.unlocked_ioctl = pfm_ioctl,
+	.open		= pfm_no_open,	/* special open code to disallow open via /proc */
+	.fasync		= pfm_fasync,
+	.release	= pfm_close,
+	.flush		= pfm_flush
 };
 
 static int
-- 
1.7.1

