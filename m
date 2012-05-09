Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2EIGOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:14:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055043.173327090@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 097/167] [PATCH] xen/smp: Fix crash when booting with ACPI hotplug CPUs.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit cf405ae612b0f7e2358db7ff594c0e94846137aa upstream.

When we boot on a machine that can hotplug CPUs and we
are using 'dom0_max_vcpus=X' on the Xen hypervisor line
to clip the amount of CPUs available to the initial domain,
we get this:

(XEN) Command line: com1=115200,8n1 dom0_mem=8G noreboot dom0_max_vcpus=8 sync_console mce_verbosity=verbose console=com1,vga loglvl=all guest_loglvl=all
.. snip..
DMI: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.99.99.x032.072520111118 07/25/2011
.. snip.
SMP: Allowing 64 CPUs, 32 hotplug CPUs
installing Xen timer for CPU 7
cpu 7 spinlock event irq 361
NMI watchdog: disabled (cpu7): hardware events not enabled
Brought up 8 CPUs
.. snip..
	[acpi processor finds the CPUs are not initialized and starts calling
	arch_register_cpu, which creates /sys/devices/system/cpu/cpu8/online]
CPU 8 got hotplugged
CPU 9 got hotplugged
CPU 10 got hotplugged
.. snip..
initcall 1_acpi_battery_init_async+0x0/0x1b returned 0 after 406 usecs
calling  erst_init+0x0/0x2bb @ 1

	[and the scheduler sticks newly started tasks on the new CPUs, but
	said CPUs cannot be initialized b/c the hypervisor has limited the
	amount of vCPUS to 8 - as per the dom0_max_vcpus=8 flag.
	The spinlock tries to kick the other CPU, but the structure for that
	is not initialized and we crash.]
BUG: unable to handle kernel paging request at fffffffffffffed8
IP: [<ffffffff81035289>] xen_spin_lock+0x29/0x60
PGD 180d067 PUD 180e067 PMD 0
Oops: 0002 [#1] SMP
CPU 7
Modules linked in:

Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc2upstream-00001-gf5154e8 #1 Intel Corporation S2600CP/S2600CP
RIP: e030:[<ffffffff81035289>]  [<ffffffff81035289>] xen_spin_lock+0x29/0x60
RSP: e02b:ffff8801fb9b3a70  EFLAGS: 00010282

With this patch, we cap the amount of vCPUS that the initial domain
can run, to exactly what dom0_max_vcpus=X has specified.

In the future, if there is a hypercall that will allow a running
domain to expand past its initial set of vCPUS, this patch should
be re-evaluated.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/smp.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 5fac691..0503c0c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -178,6 +178,7 @@ static void __init xen_fill_possible_map(void)
 static void __init xen_filter_cpu_maps(void)
 {
 	int i, rc;
+	unsigned int subtract = 0;
 
 	if (!xen_initial_domain())
 		return;
@@ -192,8 +193,22 @@ static void __init xen_filter_cpu_maps(void)
 		} else {
 			set_cpu_possible(i, false);
 			set_cpu_present(i, false);
+			subtract++;
 		}
 	}
+#ifdef CONFIG_HOTPLUG_CPU
+	/* This is akin to using 'nr_cpus' on the Linux command line.
+	 * Which is OK as when we use 'dom0_max_vcpus=X' we can only
+	 * have up to X, while nr_cpu_ids is greater than X. This
+	 * normally is not a problem, except when CPU hotplugging
+	 * is involved and then there might be more than X CPUs
+	 * in the guest - which will not work as there is no
+	 * hypercall to expand the max number of VCPUs an already
+	 * running guest has. So cap it up to X. */
+	if (subtract)
+		nr_cpu_ids = nr_cpu_ids - subtract;
+#endif
+
 }
 
 static void __init xen_smp_prepare_boot_cpu(void)
-- 
1.7.10



