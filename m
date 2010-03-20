Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0CTRg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:36:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0CTRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:36:56 -0400
Subject: Re: [Regression, post-2.6.34-rc1][PATCH] x86 / perf: Fix suspend
 to RAM on HP nx6325
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201003201507.15358.rjw@sisk.pl>
References: <201003201507.15358.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 18:36:49 +0100
Message-ID: <1269106609.9440.529.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 15:07 +0100, Rafael J. Wysocki wrote:
> Hi Peter,
> 
> Your commit 3f6da3905398826d85731247e7fbcf53400c18bd
> (perf: Rework and fix the arch CPU-hotplug hooks) unfortunately broke suspend
> to RAM (probably hibernation too, but I haven't checked) on my HP nx6325.
> I also expect more (if not all) AMD-based boxes to be broken by it.
> 
> The machine simply hangs solid while trying to disable CPU1 during suspend.
> 
> The patch below fixes it, although I'm not exactly sure why calling
> amd_pmu_cpu_offline() during suspend causes the hang to happen.  If there's a
> better way to fix this, please let me know.

Hrmm, I'll have a poke at my AMD once I'm back home again, but does
something like the below cure things for you?

---
 arch/x86/kernel/cpu/perf_event_amd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 358a8e3..0189af4 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -345,6 +345,8 @@ static void amd_pmu_cpu_offline(int cpu)
 		return;
 
 	cpuhw = &per_cpu(cpu_hw_events, cpu);
+	if (!cpuhw)
+		return;
 
 	raw_spin_lock(&amd_nb_lock);
 


