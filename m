Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2JHX4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:56:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:23200 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2JHX4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:56:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,556,1344236400"; 
   d="scan'208";a="231461511"
Subject: RE: [PATCH] fix x2apic defect that Linux kernel doesn't mask 8259A
 interrupt during the time window between changing VT-d table base address
 and initializing these VT-d entries(smpboot.c and apic.c )
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Mon, 08 Oct 2012 16:57:13 -0700
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F90FC806@G2W2429.americas.hpqcorp.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1349740633.11093.43.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-07 at 21:53 -0700, Zhang, Lin-Bao (Linux Kernel R&D)
wrote:
> Hi Suresh,
> Could you please update current status about these 2 files and patch?
> I am not sure if I have answered your questions , if not ,feel free to let me know.
> This is my first time to submit patch to LKML, so what should I do next step ?

As I mentioned earlier, the current design already ensures that all the
IO-APIC RTE's are masked between the time we enable interrupt-remapping
to the time when the IO-APIC RTE's are configured correctly.

So I looked at why you are seeing the problem with v2.6.32 but not with
the recent kernels. And I think I found out the reason.

2.6.32 kernel is missing this fix,
http://marc.info/?l=linux-acpi&m=126993666715081&w=2

commit 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Mar 30 01:07:12 2010 -0700

    x86, ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.
    
    Now that all ioapic registration happens in mp_register_ioapic we can
    move the calculation of nr_ioapic_registers there from enable_IO_APIC.
    The number of ioapic registers is already calucated in mp_register_ioapic
    so all that really needs to be done is to save the caluclated value
    in nr_ioapic_registers.
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    LKML-Reference: <1269936436-7039-11-git-send-email-ebiederm@xmission.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>


Because of this, in v2.6.32, mask_IO_APIC_setup() is not working as
expected as nr_ioapic_registers[] are not yet initialized and thus the
io-apic RTE's are not masked as expected.

We just need the last hunk of that patch, I think.

Can you please apply the appended patch to 2.6.32 kernel and see if the
issue you mentioned gets fixed? If so, we can ask the -stable and OSV's
teams to pick up this fix.

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f807255..dae9240 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4293,6 +4281,7 @@ static int bad_ioapic(unsigned long address)
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
+	int entries;
 
 	if (bad_ioapic(address))
 		return;
@@ -4311,9 +4300,14 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
+	entries = io_apic_get_redir_entries(idx);
 	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base +
-	    io_apic_get_redir_entries(idx) - 1;
+	mp_gsi_routing[idx].gsi_end = gsi_base + entries - 1;
+
+	/*
+	 * The number of IO-APIC IRQ registers (== #pins):
+	 */
+	nr_ioapic_registers[idx] = entries;
 
 	if (mp_gsi_routing[idx].gsi_end > gsi_end)
 		gsi_end = mp_gsi_routing[idx].gsi_end;


