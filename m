Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab2BPDOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:14:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854Ab2BPDOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:14:54 -0500
Date: Wed, 15 Feb 2012 22:14:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
        seiji.aguchi@hds.com, ak@linux.intel.com, mjg@redhat.com,
        levinsasha928@gmail.com
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
Message-ID: <20120216031441.GU9751@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
 <1329164860-668-3-git-send-email-dzickus@redhat.com>
 <1329305197.2293.50.camel@twins>
 <20120215145429.GE9751@redhat.com>
 <1329317835.2293.133.camel@twins>
 <20120215155708.GK9751@redhat.com>
 <1329328787.2293.173.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329328787.2293.173.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 06:59:47PM +0100, Peter Zijlstra wrote:
> > > The only way is to unplug all cpus except the one. Problem with that is
> > > that we cannot (as of yet) unplug the boot cpu.
> > 
> > Yeah, well we can migrate to the boot cpu.  I think powerpc does that for
> > kdump.
> 
> Right, there's that.

Well we are in luck, migrating to cpu0 is already done in the shutdown
path.

arch/x86/kernel/reboot.c::native_machine_shutdown:662
	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));

Now most of the time it seems to be cpu0, but I guess corner cases can put
it elsewhere.  I replaced 'stop_other_cpus' with 'for_each_online_cpu(cpu)
{ cpu_down(cpu) }.  And things seemed to work.  Output below, patch below
that:

=====================
Please stand by while rebooting the system...
[  101.470240] md: stopping all md devices.
[  101.474346] kvm: exiting hardware virtualization
[  101.480071] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[  101.535977] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  101.643479] Restarting system.
[  101.646624] machine restart
[  101.649501] DONDON: on cpu2
[  101.652502] DONDON: on new cpu0
[  101.658397] Broke affinity for irq 42
[  101.662168] Broke affinity for irq 47
[  101.669281] bnx2fc: CPU 1 offline: Remove Rx thread
[  101.674381] CPU 1 offline: Remove Rx thread
[  101.680595] Broke affinity for irq 22
[  101.686510] bnx2fc: CPU 2 offline: Remove Rx thread
[  101.691569] CPU 2 offline: Remove Rx thread
[  101.697260] Broke affinity for irq 16
[  101.702057] lockdep: fixing up alternatives.
[  101.706476] SMP alternatives: switching to UP code
[  101.720162] bnx2fc: CPU 3 offline: Remove Rx thread
[  101.725206] CPU 3 offline: Remove Rx thread
====================

Does that work for you?

Cheers,
Don

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d840e69..c3569ac 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -644,6 +644,7 @@ void native_machine_shutdown(void)
 
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
+	int cpu;
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
@@ -652,17 +653,24 @@ void native_machine_shutdown(void)
 		reboot_cpu_id = reboot_cpu;
 #endif
 
+	printk("DONDON: on cpu%d\n", smp_processor_id());
 	/* Make certain the cpu I'm about to reboot on is online */
 	if (!cpu_online(reboot_cpu_id))
 		reboot_cpu_id = smp_processor_id();
 
 	/* Make certain I only run on the appropriate processor */
 	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+	printk("DONDON: on new cpu%d\n", smp_processor_id());
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
-	stop_other_cpus();
+	//stop_other_cpus();
+	for_each_online_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+		cpu_down(cpu);
+	}
 #endif
 
 	lapic_shutdown();
