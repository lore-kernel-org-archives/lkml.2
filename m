Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2ILHG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:06:26 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:46460 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2ILHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:06:24 -0400
From: "Zhang, Lin-Bao (ESSN-MCXS-Linux Kernel R&D)" <linbao.zhang@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>
Subject: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries
Thread-Topic: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries
Thread-Index: Ac2QszzoAvNse2b0TNGUNPrbhE0QOw==
Date: Wed, 12 Sep 2012 07:02:51 +0000
Message-ID: <92645B27BF79D04FBD2B0F8494FFD0F9095637@G1W3648.americas.hpqcorp.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.11]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8C76U8C027833

Hi all, 
This defect can be observed when the x2apic setting in BIOS is set to "auto" and the BIOS has virtual wire mode enabled on a power up. This defect was found on a 2.6.32 based kernel.

The kernel code (smpboot.c, apic.c) does not mask 8259A interrupts before changing and initializing the new VT-d table when x2apic virtual wire mode is enable on power up. The Linux Kernel expects virtual wire mode to be disabled when booting and enables it when interrupts are masked.

The BIOS code builds a simple VT-d table on power up. While the Linux Kernel boots, it first builds an empty VT-d table and use it. After some time, the Linux Kernel then initializes the IO-APIC redirect table, and then initializes the VT-d entries. The window between initializing the redirect table and the VT-d entries, the 8259A interrupts are not masked. If an interrupt occurs in this window, the Linux Kernel will not find a valid entry for this interrupt. The kernel treats it to be a fatal error and panics. If the error never gets cleared, the Linux kernel continuously print this error:
"NMI: IOCK error (debug interrupt?) for reason"

The fix to this defect, the code change is to mask 8259A interrupts before changing VT-d table and initializing VT-d entries. Then unmask interrupts after completing the redirect table entries.


Signed-off-by: Zhang, Lin-Bao <linbao.zhang@hp.com>
Tested-by: Nigel Croxon <nigel.croxon@hp.com>

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c index 24deb30..299172c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1556,7 +1556,6 @@ void __init enable_IR_x2apic(void)
        }

        local_irq_save(flags);
-       legacy_pic->mask_all();
        mask_ioapic_entries();

        if (x2apic_preenabled && nox2apic) @@ -1603,7 +1602,6 @@ void __init enable_IR_x2apic(void)
 skip_x2apic:
        if (ret < 0) /* IR enabling failed */
                restore_ioapic_entries();
-       legacy_pic->restore_mask();
        local_irq_restore(flags);
 }

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c index 7c5a8c3..95fee01 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1000,7 +1000,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
                zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
        }
        set_cpu_sibling_map(0);
-
+       mask_8259A();

        if (smp_sanity_check(max_cpus) < 0) {
                pr_info("SMP disabled\n"); @@ -1037,6 +1037,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
                apic->setup_portio_remap();

        smpboot_setup_io_apic();
+       unmask_8259A();
+
        /*
         * Set up local APIC timer on boot CPU.
         */



-- Bob(Zhang LinBao)
×ÓÔ»£º¡±²»»¼ÈËÖª²»¼ºÖª,»¼²»ÖªÈËÒ²¡±
"If not us, who ? if not now, when ?"
ESSN-MCBS linux kernel enginner


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
