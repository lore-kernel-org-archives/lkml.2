Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2DEX3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:29:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54149 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2DEX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:29:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf hists browser: Fix NULL deref in hists browsing code
Date: Thu,  5 Apr 2012 20:28:51 -0300
Message-Id: <1333668532-3624-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333668532-3624-1-git-send-email-acme@infradead.org>
References: <1333668532-3624-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

If there's an event with no samples in data file, the perf report
command can segfault after entering the event details menu.

Following steps reproduce the issue:

 # ./perf record -e syscalls:sys_enter_kexec_load,syscalls:sys_enter_mmap ls
 # ./perf report
 # enter '0 syscalls:sys_enter_kexec_load' menu
 # pres ENTER twice

Above steps are valid assuming ls wont run kexec.. ;)

The check for sellection to be NULL is missing. The fix makes sure it's
being check. Above steps now endup with menu being displayed allowing
'Exit' as the only option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333570898-10505-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index d7a1c4afe..2f83e5d 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -125,6 +125,9 @@ static int callchain__count_rows(struct rb_root *chain)
 
 static bool map_symbol__toggle_fold(struct map_symbol *self)
 {
+	if (!self)
+		return false;
+
 	if (!self->has_children)
 		return false;
 
-- 
1.7.9.2.358.g22243

