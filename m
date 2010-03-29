Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0C2XTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:19:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54018 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab0C2XTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:19:43 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: [PATCH 0/14] Start coping gsis < 16 that are not isa irqs.
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	<1269221770-9667-3-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
	<m1iq8f1c1f.fsf@fess.ebiederm.org> <4BB0EA22.7000004@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 29 Mar 2010 16:19:34 -0700
In-Reply-To: <4BB0EA22.7000004@zytor.com> (H. Peter Anvin's message of "Mon\, 29 Mar 2010 10\:57\:54 -0700")
Message-ID: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, protasnb@gmail.com, garyhade@us.ibm.com, iranna.ankad@in.ibm.com, linux-acpi@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com, len.brown@intel.com, suresh.b.siddha@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org, mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It appears there are a few systems in the wild that use acpi
interrupt source overrides to report a gsi > 16 is an isa irq.

This breaks all kinds of assumptions I figure any BIOS doing that
probably should be shot as that is very much not a conservative position.

That said acpi appears to allow this insanity and on the basis of being
liberal in what we accept we should try to do something reasonable, and
keep our notions of gsi, isa irq, and linux irq as straight as we can.

To that end this patchset slightly modifies the gsi to linux irq
mapping.  Making it a 1 to 1 identity mapping except for the first 16
gsis.  If those gsis are isa irqs (the typical and default acpi
configuration) they will be mapped into the first 16 irqs.  If those
first 16 gsis are not isa irqs they will be given a linux irq number
just past the last gsi.  Allowing us the chance to use them.

This patchset is my attempt to straighten out our understanding of which
kind of irq name is used where and the cleanups used to get there.

Thanks to Yinghai Lu <yinghai@kernel.org> for taking the first stab at
this and finding that there is a real world problem here.  This patchset
is inspired by his work, but little of it remains the same.

This patchset lies in the weird world between the acpi and x86 and ia64.
Since most of the changes are x86 related I think it makes most sense
to go via the x86 tree.


Eric W. Biederman (14):
      x86 acpi/irq: Introduce apci_isa_irq_to_gsi
      x86 acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq
      x86 acpi/irq: pci device dev->irq is an isa irq not a gsi
      x86 acpi/irq: Fix acpi_sci_ioapic_setup so it has both bus_irq and gsi
      x86 acpi/irq: Generalize mp_config_acpi_legacy_irqs
      x86 ioapic: Only export mp_find_ioapic and mp_find_ioapic_pin in io_apic.h
      x86 ioapic: Fix the types of gsi values
      x86 ioapic: Teach mp_register_ioapic to compute a global gsi_end
      x86 ioapic: In mpparse use mp_register_ioapic
      x86 ioapic: Move nr_ioapic_registers calculation to mp_register_ioapic.
      x86 ioapic: Optimize pin_2_irq
      x86 ioapic: Simplify probe_nr_irqs_gsi.
      x86 acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
      x86 irq: Kill io_apic_renumber_irq

 arch/ia64/kernel/acpi.c          |    8 ++
 arch/x86/include/asm/io_apic.h   |   12 ++--
 arch/x86/include/asm/mpspec.h    |   10 ---
 arch/x86/kernel/acpi/boot.c      |  133 ++++++++++++++++++++++++--------------
 arch/x86/kernel/apic/es7000_32.c |   19 ------
 arch/x86/kernel/apic/io_apic.c   |   93 +++++++++++---------------
 arch/x86/kernel/mpparse.c        |   25 +-------
 arch/x86/kernel/sfi.c            |    4 +-
 drivers/acpi/pci_irq.c           |    8 ++-
 include/linux/acpi.h             |    5 +-
 10 files changed, 149 insertions(+), 168 deletions(-)

Eric
