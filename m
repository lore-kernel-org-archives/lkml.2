Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2BFVh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:37:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:56111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab2BFVg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:36:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf tools: Fix prefix matching for kernel maps
Date: Mon,  6 Feb 2012 19:36:08 -0200
Message-Id: <1328564169-26517-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328564169-26517-1-git-send-email-acme@infradead.org>
References: <1328564169-26517-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

In some perf ancient versions we used '[kernel.kallsyms._text]' as the
name for the kernel map.

This got changed with commit:
  perf: 'perf kvm' tool for monitoring guest performance from host
  commit a1645ce12adb6c9cc9e19d7695466204e3f017fe
  Author: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

and we started to use following name '[kernel.kallsyms]_text'.

This name change is important for the report code dealing with ancient
perf data. When processing the kernel map event, we need to recognize
the old naming (dont match the last ']') and initialize the kernel map
correctly.

The subsequent call to maps__set_kallsyms_ref_reloc_sym deals with the
superfluous ']' to get correct symbol name.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328461865-6127-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 73ddaf0..2044324 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -554,7 +554,7 @@ static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
 
 	is_kernel_mmap = memcmp(event->mmap.filename,
 				kmmap_prefix,
-				strlen(kmmap_prefix)) == 0;
+				strlen(kmmap_prefix) - 1) == 0;
 	if (event->mmap.filename[0] == '/' ||
 	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
 
-- 
1.7.9.rc2.1.g69204

