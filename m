Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab2BJOq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:46:58 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24688 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089Ab2BJOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:46:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/cpu: Make VCPU hotplug code online CPUs properly.
Date: Fri, 10 Feb 2012 09:43:53 -0500
Message-Id: <1328885033-8450-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1328885033-8450-1-git-send-email-konrad.wilk@oracle.com>
References: <1328885033-8450-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F352DDE.010E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offlining CPUs works. Onlining does not work anymore and it looks
like we were missing a cpu_up() call in the hotplug bring up path.

When the vCPUs are initialized, if they are onlined or never had
been in use (so maxcpus > vcpus) the vCPUs are in xen_play_dead
having called VCPUOP_down and are not running. When a vCPU is
onlined, the bootup (or any other currently running CPU) is suppose
to call VCPUOP_up on the vCPU that is not running and make the
vCPU unhinge itself out of the xen_play_dead and continue in
cpu_idle. We did not make the hypercall on onlining, nor did we
recreate the timer, spinlocks, ipi interrupts so the vCPU never
was onlined. This patch fixes it by calling cpu_on() and we
also make the code more readable.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/cpu_hotplug.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 4dcfced..df80af8 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -8,18 +8,20 @@
 
 static void enable_hotplug_cpu(int cpu)
 {
-	if (!cpu_present(cpu))
+	if (!cpu_present(cpu)) {
 		arch_register_cpu(cpu);
-
-	set_cpu_present(cpu, true);
+		set_cpu_present(cpu, true);
+		(void)cpu_up(cpu);
+	}
 }
 
 static void disable_hotplug_cpu(int cpu)
 {
-	if (cpu_present(cpu))
+	if (cpu_present(cpu)) {
+		(void)cpu_down(cpu);
+		set_cpu_present(cpu, false);
 		arch_unregister_cpu(cpu);
-
-	set_cpu_present(cpu, false);
+	}
 }
 
 static int vcpu_online(unsigned int cpu)
@@ -53,7 +55,6 @@ static void vcpu_hotplug(unsigned int cpu)
 		enable_hotplug_cpu(cpu);
 		break;
 	case 0:
-		(void)cpu_down(cpu);
 		disable_hotplug_cpu(cpu);
 		break;
 	default:
-- 
1.7.7.5

