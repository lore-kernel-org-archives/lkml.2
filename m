Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2DMSV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:21:28 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:16570 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2DMSVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:21:08 -0400
X-IronPort-AV: E=Sophos;i="4.75,418,1330905600"; 
   d="scan'208";a="11932575"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xensource.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tim Deegan <tim@xen.org>, Jan Beulich <jbeulich@suse.com>,
        Sheng Yang <sheng@yasker.org>
Subject: [PATCH] xen: always set the sched clock as unstable
Date: Fri, 13 Apr 2012 19:20:55 +0100
Message-ID: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The sched clock was considered stable based on the capabilities of the
underlying hardware.  This does not make sense for Xen PV guests as:
a) the hardware TSC is not used directly as the clock source; and b)
guests may migrate to hosts with different hardware capabilities.

It is not clear to me whether the Xen clock source is supposed to be
stable and whether it should be stable across migration.  For a clock
source to be stable it must be: a) monotonic; c) synchronized across
CPUs; and c) constant rate.

There have also been reports of systems with apparently unstable
clocks where clearing sched_clock_stable has fixed problems with
migrated VMs hanging.

So, always set the sched clock as unstable when using the Xen clock
source.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0296a95..8469b5a 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -473,6 +473,7 @@ static void __init xen_time_init(void)
 	do_settimeofday(&tp);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
+	sched_clock_stable = 0;
 
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
-- 
1.7.2.5

