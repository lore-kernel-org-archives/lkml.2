Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab0KLVm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:42:56 -0500
Received: from kroah.org ([198.145.64.141]:41595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab0KLVlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Pitre <nicolas.pitre@canonical.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/19] vcs: make proper usage of the poll flags
Date: Fri, 12 Nov 2010 13:41:00 -0800
Message-Id: <1289598066-10112-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@canonical.com>

Kay Sievers pointed out that usage of POLLIN is well defined by POSIX,
and the current usage here doesn't follow that definition.  So let's
duplicate the same semantics as implemented by sysfs_poll() instead.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/vt/vc_screen.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 273ab44..eab3a1f 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -553,12 +553,12 @@ static unsigned int
 vcs_poll(struct file *file, poll_table *wait)
 {
 	struct vcs_poll_data *poll = vcs_poll_data_get(file);
-	int ret = 0;
+	int ret = DEFAULT_POLLMASK|POLLERR|POLLPRI;
 
 	if (poll) {
 		poll_wait(file, &poll->waitq, wait);
-		if (!poll->seen_last_update)
-			ret = POLLIN | POLLRDNORM;
+		if (poll->seen_last_update)
+			ret = DEFAULT_POLLMASK;
 	}
 	return ret;
 }
-- 
1.7.1

