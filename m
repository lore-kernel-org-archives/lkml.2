Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2BJOmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:42:16 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:44188
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752986Ab2BJOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:42:15 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ6M64-02-EHE-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] perf tools: Moving code in header.c
Date: Fri, 10 Feb 2012 15:41:55 +0100
Message-ID: <1328884916-5901-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120210143049.GD4998@infradead.org>
References: <20120210143049.GD4998@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for later changes. No modified functionality.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |  300 +++++++++++++++++++++++-----------------------
 1 files changed, 150 insertions(+), 150 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ecd7f4d..0ca4c7c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1305,6 +1305,156 @@ static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
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
@@ -1689,156 +1839,6 @@ int perf_file_header__read(struct perf_file_header *header,
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
-- 
1.7.8


