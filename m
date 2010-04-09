Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0DIOBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:01:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:45347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab0DIOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:22 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 02/12] flash_read should update ppos instead of file->f_pos
Date: Fri,  9 Apr 2010 16:00:45 +0200
Message-Id: <1270821655-4368-3-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flash_read() updates file->f_pos directly instead of the ppos given. The
VFS later updates the file->f_pos and overwrites it with the unchanged
value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/sbus/char/flash.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 4108347..12cd438 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -106,9 +106,9 @@ static ssize_t
 flash_read(struct file * file, char __user * buf,
 	   size_t count, loff_t *ppos)
 {
-	unsigned long p = file->f_pos;
+	loff_t p = *ppos;
 	int i;
-	
+
 	if (count > flash.read_size - p)
 		count = flash.read_size - p;
 
@@ -119,7 +119,7 @@ flash_read(struct file * file, char __user * buf,
 		buf++;
 	}
 
-	file->f_pos += count;
+	*ppos += count;
 	return count;
 }
 
-- 
1.6.4.2

