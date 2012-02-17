Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2BQJyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:54:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38736 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2BQJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:54:47 -0500
Date: Fri, 17 Feb 2012 01:53:58 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-08d95bd256277f914e525aeb292da52f15173e7d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1328884916-5901-1-git-send-email-robert.richter@amd.com>
References: <1328884916-5901-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Moving code in header.c
Git-Commit-ID: 08d95bd256277f914e525aeb292da52f15173e7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:54:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08d95bd256277f914e525aeb292da52f15173e7d
Gitweb:     http://git.kernel.org/tip/08d95bd256277f914e525aeb292da52f15173e7d
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 10 Feb 2012 15:41:55 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:32:32 -0200

perf tools: Moving code in header.c

Needed for later changes. No modified functionality.

Cc: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/1328884916-5901-1-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |  300 +++++++++++++++++++++++-----------------------
 1 files changed, 150 insertions(+), 150 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6f4187d..5bb2d75 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1316,6 +1316,156 @@ static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
 	free(str);
 }
 
+static int __event_process_build_id(struct build_id_event *bev,
+				    char *filename,
+				    struct perf_session *session)
+{
+	int err = -1;
+	struct list_head *head;
+	struct machine *machine;
+	u16 misc;
+	struct dso *dso;
+	enum dso_kernel_type dso_type;
+
+	machine = perf_session__findnew_machine(session, bev->pid);
+	if (!machine)
+		goto out;
+
+	misc = bev->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	switch (misc) {
+	case PERF_RECORD_MISC_KERNEL:
+		dso_type = DSO_TYPE_KERNEL;
+		head = &machine->kernel_dsos;
+		break;
+	case PERF_RECORD_MISC_GUEST_KERNEL:
+		dso_type = DSO_TYPE_GUEST_KERNEL;
+		head = &machine->kernel_dsos;
+		break;
+	case PERF_RECORD_MISC_USER:
+	case PERF_RECORD_MISC_GUEST_USER:
+		dso_type = DSO_TYPE_USER;
+		head = &machine->user_dsos;
+		break;
+	default:
+		goto out;
+	}
+
+	dso = __dsos__findnew(head, filename);
+	if (dso != NULL) {
+		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+		dso__set_build_id(dso, &bev->build_id);
+
+		if (filename[0] == '[')
+			dso->kernel = dso_type;
+
+		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
+				  sbuild_id);
+		pr_debug("build id event received for %s: %s\n",
+			 dso->long_name, sbuild_id);
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
+static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
+						 int input, u64 offset, u64 size)
+{
+	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct {
+		struct perf_event_header   header;
+		u8			   build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+		char			   filename[0];
+	} old_bev;
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	u64 limit = offset + size;
+
+	while (offset < limit) {
+		ssize_t len;
+
+		if (read(input, &old_bev, sizeof(old_bev)) != sizeof(old_bev))
+			return -1;
+
+		if (header->needs_swap)
+			perf_event_header__bswap(&old_bev.header);
+
+		len = old_bev.header.size - sizeof(old_bev);
+		if (read(input, filename, len) != len)
+			return -1;
+
+		bev.header = old_bev.header;
+
+		/*
+		 * As the pid is the missing value, we need to fill
+		 * it properly. The header.misc value give us nice hint.
+		 */
+		bev.pid	= HOST_KERNEL_ID;
+		if (bev.header.misc == PERF_RECORD_MISC_GUEST_USER ||
+		    bev.header.misc == PERF_RECORD_MISC_GUEST_KERNEL)
+			bev.pid	= DEFAULT_GUEST_KERNEL_ID;
+
+		memcpy(bev.build_id, old_bev.build_id, sizeof(bev.build_id));
+		__event_process_build_id(&bev, filename, session);
+
+		offset += bev.header.size;
+	}
+
+	return 0;
+}
+
+static int perf_header__read_build_ids(struct perf_header *header,
+				       int input, u64 offset, u64 size)
+{
+	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	u64 limit = offset + size, orig_offset = offset;
+	int err = -1;
+
+	while (offset < limit) {
+		ssize_t len;
+
+		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
+			goto out;
+
+		if (header->needs_swap)
+			perf_event_header__bswap(&bev.header);
+
+		len = bev.header.size - sizeof(bev);
+		if (read(input, filename, len) != len)
+			goto out;
+		/*
+		 * The a1645ce1 changeset:
+		 *
+		 * "perf: 'perf kvm' tool for monitoring guest performance from host"
+		 *
+		 * Added a field to struct build_id_event that broke the file
+		 * format.
+		 *
+		 * Since the kernel build-id is the first entry, process the
+		 * table using the old format if the well known
+		 * '[kernel.kallsyms]' string for the kernel build-id has the
+		 * first 4 characters chopped off (where the pid_t sits).
+		 */
+		if (memcmp(filename, "nel.kallsyms]", 13) == 0) {
+			if (lseek(input, orig_offset, SEEK_SET) == (off_t)-1)
+				return -1;
+			return perf_header__read_build_ids_abi_quirk(header, input, offset, size);
+		}
+
+		__event_process_build_id(&bev, filename, session);
+
+		offset += bev.header.size;
+	}
+	err = 0;
+out:
+	return err;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1735,156 +1885,6 @@ int perf_file_header__read(struct perf_file_header *header,
 	return 0;
 }
 
-static int __event_process_build_id(struct build_id_event *bev,
-				    char *filename,
-				    struct perf_session *session)
-{
-	int err = -1;
-	struct list_head *head;
-	struct machine *machine;
-	u16 misc;
-	struct dso *dso;
-	enum dso_kernel_type dso_type;
-
-	machine = perf_session__findnew_machine(session, bev->pid);
-	if (!machine)
-		goto out;
-
-	misc = bev->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	switch (misc) {
-	case PERF_RECORD_MISC_KERNEL:
-		dso_type = DSO_TYPE_KERNEL;
-		head = &machine->kernel_dsos;
-		break;
-	case PERF_RECORD_MISC_GUEST_KERNEL:
-		dso_type = DSO_TYPE_GUEST_KERNEL;
-		head = &machine->kernel_dsos;
-		break;
-	case PERF_RECORD_MISC_USER:
-	case PERF_RECORD_MISC_GUEST_USER:
-		dso_type = DSO_TYPE_USER;
-		head = &machine->user_dsos;
-		break;
-	default:
-		goto out;
-	}
-
-	dso = __dsos__findnew(head, filename);
-	if (dso != NULL) {
-		char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-		dso__set_build_id(dso, &bev->build_id);
-
-		if (filename[0] == '[')
-			dso->kernel = dso_type;
-
-		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
-				  sbuild_id);
-		pr_debug("build id event received for %s: %s\n",
-			 dso->long_name, sbuild_id);
-	}
-
-	err = 0;
-out:
-	return err;
-}
-
-static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
-						 int input, u64 offset, u64 size)
-{
-	struct perf_session *session = container_of(header, struct perf_session, header);
-	struct {
-		struct perf_event_header   header;
-		u8			   build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
-		char			   filename[0];
-	} old_bev;
-	struct build_id_event bev;
-	char filename[PATH_MAX];
-	u64 limit = offset + size;
-
-	while (offset < limit) {
-		ssize_t len;
-
-		if (read(input, &old_bev, sizeof(old_bev)) != sizeof(old_bev))
-			return -1;
-
-		if (header->needs_swap)
-			perf_event_header__bswap(&old_bev.header);
-
-		len = old_bev.header.size - sizeof(old_bev);
-		if (read(input, filename, len) != len)
-			return -1;
-
-		bev.header = old_bev.header;
-
-		/*
-		 * As the pid is the missing value, we need to fill
-		 * it properly. The header.misc value give us nice hint.
-		 */
-		bev.pid	= HOST_KERNEL_ID;
-		if (bev.header.misc == PERF_RECORD_MISC_GUEST_USER ||
-		    bev.header.misc == PERF_RECORD_MISC_GUEST_KERNEL)
-			bev.pid	= DEFAULT_GUEST_KERNEL_ID;
-
-		memcpy(bev.build_id, old_bev.build_id, sizeof(bev.build_id));
-		__event_process_build_id(&bev, filename, session);
-
-		offset += bev.header.size;
-	}
-
-	return 0;
-}
-
-static int perf_header__read_build_ids(struct perf_header *header,
-				       int input, u64 offset, u64 size)
-{
-	struct perf_session *session = container_of(header, struct perf_session, header);
-	struct build_id_event bev;
-	char filename[PATH_MAX];
-	u64 limit = offset + size, orig_offset = offset;
-	int err = -1;
-
-	while (offset < limit) {
-		ssize_t len;
-
-		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
-			goto out;
-
-		if (header->needs_swap)
-			perf_event_header__bswap(&bev.header);
-
-		len = bev.header.size - sizeof(bev);
-		if (read(input, filename, len) != len)
-			goto out;
-		/*
-		 * The a1645ce1 changeset:
-		 *
-		 * "perf: 'perf kvm' tool for monitoring guest performance from host"
-		 *
-		 * Added a field to struct build_id_event that broke the file
-		 * format.
-		 *
-		 * Since the kernel build-id is the first entry, process the
-		 * table using the old format if the well known
-		 * '[kernel.kallsyms]' string for the kernel build-id has the
-		 * first 4 characters chopped off (where the pid_t sits).
-		 */
-		if (memcmp(filename, "nel.kallsyms]", 13) == 0) {
-			if (lseek(input, orig_offset, SEEK_SET) == (off_t)-1)
-				return -1;
-			return perf_header__read_build_ids_abi_quirk(header, input, offset, size);
-		}
-
-		__event_process_build_id(&bev, filename, session);
-
-		offset += bev.header.size;
-	}
-	err = 0;
-out:
-	return err;
-}
-
 static int perf_file_section__process(struct perf_file_section *section,
 				      struct perf_header *ph,
 				      int feat, int fd, void *data __used)
