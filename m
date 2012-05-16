Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717Ab2EPIVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:21:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59056 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841Ab2EPIVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:21:19 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-b4-4fb36373788e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	<CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	<1336994000.2443.24.camel@twins> <20120514115551.GA6479@gmail.com>
	<1337007985.1552.5.camel@leonhard> <1337077973.27694.24.camel@twins>
	<1337093080.1493.22.camel@leonhard> <1337101633.27694.92.camel@twins>
	<87liksd5wi.fsf@sejong.aot.lge.com>
Date: Wed, 16 May 2012 17:19:16 +0900
In-Reply-To: <87liksd5wi.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Wed, 16 May 2012 14:57:49 +0900")
Message-ID: <87397035dn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 May 2012 14:57:49 +0900, Namhyung Kim wrote:
> Hmm.. but it seems this breaks my 'perf stat -g' - it doesn't
> respond any more (even for ^C):
>

I've found that it's a problem of whole perf stat, not only for -g
option. It's because the perf stat should use per-task events for some
reason as it's not use mmap on the events.

The commit 77a6f014e9ae ("perf stat: Use perf_evlist__create_maps")
introduced the issue and it seems following patch works well for me:

---[ cut here ]---

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d19058a7b84c..185e59a4715d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -754,6 +754,9 @@ static struct perf_record record = {
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
 		.freq		     = 1000,
+		.target		     = {
+			.need_mmap   = true,
+		},
 	},
 	.write_mode = WRITE_FORCE,
 	.file_new   = true,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 553560a8b1be..ebcd15883ab8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1162,6 +1162,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		.freq		     = 1000, /* 1 KHz */
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
+		.target		     = {
+			.need_mmap   = true,
+		},
 	};
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const struct option options[] = {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 87889f325678..ba43c3a4046c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -611,6 +611,8 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 
 	if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
+	else if (!perf_target__has_cpu(target) && !target->need_mmap)
+		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
 
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index c43f632955fa..ffa247d3ede3 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -11,6 +11,7 @@ struct perf_target {
 	const char   *uid_str;
 	uid_t	     uid;
 	bool	     system_wide;
+	bool	     need_mmap;
 };
 
 enum perf_target_errno {


-- 
Thanks,
Namhyung
