Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0HPTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:25:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:28619 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756099Ab0HPTZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:25:54 -0400
Subject: [Patch] Skip cpu_calibrate for kernel running under hypervisors.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: Greg KH <gregkh@suse.de>, greg@kroah.com, ksrinivasan@novell.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 16 Aug 2010 12:25:54 -0700
Message-Id: <1281986754.23253.32.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This is a trivial change to fix the cpu_khz value returned when running
on a virtualized environment. We have seen instances when the cpu_khz
value is off by couple of MHz's when running on VMware's platform on AMD
hardware.

--
Since the TSC frequency read from hypervisor is accurate for the guest, and
since the hypervisor will always clock the vcpu at the TSC frequency, there is
no need to calibrate it again. To avoid any calibration errors through
calibrate_cpu this patch skips calling calibrate_cpu for kernel running
under hypervisors.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: K. Y. Srinivasan <ksrinivasan@novell.com>
Cc: Greg KH <greg@kroah.com>
Cc: H. Peter Anvin <hpa@zytor.com>

Index: linux-x86-tree.git/arch/x86/kernel/tsc.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/tsc.c	2010-08-03 12:21:20.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/tsc.c	2010-08-13 15:07:08.000000000 -0700
@@ -927,7 +927,7 @@ void __init tsc_init(void)
 	}
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
+	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !x86_hyper)
 		cpu_khz = calibrate_cpu();
 
 	printk("Detected %lu.%03lu MHz processor.\n",


