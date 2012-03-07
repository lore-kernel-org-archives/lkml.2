Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030618Ab2CGV7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:59:37 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47719 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030491Ab2CGV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Nick Kralevich <nnk@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 13/13] android: ram_console: honor dmesg_restrict
Date: Wed,  7 Mar 2012 13:58:23 -0800
Message-Id: <1331157503-3413-14-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-3270-0000-0000-0000049FA000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Kralevich <nnk@google.com>

The Linux kernel has a setting called dmesg_restrict. When true,
only processes with CAP_SYSLOG can view the kernel dmesg logs. This
helps prevent leaking of kernel information into user space.

On Android, it's possible to bypass these restrictions by viewing
/proc/last_kmsg.

This change makes /proc/last_kmsg require the same permissions as
dmesg.

Bug: 5555691
CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: I50ecb74012ef2ac0a3cff7325192634341fddae9
Signed-off-by: Nick Kralevich <nnk@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ram_console.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index d956b84..b242be2 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -99,6 +99,9 @@ static ssize_t ram_console_read_old(struct file *file, char __user *buf,
 	char *str;
 	int ret;
 
+	if (dmesg_restrict && !capable(CAP_SYSLOG))
+		return -EPERM;
+
 	/* Main last_kmsg log */
 	if (pos < old_log_size) {
 		count = min(len, (size_t)(old_log_size - pos));
-- 
1.7.3.2.146.gca209

