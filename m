Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2CTJpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:45:24 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21090 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2CTJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:45:21 -0400
Date: Tue, 20 Mar 2012 05:40:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120320094048.GC20079@phenom.dumpdata.com>
References: <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
 <20120125134947.GF13655@zod.bos.redhat.com>
 <1327529048.2327.17.camel@sbsiddha-mobl2>
 <20120125231534.GL13655@zod.bos.redhat.com>
 <20120131142621.GA2136@zod.bos.redhat.com>
 <1328083230.3638.2.camel@sbsiddha-mobl2>
 <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
 <20120319193842.GA8123@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319193842.GA8123@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F6851A1.009B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > Yes, it was helpful. Something like the appended patch should ignore the
> > > > > bogus io-apic entry all together. As I can't test this, can you or the
> > > > > reporter give the appended patch a try and ack please?
> > > > 
> > > > Hi Suresh,
> > > > 
> > > > Apologies for the delay.  The original reporter had to return the
> > > > machine he was using.  We've since had another report where this
> > > > happened and your patch below does indeed fix the issue.
> > > > 
> > > > I'd suggest pushing this soon.
> > > > 
> > > > https://bugzilla.redhat.com/show_bug.cgi?id=801501
> > > > 
> > > 
> > > Thanks Josh. Peter/Ingo, please queue the appended patch for -tip.
> > 
> > Hi Suresh,
> > 
> > Seems this patch and Xen don't get along very well.  See the bug link
> > below.  I've CC'd Konrad and hopefully he'll have some insight as to why
> > that might be.
> 
> Quick glance at the code tells me that the 'mp_register_ioapic' with the
> patch won't increment the gsi_top. That value (gsi_top) is used in
.. snip..
> So the IO_APIC is all 0xfff.. 

My "quick glance" was wrong. The reason we are dying is b/c the call
acpi_get_override_irq() is used, which returns the polarity and trigger for the
IRQs. But that function calls mp_find_ioapics to get the 'struct ioapic' structure
- which along with the mp_irq[x] is used to figure out the default values
and the polarity/trigger overrides. Since the mp_find_ioapics now returns -1
[b/c the IOAPIC is filled with 0xffffffff], the acpi_get_override_irq() stops
trying to lookup in the mp_irq[x] the proper INT_SRV_OVR and we can't install the
SCI interrupt.

Furthermore, we end up using that function in a loop to setup the sixteen legacy
interrupts:

    /* Pre-allocate legacy irqs */
480         for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
481                 int trigger, polarity;
482 
483                 if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
484                         continue;
485 
486                 xen_register_pirq(irq, -1 /* no GSI override */,
487                         trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
488                         true /* Map GSI to PIRQ */);


and since we get -1, we never end up setting any interrupts. 

Also the nr_ioapics ends up being zero, so we think we are running in legacy mode with XT-PIC
interrupts (ugh). By the time ACPI kicks in and wants to install the SCI interrupt
we blow up since we cannot get the proper irq_desc.

The interesting thing is that the same issue could be reproduced on baremetal
if the first IOAPIC had 0xfff all over it - and the call to acpi_get_override_irq()
done by the ACPI layer to setup the SCI would have triggered a similar failure.
But the baremetal failing case has the first IOAPIC with the INT_SRV_OVR with
valid values - it is just the second IOAPIC is busted.

Or if the second IOAPIC was busted and there was an INT_SRV_OVR for the second
APIC to handle the SCI.

I think there are three ways of fixing this:

 1). Revert Suresh's patch and look at just removing the "Unable to reset IRR" warning
    (perhaps by being conditional on running in kexec-env?).

 2). Make the Xen layer fake out an IOAPIC - so instead of 0xffffff, make sure to
     clear the three bits that Suresh' patch is testing for (Ewwwww, I don't actually
     like that - that stinks of a hack).

 3). Rework Suresh's patch - to only remove the IOAPIC entry if there is no
     INT_SRV_OVR that depend on it. I made a stab at it and here is draft patch, that
     looks to work on my boxes that have more than one IOAPIC and are booting under Xen:
     But I am not 100% confident about it so would appreciate somebody looking at it.

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 690d1cc..d92be91 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -170,6 +170,7 @@ extern u32 gsi_top;
 int mp_find_ioapic(u32 gsi);
 int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+void __init mp_erase_defective_ioapics(void);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 9c7d95f..e886853 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -103,6 +103,7 @@ extern void mp_config_acpi_legacy_irqs(void);
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
+extern void mp_erase_defective_ioapics(void);
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_LOCAL_APIC)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c3a5b95..b5115e7 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1193,6 +1193,10 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	}
 
 	/*
+	 * Cleanup up invalid IOAPICs.
+	 */
+	mp_erase_defective_ioapics();
+	/*
 	 * If BIOS did not supply an INT_SRC_OVR for the SCI
 	 * pretend we got one so we can set the SCI flags.
 	 */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d10a66..77f1e84 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3989,14 +3989,43 @@ static __init int bad_ioapic_register(int idx)
 	reg_02.raw = io_apic_read(idx, 2);
 
 	if (reg_00.raw == -1 && reg_01.raw == -1 && reg_02.raw == -1) {
-		pr_warn("I/O APIC 0x%x registers return all ones, skipping!\n",
-			mpc_ioapic_addr(idx));
 		return 1;
 	}
 
 	return 0;
 }
+bool __init no_gsi_override_for_ioapic(int idx)
+{
+	unsigned int gsi, i;
+	struct mp_ioapic_gsi *gsi_cfg;
+
+	gsi_cfg = mp_ioapic_gsi_routing(idx);
+	for (gsi = gsi_cfg->gsi_base; gsi < gsi_cfg->gsi_end; gsi++) {
+		unsigned int pin = mp_find_ioapic_pin(idx, gsi);
+		for (i = 0; i < mp_irq_entries; i++) {
+			if (mp_irqs[i].dstirq == pin &&
+				mp_irqs[i].dstapic == mpc_ioapic_id(idx))
+				return false;
+		}
+	}
+	return true;
+}
+void __init mp_erase_defective_ioapics(void)
+{
+	unsigned int idx = 0;
 
+	while (idx < nr_ioapics) {
+		if (bad_ioapic_register(idx) && no_gsi_override_for_ioapic(idx)) {
+			pr_warn("I/O APIC 0x%x registers return all ones, skipping!\n",
+				mpc_ioapic_addr(idx));
+			clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+			memmove(&ioapics[idx], &(ioapics[idx+1]),
+				sizeof(struct ioapic) * (nr_ioapics - 1 - idx));
+			--nr_ioapics;
+		} else
+			idx++;
+	}
+}
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -4014,11 +4043,6 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
-	if (bad_ioapic_register(idx)) {
-		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
-		return;
-	}
-
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
