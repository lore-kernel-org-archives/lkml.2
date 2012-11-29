Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2K2Gom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:44:42 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44879 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2K2GjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:07 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-b5-50b703080c86
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 04/18] perf header: Add HEADER_GROUP_DESC feature
Date: Thu, 29 Nov 2012 15:38:32 +0900
Message-Id: <1354171126-14387-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Save group relationship information so that it can be restored when
perf report is running.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |   3 +
 tools/perf/util/header.c    | 153 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |   2 +
 3 files changed, 158 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f3151d3c70ce..d50f0dcfe1c1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -592,6 +592,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
+	if (!evsel_list->nr_groups)
+		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
+
 	/*
 	 * perf_session__delete(session) will be called at perf_record__exit()
 	 */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 195a47a8f052..6ae8185842f2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1073,6 +1073,41 @@ static int write_pmu_mappings(int fd, struct perf_header *h __maybe_unused,
 }
 
 /*
+ * File format:
+ *
+ * struct group_descs {
+ *	u32	nr_groups;
+ *	struct group_desc {
+ *		char	name[];
+ *		u32	leader_idx;
+ *		u32	nr_members;
+ *	}[nr_groups];
+ * };
+ */
+static int write_group_desc(int fd, struct perf_header *h __maybe_unused,
+			    struct perf_evlist *evlist)
+{
+	u32 nr_groups = evlist->nr_groups;
+	struct perf_evsel *evsel;
+
+	do_write(fd, &nr_groups, sizeof(nr_groups));
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (perf_evsel__is_group_leader(evsel) &&
+		    evsel->nr_members > 1) {
+			const char *name = evsel->group_name ?: "{anon_group}";
+			u32 leader_idx = evsel->idx;
+			u32 nr_members = evsel->nr_members;
+
+			do_write_string(fd, name);
+			do_write(fd, &leader_idx, sizeof(leader_idx));
+			do_write(fd, &nr_members, sizeof(nr_members));
+		}
+	}
+	return 0;
+}
+
+/*
  * default get_cpuid(): nothing gets recorded
  * actual implementation must be in arch/$(ARCH)/util/header.c
  */
@@ -1433,6 +1468,31 @@ error:
 	fprintf(fp, "# pmu mappings: unable to read\n");
 }
 
+static void print_group_desc(struct perf_header *ph, int fd __maybe_unused,
+			     FILE *fp)
+{
+	struct perf_session *session;
+	struct perf_evsel *evsel;
+	u32 nr = 0;
+
+	session = container_of(ph, struct perf_session, header);
+
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		if (perf_evsel__is_group_leader(evsel) &&
+		    evsel->nr_members > 1) {
+			fprintf(fp, "# group: %s{%s", evsel->group_name ?: "",
+				perf_evsel__name(evsel));
+
+			nr = evsel->nr_members - 1;
+		} else if (nr) {
+			fprintf(fp, ",%s", perf_evsel__name(evsel));
+
+			if (--nr == 0)
+				fprintf(fp, "}\n");
+		}
+	}
+}
+
 static int __event_process_build_id(struct build_id_event *bev,
 				    char *filename,
 				    struct perf_session *session)
@@ -1947,6 +2007,98 @@ error:
 	return -1;
 }
 
+static int process_group_desc(struct perf_file_section *section __maybe_unused,
+			      struct perf_header *ph, int fd,
+			      void *data __maybe_unused)
+{
+	size_t ret = -1;
+	u32 i, nr, nr_groups;
+	struct perf_session *session;
+	struct perf_evsel *evsel, *leader = NULL;
+	struct group_desc {
+		char *name;
+		u32 leader_idx;
+		u32 nr_members;
+	} *desc;
+
+	if (read(fd, &nr_groups, sizeof(nr_groups)) != sizeof(nr_groups))
+		return -1;
+
+	if (ph->needs_swap)
+		nr_groups = bswap_32(nr_groups);
+
+	ph->env.nr_groups = nr_groups;
+	if (!nr_groups) {
+		pr_debug("group desc not available\n");
+		return 0;
+	}
+
+	desc = calloc(nr_groups, sizeof(*desc));
+	if (!desc)
+		return -1;
+
+	for (i = 0; i < nr_groups; i++) {
+		desc[i].name = do_read_string(fd, ph);
+		if (!desc[i].name)
+			goto out_free;
+
+		if (read(fd, &desc[i].leader_idx, sizeof(u32)) != sizeof(u32))
+			goto out_free;
+
+		if (read(fd, &desc[i].nr_members, sizeof(u32)) != sizeof(u32))
+			goto out_free;
+
+		if (ph->needs_swap) {
+			desc[i].leader_idx = bswap_32(desc[i].leader_idx);
+			desc[i].nr_members = bswap_32(desc[i].nr_members);
+		}
+	}
+
+	/*
+	 * Rebuild group relationship based on the group_desc
+	 */
+	session = container_of(ph, struct perf_session, header);
+	session->evlist->nr_groups = nr_groups;
+
+	i = nr = 0;
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		if (evsel->idx == (int) desc[i].leader_idx) {
+			evsel->leader = evsel;
+			/* {anon_group} is a dummy name */
+			if (strcmp(desc[i].name, "{anon_group}"))
+				evsel->group_name = desc[i].name;
+			evsel->nr_members = desc[i].nr_members;
+
+			if (i >= nr_groups || nr > 0) {
+				pr_debug("invalid group desc\n");
+				goto out_free;
+			}
+
+			leader = evsel;
+			nr = evsel->nr_members - 1;
+			i++;
+		} else if (nr) {
+			/* This is a group member */
+			evsel->leader = leader;
+
+			nr--;
+		}
+	}
+
+	if (i != nr_groups || nr != 0) {
+		pr_debug("invalid group desc\n");
+		goto out_free;
+	}
+
+	ret = 0;
+out_free:
+	while ((int) --i >= 0)
+		free(desc[i].name);
+	free(desc);
+
+	return ret;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1986,6 +2138,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
+	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 5f1cd6884f37..e3e7fb490310 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -29,6 +29,7 @@ enum {
 	HEADER_NUMA_TOPOLOGY,
 	HEADER_BRANCH_STACK,
 	HEADER_PMU_MAPPINGS,
+	HEADER_GROUP_DESC,
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
 };
@@ -79,6 +80,7 @@ struct perf_session_env {
 	char			*numa_nodes;
 	int			nr_pmu_mappings;
 	char			*pmu_mappings;
+	int			nr_groups;
 };
 
 struct perf_header {
-- 
1.7.11.7

