Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2DMSEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:04:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2DMSEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:04:46 -0400
Date: Fri, 13 Apr 2012 11:04:18 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-8493fe1daf15324eb13a4cc2f94e258716daa568@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1333570898-10505-2-git-send-email-jolsa@redhat.com>
References: <1333570898-10505-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Fix NULL deref in hists browsing code
Git-Commit-ID: 8493fe1daf15324eb13a4cc2f94e258716daa568
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:04:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8493fe1daf15324eb13a4cc2f94e258716daa568
Gitweb:     http://git.kernel.org/tip/8493fe1daf15324eb13a4cc2f94e258716daa568
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 4 Apr 2012 22:21:31 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Apr 2012 18:58:45 -0300

perf hists browser: Fix NULL deref in hists browsing code

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
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index d7a1c4a..2f83e5d 100644
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
 
