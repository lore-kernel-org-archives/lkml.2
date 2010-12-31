Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0LaBFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 20:05:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59266 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0LaBFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 20:05:51 -0500
Message-ID: <4D1D2C4D.4090806@kernel.org>
Date: Thu, 30 Dec 2010 17:05:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, 64bit: Always make MAX_APICS to 32768
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Found one x2apic pre-enabled system, x2apic_mode suddenly get corrupted
after register some cpus. when compiled CONFIG_NR_CPUS=255 instead of 512

It turns out that generic_processor_info() ==> phyid_set(apicid, phys_cpu_present_map) cause the problem.

phys_cpu_present_map is with MAX_APICS bits. and pre-enabled system some cpus apic id > 255.

the variable after phys_cpu_present_map may get corrupted.... siliently...

ffffffff828e8420 B phys_cpu_present_map
ffffffff828e8440 B apic_verbosity
ffffffff828e8444 B local_apic_timer_c2_ok
ffffffff828e8448 B disable_apic
ffffffff828e844c B x2apic_mode
ffffffff828e8450 B x2apic_disabled
ffffffff828e8454 B num_processors
...

Actually phys_cpu_present_map is referenced via apic id, instead index. we should use
MAX_LOCAL_APIC instead MAX_APICIS. but that is another header.

So just let MAX_APICS equal to MAX_LOCAL_APIC at this point.
esp for 64 bit will be 32768 in all cases.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec_def.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec_def.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec_def.h
+++ linux-2.6/arch/x86/include/asm/mpspec_def.h
@@ -17,11 +17,7 @@
 # define MAX_MPC_ENTRY 1024
 # define MAX_APICS      256
 #else
-# if NR_CPUS <= 255
-#  define MAX_APICS     255
-# else
-#  define MAX_APICS   32768
-# endif
+# define MAX_APICS    32768
 #endif
 
 /* Intel MP Floating Pointer Structure */
