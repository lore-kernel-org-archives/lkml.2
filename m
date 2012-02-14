Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2BNFKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:10:05 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37159 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2BNFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:10:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, JBeulich@novell.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC] acpi processor and cpufreq harester - aka pipe all of that up to the hypervisor (v3) 
Date: Tue, 14 Feb 2012 00:06:46 -0500
Message-Id: <1329196009-25268-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F39ECA2.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog [v3:]
 - new name and decided to put it in drivers/xen since it uses APIs from both cpufreq and acpi.
 - updated to expose MWAIT capability
 - cleaned up the code a bit.
[since v2 - not posted]:
 - change the name to processor_passthrough_xen and move it to drivers/acpi
 - make it launch a thread, support CPU hotplug
[since v1: http://comments.gmane.org/gmane.linux.acpi.devel/51862]
 - initial posting.

The problem these three patches try to solve is to provide ACPI power management
information to the hypervisor. The hypervisor lacks the ACPI DSDT parser so it can't
get that data without some help - and the initial domain can provide that. One
approach (https://lkml.org/lkml/2011/11/30/245) augments the ACPI code to call
an external PM code - but there were no comments about it so I decided to see
if another approach could solve it.

This "harvester" (I am horrible with names, if you have any suggestions please
tell me them) collects the information that the cpufreq drivers and the
ACPI processor code save in the 'struct acpi_processor' and then sends it to
the hypervisor.

The driver can be either an module or compiled in. In either mode the driver
launches a thread that checks whether an cpufreq driver is registered. If so
it reads all the 'struct acpi_processor' data for all online CPUs and sends
it to hypervisor. The driver also register a CPU hotplug component - so if a new
CPU shows up - it would send the data to the hypervisor for it as well.

I've tested this with success on a variety of Intel and AMD hardware (need
a patch to the hypervisor to allow the rdmsr to be passed through). The one
caveat is that dom0_max_vcpus inhibits the driver from reading the vCPUs
that are not present in dom0. One solution is to boot without dom0_max_vcpus
and utilize the 'xl vcpu-set' command to offline the vCPUs. Other one that
Nakajima Jun suggested was to hotplug vCPUS in - so bootup dom0 and hotplug
the vCPUs in - but I am running in difficulties on how to do this in the hypervisor.

Konrad Rzeszutek Wilk (3):
      xen/setup/pm/acpi: Remove the call to boot_option_idle_override.
      xen/enlighten: Expose MWAIT and MWAIT_LEAF if hypervisor OKs it.
      xen/acpi/cpufreq: Provide an driver that passes struct acpi_processor data to the hypervisor.

 arch/x86/xen/enlighten.c         |   92 +++++++++-
 arch/x86/xen/setup.c             |    1 -
 drivers/xen/Kconfig              |   14 ++
 drivers/xen/Makefile             |    2 +-
 drivers/xen/processor-harvest.c  |  397 ++++++++++++++++++++++++++++++++++++++
 include/xen/interface/platform.h |    4 +-
 6 files changed, 506 insertions(+), 4 deletions(-)


Oh, and the hypervisor patch to make this work under AMD:
# HG changeset patch
# Parent 9ad1e42c341bc78463b6f6610a6300f75b535fbb
traps: AMD PM MSRs (MSR_K8_PSTATE_CTRL, etc)

The restriction to read and write the AMD power management MSRs is gated if the
domain 0 is the PM domain (so FREQCTL_dom0_kernel is set). But we can
relax this restriction and allow the privileged domain to read the MSRs
(but not write). This allows the priviliged domain to harvest the power
management information (ACPI _PSS states) and send it to the hypervisor.

TODO: Have not tested on K7 machines.
TODO: Have not tested this with XenOLinux 2.6.32 dom0 on AMD machines.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff -r 9ad1e42c341b xen/arch/x86/traps.c
--- a/xen/arch/x86/traps.c	Fri Feb 10 17:24:50 2012 +0000
+++ b/xen/arch/x86/traps.c	Mon Feb 13 23:11:59 2012 -0500
@@ -2457,7 +2457,7 @@ static int emulate_privileged_op(struct 
         case MSR_K8_HWCR:
             if ( boot_cpu_data.x86_vendor != X86_VENDOR_AMD )
                 goto fail;
-            if ( !is_cpufreq_controller(v->domain) )
+            if ( !is_cpufreq_controller(v->domain) && !IS_PRIV(v->domain) )
                 break;
             if ( wrmsr_safe(regs->ecx, msr_content) != 0 )
                 goto fail;
