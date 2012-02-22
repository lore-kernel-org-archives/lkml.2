Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2BVK3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:29:30 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:50910 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783Ab2BVK33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:29:29 -0500
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>
Subject: [PATCH] staging: logger: hold mutex while removing reader
Date: Wed, 22 Feb 2012 15:58:00 +0530
Message-ID: <1329906480-22752-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The readers list is traversed under the log->mutex lock
(for example from fix_up_readers()), but the deletion of
elements from this list is not being done under this lock.

Cc: Brian Swetland <swetland@google.com>
Cc: Dima Zavin <dima@android.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/staging/android/logger.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index ffc2d04..a45c3b0 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -432,7 +432,12 @@ static int logger_release(struct inode *ignored, struct file *file)
 {
 	if (file->f_mode & FMODE_READ) {
 		struct logger_reader *reader = file->private_data;
+		struct logger_log *log = reader->log;
+
+		mutex_lock(&log->mutex);
 		list_del(&reader->list);
+		mutex_unlock(&log->mutex);
+
 		kfree(reader);
 	}
 
-- 
1.7.4.3

