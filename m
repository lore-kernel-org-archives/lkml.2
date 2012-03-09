Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2CINbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:31:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2CINbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:31:09 -0500
Date: Fri, 9 Mar 2012 05:30:52 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-69996df486fc3921bbaaa17fca0d68f537f9eabf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-17-git-send-email-eranian@google.com>
References: <1328826068-11713-17-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf tools: Enable reading of perf.
 data files from different ABI rev
Git-Commit-ID: 69996df486fc3921bbaaa17fca0d68f537f9eabf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:30:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69996df486fc3921bbaaa17fca0d68f537f9eabf
Gitweb:     http://git.kernel.org/tip/69996df486fc3921bbaaa17fca0d68f537f9eabf
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:21:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:06 +0100

perf tools: Enable reading of perf.data files from different ABI rev

This patch allows perf to process perf.data files generated
using an ABI that has a different perf_event_attr struct size,
i.e., a different ABI version.

The perf_event_attr can be extended, yet perf needs to cope with
older perf.data files. Similarly, perf must be able to cope with
a perf.data file which is using a newer version of the ABI than
what it knows about.

This patch adds read_attr(), a routine that reads a
perf_event_attr struct from a file incrementally based on its
advertised size. If the on-file struct is smaller than what perf
knows, then the extra fields are zeroed. If the on-file struct
is bigger, then perf only uses what it knows about, the rest is
skipped.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: robert.richter@amd.com
Cc: ming.m.lin@intel.com
Cc: andi@firstfloor.org
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1328826068-11713-17-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c  |   53 ++++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/session.c |    4 +-
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9f867d9..666f189 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1973,6 +1973,51 @@ static int perf_header__read_pipe(struct perf_session *session, int fd)
 	return 0;
 }
 
+static int read_attr(int fd, struct perf_header *ph,
+		     struct perf_file_attr *f_attr)
+{
+	struct perf_event_attr *attr = &f_attr->attr;
+	size_t sz, left;
+	size_t our_sz = sizeof(f_attr->attr);
+	int ret;
+
+	memset(f_attr, 0, sizeof(*f_attr));
+
+	/* read minimal guaranteed structure */
+	ret = readn(fd, attr, PERF_ATTR_SIZE_VER0);
+	if (ret <= 0) {
+		pr_debug("cannot read %d bytes of header attr\n",
+			 PERF_ATTR_SIZE_VER0);
+		return -1;
+	}
+
+	/* on file perf_event_attr size */
+	sz = attr->size;
+	if (ph->needs_swap)
+		sz = bswap_32(sz);
+
+	if (sz == 0) {
+		/* assume ABI0 */
+		sz =  PERF_ATTR_SIZE_VER0;
+	} else if (sz > our_sz) {
+		pr_debug("file uses a more recent and unsupported ABI"
+			 " (%zu bytes extra)\n", sz - our_sz);
+		return -1;
+	}
+	/* what we have not yet read and that we know about */
+	left = sz - PERF_ATTR_SIZE_VER0;
+	if (left) {
+		void *ptr = attr;
+		ptr += PERF_ATTR_SIZE_VER0;
+
+		ret = readn(fd, ptr, left);
+	}
+	/* read perf_file_section, ids are read in caller */
+	ret = readn(fd, &f_attr->ids, sizeof(f_attr->ids));
+
+	return ret <= 0 ? -1 : 0;
+}
+
 int perf_session__read_header(struct perf_session *session, int fd)
 {
 	struct perf_header *header = &session->header;
@@ -1988,19 +2033,17 @@ int perf_session__read_header(struct perf_session *session, int fd)
 	if (session->fd_pipe)
 		return perf_header__read_pipe(session, fd);
 
-	if (perf_file_header__read(&f_header, header, fd) < 0) {
-		pr_debug("incompatible file format\n");
+	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
-	}
 
-	nr_attrs = f_header.attrs.size / sizeof(f_attr);
+	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
 	for (i = 0; i < nr_attrs; i++) {
 		struct perf_evsel *evsel;
 		off_t tmp;
 
-		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
+		if (read_attr(fd, header, &f_attr) < 0)
 			goto out_errno;
 
 		if (header->needs_swap)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bec8a32..e650de8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -24,7 +24,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 		self->fd = STDIN_FILENO;
 
 		if (perf_session__read_header(self, self->fd) < 0)
-			pr_err("incompatible file format");
+			pr_err("incompatible file format (rerun with -v to learn more)");
 
 		return 0;
 	}
@@ -56,7 +56,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 	}
 
 	if (perf_session__read_header(self, self->fd) < 0) {
-		pr_err("incompatible file format");
+		pr_err("incompatible file format (rerun with -v to learn more)");
 		goto out_close;
 	}
 
