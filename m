Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab0HLRYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:24:52 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:41652 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab0HLRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:24:49 -0400
Message-Id: <20100812172623.803022441@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 Aug 2010 19:25:48 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 4/5] [PATCH] topology/sysfs: provide book id and siblings attributes
References: <20100812172544.655648128@de.ibm.com>
Content-Disposition: inline; filename=04-topology-sysfs-book.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Create attributes
/sys/devices/system/cpu/cpuX/topology/book_id
/sys/devices/system/cpu/cpuX/topology/book_siblings
which show the book id and the book siblings of a cpu.

Unlike the attributes for SMT and MC these attributes are only present if
CONFIG_SCHED_BOOK is set. There is no reason to pollute sysfs for every
architecture with unused attributes.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 Documentation/cputopology.txt |   23 ++++++++++++++++++++---
 drivers/base/topology.c       |   16 +++++++++++++++-
 2 files changed, 35 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/Documentation/cputopology.txt linux-2.6-patched/Documentation/cputopology.txt
--- linux-2.6/Documentation/cputopology.txt	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6-patched/Documentation/cputopology.txt	2010-08-11 13:47:23.000000000 +0200
@@ -14,25 +14,39 @@ to /proc/cpuinfo.
 	identifier (rather than the kernel's).  The actual value is
 	architecture and platform dependent.
 
-3) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
+3) /sys/devices/system/cpu/cpuX/topology/book_id:
+
+	the book ID of cpuX. Typically it is the hardware platform's
+	identifier (rather than the kernel's).	The actual value is
+	architecture and platform dependent.
+
+4) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
 
 	internel kernel map of cpuX's hardware threads within the same
 	core as cpuX
 
-4) /sys/devices/system/cpu/cpuX/topology/core_siblings:
+5) /sys/devices/system/cpu/cpuX/topology/core_siblings:
 
 	internal kernel map of cpuX's hardware threads within the same
 	physical_package_id.
 
+6) /sys/devices/system/cpu/cpuX/topology/book_siblings:
+
+	internal kernel map of cpuX's hardware threads within the same
+	book_id.
+
 To implement it in an architecture-neutral way, a new source file,
-drivers/base/topology.c, is to export the 4 attributes.
+drivers/base/topology.c, is to export the 4 or 6 attributes. The two book
+related sysfs files will only be created if CONFIG_SCHED_BOOK is selected.
 
 For an architecture to support this feature, it must define some of
 these macros in include/asm-XXX/topology.h:
 #define topology_physical_package_id(cpu)
 #define topology_core_id(cpu)
+#define topology_book_id(cpu)
 #define topology_thread_cpumask(cpu)
 #define topology_core_cpumask(cpu)
+#define topology_book_cpumask(cpu)
 
 The type of **_id is int.
 The type of siblings is (const) struct cpumask *.
@@ -45,6 +59,9 @@ not defined by include/asm-XXX/topology.
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
 
+For architectures that don't support books (CONFIG_SCHED_BOOK) there are no
+default definitions for topology_book_id() and topology_book_cpumask().
+
 Additionally, CPU topology information is provided under
 /sys/devices/system/cpu and includes these files.  The internal
 source for the output is in brackets ("[]").
diff -urpN linux-2.6/drivers/base/topology.c linux-2.6-patched/drivers/base/topology.c
--- linux-2.6/drivers/base/topology.c	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6-patched/drivers/base/topology.c	2010-08-11 13:47:23.000000000 +0200
@@ -45,7 +45,8 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
-#if defined(topology_thread_cpumask) || defined(topology_core_cpumask)
+#if defined(topology_thread_cpumask) || defined(topology_core_cpumask) || \
+    defined(topology_book_cpumask)
 static ssize_t show_cpumap(int type, const struct cpumask *mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
@@ -114,6 +115,14 @@ define_siblings_show_func(core_cpumask);
 define_one_ro_named(core_siblings, show_core_cpumask);
 define_one_ro_named(core_siblings_list, show_core_cpumask_list);
 
+#ifdef CONFIG_SCHED_BOOK
+define_id_show_func(book_id);
+define_one_ro(book_id);
+define_siblings_show_func(book_cpumask);
+define_one_ro_named(book_siblings, show_book_cpumask);
+define_one_ro_named(book_siblings_list, show_book_cpumask_list);
+#endif
+
 static struct attribute *default_attrs[] = {
 	&attr_physical_package_id.attr,
 	&attr_core_id.attr,
@@ -121,6 +130,11 @@ static struct attribute *default_attrs[]
 	&attr_thread_siblings_list.attr,
 	&attr_core_siblings.attr,
 	&attr_core_siblings_list.attr,
+#ifdef CONFIG_SCHED_BOOK
+	&attr_book_id.attr,
+	&attr_book_siblings.attr,
+	&attr_book_siblings_list.attr,
+#endif
 	NULL
 };
 

