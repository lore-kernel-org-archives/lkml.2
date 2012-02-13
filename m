Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2BMTbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:31:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab2BMTa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:30:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com
Cc: vgoyal@redhat.com, psusi@ubuntu.com, psusi@cfl.rr.com,
        maxim.patlasov@gmail.com
Subject: [PATCH 2/2] resizepart: Utility to resize a partition
Date: Mon, 13 Feb 2012 14:30:38 -0500
Message-Id: <1329161438-12602-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple user space utility to resize an existing partition.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 partx/Makefile.am  |    4 ++--
 partx/partx.h      |   19 +++++++++++++++++++
 partx/resizepart.8 |   38 ++++++++++++++++++++++++++++++++++++++
 partx/resizepart.c |   30 ++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 2 deletions(-)
 create mode 100644 partx/resizepart.8
 create mode 100644 partx/resizepart.c

diff --git a/partx/Makefile.am b/partx/Makefile.am
index 080bc47..1f4dbf5 100644
--- a/partx/Makefile.am
+++ b/partx/Makefile.am
@@ -1,7 +1,7 @@
 include $(top_srcdir)/config/include-Makefile.am
 
-usrsbin_exec_PROGRAMS = addpart delpart
-dist_man_MANS = addpart.8 delpart.8
+usrsbin_exec_PROGRAMS = addpart delpart resizepart
+dist_man_MANS = addpart.8 delpart.8 resizepart.8
 
 usrsbin_exec_PROGRAMS += partx
 partx_SOURCES = partx.c partx.h \
diff --git a/partx/partx.h b/partx/partx.h
index b40fa8f..7a509f3 100644
--- a/partx/partx.h
+++ b/partx/partx.h
@@ -41,4 +41,23 @@ static inline int partx_add_partition(int fd, int partno,
 	return ioctl(fd, BLKPG, &a);
 }
 
+static inline int partx_resize_partition(int fd, int partno, unsigned long size)
+{
+	struct blkpg_ioctl_arg a;
+	struct blkpg_partition p;
+
+	p.pno = partno;
+	/* start is unused for resize operation. It can't be changed */
+	p.start = 0;
+	p.length = size << 9;
+	p.devname[0] = 0;
+	p.volname[0] = 0;
+	a.op = BLKPG_RESIZE_PARTITION;
+	a.flags = 0;
+	a.datalen = sizeof(p);
+	a.data = &p;
+
+	return ioctl(fd, BLKPG, &a);
+}
+
 #endif /*  UTIL_LINUX_PARTX_H */
diff --git a/partx/resizepart.8 b/partx/resizepart.8
new file mode 100644
index 0000000..0b47e81
--- /dev/null
+++ b/partx/resizepart.8
@@ -0,0 +1,38 @@
+.\" resizepart.8 --
+.\" Copyright 2012 Vivek Goyal <vgoyal@redhat.com>
+.\" Copyright 2012 Red Hat, Inc.
+.\" May be distributed under the GNU General Public License
+.TH RESIZEPART 8 "February 2012" "util-linux" "System Administration"
+.SH NAME
+resizepart \-
+simple wrapper around the "resize partition" ioctl
+.SH SYNOPSIS
+.B resizepart
+.I device partition length
+.SH DESCRIPTION
+.B resizepart
+is a program that informs the Linux kernel of new partition size.
+
+This command doesn't manipulate partitions on hard drive.
+
+.SH PARAMETERS
+.TP
+.I device
+Specify the disk device.
+.TP
+.I partition
+Specify the partition number.
+.TP
+.I length
+Specify the length of the partition (in 512-byte sectors).
+
+.SH SEE ALSO
+.BR addpart (8),
+.BR delpart (8),
+.BR fdisk (8),
+.BR parted (8),
+.BR partprobe (8),
+.BR partx (8)
+.SH AVAILABILITY
+The addpart command is part of the util-linux package and is available from
+ftp://ftp.kernel.org/pub/linux/utils/util-linux/.
diff --git a/partx/resizepart.c b/partx/resizepart.c
new file mode 100644
index 0000000..e230fcd
--- /dev/null
+++ b/partx/resizepart.c
@@ -0,0 +1,30 @@
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
+			"usage: %s diskdevice partitionnr length\n",
+			argv[0]);
+		exit(1);
+	}
+	if ((fd = open(argv[1], O_RDONLY)) < 0) {
+		perror(argv[1]);
+		exit(1);
+	}
+
+	if (partx_resize_partition(fd, atoi(argv[2]),
+				atoll(argv[3]))) {
+		perror("BLKPG");
+		exit(1);
+	}
+
+	return 0;
+}
-- 
1.7.6.4

