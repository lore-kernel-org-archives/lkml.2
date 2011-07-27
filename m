Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1G0E4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:56:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1G0E4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:56:32 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/2] proc/insterrupts: make it cpu hotplug safe
Date: Wed, 27 Jul 2011 12:56:22 +0800
Message-Id: <1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
References: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motonhiro noticed that the reader of /proc/interrupts
could be preempted by cpu hotplug, thus the reader can get
broken result due to show_interrupts() iterate every online
cpu without any protection.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/proc/interrupts.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
index 05029c0..d5642a6 100644
--- a/fs/proc/interrupts.c
+++ b/fs/proc/interrupts.c
@@ -4,6 +4,7 @@
 #include <linux/irqnr.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/cpu.h>
 
 /*
  * /proc/interrupts
@@ -35,14 +36,21 @@ static const struct seq_operations int_seq_ops = {
 
 static int interrupts_open(struct inode *inode, struct file *filp)
 {
+	get_online_cpus();
 	return seq_open(filp, &int_seq_ops);
 }
 
+static int interrupts_release(struct inode *inode, struct file *filp)
+{
+	put_online_cpus();
+	return seq_release(inode, filp);
+}
+
 static const struct file_operations proc_interrupts_operations = {
 	.open		= interrupts_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= interrupts_release,
 };
 
 static int __init proc_interrupts_init(void)
-- 
1.7.4.1

