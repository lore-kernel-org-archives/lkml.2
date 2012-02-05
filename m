Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2BERLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 12:11:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2BERLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:11:21 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool: Fix prefix matching for kernel maps
Date: Sun,  5 Feb 2012 18:11:05 +0100
Message-Id: <1328461865-6127-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some perf ancient versions we used '[kernel.kallsyms._text]' as
the name for the kernel map.

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

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.4.4

