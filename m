Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1HLQ3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:29:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:33808 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1HLQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/12] perf report: Use properly build_id kernel binaries
Date: Fri, 12 Aug 2011 13:28:54 -0300
Message-Id: <1313166544-6209-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

If we bring the recorded perf data together with kernel binary from another
machine using:

	on server A:
	perf archive

	on server B:
	tar xjvf perf.data.tar.bz2 -C ~/.debug

the build_id kernel dso is not properly recognized during the "perf report"
command on server B.

The reason is, that build_id dsos are added during the session initialization,
while the kernel maps are created during the sample event processing.

The machine__create_kernel_maps functions ends up creating new dso object for
kernel, but it does not check if we already have one added by build_id
processing.

Also the build_id reading ABI quirk added in commit:

 - commit b25114817a73bbd2b84ce9dba02ee1ef8989a947
   perf build-id: Add quirk to deal with perf.data file format breakage

populates the "struct build_id_event::pid" with 0, which
is later interpreted as DEFAULT_GUEST_KERNEL_ID.

This is not always correct, so it's better to guess the pid
value based on the "struct build_id_event::header::misc" value.

- Tested with data generated on x86 kernel version v2.6.34
  and reported back on x86_64 current kernel.
- Not tested for guest kernel case.

Note the problem stays for PERF_RECORD_MMAP events recorded by perf that
does not use proper pid (HOST_KERNEL_ID/DEFAULT_GUEST_KERNEL_ID). They are
misinterpreted within the current perf code. Probably there's not much we
can do about that.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Link: http://lkml.kernel.org/r/20110601194346.GB1934@jolsa.brq.redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   11 ++++++++-
 tools/perf/util/symbol.c |   57 +++++++++++++++++++++++++--------------------
 tools/perf/util/symbol.h |    1 -
 3 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d4f3101..b6c1ad1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -726,7 +726,16 @@ static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
 			return -1;
 
 		bev.header = old_bev.header;
-		bev.pid	   = 0;
+
+		/*
+		 * As the pid is the missing value, we need to fill
+		 * it properly. The header.misc value give us nice hint.
+		 */
+		bev.pid	= HOST_KERNEL_ID;
+		if (bev.header.misc == PERF_RECORD_MISC_GUEST_USER ||
+		    bev.header.misc == PERF_RECORD_MISC_GUEST_KERNEL)
+			bev.pid	= DEFAULT_GUEST_KERNEL_ID;
+
 		memcpy(bev.build_id, old_bev.build_id, sizeof(bev.build_id));
 		__event_process_build_id(&bev, filename, session);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a8b5371..e142c21 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2181,27 +2181,22 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
 	return ret;
 }
 
-struct dso *dso__new_kernel(const char *name)
+static struct dso*
+dso__kernel_findnew(struct machine *machine, const char *name,
+		    const char *short_name, int dso_type)
 {
-	struct dso *dso = dso__new(name ?: "[kernel.kallsyms]");
-
-	if (dso != NULL) {
-		dso__set_short_name(dso, "[kernel]");
-		dso->kernel = DSO_TYPE_KERNEL;
-	}
-
-	return dso;
-}
+	/*
+	 * The kernel dso could be created by build_id processing.
+	 */
+	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, name);
 
-static struct dso *dso__new_guest_kernel(struct machine *machine,
-					const char *name)
-{
-	char bf[PATH_MAX];
-	struct dso *dso = dso__new(name ?: machine__mmap_name(machine, bf,
-							      sizeof(bf)));
+	/*
+	 * We need to run this in all cases, since during the build_id
+	 * processing we had no idea this was the kernel dso.
+	 */
 	if (dso != NULL) {
-		dso__set_short_name(dso, "[guest.kernel]");
-		dso->kernel = DSO_TYPE_GUEST_KERNEL;
+		dso__set_short_name(dso, short_name);
+		dso->kernel = dso_type;
 	}
 
 	return dso;
@@ -2219,24 +2214,36 @@ void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 		dso->has_build_id = true;
 }
 
-static struct dso *machine__create_kernel(struct machine *machine)
+static struct dso *machine__get_kernel(struct machine *machine)
 {
 	const char *vmlinux_name = NULL;
 	struct dso *kernel;
 
 	if (machine__is_host(machine)) {
 		vmlinux_name = symbol_conf.vmlinux_name;
-		kernel = dso__new_kernel(vmlinux_name);
+		if (!vmlinux_name)
+			vmlinux_name = "[kernel.kallsyms]";
+
+		kernel = dso__kernel_findnew(machine, vmlinux_name,
+					     "[kernel]",
+					     DSO_TYPE_KERNEL);
 	} else {
+		char bf[PATH_MAX];
+
 		if (machine__is_default_guest(machine))
 			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		kernel = dso__new_guest_kernel(machine, vmlinux_name);
+		if (!vmlinux_name)
+			vmlinux_name = machine__mmap_name(machine, bf,
+							  sizeof(bf));
+
+		kernel = dso__kernel_findnew(machine, vmlinux_name,
+					     "[guest.kernel]",
+					     DSO_TYPE_GUEST_KERNEL);
 	}
 
-	if (kernel != NULL) {
+	if (kernel != NULL && (!kernel->has_build_id))
 		dso__read_running_kernel_build_id(kernel, machine);
-		dsos__add(&machine->kernel_dsos, kernel);
-	}
+
 	return kernel;
 }
 
@@ -2340,7 +2347,7 @@ void machine__destroy_kernel_maps(struct machine *machine)
 
 int machine__create_kernel_maps(struct machine *machine)
 {
-	struct dso *kernel = machine__create_kernel(machine);
+	struct dso *kernel = machine__get_kernel(machine);
 
 	if (kernel == NULL ||
 	    __machine__create_kernel_maps(machine, kernel) < 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 325ee36..4f377d9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -155,7 +155,6 @@ struct dso {
 };
 
 struct dso *dso__new(const char *name);
-struct dso *dso__new_kernel(const char *name);
 void dso__delete(struct dso *dso);
 
 int dso__name_len(const struct dso *dso);
-- 
1.6.2.5

