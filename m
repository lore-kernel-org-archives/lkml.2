Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab1CaBfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:35:30 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58050 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456Ab1CaBf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hmuKCZ2Z2cnmMmClUlEsQ3iaITueqZGglgc2GgXYQ+i1+0mUpPNas7YGoFq+Ii4Gv/
         TZ30jrtY/HmgpHx7UYn/AWulgQXAAeREzUyjzZeEZioBUo8cLaqLqrnKqL1O4dVMA6AQ
         6jhNKGwkAGR/YiNjMf/TdogsQgUw+PsXGJVng=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf: Mmap 512 kiB by default
Date: Thu, 31 Mar 2011 03:35:24 +0200
Message-Id: <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1301496028.4859.183.camel@twins>
References: <1301496028.4859.183.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default setting of perf record is to mmap 128 pages if the user
did not override with -m.
However the page size may vary accross different architecture
settings, giving different default size between each.

Moreover the kernel side still has a default max number of mlocked
pages of 512 kiB + 1 page for unprivileged users. 128 + 1 pages
with page size > 4096 overlaps this threshold.

Thus, better adapt to this limitation and set the default number of
pages to fit those 512 kiB + 1 page.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6febcc1..a7e14bd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,7 +41,7 @@ static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 
 static unsigned int		page_size;
-static unsigned int		mmap_pages			=    128;
+static unsigned int		mmap_pages			= UINT_MAX;
 static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
 static int			output;
@@ -506,6 +506,10 @@ static int __cmd_record(int argc, const char **argv)
 	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
+	/* 512 kiB: default amount of unprivileged mlocked memory */
+	if (mmap_pages == UINT_MAX)
+		mmap_pages = (512 * 1024) / page_size;
+
 	if (forks) {
 		child_pid = fork();
 		if (child_pid < 0) {
-- 
1.7.3.2

