Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab2GIVjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab2GIVgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:36:10 -0400
Message-Id: <20120709213559.918409313@redhat.com>
User-Agent: quilt/0.48-1
Date: Mon, 09 Jul 2012 17:34:20 -0400
From: vgoyal@redhat.com
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com
Cc: psusi@ubuntu.com, vgoyal@redhat.comi, maxim.patlasov@gmail.com
Subject: [patch 2/2] util-linux: resizepart: Utility to resize a partition
References: <20120709213418.799759100@redhat.com>
Content-Disposition: inline; filename=0001-util-linux-resizepart-Utility-to-resize-a-partition.patch
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
 disk-utils/Makemodule.am |    7 +++-
 disk-utils/partx.h       |   19 +++++++++
 disk-utils/resizepart.8  |   38 ++++++++++++++++++
 disk-utils/resizepart.c  |   98 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+), 1 deletions(-)
 create mode 100644 disk-utils/resizepart.8
 create mode 100644 disk-utils/resizepart.c

diff --git a/disk-utils/Makemodule.am b/disk-utils/Makemodule.am
index 830e8f7..b544e87 100644
--- a/disk-utils/Makemodule.am
+++ b/disk-utils/Makemodule.am
@@ -113,7 +113,7 @@ endif # LINUX
 
 
 if BUILD_PARTX
-usrsbin_exec_PROGRAMS += partx addpart delpart
+usrsbin_exec_PROGRAMS += partx addpart delpart resizepart
 dist_man_MANS += \
 	disk-utils/addpart.8 \
 	disk-utils/delpart.8 \
@@ -130,6 +130,11 @@ delpart_SOURCES = \
 	disk-utils/partx.h
 delpart_LDADD = $(LDADD) libcommon.la
 
+resizepart_SOURCES = \
+	disk-utils/resizepart.c \
+	disk-utils/partx.h
+resizepart_LDADD = $(LDADD) libcommon.la
+
 partx_SOURCES = \
 	disk-utils/partx.c \
 	disk-utils/partx.h
diff --git a/disk-utils/partx.h b/disk-utils/partx.h
index ed0fd0a..02e273e 100644
--- a/disk-utils/partx.h
+++ b/disk-utils/partx.h
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
diff --git a/disk-utils/resizepart.8 b/disk-utils/resizepart.8
new file mode 100644
index 0000000..c009cc3
--- /dev/null
+++ b/disk-utils/resizepart.8
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
+The resizepart command is part of the util-linux package and is available from
+ftp://ftp.kernel.org/pub/linux/utils/util-linux/.
diff --git a/disk-utils/resizepart.c b/disk-utils/resizepart.c
new file mode 100644
index 0000000..4f9e9ce
--- /dev/null
+++ b/disk-utils/resizepart.c
@@ -0,0 +1,98 @@
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
+	if (sysfs_init(&cxt, devno, NULL)) {
+		fprintf(stderr, "failed to initialize sysfs. \n");
+		exit(1);
+	}
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
1.7.7.6


