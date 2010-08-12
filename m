Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084Ab0HLXIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 19:08:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091Ab0HLXIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 19:08:09 -0400
Date: Thu, 12 Aug 2010 16:08:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Brown, Len" <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Fix wrong atomicity check in preemption point
Message-Id: <20100812160804.3578a724.akpm@linux-foundation.org>
In-Reply-To: <4911F71203A09E4D9981D27F9D830858AC6DB2A6@orsmsx503.amr.corp.intel.com>
References: <1281152316-5907-1-git-send-regression-fweisbec@gmail.com>
	<4911F71203A09E4D9981D27F9D830858AC6DB2A6@orsmsx503.amr.corp.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010 08:56:28 -0700
"Moore, Robert" <robert.moore@intel.com> wrote:

> >-----Original Message-----
> >From: Frederic Weisbecker [mailto:fweisbec@gmail.com]
> >Sent: Friday, August 06, 2010 8:39 PM
> >To: Brown, Len
> >Cc: LKML; Frederic Weisbecker; Moore, Robert
> >Subject: [PATCH] ACPI: Fix wrong atomicity check in preemption point
> >
> >The acpi preemption point checks the atomicity of the context
> >using in_atomic_preempt_off(). This helper must be used only
> >to check the atomicity before a prior call to preempt_disable(),
> >which is not what we want here.
> >
> >What we want is to simply check if we are in an atomic section.
> >This helper is actually only used by the scheduler for particular
> >needs and shouldn't be used outside.
> >
> >The check made here is then always wrong. We will schedule only if
> >preemption has been disabled once. It never has been a problem
> >during the boot because premption is disabled and moreover the BKL
> >is held, so we increase twice the preempt count. But now that
> >we drop the bkl from the boot, the preempt count is only increased
> >once, and then we schedule in the acpi preemption point while we
> >shouldn't.
> >
> >In fact using such in_atomic*() like helpers is quite fragile to
> >guess if we can schedule, but still, in_atomic() is less buggy than
> >what was there before.
> >
> >This fixes:
> >
> >[    0.008086] BUG: scheduling while atomic: swapper/0/0x10000002
> >[    0.008167] no locks held by swapper/0.
> >[    0.008243] Modules linked in:
> >[    0.008356] Pid: 0, comm: swapper Not tainted 2.6.35+ #793
> >[    0.008437] Call Trace:
> >[    0.008519]  [<ffffffff8106eab3>] ? __debug_show_held_locks+0x13/0x30
> >[    0.008605]  [<ffffffff81039a65>] __schedule_bug+0x85/0x90
> >[    0.008690]  [<ffffffff815edf20>] schedule+0x670/0x840
> >[    0.008775]  [<ffffffff8129ff88>] ? acpi_os_release_object+0x9/0xd
> >[    0.008860]  [<ffffffff812beca0>] ? acpi_ps_free_op+0x22/0x24
> >[    0.008944]  [<ffffffff8103ccd5>] __cond_resched+0x25/0x40
> >[    0.009008]  [<ffffffff815ee1ed>] _cond_resched+0x2d/0x40
> >[    0.009091]  [<ffffffff812bdf4a>] acpi_ps_complete_op+0x292/0x2a8
> >[    0.009174]  [<ffffffff812be7b6>] acpi_ps_parse_loop+0x856/0x9ac
> >[    0.010008]  [<ffffffff812bd81d>] acpi_ps_parse_aml+0x9a/0x2b9
> >[    0.010092]  [<ffffffff812bc048>] acpi_ns_one_complete_parse+0xfc/0x117
> >[    0.010176]  [<ffffffff812bc07f>] acpi_ns_parse_table+0x1c/0x35
> >[    0.010259]  [<ffffffff812b9606>] acpi_ns_load_table+0x4a/0x8c
> >[    0.010343]  [<ffffffff812c075f>] acpi_load_tables+0xa0/0x164
> >[    0.010429]  [<ffffffff819751e1>] ? acpi_initialize_subsystem+0x69/0x91
> >[    0.010513]  [<ffffffff819740df>] acpi_early_init+0x6c/0xf7
> >[    0.010598]  [<ffffffff8194fd68>] start_kernel+0x3b3/0x3fb
> >[    0.010681]  [<ffffffff8194f26d>] x86_64_start_reservations+0x7d/0x89
> >[    0.010765]  [<ffffffff8194f359>] x86_64_start_kernel+0xe0/0xf2
> >
>
> I'll be happy to include this in the aclinux.h file if the day ever comes when it is stable.
> 
> 

(top-posting repaired.  Please don't.)

Linus merged the below fix yesterday.  It's tagged for -stable
backporting.  


From: Thomas Gleixner <tglx@linutronix.de>

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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/erst.c        |    1 +
 include/acpi/platform/aclinux.h |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/apei/erst.c~acpi-fix-bogus-preemption-logic drivers/acpi/apei/erst.c
--- a/drivers/acpi/apei/erst.c~acpi-fix-bogus-preemption-logic
+++ a/drivers/acpi/apei/erst.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/cper.h>
 #include <linux/nmi.h>
+#include <linux/hardirq.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
diff -puN include/acpi/platform/aclinux.h~acpi-fix-bogus-preemption-logic include/acpi/platform/aclinux.h
--- a/include/acpi/platform/aclinux.h~acpi-fix-bogus-preemption-logic
+++ a/include/acpi/platform/aclinux.h
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
 
_

