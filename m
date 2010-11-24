Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0KXLfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:35:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41661 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0KXLfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LgtV8tcGejC/vxqasXA3EPiaB114APjg6mq/A0YfPd/bOt2etW2rxzd7yUNyKCo5GY
         lxvo9fOZopIi+4ZGho0BJXD1Amfr0gEOZg5osPG4CmGS17CDKYBfbR7x1lkFT/ztwuxs
         khWPvb9YivcUgo5MiACBnabqceVt0G4F328TQ=
From: tom.leiming@gmail.com
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf:tools: figure out start address of kernel map from /proc/kallsyms
Date: Wed, 24 Nov 2010 19:35:33 +0800
Message-Id: <1290598533-31855-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

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
 tools/perf/util/symbol.c |   60 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c5b4ccb..1a8895c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2183,14 +2183,72 @@ static struct dso *machine__create_kernel(struct machine *self)
 	return kernel;
 }
 
+/*figure out the start address of kernel map from /proc/kallsyms*/
+static u64 __machine_get_kernel_start_addr(struct machine *self)
+{
+	char *line = NULL;
+	size_t n;
+	u64 start_addr = 0;
+	FILE *file;
+	const char *filename;
+	char path[PATH_MAX];
+
+	if (machine__is_default_guest(self)) {
+		filename = symbol_conf.default_guest_kallsyms;
+		if (!filename)
+			goto out_failure;
+	} else {
+		sprintf(path, "%s/proc/kallsyms", self->root_dir);
+		filename = path;
+	}
+
+	file = fopen(filename, "r");
+
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		u64 start = 0;
+		int line_len, len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0 || !line)
+			break;
+
+		line[--line_len] = '\0'; /* \n */
+
+		/*if the line is for module symbol, skip it*/
+		if (strchr(line, '['))
+			continue;
+
+		len = hex2u64(line, &start);
+
+		len++;
+		if (len + 2 >= line_len)
+			continue;
+
+		start_addr = start;
+		break;
+	}
+
+	free(line);
+	fclose(file);
+	return start_addr;
+
+out_failure:
+	return start_addr;
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

