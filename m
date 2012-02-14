Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042Ab2BNUkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:40:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259Ab2BNUkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:40:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com
Cc: vgoyal@redhat.com, psusi@ubuntu.com, psusi@cfl.rr.com,
        maxim.patlasov@gmail.com
Subject: [PATCH 2/2] util-linux: resizepart: Utility to resize a partition
Date: Tue, 14 Feb 2012 15:39:51 -0500
Message-Id: <1329251991-22468-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1329251991-22468-1-git-send-email-vgoyal@redhat.com>
References: <1329251991-22468-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple user space utility to resize an existing partition. It tries to read
the start of partiton from sysfs.

This is a real quick dirty patch I used for my testing. I am sure there
are better and faster ways of getting to partition "start" from device
and partition number.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 partx/Makefile.am  |    9 ++++-
 partx/partx.h      |   19 ++++++++++
 partx/resizepart.8 |   38 +++++++++++++++++++++
 partx/resizepart.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 159 insertions(+), 2 deletions(-)
 create mode 100644 partx/resizepart.8
 create mode 100644 partx/resizepart.c

diff --git a/partx/Makefile.am b/partx/Makefile.am
index 080bc47..72b605c 100644
--- a/partx/Makefile.am
+++ b/partx/Makefile.am
@@ -1,7 +1,12 @@
 include $(top_srcdir)/config/include-Makefile.am
 
-usrsbin_exec_PROGRAMS = addpart delpart
-dist_man_MANS = addpart.8 delpart.8
+usrsbin_exec_PROGRAMS = addpart delpart resizepart
+dist_man_MANS = addpart.8 delpart.8 resizepart.8
+
+resizepart_SOURCES = resizepart.c \
+		$(top_srcdir)/lib/sysfs.c \
+		$(top_srcdir)/lib/canonicalize.c \
+		$(top_srcdir)/lib/at.c
 
 usrsbin_exec_PROGRAMS += partx
 partx_SOURCES = partx.c partx.h \
diff --git a/partx/partx.h b/partx/partx.h
index b40fa8f..c2b87f0 100644
--- a/partx/partx.h
+++ b/partx/partx.h
@@ -41,4 +41,23 @@ static inline int partx_add_partition(int fd, int partno,
 	return ioctl(fd, BLKPG, &a);
 }
 
+static inline int partx_resize_partition(int fd, int partno,
+			long long start, long long size)
+{
+	struct blkpg_ioctl_arg a;
+	struct blkpg_partition p;
+
+	p.pno = partno;
+	p.start = start << 9;
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
index 0000000..64dcfdb
--- /dev/null
+++ b/partx/resizepart.c
@@ -0,0 +1,95 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <ctype.h>
+#include "canonicalize.h"
+#include "sysfs.h"
+#include "partx.h"
+
+char *
+get_devname_from_canonical_path(char *path)
+{
+	struct sysfs_cxt cxt;
+	dev_t devno;
+	char name[PATH_MAX];
+	char *devname;
+
+	devno = sysfs_devname_to_devno(path, NULL);
+	if (!devno) {
+		fprintf(stderr, "failed to read devno. \n");
+		exit(1);
+	}
+
+	sysfs_init(&cxt, devno, NULL);
+	devname = sysfs_get_devname(&cxt, name, sizeof(name));
+	return strdup(devname);
+}
+
+char *
+get_partname_from_devname(char *devname, int partno)
+{
+	char partname[PATH_MAX];
+
+	if (isdigit(devname[strlen(devname) - 1]))
+		snprintf(partname, PATH_MAX, "%sp%d", devname, partno);
+	else
+		snprintf(partname, PATH_MAX, "%s%d", devname, partno);
+
+	return strdup(partname);
+}
+
+
+int
+main(int argc, char **argv)
+{
+	int fd;
+	char *real_path, *devname, *partname, *pstart;
+	char part_sysfs_path[PATH_MAX], part_start[30];
+	FILE *fp;
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
+	real_path = canonicalize_path(argv[1]);
+
+	if (real_path == NULL) {
+		fprintf(stderr, "canonicalize_path(%s) failed. \n", argv[1]);
+		exit(1);
+	}
+
+	devname = get_devname_from_canonical_path(real_path);
+	partname = get_partname_from_devname(devname, atoi(argv[2]));
+
+	snprintf(part_sysfs_path, PATH_MAX, "/sys/block/%s/%s/start",
+			devname, partname);
+
+	fp = fopen(part_sysfs_path, "r");
+
+	if (!fp) {
+		perror("BLKPG");
+		exit(1);
+	}
+
+	pstart = fgets(part_start, 30, fp);
+
+	if (!pstart) {
+		perror("BLKPG");
+		exit(1);
+	}
+
+	if (partx_resize_partition(fd, atoi(argv[2]), atoll(pstart),
+				atoll(argv[3]))) {
+		perror("BLKPG");
+		exit(1);
+	}
+
+	return 0;
+}
-- 
1.7.6.4

