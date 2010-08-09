Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0HIP4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:56:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:15536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0HIP4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:56:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,344,1278313200"; 
   d="scan'208";a="645893599"
From: "Moore, Robert" <robert.moore@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Brown, Len" <len.brown@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 9 Aug 2010 08:56:28 -0700
Subject: RE: [PATCH] ACPI: Fix wrong atomicity check in preemption point
Thread-Topic: [PATCH] ACPI: Fix wrong atomicity check in preemption point
Thread-Index: Acs14gjWb/+Qm0wnSjGavtyVtQ6eDQB+VIfA
Message-ID: <4911F71203A09E4D9981D27F9D830858AC6DB2A6@orsmsx503.amr.corp.intel.com>
References: <1281152316-5907-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1281152316-5907-1-git-send-regression-fweisbec@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll be happy to include this in the aclinux.h file if the day ever comes when it is stable.


>-----Original Message-----
>From: Frederic Weisbecker [mailto:fweisbec@gmail.com]
>Sent: Friday, August 06, 2010 8:39 PM
>To: Brown, Len
>Cc: LKML; Frederic Weisbecker; Moore, Robert
>Subject: [PATCH] ACPI: Fix wrong atomicity check in preemption point
>
>The acpi preemption point checks the atomicity of the context
>using in_atomic_preempt_off(). This helper must be used only
>to check the atomicity before a prior call to preempt_disable(),
>which is not what we want here.
>
>What we want is to simply check if we are in an atomic section.
>This helper is actually only used by the scheduler for particular
>needs and shouldn't be used outside.
>
>The check made here is then always wrong. We will schedule only if
>preemption has been disabled once. It never has been a problem
>during the boot because premption is disabled and moreover the BKL
>is held, so we increase twice the preempt count. But now that
>we drop the bkl from the boot, the preempt count is only increased
>once, and then we schedule in the acpi preemption point while we
>shouldn't.
>
>In fact using such in_atomic*() like helpers is quite fragile to
>guess if we can schedule, but still, in_atomic() is less buggy than
>what was there before.
>
>This fixes:
>
>[    0.008086] BUG: scheduling while atomic: swapper/0/0x10000002
>[    0.008167] no locks held by swapper/0.
>[    0.008243] Modules linked in:
>[    0.008356] Pid: 0, comm: swapper Not tainted 2.6.35+ #793
>[    0.008437] Call Trace:
>[    0.008519]  [<ffffffff8106eab3>] ? __debug_show_held_locks+0x13/0x30
>[    0.008605]  [<ffffffff81039a65>] __schedule_bug+0x85/0x90
>[    0.008690]  [<ffffffff815edf20>] schedule+0x670/0x840
>[    0.008775]  [<ffffffff8129ff88>] ? acpi_os_release_object+0x9/0xd
>[    0.008860]  [<ffffffff812beca0>] ? acpi_ps_free_op+0x22/0x24
>[    0.008944]  [<ffffffff8103ccd5>] __cond_resched+0x25/0x40
>[    0.009008]  [<ffffffff815ee1ed>] _cond_resched+0x2d/0x40
>[    0.009091]  [<ffffffff812bdf4a>] acpi_ps_complete_op+0x292/0x2a8
>[    0.009174]  [<ffffffff812be7b6>] acpi_ps_parse_loop+0x856/0x9ac
>[    0.010008]  [<ffffffff812bd81d>] acpi_ps_parse_aml+0x9a/0x2b9
>[    0.010092]  [<ffffffff812bc048>] acpi_ns_one_complete_parse+0xfc/0x117
>[    0.010176]  [<ffffffff812bc07f>] acpi_ns_parse_table+0x1c/0x35
>[    0.010259]  [<ffffffff812b9606>] acpi_ns_load_table+0x4a/0x8c
>[    0.010343]  [<ffffffff812c075f>] acpi_load_tables+0xa0/0x164
>[    0.010429]  [<ffffffff819751e1>] ? acpi_initialize_subsystem+0x69/0x91
>[    0.010513]  [<ffffffff819740df>] acpi_early_init+0x6c/0xf7
>[    0.010598]  [<ffffffff8194fd68>] start_kernel+0x3b3/0x3fb
>[    0.010681]  [<ffffffff8194f26d>] x86_64_start_reservations+0x7d/0x89
>[    0.010765]  [<ffffffff8194f359>] x86_64_start_kernel+0xe0/0xf2
>
>Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>Cc: Bob Moore <robert.moore@intel.com>
>---
> include/acpi/platform/aclinux.h |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/include/acpi/platform/aclinux.h
>b/include/acpi/platform/aclinux.h
>index e5039a2..8da1e8c 100644
>--- a/include/acpi/platform/aclinux.h
>+++ b/include/acpi/platform/aclinux.h
>@@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t
>* cache)
> #include <linux/hardirq.h>
> #define ACPI_PREEMPTION_POINT() \
> 	do { \
>-		if (!in_atomic_preempt_off() && !irqs_disabled()) \
>+		if (!in_atomic() && !irqs_disabled()) \
> 			cond_resched(); \
> 	} while (0)
>
>--
>1.6.2.3

