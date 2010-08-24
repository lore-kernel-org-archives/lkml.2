Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab0HXXZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:25:03 -0400
Received: from kroah.org ([198.145.64.141]:40769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab0HXXBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:03 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:01 2010
Message-Id: <20100824224501.542494112@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Francois Valenduc <francois.valenduc@tvcablenet.be>,
        Lin Ming <ming.m.lin@intel.com>
Subject: [003/114] acpi: fix bogus preemption logic
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0a7992c90828a65281c3c9cf180be3b432d277b2 upstream.

The ACPI_PREEMPTION_POINT() logic was introduced in commit 8bd108d
(ACPICA: add preemption point after each opcode parse).  The follow up
commits abe1dfab6, 138d15692, c084ca70 tried to fix the preemption logic
back and forth, but nobody noticed that the usage of
in_atomic_preempt_off() in that context is wrong.

The check which guards the call of cond_resched() is:

    if (!in_atomic_preempt_off() && !irqs_disabled())

in_atomic_preempt_off() is not intended for general use as the comment
above the macro definition clearly says:

 * Check whether we were atomic before we did preempt_disable():
 * (used by the scheduler, *after* releasing the kernel lock)

On a CONFIG_PREEMPT=n kernel the usage of in_atomic_preempt_off() works by
accident, but with CONFIG_PREEMPT=y it's just broken.

The whole purpose of the ACPI_PREEMPTION_POINT() is to reduce the latency
on a CONFIG_PREEMPT=n kernel, so make ACPI_PREEMPTION_POINT() depend on
CONFIG_PREEMPT=n and remove the in_atomic_preempt_off() check.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16210

[akpm@linux-foundation.org: fix build]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Francois Valenduc <francois.valenduc@tvcablenet.be>
Cc: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/apei/erst.c        |    1 +
 include/acpi/platform/aclinux.h |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/cper.h>
 #include <linux/nmi.h>
+#include <linux/hardirq.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -148,13 +148,17 @@ static inline void *acpi_os_acquire_obje
 #define ACPI_ALLOCATE_ZEROED(a) acpi_os_allocate_zeroed(a)
 #define ACPI_FREE(a)            kfree(a)
 
-/* Used within ACPICA to show where it is safe to preempt execution */
-#include <linux/hardirq.h>
+#ifndef CONFIG_PREEMPT
+/*
+ * Used within ACPICA to show where it is safe to preempt execution
+ * when CONFIG_PREEMPT=n
+ */
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off() && !irqs_disabled()) \
+		if (!irqs_disabled()) \
 			cond_resched(); \
 	} while (0)
+#endif
 
 #endif /* __KERNEL__ */
 


