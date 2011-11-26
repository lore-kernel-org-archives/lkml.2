Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1KZRbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:31:25 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63341 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1KZRbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:31:22 -0500
Date: Sat, 26 Nov 2011 18:31:14 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org
Cc: federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: [RFC PATCH 6/7] drivers/zio: add user-space tool zio-dump
Message-ID: <eaf3fd1679de3fc2f892578fd63372c55a657cf1.1322328076.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1322328073.git.rubini@gnudd.com>
In-Reply-To: <cover.1322328073.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of zio-dump is described in the README.
The files match commit 7d37663 in git://ohwr.org/misc/zio.git .

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Samuel Iglesias Gonsalvez <siglesia@cern.ch>
Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/zio/zio-dump.c |  196 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 drivers/zio/zio-dump.c

diff --git a/drivers/zio/zio-dump.c b/drivers/zio/zio-dump.c
new file mode 100644
index 0000000..e6f2149
--- /dev/null
+++ b/drivers/zio/zio-dump.c
@@ -0,0 +1,196 @@
+/*
+ * Trivial utility that reports data from ZIO input channels
+ */
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/select.h>
+
+#include <linux/zio.h>
+#include <linux/zio-buffer.h>
+
+unsigned char buf[1024*1024];
+char *prgname;
+
+void read_channel(int cfd, int dfd, FILE *log)
+{
+	int err = 0;
+	struct zio_control ctrl;
+	int i, j;
+
+	i = read(cfd, &ctrl, sizeof(ctrl));
+	switch (i) {
+	case -1:
+		fprintf(stderr, "%s: control read: %s\n",
+			prgname, strerror(errno));
+		exit(1);
+	case 0:
+		fprintf(stderr, "%s: control read: unexpected EOF\n",
+			prgname);
+		exit(1);
+	default:
+		fprintf(stderr, "%s: ctrl read: %i bytes (expected %i)\n",
+			prgname, i, sizeof(ctrl));
+		/* continue anyways */
+	case sizeof(ctrl):
+		break; /* ok */
+	}
+
+	/* Fail badly if the version is not the right one */
+	if (ctrl.major_version != ZIO_MAJOR_VERSION)
+		err++;
+	if (ZIO_MAJOR_VERSION == 0 && ctrl.minor_version != ZIO_MINOR_VERSION)
+		err++;
+	if (err) {
+		fprintf(stderr, "%s: kernel has zio %i.%i, "
+			"but I'm compiled for %i.%i\n", prgname,
+			ctrl.major_version, ctrl.minor_version,
+			ZIO_MAJOR_VERSION, ZIO_MINOR_VERSION);
+		exit(1);
+	}
+	if (ctrl.minor_version != ZIO_MINOR_VERSION) {
+		static int warned;
+
+		if (!warned++)
+			fprintf(stderr, "%s: warning: minor version mismatch\n",
+				prgname);
+	}
+
+	printf("Ctrl: version %i.%i, trigger %.16s, dev %.16s, "
+	       "cset %i, chan %i\n",
+	       ctrl.major_version, ctrl.minor_version,
+	       ctrl.triggername, ctrl.devname, ctrl.cset_i,
+	       ctrl.chan_i);
+	printf("Ctrl: seq %i, n %i, size %i, bits %i, "
+	       "flags %08x (%s)\n",
+	       ctrl.seq_num,
+	       ctrl.nsamples,
+	       ctrl.ssize,
+	       ctrl.sbits,
+	       ctrl.flags,
+	       ctrl.flags & ZIO_CONTROL_LITTLE_ENDIAN
+	       ? "little-endian" :
+	       ctrl.flags & ZIO_CONTROL_BIG_ENDIAN
+	       ? "big-endian" : "unknown-endian");
+	printf("Ctrl: stamp %lli.%09lli (%lli)\n",
+	       (long long)ctrl.tstamp.secs,
+	       (long long)ctrl.tstamp.ticks,
+	       (long long)ctrl.tstamp.bins);
+	/* FIXME: some control information is missing */
+
+	i = read(dfd, buf, sizeof(buf));
+	if (i < 0) {
+		fprintf(stderr, "%s: data read: %s\n",
+			prgname, strerror(errno));
+		return; /* next ctrl, let's see... */
+	}
+	if (!i) {
+		fprintf(stderr, "%s: data read: unexpected EOF\n", prgname);
+		return;
+	}
+	if (i != ctrl.nsamples * ctrl.ssize) {
+		if (i == sizeof(buf)) {
+			fprintf(stderr, "%s: buffer too small: "
+				"please fix me and recompile\n", prgname);
+			/* FIXME: empty the data channel */
+		} else {
+			fprintf(stderr, "%s: ctrl: read %i bytes "
+				"(exp %i)\n", prgname, i,
+				ctrl.nsamples * ctrl.ssize);
+		}
+		/* continue anyways */
+	}
+	fwrite(buf, 1, i, log);
+
+	/* report data to stdout */
+	for (j = 0; j < i; j++) {
+		if (!(j & 0xf))
+			printf("Data:");
+		printf(" %02x", buf[j]);
+		if ((j & 0xf) == 0xf || j == i - 1)
+			putchar('\n');
+	}
+	putchar('\n');
+}
+
+int main(int argc, char **argv)
+{
+	FILE *f;
+	char *outfname;
+	int *cfd; /* control file descriptors */
+	int *dfd; /* data file descriptors */
+	fd_set control_set, ready_set;
+	int i, j, maxfd, ndev;
+
+	if (argc < 3 || (argc & 1) != 1) {
+		fprintf(stderr, "%s: Wrong number of arguments\n"
+			"Use: \"%s <ctrl-file> <data-file> [...]\"\n",
+			argv[0], argv[0]);
+		exit(1);
+	}
+	prgname = argv[0];
+	cfd = malloc(argc / 2 * sizeof(*cfd));
+	dfd = malloc(argc / 2 * sizeof(*dfd));
+	if (!cfd || !dfd) {
+		fprintf(stderr, "%s: malloc: %s\n", prgname, strerror(errno));
+		exit(1);
+	}
+
+	/* Open all pairs, and build the fd_set for later select() */
+	FD_ZERO(&control_set);
+	for (i = 1, j = 0; i < argc; i += 2, j++) {
+		cfd[j] = open(argv[i], O_RDONLY);
+		dfd[j] = open(argv[i + 1], O_RDONLY);
+		if (cfd[j] < 0) {
+			fprintf(stderr, "%s: %s: %s\n", prgname, argv[i],
+				strerror(errno));
+			exit(1);
+		}
+		if (dfd[j] < 0) {
+			fprintf(stderr, "%s: %s: %s\n", prgname, argv[i + 1],
+				strerror(errno));
+			exit(1);
+		}
+		/* ctrl file is used in select, data file is non-blocking */
+		FD_SET(cfd[j], &control_set);
+		fcntl(dfd[j], F_SETFL, fcntl(dfd[j], F_GETFL) | O_NONBLOCK);
+		maxfd = dfd[j];
+	}
+	ndev = j;
+
+	/* always log data we read to some filename */
+	outfname = getenv("ZIO_DUMP_TO");
+	if (!outfname)
+		outfname = "/dev/null";
+	f = fopen(outfname, "w");
+	if (!f) {
+		fprintf(stderr, "%s: %s: %s\n", prgname, outfname,
+			strerror(errno));
+		exit(1);
+	}
+	/* ensure proper strace information and output to pipes */
+	setlinebuf(stdout);
+	setbuf(f, NULL);
+
+	/* now read control and then data, forever */
+	while (1) {
+		ready_set = control_set;
+		i = select(maxfd + 1, &ready_set, NULL, NULL, NULL);
+		if (i < 0 && errno == EINTR)
+			continue;
+		if (i < 0) {
+			fprintf(stderr, "%s: select(): %s\n", prgname,
+				strerror(errno));
+			exit(1);
+		}
+		for (j = 0; j < ndev; j++)
+			if (FD_ISSET(cfd[j], &ready_set))
+				read_channel(cfd[j], dfd[j], f);
+	}
+}
-- 
1.7.7.2
