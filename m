Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2LBR3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:29:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39088 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2LBR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:29:07 -0500
Date: Sun, 2 Dec 2012 20:28:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Russ Anderson <rja@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        walter harms <wharms@bfs.de>
Subject: [patch v3] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121202172842.GA20110@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BB74E7.9060306@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a static checker fix.  The problem is that we store the bits
from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
them.

I have also simplified uv_wakeup_secondary() a little based on a
suggestion.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Style fix.  Don't use ulong.
v3: Another style fix to uv_wakeup_secondary() based on Walter Harms's
suggestion.

I don't have this hardware so I can't test it.  There may also be other
bugs which this patch does not addressed.  These files are only compiled
on x86_64 and "unsigned long" is used throughout to mean 64 bits.

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 21f7385..e7a83d5 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -577,7 +577,7 @@ static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
 {
 	apicid |= uv_apicid_hibits;
 	return (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			((unsigned long)apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 }
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 8cfade9..251b36f 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -194,16 +194,10 @@ static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_ri
 	pnode = uv_apicid_to_pnode(phys_apicid);
 	phys_apicid |= uv_apicid_hibits;
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
-	    APIC_DM_INIT;
-	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-
-	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
-	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
-	    APIC_DM_STARTUP;
-	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
+	    ((unsigned long)phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
+	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val | APIC_DM_INIT);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val | APIC_DM_STARTUP);
 
 	atomic_set(&init_deasserted, 1);
 #endif
