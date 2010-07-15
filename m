Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0GOHFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 03:05:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52646 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0GOHEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 03:04:54 -0400
Message-ID: <4C3EB22B.3000701@kernel.org>
Date: Thu, 15 Jul 2010 00:00:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>
Subject: [PATCH] x86: fix x2apic preenabled system with kexec
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com>	 <4C3CF650.30905@kernel.org> <4C3E1FA0.9000107@kernel.org>	 <4C3E2AE6.30406@kernel.org>  <4C3E40EC.5060607@kernel.org> <1279152189.2849.260.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1279152189.2849.260.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C3EB2D0.01C9,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Found one x2apic system kexec loop test failed 
when CONFIG_NMI_WATCHDOG=y (old) or CONFIG_LOCKUP_DETECTOR=y (current tip)

first kernel can kexec second kernel, but second kernel can not kexec third one.

it can be duplicated on another system with BIOS preenabled x2apic.
First kernel can not kexec second kernel.

It turns out, when kernel boot with pre-enabled x2apic, it will not execute
disable_local_APIC on shutdown path.

when init_apic_mappings() is called in setup_arch, it will skip setting of
apic_phys when x2apic_mode is set. ( x2apic_mode is much early check_x2apic())
Then later, disable_local_APIC() will bail out early because !apic_phys.

So check !x2apic_mode in x2apic_mode in disable_local_APIC with !apic_phys.

another solution could be updating init_apic_mappings() to set apic_phys even
for preenabled x2apic system. Actually even for x2apic system, that lapic
address is mapped already in early stage.

BTW: is there any x2apic preenabled system with apicid of boot cpu > 255?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -921,7 +921,7 @@ void disable_local_APIC(void)
 	unsigned int value;
 
 	/* APIC hasn't been mapped yet */
-	if (!apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	clear_local_APIC();
