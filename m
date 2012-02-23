Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2BWWgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:36:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:38092 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2BWWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:34:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, JBeulich@novell.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] processor passthru - upload _Cx and _Pxx data to hypervisor (v5).
Date: Thu, 23 Feb 2012 17:31:07 -0500
Message-Id: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F46BF08.00AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem these three patches try to solve is to provide ACPI power management
information to the Xen hypervisor. The hypervisor lacks the ACPI DSDT parser so it can't
get that data without some help - and the initial domain can provide that. One
approach (https://lkml.org/lkml/2011/11/30/245) augments the ACPI code to call
an external PM code - but there were no comments about it so I decided to see
if another approach could solve it.

This module (processor-passthru)  collects the information that the cpufreq
drivers and the ACPI processor code save in the 'struct acpi_processor' and
then uploads it to the hypervisor.

The driver can be either an module or compiled in. In either mode the driver
launches a thread that checks whether an cpufreq driver is registered. If so
it reads all the 'struct acpi_processor' data for all online CPUs and sends
it to hypervisor. The driver also register a CPU hotplug component - so if a new
CPU shows up - it would send the data to the hypervisor for it as well.
Furthermore it also verifies whether the ACPI ID count is different than what
the kernel sees (which is possible with dom0_max_vcpus) and if so uploads
the data for the other ACPI IDs.

The patches are available in this git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/processor-passthru.v5


Konrad Rzeszutek Wilk (3):
      xen/setup/pm/acpi: Remove the call to boot_option_idle_override.
      xen/enlighten: Expose MWAIT and MWAIT_LEAF if hypervisor OKs it.
      xen/processor-passthru: Provide an driver that passes struct acpi_processor data to the hypervisor.

 arch/x86/xen/enlighten.c         |   92 +++++++-
 arch/x86/xen/setup.c             |    1 -
 drivers/xen/Kconfig              |   14 +
 drivers/xen/Makefile             |    2 +-
 drivers/xen/processor-passthru.c |  485 ++++++++++++++++++++++++++++++++++++++
 include/xen/interface/platform.h |    4 +-
 6 files changed, 594 insertions(+), 4 deletions(-)


P.S.
On the hypervisor side, it requires this patch on AMD:
# HG changeset patch
# Parent aea8cfac8cf1afe397f2e1d422a852008d8a83fe
traps: AMD PM RDMSRs (MSR_K8_PSTATE_CTRL, etc)

The restriction to read and write the AMD power management MSRs is gated if the
domain 0 is the PM domain (so FREQCTL_dom0_kernel is set). But we can
relax this restriction and allow the privileged domain to read the MSRs
(but not write). This allows the priviliged domain to harvest the power
management information (ACPI _PSS states) and send it to the hypervisor.

This patch works fine with older classic dom0 (2.6.32) and with
AMD K7 and K8 boxes.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
diff -r aea8cfac8cf1 xen/arch/x86/traps.c
--- a/xen/arch/x86/traps.c	Thu Feb 23 13:23:02 2012 -0500
+++ b/xen/arch/x86/traps.c	Thu Feb 23 13:29:00 2012 -0500
@@ -2484,7 +2484,7 @@ static int emulate_privileged_op(struct 
         case MSR_K8_PSTATE7:
             if ( boot_cpu_data.x86_vendor != X86_VENDOR_AMD )
                 goto fail;
-            if ( !is_cpufreq_controller(v->domain) )
+            if ( !is_cpufreq_controller(v->domain) && !IS_PRIV(v->domain) )
             {
                 regs->eax = regs->edx = 0;
                 break;


