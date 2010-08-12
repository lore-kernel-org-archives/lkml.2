Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738Ab0HLS0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:26:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0HLS0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k7kqQ6xMwNwntum7EgtRXZrAG28tHSxCWgrFuRj4ZnH3cCXZkaJUIq9tFpW+YPJSFV
         RQvd+Mn8dtD5SrLJSyB+04dkt7oPFrYUo4Bt/cnPZ7p51DuCz3H5n/gnA8CHMyRYvygE
         /uqILsrDbYrrgPliijxORMn5YoMJtd6rfq2e8=
Date: Thu, 12 Aug 2010 20:26:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: walt <w41ter@gmail.com>, Robert Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@yahoo-wildcard.a05.yahoodns.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BISECTED] Removing BKL causes stack trace during early bootup
Message-ID: <20100812182633.GB5369@nowhere>
References: <4C6438BF.9070608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6438BF.9070608@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding ACPI guys and LKML in Cc)

On Thu, Aug 12, 2010 at 11:09:03AM -0700, walt wrote:
> Hi guys.  This commit produces a non-fatal call trace very early during boot
> on my dual-CPU amd64 machine (but not on my single-CPU x86):
>
> commit 5e3d20a68f63fc5a310687d81956c3b96e488b84
> Author: Arnd Bergmann <arnd@xxxx.de>
> Date:   Sun Jul 4 00:02:26 2010 +0200
>
>     init: Remove the BKL from startup code
>
> The trace whizzes by so fast that I can't read it, and the trace doesn't appear
> in any of the logs.  Is there a way to capture such a trace, like maybe changing
> it to a fatal error?
>
> Thanks!
>


Hi,

Thanks for bisecting this.

May be it's about that:

[    0.008437] Call Trace:
[    0.008519]  [<ffffffff8106eab3>] ? __debug_show_held_locks+0x13/0x30
[    0.008605]  [<ffffffff81039a65>] __schedule_bug+0x85/0x90
[    0.008690]  [<ffffffff815edf20>] schedule+0x670/0x840
[    0.008775]  [<ffffffff8129ff88>] ? acpi_os_release_object+0x9/0xd
[    0.008860]  [<ffffffff812beca0>] ? acpi_ps_free_op+0x22/0x24
[    0.008944]  [<ffffffff8103ccd5>] __cond_resched+0x25/0x40
[    0.009008]  [<ffffffff815ee1ed>] _cond_resched+0x2d/0x40
[    0.009091]  [<ffffffff812bdf4a>] acpi_ps_complete_op+0x292/0x2a8
[    0.009174]  [<ffffffff812be7b6>] acpi_ps_parse_loop+0x856/0x9ac
[    0.010008]  [<ffffffff812bd81d>] acpi_ps_parse_aml+0x9a/0x2b9
[    0.010092]  [<ffffffff812bc048>] acpi_ns_one_complete_parse+0xfc/0x117
[    0.010176]  [<ffffffff812bc07f>] acpi_ns_parse_table+0x1c/0x35
[    0.010259]  [<ffffffff812b9606>] acpi_ns_load_table+0x4a/0x8c
[    0.010343]  [<ffffffff812c075f>] acpi_load_tables+0xa0/0x164
[    0.010429]  [<ffffffff819751e1>] ? acpi_initialize_subsystem+0x69/0x91
[    0.010513]  [<ffffffff819740df>] acpi_early_init+0x6c/0xf7
[    0.010598]  [<ffffffff8194fd68>] start_kernel+0x3b3/0x3fb
[    0.010681]  [<ffffffff8194f26d>] x86_64_start_reservations+0x7d/0x89
[    0.010765]  [<ffffffff8194f359>] x86_64_start_kernel+0xe0/0xf2


This is due to ACPI that does buggy checks and then sleeps too early.

I have sent a patch "ACPI: Fix wrong atomicity check in preemption point" and
now I wait for its inclusion.

I'm attaching it here.

Could you test it just to check it's about the same warning?
Otherwise we'll try some tricks to get the early boot messages :)

Thanks.

---
>From fweisbec@gmail.com Sat Aug  7 05:38:39 2010
Return-Path: <fweisbec@gmail.com>
Received: from localhost.localdomain (10.169.203-77.rev.gaoland.net [77.203.169.10])
        by mx.google.com with ESMTPS id i25sm1953266wbi.16.2010.08.06.20.38.38
        (version=SSLv3 cipher=RC4-MD5);
        Fri, 06 Aug 2010 20:38:39 -0700 (PDT)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH] ACPI: Fix wrong atomicity check in preemption point
Date: Sat,  7 Aug 2010 05:38:36 +0200
Message-Id: <1281152316-5907-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.

The acpi preemption point checks the atomicity of the context
using in_atomic_preempt_off(). This helper must be used only
to check the atomicity before a prior call to preempt_disable(),
which is not what we want here.

What we want is to simply check if we are in an atomic section.
This helper is actually only used by the scheduler for particular
needs and shouldn't be used outside.

The check made here is then always wrong. We will schedule only if
preemption has been disabled once. It never has been a problem
during the boot because premption is disabled and moreover the BKL
is held, so we increase twice the preempt count. But now that
we drop the bkl from the boot, the preempt count is only increased
once, and then we schedule in the acpi preemption point while we
shouldn't.

In fact using such in_atomic*() like helpers is quite fragile to
guess if we can schedule, but still, in_atomic() is less buggy than
what was there before.

This fixes:

[    0.008086] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.008167] no locks held by swapper/0.
[    0.008243] Modules linked in:
[    0.008356] Pid: 0, comm: swapper Not tainted 2.6.35+ #793
[    0.008437] Call Trace:
[    0.008519]  [<ffffffff8106eab3>] ? __debug_show_held_locks+0x13/0x30
[    0.008605]  [<ffffffff81039a65>] __schedule_bug+0x85/0x90
[    0.008690]  [<ffffffff815edf20>] schedule+0x670/0x840
[    0.008775]  [<ffffffff8129ff88>] ? acpi_os_release_object+0x9/0xd
[    0.008860]  [<ffffffff812beca0>] ? acpi_ps_free_op+0x22/0x24
[    0.008944]  [<ffffffff8103ccd5>] __cond_resched+0x25/0x40
[    0.009008]  [<ffffffff815ee1ed>] _cond_resched+0x2d/0x40
[    0.009091]  [<ffffffff812bdf4a>] acpi_ps_complete_op+0x292/0x2a8
[    0.009174]  [<ffffffff812be7b6>] acpi_ps_parse_loop+0x856/0x9ac
[    0.010008]  [<ffffffff812bd81d>] acpi_ps_parse_aml+0x9a/0x2b9
[    0.010092]  [<ffffffff812bc048>] acpi_ns_one_complete_parse+0xfc/0x117
[    0.010176]  [<ffffffff812bc07f>] acpi_ns_parse_table+0x1c/0x35
[    0.010259]  [<ffffffff812b9606>] acpi_ns_load_table+0x4a/0x8c
[    0.010343]  [<ffffffff812c075f>] acpi_load_tables+0xa0/0x164
[    0.010429]  [<ffffffff819751e1>] ? acpi_initialize_subsystem+0x69/0x91
[    0.010513]  [<ffffffff819740df>] acpi_early_init+0x6c/0xf7
[    0.010598]  [<ffffffff8194fd68>] start_kernel+0x3b3/0x3fb
[    0.010681]  [<ffffffff8194f26d>] x86_64_start_reservations+0x7d/0x89
[    0.010765]  [<ffffffff8194f359>] x86_64_start_kernel+0xe0/0xf2

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Bob Moore <robert.moore@intel.com>
---
 include/acpi/platform/aclinux.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index e5039a2..8da1e8c 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 #include <linux/hardirq.h>
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off() && !irqs_disabled()) \
+		if (!in_atomic() && !irqs_disabled()) \
 			cond_resched(); \
 	} while (0)
 
-- 
1.6.2.3


