Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab2IEJV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:21:29 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40402 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758388Ab2IEJVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:21:25 -0400
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 1/2] btrfs-progs: Close file descriptor on exit
Date: Wed,  5 Sep 2012 17:21:06 +0800
Message-Id: <1346836867-1060-2-git-send-email-wuzhy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
References: <1346836867-1060-1-git-send-email-wuzhy@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090509-8974-0000-0000-00000D1E0ED7
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00171462; UDB=6.00038889; UTC=2012-09-05
 09:21:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Need to close fd on exit.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 cmds-filesystem.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1457de..e62c4fd 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -77,18 +77,23 @@ static int cmd_df(int argc, char **argv)
 	if (ret) {
 		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
 			path, strerror(e));
+		close(fd);
 		free(sargs);
 		return ret;
 	}
-	if (!sargs->total_spaces)
+	if (!sargs->total_spaces) {
+		close(fd);
 		return 0;
+	}
 
 	count = sargs->total_spaces;
 
 	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
 			(count * sizeof(struct btrfs_ioctl_space_info)));
-	if (!sargs)
+	if (!sargs) {
+		close(fd);
 		return -ENOMEM;
+	}
 
 	sargs->space_slots = count;
 	sargs->total_spaces = 0;
@@ -148,6 +153,7 @@ static int cmd_df(int argc, char **argv)
 		printf("%s: total=%s, used=%s\n", description, total_bytes,
 		       used_bytes);
 	}
+	close(fd);
 	free(sargs);
 
 	return 0;
-- 
1.7.6.5

