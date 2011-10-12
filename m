Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1JLHeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:34:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27849 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1JLHeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:34:07 -0400
Message-ID: <4E9542C8.8040209@oracle.com>
Date: Wed, 12 Oct 2011 00:33:28 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] x86, ioapic: Print out irte with right ioapic index
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com> <4E29BEEA.4020600@kernel.org> <20110725072831.GB22518@elte.hu> <4E33334D.1030007@kernel.org>
In-Reply-To: <4E33334D.1030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090203.4E9542D3.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While checking irte dump in dmesg, the print out is confusing ioapic index
with real io apic id.

IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:00FF SQ:0 SVT:1)
IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:00FF SQ:0 SVT:1)

The system first ioapic id is 1.

Those irte print out is from:
| commit 3040db92ee1b6c5b6b6d73f8cdcad54c0da11563
| Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
| Date:   Tue Jul 12 21:17:41 2011 +0000
|
|    x86, ioapic: Print IRTE when IR is enabled
it uses apic_id in setup_ioapic_entry(), and think it is ioapic idx.
actually it is ioapic apic id.

So need to use ioapic idx instead to get right printout.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1289,7 +1289,7 @@ static int setup_ir_ioapic_entry(int irq
 		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
 		"Avail:%X Vector:%02X Dest:%08X "
 		"SID:%04X SQ:%X SVT:%X)\n",
-		apic_id, irte.present, irte.fpd, irte.dst_mode,
+		attr->ioapic, irte.present, irte.fpd, irte.dst_mode,
 		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
 		irte.avail, irte.vector, irte.dest_id,
 		irte.sid, irte.sq, irte.svt);
