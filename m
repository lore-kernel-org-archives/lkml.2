Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0ESRYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:24:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0ESRY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=YitKjS01Hmkc9tqetKJYcXEWheOAkNviLiBO0/6pUec8u/qpEy+dSiNFXcQkQUTm21
         zDCat1WUQznMR+f1EV3oBeOq7E9v3uT8hl+SnMS6JMtDTU+X8apFLS6p0bPb5lZR/eOG
         TjjHfzN3LZsp+ESb1WlPUW9ZHX4Ara+ovv3y4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       IA64 <linux-ia64@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/8] ia64: Use unlocked_ioctl from perfmon
Date: Wed, 19 May 2010 19:24:15 +0200
Message-Id: <1274289855-10001-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pfm_ioctl() obviously doesn't need the bkl just to print a
message.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: IA64 <linux-ia64@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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
1.6.2.3

