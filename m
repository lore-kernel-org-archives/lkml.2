Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484Ab2EWPbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:31:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297Ab2EWPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:31:07 -0400
Date: Wed, 23 May 2012 08:30:41 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-299c345208ae15fbc1e1c96dc1b6ac61e4e5da10@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1337081295-10303-6-git-send-email-eranian@google.com>
References: <1337081295-10303-6-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-list: Work better with pipe mode
Git-Commit-ID: 299c345208ae15fbc1e1c96dc1b6ac61e4e5da10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:30:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  299c345208ae15fbc1e1c96dc1b6ac61e4e5da10
Gitweb:     http://git.kernel.org/tip/299c345208ae15fbc1e1c96dc1b6ac61e4e5da10
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 15 May 2012 13:28:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 13:03:54 -0300

perf buildid-list: Work better with pipe mode

In order for perf buildid-list to work with pipe-mode files, it needs to
process buildids and event attr structs.

$ perf record -o - noploop 2 | ./perf inject -b | perf buildid-list -i - -H
noploop for 2 seconds
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.084 MB - (~3678 samples) ]
0000000000000000000000000000000000000000 [kernel.kallsyms]
3a0d0629efe74a8da3eeba372cdbd74ad9b8f5d5 /usr/local/bin/noploop

The reason [kernel.kallsyms] shows a 0 build-id comes from the
way buildids are injected in the stream.

The buildid for the kernel is provided by a BUILD_ID record. The
[kernel.kallsyms] is provided by a MMAP record. There is no clean and
obvious way to link the two, unfortunately.

In regular mode, the kernel buildid is generated from reading the ELF
image or kallsyms and perf knows to associate [kernel.kallsyms] to it.
Later on, when perf processes the [kernel.kallsyms] MMAP record, it will
already have a dso for it.

So for now, make sure perf buildid-list shows the buildids for
everything but the kernel image.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1337081295-10303-6-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |    6 +++++-
 tools/perf/util/build-id.c        |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 5248046..6b2bcfb 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -84,7 +84,11 @@ static int perf_session__list_build_ids(void)
 	if (filename__fprintf_build_id(session->filename, stdout))
 		goto out;
 
-	if (with_hits)
+	/*
+	 * in pipe-mode, the only way to get the buildids is to parse
+	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
+	 */
+	if (with_hits || session->fd_pipe)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index dff9c7a..fd9a594 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -65,6 +65,8 @@ struct perf_tool build_id__mark_dso_hit_ops = {
 	.mmap	= perf_event__process_mmap,
 	.fork	= perf_event__process_task,
 	.exit	= perf_event__exit_del_thread,
+	.attr		 = perf_event__process_attr,
+	.build_id	 = perf_event__process_build_id,
 };
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
