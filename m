Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070Ab2KBKK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:10:29 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61185 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab2KBKK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:10:27 -0400
Message-ID: <1351851021.1597.27.camel@x61.thuisdomein>
Subject: [PATCH] xfs: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 02 Nov 2012 11:10:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Nov 2012 10:10:22.0076 (UTC) FILETIME=[44D853C0:01CDB8E2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building xfs_ioctl.o triggers this GCC warning:
    In file included from fs/xfs/xfs_linux.h:49:0,
                     from fs/xfs/xfs.h:27,
                     from fs/xfs/xfs_ioctl.c:18:
    fs/xfs/xfs_ioctl.c: In function ‘xfs_find_handle’:
    include/linux/file.h:37:7: warning: ‘f.file’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    fs/xfs/xfs_ioctl.c:73:13: note: ‘f.file’ was declared here

In this function 'f' and ('f.file') are only used for the
XFS_IOC_FD_TO_HANDLE command. It is clear that 'f.file' is always used
initialized, but there appears to be no easy way to give GCC enough
information to determine that. So let's silence this warning, using the
pattern Ingo Molnar recently suggested.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) I fear that the only way to give GCC the information it needs to do
the flow analysis correctly is to split xfs_find_handle() into three
separate functions, one for each command it handles, and add one or two
helper functions for the code common to all three functions. That seemed
a bit drastic. But perhaps we should try that.

 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8305f2a..5c98ce3 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -70,7 +70,7 @@ xfs_find_handle(
 	int			hsize;
 	xfs_handle_t		handle;
 	struct inode		*inode;
-	struct fd		f;
+	struct fd		f = { }; /* Avoid GCC warning */
 	struct path		path;
 	int			error;
 	struct xfs_inode	*ip;
-- 
1.7.11.7

