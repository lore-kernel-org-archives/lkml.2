Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2CQWXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 18:23:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37737 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab2CQWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 18:23:18 -0400
Date: Sat, 17 Mar 2012 23:23:18 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, acme@redhat.com, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf report: fix bug in raw smple parsing
Message-ID: <20120317222317.GA8803@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In perf_event__parse_sample(), the array variable was not incremented
by the amount of data used by the raw_data. That was okay until
we added PERF_SAMPLE_BRANCH_STACK which depends on the array variable
pointing to the beginning of the branch stack data. But that was not
the case if branch stack was combined with raw mode sampling. That led
to bogus branch stack addresses and count.

The bug would show up with:
$ perf record -R -b foo

This patch fixes the problem by correctly moving the array pointer
forward for RAW samples.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f421f7c..9f35d92 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -578,6 +578,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_data = (void *) pdata;
+
+		array = (void *)array + data->raw_size + sizeof(u32);
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
