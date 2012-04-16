Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2DPTYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:24:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31250 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2DPTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:24:43 -0400
Date: Mon, 16 Apr 2012 15:19:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: xen-devel@lists.xensource.com, suresh.b.siddha@intel.com, hpa@zytor.com,
        hpa@zytor.co, tglx@linutronix.de
Subject: Re: [GIT PULL] (xen) for stable/for-ingo-v3.5.v3 for v3.5
Message-ID: <20120416191928.GA25676@phenom.dumpdata.com>
References: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F8C71EE.00AE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 02:40:13PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Ingo,
> 
> Please git pull the following branch for v3.5:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-ingo-v3.5.v3
> 
> It has the proper fix for the IO-APIC having 0xfffff... contents when booting under Xen.
> 
> Compared to the patch you have already in the tree (136d249ef7dbf0fefa292082cc40be1ea864cbd6
>  x86/ioapic: Add io_apic_ops driver layer to allow interception) it does three things:
> 
>  1) Exposes the io_apic baremetal functions and uses the x86_io_apic_ops function table
>     instead of keeping it in the io_apic. This makes the code fit within the rest of
>     x86_ops functions.
> 
>  2) Use the x86_io_apic_ops to re-direct the (*read) to the Xen emulated one.
> 
>  3) Removes the work-around.
> 
> Please note, that the existing interface (136d249) can be used to do 2) as well. But the

.. If the __ioapic_init_mappings is made visible (so that we can call it in the Xen's
version of io_apic_ops.init() - as we want to re-use as much as possible of the generic
code:

commit fa45ea06ab785ce82644980befc7e983f884f72a
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Mon Apr 16 14:50:02 2012 -0400

    x86/io_apic: Make __ioapic_init_mappings visible to other sub-systems.
    
    This way, we can re-use as much as possible of the generic code as possible
    and re-use the generic initialization.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 2c4943d..e75979c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -157,6 +157,7 @@ extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_and_gsi_init(void);
+extern void __ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
@@ -191,6 +192,7 @@ extern void disable_ioapic_support(void);
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static const int timer_through_8259 = 0;
 static inline void ioapic_and_gsi_init(void) { }
+static inline void __ioapic_init_mappings(void) { }
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..58e6986 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -68,8 +68,6 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
-static void		__init __ioapic_init_mappings(void);
-
 static unsigned int	__io_apic_read  (unsigned int apic, unsigned int reg);
 static void		__io_apic_write (unsigned int apic, unsigned int reg, unsigned int val);
 static void		__io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
@@ -3936,7 +3934,7 @@ void __init ioapic_and_gsi_init(void)
 	io_apic_ops.init();
 }
 
-static void __init __ioapic_init_mappings(void)
+void __init __ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
