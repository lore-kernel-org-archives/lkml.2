Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab1FWSSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:18:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:34284 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab1FWRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Kashyap, Desai" <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 091/247] mptfusion: mptctl_release is required in mptctl.c
Date: Thu, 23 Jun 2011 13:32:39 -0400
Message-Id: <1308850515-15242-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kashyap, Desai <kashyap.desai@lsi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 84857c8bf83e8aa87afc57d2956ba01f11d82386 upstream.

Added missing release callback for file_operations mptctl_fops.
Without release callback there will be never freed. It remains on
mptctl's eent list even after the file is closed and released.

Relavent RHEL bugzilla is 660871

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/message/fusion/mptctl.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index caa8f56..4e12556 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -577,6 +577,13 @@ mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 }
 
 static int
+mptctl_release(struct inode *inode, struct file *filep)
+{
+	fasync_helper(-1, filep, 0, &async_queue);
+	return 0;
+}
+
+static int
 mptctl_fasync(int fd, struct file *filep, int mode)
 {
 	MPT_ADAPTER	*ioc;
@@ -2778,6 +2785,7 @@ static const struct file_operations mptctl_fops = {
 	.llseek =	no_llseek,
 	.fasync = 	mptctl_fasync,
 	.unlocked_ioctl = mptctl_ioctl,
+	.release =	mptctl_release,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_mpctl_ioctl,
 #endif
-- 
1.7.4.4

