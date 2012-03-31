Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2CaHmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:42:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2CaHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:42:18 -0400
Date: Sat, 31 Mar 2012 00:41:53 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-fa30c964c0ac31a705a4f86072267a42343c4158@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120317222317.GA8803@quad>
References: <20120317222317.GA8803@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix bug in raw sample parsing
Git-Commit-ID: fa30c964c0ac31a705a4f86072267a42343c4158
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:42:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa30c964c0ac31a705a4f86072267a42343c4158
Gitweb:     http://git.kernel.org/tip/fa30c964c0ac31a705a4f86072267a42343c4158
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Sat, 17 Mar 2012 23:23:18 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Mar 2012 15:36:03 -0300

perf tools: Fix bug in raw sample parsing

In perf_event__parse_sample(), the array variable was not incremented
by the amount of data used by the raw_data.

That was okay until we added PERF_SAMPLE_BRANCH_STACK which depends on
the array variable pointing to the beginning of the branch stack data.

But that was not the case if branch stack was combined with raw mode
sampling. That led to bogus branch stack addresses and count.

The bug would show up with:
$ perf record -R -b foo

This patch fixes the problem by correctly moving the array pointer
forward for RAW samples.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120317222317.GA8803@quad
[ committer note: Fix also later submitted by Jiri Olsa ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d9da62a..8c13dbc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -580,6 +580,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_data = (void *) pdata;
+
+		array = (void *)array + data->raw_size + sizeof(u32);
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
