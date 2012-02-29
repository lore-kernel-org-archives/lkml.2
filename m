Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab2B2PnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:43:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13803 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2B2PnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:43:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 Feb 2012 07:42:47 -0800
Date: Wed, 29 Feb 2012 17:42:29 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/10] Add tegra30 support for secondary cores
Message-ID: <20120229154229.GL12917@tbergstrom-lnx.Nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Feb 15, 2012 at 10:27:43PM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Thursday, February 09, 2012 4:48 PM:
> > This patchset introduces support for secondary cores on tegra30. It also
> > introduces some functions for the flowcontroller and adds basic support for
> > tegra30 powerdomains.
> 
> The code looks fine to me. I do notice the following when running
> "shutdown -h now":
> 
> [   27.762124] SMP: failed to stop secondary CPUs
> 
> So, this patch series makes the secondary cores boot OK, but not shut
> down it appears. Is that expected? It's probably something we can fix
> with a following on patch rather than re-spinning this series though?
> 

I spent some more time looking at this. It appears that nr_online_cpus isn't
always updated properly. I added an extra pr_warn() when the failure happens
and I got:

[   22.369815] Restarting system.
[   23.506792] SMP: failed to stop secondary CPUs
[   23.511535] running on CPU: 3, still online: 2, mask: 8

I also did some function tracing and all CPUs besides the one initiating the
halt reach platform_cpu_kill() about 50us after sending the IPIs to stop them.
The set_cpu_online() call in ipi_cpu_stop() should update nr_online_cpus, but
somehow this doesn't always happen. Any insight on what might be going on?

Instrumentation patch attached.

Cheers,

Peter.


--QRj9sO5tAVLaXnSD
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-ARM-debugging-smp_send_stop.patch"

>From d871feda574bd9f626f175be403cabd308ca18c0 Mon Sep 17 00:00:00 2001
From: Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Wed, 29 Feb 2012 17:37:27 +0200
Subject: [PATCH] ARM: debugging smp_send_stop
X-NVConfidentiality: public

Change-Id: Ia4f33b054f2eccf173a3d977686e1577e2146b92
---
 arch/arm/kernel/smp.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 3e43c5f..e0e5eea 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -570,6 +570,7 @@ void smp_send_reschedule(int cpu)
 void smp_send_stop(void)
 {
 	unsigned long timeout;
+	int cpu = smp_processor_id();
 
 	if (num_online_cpus() > 1) {
 		cpumask_t mask = cpu_online_map;
@@ -583,8 +584,12 @@ void smp_send_stop(void)
 	while (num_online_cpus() > 1 && timeout--)
 		udelay(1);
 
-	if (num_online_cpus() > 1)
+	if (num_online_cpus() > 1) {
+		char cpu_mask[10];
 		pr_warning("SMP: failed to stop secondary CPUs\n");
+		cpumask_scnprintf(cpu_mask, sizeof(cpu_mask), cpu_online_mask);
+		pr_warn("running on CPU: %d, still online: %d, mask: %s\n", cpu, num_online_cpus(), cpu_mask);
+	}
 }
 
 /*
-- 
1.7.7.rc0.72.g4b5ea.dirty


--QRj9sO5tAVLaXnSD--
