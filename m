Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0KYL1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:27:39 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:46425 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0KYL1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:27:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:organization:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hAWhHTI3H82LJGtWEUykQrhWq29oOO/fO51B07YvCmTGyYyb67kvZmeBIi8VD4Z/60
         ZdTktvM9hEocvBNSJ+jYWScX0JImC7fBcWgLlLzbVeQIy5P5nXj9fehL3RKJQGoh5XQk
         +uVSs6c9wv8Bm9kNvNw9xOdpfI49fEeNEKssQ=
Date: Thu, 25 Nov 2010 19:27:25 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: acme@ghostprotocols.net
Cc: Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf:tools: figure out start address of kernel map from
 /proc/kallsyms(v1)
Message-ID: <20101125192725.62d31b42@tom-lei>
Organization: private
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5dffda5978f0cae0b390e01957e49522a60324ac Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 24 Nov 2010 16:31:15 +0800
Subject: [PATCH] perf:tools: figure out start address of kernel map from /proc/kallsyms(v1)

On ARM, module symbol start address is ahead of kernel symbol start
address, so we can't suppose that the start address of kenerl map
always is zero, otherwise may cause incorrect .start and .end of kernel map
(caused by fixup) when there are modules loaded, then map_groups__find
may return incorrect map for symbol query.

This patch always figures out the start address of kernel map from
/proc/kallsyms if the file is available, so fix the issues on ARM for
module loaded case.

This patch fixes the following issues on ARM when modules are loaded:

	- vmlinux symbol can't be found by kallsyms maps doing 'perf test'
	- module symbols are parsed mistakenlly when doing 'perf top'/'perf report'

Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
v1: use kallsyms__parse, suggested by Arnaldo
---
 tools/perf/util/symbol.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2af4d7d..00189d1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2131,14 +2131,56 @@ static struct dso *machine__create_kernel(struct machine *self)
 	return kernel;
 }
 
+struct process_args {
+	u64 start;
+};
+
+static int find_kernel_start(void *arg, const char *name,
+			char type __attribute__((__unused__)), u64 start)
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
+/*figure out the start address of kernel map from /proc/kallsyms*/
+static u64 __machine_get_kernel_start_addr(struct machine *machine)
+{
+	const char *filename;
+	char path[PATH_MAX];
+	struct process_args args;
+
+	if (machine__is_host(machine)) {
+		filename = "/proc/kallsyms";
+	} else {
+		if (machine__is_default_guest(machine))
+			filename = (char *) symbol_conf.default_guest_kallsyms;
+		else {
+			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+			filename = path;
+		}
+	}
+
+	if (kallsyms__parse(filename, &args, find_kernel_start) <= 0)
+		return 0;
+
+	return args.start;
+}
+
 int __machine__create_kernel_maps(struct machine *self, struct dso *kernel)
 {
 	enum map_type type;
+	u64 start;
 
+	start = __machine_get_kernel_start_addr(self);
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
 
-		self->vmlinux_maps[type] = map__new2(0, kernel, type);
+		self->vmlinux_maps[type] = map__new2(start, kernel, type);
 		if (self->vmlinux_maps[type] == NULL)
 			return -1;
 
-- 
1.7.3

