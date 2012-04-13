Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2DMSI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:08:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2DMSIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:08:24 -0400
Date: Fri, 13 Apr 2012 11:07:34 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui annotate browser:
  Allow toggling addr offset view
Git-Commit-ID: e235f3f3bf238eb092ad2fe7c35c6d7fd5dc2aeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:07:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e235f3f3bf238eb092ad2fe7c35c6d7fd5dc2aeb
Gitweb:     http://git.kernel.org/tip/e235f3f3bf238eb092ad2fe7c35c6d7fd5dc2aeb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Apr 2012 13:21:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 16:10:19 -0300

perf ui annotate browser: Allow toggling addr offset view

The lines in objdump have this format:

    ffffffff8126543f:       jne    ffffffff81265494 <__list_del_entry+0x84>
<SNIP>
    ffffffff81265494:       mov    %rdi,%rcx

Since we now have objdump_line allowing tools to print the offset
independently from the rest of the line, allow toggling a view where
just offsets from the start of the function are shown:

     2f:       jne    ffffffff81265494 <__list_del_entry+0x84>
<SNIP>
     84:       mov    %rdi,%rcx

The offset view will be the default as soon as operations that deal with
offsets in a function are handled accodringly, i.e. in offset view the
above will become:

     2f:       jne    __list_del_entry+0x84
<SNIP>
     84:       mov    %rdi,%rcx

And then a follow up patch will allow navigating thru jumps, just like
we handle callq instructions.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 7ac7dd0..5cf9b78 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -20,6 +20,7 @@ struct annotate_browser {
 	int		    nr_asm_entries;
 	int		    nr_entries;
 	bool		    hide_src_code;
+	bool		    use_offset;
 };
 
 struct objdump_line_rb_node {
@@ -82,10 +83,13 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(ol->line, width - 18);
 	else {
 		char bf[64];
-		u64 addr = ab->start + ol->offset;
-		int printed = scnprintf(bf, sizeof(bf), " %" PRIx64 ":", addr);
-		int color = -1;
+		u64 addr = ol->offset;
+		int printed, color = -1;
 
+		if (!ab->use_offset)
+			addr += ab->start;
+
+		printed = scnprintf(bf, sizeof(bf), " %" PRIx64 ":", addr);
 		if (change_color)
 			color = ui_browser__set_color(self, HE_COLORSET_ADDR);
 		slsmg_write_nstring(bf, printed);
@@ -250,6 +254,7 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	struct symbol *sym = ms->sym;
 	const char *help = "<-/ESC: Exit, TAB/shift+TAB: Cycle hot lines, "
 			   "H: Go to hottest line, ->/ENTER: Line action, "
+			   "O: Toggle offset view, "
 			   "S: Toggle source code view";
 	int key;
 
@@ -310,6 +315,10 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 			if (annotate_browser__toggle_source(self))
 				ui_helpline__puts(help);
 			continue;
+		case 'O':
+		case 'o':
+			self->use_offset = !self->use_offset;
+			continue;
 		case K_ENTER:
 		case K_RIGHT:
 			if (self->selection == NULL) {
