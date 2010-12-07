Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0LGI4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:56:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22678 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0LGI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:56:45 -0500
Message-ID: <4CFDF69C.9070501@kernel.org>
Date: Tue, 07 Dec 2010 00:55:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] x86, x2apic: Don't map lapic addr for preenabled x2apic
 system
References: <4CFDF544.8020309@kernel.org>
In-Reply-To: <4CFDF544.8020309@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If x2apic is reenabled, and used in kernel, We don't need to map that lapic
address. That mapping will never be used.

So just skip that in register_lapic_address()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1676,9 +1676,11 @@ void __init register_lapic_address(unsig
 {
 	mp_lapic_addr = address;
 
-	set_fixmap_nocache(FIX_APIC_BASE, address);
-	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
-		    APIC_BASE, mp_lapic_addr);
+	if (!x2apic_mode) {
+		set_fixmap_nocache(FIX_APIC_BASE, address);
+		apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+			    APIC_BASE, mp_lapic_addr);
+	}
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
 		apic_version[boot_cpu_physical_apicid] =
