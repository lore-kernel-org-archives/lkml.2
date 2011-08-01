Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1HAXYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:24:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1HAXYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.312661542@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [17/70] ARM: 6989/1: perf: do not start the PMU when no events are present
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f4f38430c94c38187db73a2cf3892cc8b12a2713 upstream.

armpmu_enable can be called in situations where no events are present
(for example, from the event rotation tick after a profiled task has
exited). In this case, we currently start the PMU anyway which may
leave it active inevitably without any events being monitored.

This patch adds a simple check to the enabling code so that we avoid
starting the PMU when no events are present.

Reported-by: Ashwin Chaugle <ashwinc@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/perf_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -588,7 +588,7 @@ static int armpmu_event_init(struct perf
 static void armpmu_enable(struct pmu *pmu)
 {
 	/* Enable all of the perf events on hardware. */
-	int idx;
+	int idx, enabled = 0;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	if (!armpmu)
@@ -601,9 +601,11 @@ static void armpmu_enable(struct pmu *pm
 			continue;
 
 		armpmu->enable(&event->hw, idx);
+		enabled = 1;
 	}
 
-	armpmu->start();
+	if (enabled)
+		armpmu->start();
 }
 
 static void armpmu_disable(struct pmu *pmu)


