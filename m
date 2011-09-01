Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1IAVzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab1IAVzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:55:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, dm-devel@redhat.com
Cc: kzak@redhat.com, vgoyal@redhat.com
Subject: [PATCH 1/1] extendpart: A new command line to extend an existing partition
Date: Thu,  1 Sep 2011 17:55:28 -0400
Message-Id: <1314914128-3171-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1314914128-3171-1-git-send-email-vgoyal@redhat.com>
References: <1314914128-3171-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is along the lines of addpart and delpart to modify in kernel partition
table and does not touch the ondisk data structures.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 partx/Makefile.am  |    2 +-
 partx/extendpart.c |   29 +++++++++++++++++++++++++++++
 partx/partx.h      |   20 ++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletions(-)
 create mode 100644 partx/extendpart.c

diff --git a/partx/Makefile.am b/partx/Makefile.am
index 6a72942..f84126d 100644
--- a/partx/Makefile.am
+++ b/partx/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/config/include-Makefile.am
 
-usrsbin_exec_PROGRAMS = addpart delpart
+usrsbin_exec_PROGRAMS = addpart delpart extendpart
 dist_man_MANS = addpart.8 delpart.8
 
 usrsbin_exec_PROGRAMS += partx
diff --git a/partx/extendpart.c b/partx/extendpart.c
new file mode 100644
index 0000000..a9577c2
--- /dev/null
+++ b/partx/extendpart.c
@@ -0,0 +1,29 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+
+#include "partx.h"
+
+int
+main(int argc, char **argv)
+{
+	int fd;
+
+	if (argc != 4) {
+		fprintf(stderr,
+			"usage: %s diskdevice partitionnr size\n",
+			argv[0]);
+		exit(1);
+	}
+	if ((fd = open(argv[1], O_RDONLY)) < 0) {
+		perror(argv[1]);
+		exit(1);
+	}
+
+	if (partx_extend_partition(fd, atoi(argv[2]), atoll(argv[3]))) {
+		perror("BLKPG");
+		exit(1);
+	}
+
+	return 0;
+}
diff --git a/partx/partx.h b/partx/partx.h
index b40fa8f..1acbff9 100644
--- a/partx/partx.h
+++ b/partx/partx.h
@@ -41,4 +41,24 @@ static inline int partx_add_partition(int fd, int partno,
 	return ioctl(fd, BLKPG, &a);
 }
 
+static inline int partx_extend_partition(int fd, int partno,
+				unsigned long size)
+{
+	struct blkpg_ioctl_arg a;
+	struct blkpg_partition p;
+
+	p.pno = partno;
+	/* p.start is unused for extend operation */
+	p.start = 0;
+	p.length = size << 9;
+	p.devname[0] = 0;
+	p.volname[0] = 0;
+	a.op = BLKPG_EXTEND_PARTITION;
+	a.flags = 0;
+	a.datalen = sizeof(p);
+	a.data = &p;
+
+	return ioctl(fd, BLKPG, &a);
+}
+
 #endif /*  UTIL_LINUX_PARTX_H */
-- 
1.7.6

