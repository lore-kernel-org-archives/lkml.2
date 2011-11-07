Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1KGMyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:54:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:40985 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab1KGMyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:54:23 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 7/7] perf: add scripts for profiling sleep times
Date: Mon,  7 Nov 2011 15:54:17 +0300
Message-Id: <1320670457-2633428-8-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

E.g.:
 # ./perf script record sched-stat -- -e sched:sched_stat_sleep &
 # ./foo;
 # killall -SIGINT perf
 ./perf script report sched-stat

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/scripts/python/bin/sched-stat-record |   65 +++++++++++++++++++++++
 tools/perf/scripts/python/bin/sched-stat-report |    5 ++
 2 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-report

diff --git a/tools/perf/scripts/python/bin/sched-stat-record b/tools/perf/scripts/python/bin/sched-stat-record
new file mode 100644
index 0000000..5e0bd97
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sched-stat-record
@@ -0,0 +1,65 @@
+#!/bin/bash
+# perf script record -- sched:sched_stat_[smth] -- CMD
+# perf script record -- -e sched:sched_stat_[smth]
+#
+set -o monitor
+
+usage()
+{
+	echo "Usage:"
+	echo "	perf script record -- sched:sched_stat_[smth] -- CMD"
+	echo "	perf script record -- [PERF OPTS] -e sched:sched_stat_[smth]"
+	exit 1;
+}
+
+declare -a opt
+declare -a cmd
+f=0;
+for i in "${@:2}"; do
+	if [ "$i" == "--" ]; then
+		f=1
+		continue
+	fi
+	if [ $f -eq 1 ]; then
+		cmd[${#cmd[*]}]="$i"
+	else
+		opt[${#opt[*]}]="$i"
+	fi
+done
+
+if [[ "${opt[@]}" != *sched_stat_* ]]; then
+	usage;
+fi
+
+if [ ${#cmd[@]} -eq 0 ]; then
+	if [ ${#opt[@]} -eq 0 ]; then
+		usage;
+	fi
+	exec perf record -agP \
+		-e sched:sched_switch \
+		--filter "prev_state == 1 || prev_state == 2" \
+		"${opt[@]}"
+fi
+
+if [ ${#opt[@]} -ne 1 ]; then
+	usage;
+fi
+
+# Wait until a target process is stopped.
+bash -c 'kill -STOP $$; exec "$@"' -- "${cmd[@]}" &
+pid=$!
+wait %1
+[ $? -eq 147 ] || exit 1;
+
+perf record -agP \
+		-e sched:sched_switch \
+		--filter "prev_pid == $pid && prev_state == 1 || prev_state == 2" \
+		-e sched:sched_process_exit -e "${opt[@]}" --filter "pid == $pid" &
+pid_perf=$!
+kill -CONT %1
+while :; do
+	wait %1
+	[ $? -eq 127 ] && break;
+done
+kill -INT %2
+wait %2
diff --git a/tools/perf/scripts/python/bin/sched-stat-report b/tools/perf/scripts/python/bin/sched-stat-report
new file mode 100644
index 0000000..e5114ce
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sched-stat-report
@@ -0,0 +1,5 @@
+#!/bin/bash
+# description: profiling sleep times
+perf inject -s -i perf.data -o perf.data.d || exit
+perf report -i perf.data.d || exit
+unlink perf.data.d
-- 
1.7.1

