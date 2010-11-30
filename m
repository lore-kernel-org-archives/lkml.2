Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0K3PlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:41:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:33887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab0K3PlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:41:00 -0500
Date: Tue, 30 Nov 2010 15:40:29 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, imunsie@au1.ibm.com, tglx@linutronix.de,
        tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, imunsie@au1.ibm.com, tglx@linutronix.de,
        tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <20101125192725.62d31b42@tom-lei>
References: <20101125192725.62d31b42@tom-lei>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Figure out start address of kernel map from kallsyms
Message-ID: <tip-d214afbd81405d4da2c5745fe867e6b313fd4178@git.kernel.org>
Git-Commit-ID: d214afbd81405d4da2c5745fe867e6b313fd4178
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Nov 2010 15:40:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d214afbd81405d4da2c5745fe867e6b313fd4178
Gitweb:     http://git.kernel.org/tip/d214afbd81405d4da2c5745fe867e6b313fd4178
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 25 Nov 2010 19:27:25 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 14:47:58 -0200

perf symbols: Figure out start address of kernel map from kallsyms

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
 
