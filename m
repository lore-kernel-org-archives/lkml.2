Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300Ab0COQEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:04:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965216Ab0COQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:04:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       stable@kernel.org,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1 v2] perf annotate: Properly notify the user that vmlinux is missing
Date: Mon, 15 Mar 2010 13:04:33 -0300
Message-Id: <1268669073-6856-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before this patch we would not find a vmlinux, then try to pass objdump "[kernel.kallsyms]"
as the filename, it would get confused and produce no output:

[root@doppio ~]# perf annotate n_tty_write

------------------------------------------------
 Percent |      Source code & Disassembly of [kernel.kallsyms]
------------------------------------------------

Now we check that and emit meaningful warning:

[root@doppio ~]# perf annotate n_tty_write
Can't annotate n_tty_write: No vmlinux file was found in the path:
[0] vmlinux
[1] /boot/vmlinux
[2] /boot/vmlinux-2.6.34-rc1-tip+
[3] /lib/modules/2.6.34-rc1-tip+/build/vmlinux
[4] /usr/lib/debug/lib/modules/2.6.34-rc1-tip+/vmlinux
[root@doppio ~]#

This bug was introduced when we added automatic search for vmlinux, before that
time the user had to specify a vmlinux file.

v2: Print the warning just for the first symbol found when no symbol
name is specified, otherwise it will spam the screen repeating the
warning for each symbol.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   10 ++++++++++
 tools/perf/util/newt.c        |    2 +-
 tools/perf/util/symbol.h      |    1 +
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6ad7148..45d1466 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -452,6 +452,16 @@ static void annotate_sym(struct hist_entry *he)
 	if (!filename)
 		return;
 
+	if (dso->origin == DSO__ORIG_KERNEL) {
+		if (dso->annotate_warned)
+			return;
+		dso->annotate_warned = 1;
+		pr_err("Can't annotate %s: No vmlinux file was found in the "
+		       "path:\n", sym->name);
+		vmlinux_path__fprintf(stderr);
+		return;
+	}
+
 	pr_debug("%s: filename=%s, sym=%s, start=%#Lx, end=%#Lx\n", __func__,
 		 filename, sym->name, map->unmap_ip(map, sym->start),
 		 map->unmap_ip(map, sym->end));
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 2836394..2d19e7a 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -63,7 +63,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	if (self->sym == NULL)
 		return;
 
-	if (asprintf(&str, "perf annotate %s | expand", self->sym->name) < 0)
+	if (asprintf(&str, "perf annotate %s 2>&1 | expand", self->sym->name) < 0)
 		return;
 
 	fp = popen(str, "r");
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d983bba..5bd91d1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -106,6 +106,7 @@ struct dso {
 	u8		 has_build_id:1;
 	u8		 kernel:1;
 	u8		 hit:1;
+	u8		 annotate_warned:1;
 	unsigned char	 origin;
 	u8		 sorted_by_name;
 	u8		 loaded;
-- 
1.6.2.5

