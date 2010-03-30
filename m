Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0C3X5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:57:53 -0400
Received: from kroah.org ([198.145.64.141]:45593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab0C3XTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:15 2010
Message-Id: <20100330225715.375996152@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dimitri Sivanich <sivanich@sgi.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [115/116] x86: Fix sched_clock_cpu for systems with unsynchronized TSC
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dimitri Sivanich <sivanich@sgi.com>

commit 14be1f7454ea96ee614467a49cf018a1a383b189 upstream.

On UV systems, the TSC is not synchronized across blades.  The
sched_clock_cpu() function is returning values that can go
backwards  (I've seen as much as 8 seconds) when switching
between cpus.

As each cpu comes up, early_init_intel() will currently set the
sched_clock_stable flag true.  When mark_tsc_unstable() runs, it
clears the flag, but this only occurs once (the first time a cpu
comes up whose TSC is not synchronized with cpu 0).  After this,
early_init_intel() will set the flag again as the next cpu comes
up.

Only set sched_clock_stable if tsc has not been marked unstable.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100301174815.GC8224@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,8 @@ static void __cpuinit early_init_intel(s
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		sched_clock_stable = 1;
+		if (!check_tsc_unstable())
+			sched_clock_stable = 1;
 	}
 
 	/*


