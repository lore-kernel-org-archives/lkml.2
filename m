Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0DTGSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:18:22 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52455 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0DTGSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:18:20 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: Fix NULL pointer dereference
Date: Tue, 20 Apr 2010 16:16:25 +1000
Message-Id: <1271744185-12469-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au.ibm.com>

I began to receive semi-reproducible segmentation faults while using
perf probe on one machine. From the below back trace it is apparent that
they were due to using a list node which had not been properly
initialised while parsing the vmlinux file.

This patch adds the appropriate initialisation in dso__new.

This is the output from running perf probe under gdb:

 Starting program: /root/perf probe --line schedule
 [Thread debugging using libthread_db enabled]
 [New process 11247]
 [New Thread -137527296 (LWP 11247)]

 Program received signal SIGSEGV, Segmentation fault.
 [Switching to Thread -137527296 (LWP 11247)]
 0x100407e4 in __list_add (new=0x105b9bf0, prev=0x0, next=0x105b71c8) at util/include/../../../../include/linux/list.h:48
 48              prev->next = new;
 (gdb) bt
 #0  0x100407e4 in __list_add (new=0x105b9bf0, prev=0x0, next=0x105b71c8) at util/include/../../../../include/linux/list.h:48
 #1  0x10040830 in list_add_tail (new=0x105b9bf0, head=0x105b71c8) at util/include/../../../../include/linux/list.h:80
 #2  0x100462dc in dsos__add (head=0x105b71c8, dso=0x105b9bf0) at util/symbol.c:1871
 #3  0x10043edc in dso__load_sym (self=0x105b71c8, map=0x105b7238, name=0x105b7088 "vmlinux", fd=5, filter=0, kmodule=0) at util/symbol.c:1062
 #4  0x10045c30 in dso__load_vmlinux (self=0x105b71c8, map=0x105b7238, vmlinux=0x105b7088 "vmlinux", filter=0) at util/symbol.c:1692
 #5  0x10045d2c in dso__load_vmlinux_path (self=0x105b71c8, map=0x105b7238, filter=0) at util/symbol.c:1710
 #6  0x10045e6c in dso__load_kernel_sym (self=0x105b71c8, map=0x105b7238, filter=0) at util/symbol.c:1748
 #7  0x10044948 in dso__load (self=0x105b71c8, map=0x105b7238, filter=0) at util/symbol.c:1299
 #8  0x10050e00 in map__load (self=0x105b7238, filter=0) at util/map.c:127
 #9  0x1006b38c in open_vmlinux () at util/probe-event.c:113
 #10 0x1006b9e4 in show_line_range (lr=0x1024ea68) at util/probe-event.c:249
 #11 0x100243a0 in cmd_probe (argc=0, argv=0xffb3a418, prefix=0x0) at builtin-probe.c:231
 #12 0x100042b4 in run_builtin (p=0x1009e48c, argc=3, argv=0xffb3a418) at perf.c:265
 #13 0x1000455c in handle_internal_command (argc=3, argv=0xffb3a418) at perf.c:334
 #14 0x100046fc in run_argv (argcp=0xffb3a18c, argv=0xffb3a188) at perf.c:378
 #15 0x10004984 in main (argc=3, argv=0xffb3a418) at perf.c:462

Signed-off-by: Ian Munsie <imunsie@au.ibm.com>
---
 tools/perf/util/symbol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e782e7d..e77c33a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -189,6 +189,7 @@ struct dso *dso__new(const char *name)
 		self->sorted_by_name = 0;
 		self->has_build_id = 0;
 		self->kernel = DSO_TYPE_USER;
+		INIT_LIST_HEAD(&self->node);
 	}
 
 	return self;
-- 
1.7.0

