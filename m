Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1HLXmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 19:42:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1HLXmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 19:42:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=m+O0A/AsBhmN4S9BFi87GBZZ8T7lxM8jTKz6ybEh+YVyhfUzXF0qk5opKi8mfj/Ml
	KmKh8kKfHwnC5t9KLL68w==
From: Mike Waychison <mikew@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] oprofilefs: Handle zero-length writes.
Date: Fri, 12 Aug 2011 16:42:19 -0700
Message-Id: <1313192539-19581-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in oprofilefs, files that use ulong_fops mis-handle writes of
zero length.  A count of 0 causes oprofilefs_ulong_from_user to return
0 (success), which then leads to oprofile_set_ulong being called to
stuff "value" into file->private_data without it being initialized.

Fix this by moving the check for a zero-length write up into
ulong_write_file.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/oprofile/oprofilefs.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index e9ff6f7..ee14e6e 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -65,9 +65,6 @@ int oprofilefs_ulong_from_user(unsigned long *val, char const __user *buf, size_
 	char tmpbuf[TMPBUFSIZE];
 	unsigned long flags;
 
-	if (!count)
-		return 0;
-
 	if (count > TMPBUFSIZE - 1)
 		return -EINVAL;
 
@@ -97,6 +94,8 @@ static ssize_t ulong_write_file(struct file *file, char const __user *buf, size_
 
 	if (*offset)
 		return -EINVAL;
+	if (count == 0)
+		return 0;
 
 	retval = oprofilefs_ulong_from_user(&value, buf, count);
 	if (retval)
-- 
1.7.3.1

