Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0IITrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:47:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:40825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0IITrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:47:31 -0400
Date: Thu, 9 Sep 2010 19:46:55 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100831082844.435648457@de.ibm.com>
References: <20100831082844.435648457@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] topology/sysfs: Provide book id and siblings attributes
Message-ID: <tip-b40d8ed4e42c79f8ed1cf345eed0888f4a2f0678@git.kernel.org>
Git-Commit-ID: b40d8ed4e42c79f8ed1cf345eed0888f4a2f0678
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:46:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b40d8ed4e42c79f8ed1cf345eed0888f4a2f0678
Gitweb:     http://git.kernel.org/tip/b40d8ed4e42c79f8ed1cf345eed0888f4a2f0678
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Tue, 31 Aug 2010 10:28:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:41:25 +0200

topology/sysfs: Provide book id and siblings attributes

Create attributes:

 /sys/devices/system/cpu/cpuX/topology/book_id
 /sys/devices/system/cpu/cpuX/topology/book_siblings

which show the book id and the book siblings of a cpu.

Unlike the attributes for SMT and MC these attributes are only present if
CONFIG_SCHED_BOOK is set. There is no reason to pollute sysfs for every
architecture with unused attributes.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100831082844.435648457@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/cputopology.txt |   23 ++++++++++++++++++++---
 drivers/base/topology.c       |   16 +++++++++++++++-
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/Documentation/cputopology.txt b/Documentation/cputopology.txt
index f1c5c4b..902d315 100644
--- a/Documentation/cputopology.txt
+++ b/Documentation/cputopology.txt
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
@@ -45,6 +59,9 @@ not defined by include/asm-XXX/topology.h:
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
 
+For architectures that don't support books (CONFIG_SCHED_BOOK) there are no
+default definitions for topology_book_id() and topology_book_cpumask().
+
 Additionally, CPU topology information is provided under
 /sys/devices/system/cpu and includes these files.  The internal
 source for the output is in brackets ("[]").
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index 9fc630c..f6f37a0 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -45,7 +45,8 @@ static ssize_t show_##name(struct sys_device *dev,		\
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
@@ -121,6 +130,11 @@ static struct attribute *default_attrs[] = {
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
 
