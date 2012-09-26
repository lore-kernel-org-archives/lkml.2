Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2IZH6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:58:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54410 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2IZH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:09 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-43-5062b515fe5a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 07/16] perf header: Add HEADER_GROUP_DESC feature
Date: Wed, 26 Sep 2012 16:47:34 +0900
Message-Id: <1348645663-25303-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Save group relationship information so that it can be restored when
perf report is running.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |   3 +
 tools/perf/util/header.c    | 149 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |   2 +
 3 files changed, 154 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 99ad5234e6ff..b2d9c0af9a15 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -561,6 +561,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
+	if (!evsel_list->nr_groups)
+		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
+
 	/*
 	 * perf_session__delete(session) will be called at perf_record__exit()
 	 */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6aae3290358e..0039c08ad4c7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1072,6 +1072,41 @@ static int write_pmu_mappings(int fd, struct perf_header *h __maybe_unused,
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
+		    evsel->nr_members > 0) {
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
@@ -1430,6 +1465,31 @@ error:
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
+		    evsel->nr_members > 0) {
+			fprintf(fp, "# group: %s{%s", evsel->group_name ?: "",
+				perf_evsel__name(evsel));
+
+			nr = evsel->nr_members;
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
@@ -1944,6 +2004,94 @@ error:
 	return -1;
 }
 
+static int process_group_desc(struct perf_file_section *section __maybe_unused,
+			      struct perf_header *ph, int fd,
+			      void *data __maybe_unused)
+{
+	size_t ret = -1;
+	u32 i, nr, nr_groups;
+	struct perf_session *session;
+	struct perf_evsel *evsel, *leader;
+	struct group_desc {
+		char *name;
+		u32 leader_idx;
+		u32 nr_members;
+	} *desc;
+
+	ret = read(fd, &nr_groups, sizeof(nr_groups));
+	if (ret != sizeof(nr_groups))
+		return -1;
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
+		ret = read(fd, &desc[i].leader_idx, sizeof(u32));
+		if (ret != sizeof(u32))
+			goto out_free;
+
+		ret = read(fd, &desc[i].nr_members, sizeof(u32));
+		if (ret != sizeof(u32))
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
+			evsel->leader = NULL;
+			/* {anon_group} is a dummy name */
+			if (strcmp(desc[i].name, "{anon_group}"))
+				evsel->group_name = desc[i].name;
+			evsel->nr_members = desc[i].nr_members;
+
+			BUG_ON(i >= nr_groups);
+			BUG_ON(nr > 0);
+
+			leader = evsel;
+			nr = evsel->nr_members;
+			i++;
+		} else if (nr) {
+			/* This is a group member */
+			evsel->leader = leader;
+			/* group_idx starts from 0 */
+			evsel->group_idx = leader->nr_members - nr;
+			nr--;
+		}
+	}
+
+	BUG_ON(i != nr_groups);
+	BUG_ON(nr != 0);
+
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
@@ -1983,6 +2131,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
+	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 99bdd3abce59..f143aa7153a2 100644
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
1.7.11.4

