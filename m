Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936556Ab0COPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:43:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936194Ab0COPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:43:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       stable@kernel.org,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf annotate: Properly notify the user that vmlinux is missing
Date: Mon, 15 Mar 2010 12:43:33 -0300
Message-Id: <1268667813-5710-1-git-send-email-acme@infradead.org>
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

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    7 +++++++
 tools/perf/util/newt.c        |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6ad7148..b2ca290 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -452,6 +452,13 @@ static void annotate_sym(struct hist_entry *he)
 	if (!filename)
 		return;
 
+	if (dso->origin == DSO__ORIG_KERNEL) {
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
-- 
1.6.2.5

