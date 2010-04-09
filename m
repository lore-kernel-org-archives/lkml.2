Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0DIOCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:02:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:45367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0DIOB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:28 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 09/12] osst: Use noop_llseek() instead of default_llseek()
Date: Fri,  9 Apr 2010 16:00:52 +0200
Message-Id: <1270821655-4368-10-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__os_scsi_tape_open() suggests that llseek() doesn't work:
"We really want to do nonseekable_open(inode, filp); here, but some
versions of tar incorrectly call lseek on tapes and bail out if that
fails.  So we disallow pread() and pwrite(), but permit lseeks."

Instead of using the fallback default_llseek() the driver should use
noop_llseek() which leaves the file->f_pos untouched but succeeds.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/scsi/osst.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 9dc0b9a..960e39c 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5619,6 +5619,7 @@ static const struct file_operations osst_fops = {
 	.open =         os_scsi_tape_open,
 	.flush =        os_scsi_tape_flush,
 	.release =      os_scsi_tape_close,
+	.llseek =	noop_llseek,
 };
 
 static int osst_supports(struct scsi_device * SDp)
-- 
1.6.4.2

