Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0INTzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0INTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] dvb/bt8xx: kill the big kernel lock
Date: Tue, 14 Sep 2010 21:55:21 +0200
Message-Id: <1284494124-7384-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AC12PoHNzYLVA07c0i1pmpdpumTqkvx8KInQ58n9axR
 lYuzmCcEUgy4tN772sK9AWrpbA0THfwAlO6hoELBABKB8IaizM
 jbKOyW93iqahd4hoOth/syLwmt2Ph8utVfd4Sh8L4RUovbG77M
 BZ0slVqCsqZI1U/zGDEIYunWkLspKDlDhMNFWotz2qk9IOzaQ8
 jdYVVeoNDZ9iTTp/Npz1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bt8xx driver only uses the big kernel lock in its dst_ca_ioctl
function and never to serialize against other code, so we can
trivially replace it with a private mutex.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/dvb/bt8xx/dst_ca.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index cf87051..d75788b 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -22,7 +22,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/dvb/ca.h>
 #include "dvbdev.h"
@@ -52,6 +52,7 @@
 } while(0)
 
 
+static DEFINE_MUTEX(dst_ca_mutex);
 static unsigned int verbose = 5;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
@@ -564,7 +565,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	void __user *arg = (void __user *)ioctl_arg;
 	int result = 0;
 
-	lock_kernel();
+	mutex_lock(&dst_ca_mutex);
 	dvbdev = file->private_data;
 	state = (struct dst_state *)dvbdev->priv;
 	p_ca_message = kmalloc(sizeof (struct ca_msg), GFP_KERNEL);
@@ -652,7 +653,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 	kfree (p_ca_slot_info);
 	kfree (p_ca_caps);
 
-	unlock_kernel();
+	mutex_unlock(&dst_ca_mutex);
 	return result;
 }
 
-- 
1.7.1

