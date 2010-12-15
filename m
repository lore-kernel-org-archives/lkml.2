Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0LOB6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:58:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:34883 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0LOB6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:58:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,345,1288594800"; 
   d="scan'208";a="636405468"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D073FA9.9020801@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
	 <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>
	 <4D073FA9.9020801@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 09:57:48 +0800
Message-ID: <1292378268.2323.464.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 17:58 +0800, Tejun Heo wrote:
> Hello,
> 
> On 12/14/2010 02:08 AM, Shaohua Li wrote:
> > I don't understand what you mean. defining a cachine line size macro
> > for all archs? There is such macro, but using it in vmlinux.ld.h
> > always report error. There is some other defines which can't be
> > included in a link script.
> 
> I haven't really looked through it but wouldn't it be possible to
> ifdef it.  ie. if cacheline macro is available, align it to it;
> otherwise, don't.  And, ultimately, the correct thing to do is making
> it cacheline aligned on all archs.  There can be several different
> ways to get there but it might just as well be making cacheline size
> available in all archs first and then update the PERCPU macro.
How about this one?

Subject: Make x86 percpu readmostly section correctly aligned

percpu readmostly section should start and end at address cachline aligned to
avoid cache false sharing. For ARCHs care about the cache false sharing,
they should define INTERNODE_CACHE_BYTES. We use it to do the alignment.
Currently only x86 has percpu readmostly section, so only changed it so far.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/kernel/vmlinux.lds.S     |    2 +-
 include/asm-generic/vmlinux.lds.h |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux.orig/include/asm-generic/vmlinux.lds.h	2010-12-15 09:27:26.000000000 +0800
+++ linux/include/asm-generic/vmlinux.lds.h	2010-12-15 09:55:22.000000000 +0800
@@ -665,6 +665,13 @@
 	*(.discard.*)							\
 	}
 
+#ifdef INTERNODE_CACHE_BYTES
+#define INTERNODE_CACHEALIGNED						\
+	. = ALIGN(INTERNODE_CACHE_BYTES);
+#else
+#define INTERNODE_CACHEALIGNED
+#endif
+
 /**
  * PERCPU_VADDR - define output section for percpu area
  * @vaddr: explicit base address (optional)
@@ -692,7 +699,9 @@
 		*(.data..percpu..first)					\
 		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		INTERNODE_CACHEALIGNED					\
 		*(.data..percpu..readmostly)				\
+		INTERNODE_CACHEALIGNED					\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
@@ -720,7 +729,9 @@
 		*(.data..percpu..first)					\
 		. = ALIGN(PAGE_SIZE);					\
 		*(.data..percpu..page_aligned)				\
+		INTERNODE_CACHEALIGNED					\
 		*(.data..percpu..readmostly)				\
+		INTERNODE_CACHEALIGNED					\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
Index: linux/arch/x86/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:01.000000000 +0800
+++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:06.000000000 +0800
@@ -20,11 +20,11 @@
 #define LOAD_OFFSET __START_KERNEL_map
 #endif
 
-#include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/page_types.h>
 #include <asm/cache.h>
+#include <asm-generic/vmlinux.lds.h>
 #include <asm/boot.h>
 
 #undef i386     /* in case the preprocessor is a 32bit one */


