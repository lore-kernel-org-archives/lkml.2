Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0D0O5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:57:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:52303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0D0O5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:57:50 -0400
From: Thomas Renninger <trenn@suse.de>
To: x86@kernel.org
Cc: linux-trace-users@vger.kernel.org, linux-perf-users@vger.kernel.org,
       robert.schoene@tu-dresden.de, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       Thomas Renninger <trenn@suse.de>, venki@google.com
Subject: [PATCH 1/2] acpi-cpufreq: Fix CPU_ANY CPUFREQ_{PRE,POST}CHANGE notification
Date: Tue, 27 Apr 2010 16:57:41 +0200
Message-Id: <1272380262-23671-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1272380262-23671-1-git-send-email-trenn@suse.de>
References: <1272380262-23671-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been found be review.
Currently PRE/POSTCHANGE events seem to only be thrown for one core
if the BIOS tells us to run in CPU_ANY mode (switching one/any
of the depending cores is enough).

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: venki@google.com
CC: davej@redhat.com
CC: linux-kernel@vger.kernel.org
CC: cpufreq@vger.kernel.org
CC: linux-perf-users@vger.kernel.org
CC: linux-trace-users@vger.kernel.org
CC: x86@kernel.org
CC: robert.schoene@tu-dresden.de
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4591680..c6de3a9 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -391,7 +391,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu(i, cmd.mask) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -407,7 +407,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	for_each_cpu(i, cmd.mask) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
-- 
1.6.3

