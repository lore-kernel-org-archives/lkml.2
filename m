Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0JTXHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:07:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:37461 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0JTXHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:21 -0400
Date: Wed, 20 Oct 2010 23:06:59 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, shaohua.li@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, tglx@linutronix.de, shaohua.li@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
Message-ID: <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
Git-Commit-ID: c957ef2c59e952803766ddc22e89981ab534606f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 23:06:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c957ef2c59e952803766ddc22e89981ab534606f
Gitweb:     http://git.kernel.org/tip/c957ef2c59e952803766ddc22e89981ab534606f
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Wed, 20 Oct 2010 11:07:02 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Oct 2010 14:33:58 -0700

percpu: Introduce a read-mostly percpu API

Add a new readmostly percpu section and API.  This can be used to
avoid dirtying data lines which are generally not written to, which is
especially important for data which may be accessed by processors
other than the one for which the percpu area belongs to.

[ hpa: moved it *after* the page-aligned section, for obvious
  reasons. ]

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/asm-generic/vmlinux.lds.h |    4 ++++
 include/linux/percpu-defs.h       |    9 +++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8a92a17..d7e7b21 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -677,7 +677,9 @@
 				- LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
@@ -703,6 +705,8 @@
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
+		. = ALIGN(PAGE_SIZE);					\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu..page_aligned)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index ce2dc65..27ef6b1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -139,6 +139,15 @@
 	__aligned(PAGE_SIZE)
 
 /*
+ * Declaration/definition used for per-CPU variables that must be read mostly.
+ */
+#define DECLARE_PER_CPU_READ_MOSTLY(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, "..readmostly")
+
+#define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
+
+/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
