Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0K2R4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:56:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:58380 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0K2R4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:56:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf symbols: Figure out start address of kernel map from kallsyms
Date: Mon, 29 Nov 2010 15:56:12 -0200
Message-Id: <1291053372-13592-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291053372-13592-1-git-send-email-acme@infradead.org>
References: <1291053372-13592-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

On ARM, module symbol start address is ahead of kernel symbol start address, so
we can't suppose that the start address of kernel map always is zero, otherwise
may cause incorrect .start and .end of kernel map (caused by fixup) when there
are modules loaded, then map_groups__find may return incorrect map for symbol
query.

This patch always figures out the start address of kernel map from
/proc/kallsyms if the file is available, so fix the issues on ARM for module
loaded case.

This patch fixes the following issues on ARM when modules are loaded:

	- vmlinux symbol can't be found by kallsyms maps doing 'perf test'
	- module symbols are parsed mistakenlly when doing 'perf top'/'perf report'

Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20101125192725.62d31b42@tom-lei>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2af4d7d..d628c8d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2131,14 +2131,55 @@ static struct dso *machine__create_kernel(struct machine *self)
 	return kernel;
 }
 
+struct process_args {
+	u64 start;
+};
+
+static int symbol__in_kernel(void *arg, const char *name,
+			     char type __used, u64 start)
+{
+	struct process_args *args = arg;
+
+	if (strchr(name, '['))
+		return 0;
+
+	args->start = start;
+	return 1;
+}
+
+/* Figure out the start address of kernel map from /proc/kallsyms */
+static u64 machine__get_kernel_start_addr(struct machine *machine)
+{
+	const char *filename;
+	char path[PATH_MAX];
+	struct process_args args;
+
+	if (machine__is_host(machine)) {
+		filename = "/proc/kallsyms";
+	} else {
+		if (machine__is_default_guest(machine))
+			filename = (char *)symbol_conf.default_guest_kallsyms;
+		else {
+			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+			filename = path;
+		}
+	}
+
+	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
+		return 0;
+
+	return args.start;
+}
+
 int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
 {
 	enum map_type type;
+	u64 start = machine__get_kernel_start_addr(self);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		self->vmlinux_maps[type] = map__new2(0, kernel, type);
+		self->vmlinux_maps[type] = map__new2(start, kernel, type);
 		if (self->vmlinux_maps[type] == NULL)
 			return -1;
 
-- 
1.6.2.5

