Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2BAIAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:00:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:2398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab2BAIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:00:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101865437"
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org, midgoon@gmail.com
In-Reply-To: <20120131142621.GA2136@zod.bos.redhat.com>
References: <20120125000434.GC13655@zod.bos.redhat.com>
	 <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
	 <20120125134947.GF13655@zod.bos.redhat.com>
	 <1327529048.2327.17.camel@sbsiddha-mobl2>
	 <20120125231534.GL13655@zod.bos.redhat.com>
	 <20120131142621.GA2136@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 01 Feb 2012 00:00:30 -0800
Message-ID: <1328083230.3638.2.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 09:26 -0500, Josh Boyer wrote:
> On Wed, Jan 25, 2012 at 06:15:35PM -0500, Josh Boyer wrote:
> > On Wed, Jan 25, 2012 at 02:04:08PM -0800, Suresh Siddha wrote:
> > > On Wed, 2012-01-25 at 08:49 -0500, Josh Boyer wrote:
> > > > [    0.000000] IOAPIC[1]: apic_id 2, version 255, address 0xfec28000, GSI 24-279
> > > 
> > > This looks indeed like a bogus entry probably returning all 1's for
> > > RTE's etc. Can you please send me a dmesg with "apic=verbose" boot
> > > parameter?
> > 
> > Here you go:
> > 
> > https://bugzilla.redhat.com/attachment.cgi?id=557552
> 
> Was this helpful at all?  I've been watching lkml for a related patch
> in case I was missed on CC but haven't seen anything as of yet.

Yes, it was helpful. Something like the appended patch should ignore the
bogus io-apic entry all together. As I can't test this, can you or the
reporter give the appended patch a try and ack please?

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, ioapic: add register checks for bogus io-apic entries

With the recent changes to clear_IO_APIC_pin() which tries to clear
remoteIRR bit explicitly, some of the users started to see
"Unable to reset IRR for apic .." messages.

Close look shows that these are related to bogus IO-APIC entries which
return's all 1's for their io-apic registers. And the above mentioned error
messages are benign. But kernel should have ignored such io-apic's in the
first place.

Check if register 0, 1, 2 of the listed io-apic are all 1's and ignore
such io-apic.

Reported-by: Álvaro Castillo <midgoon@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..953e54d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3979,6 +3979,26 @@ static __init int bad_ioapic(unsigned long address)
 	return 0;
 }
 
+static __init int bad_ioapic_regs(int idx)
+{
+	union IO_APIC_reg_00 reg_00;
+	union IO_APIC_reg_01 reg_01;
+	union IO_APIC_reg_02 reg_02;
+
+	reg_00.raw = io_apic_read(idx, 0);
+	reg_01.raw = io_apic_read(idx, 1);
+	reg_02.raw = io_apic_read(idx, 2);
+
+	if (reg_00.raw == -1 && reg_01.raw == -1 && reg_02.raw == -1) {
+		printk(KERN_WARNING
+		       "I/O APIC 0x%x regs return all ones, skipping!\n",
+		       mpc_ioapic_addr(idx));
+		return 1;
+	}
+
+	return 0;
+}
+
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -3995,6 +4015,12 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	ioapics[idx].mp_config.apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
+
+	if (bad_ioapic_regs(idx)) {
+		clear_fixmap(FIX_IO_APIC_BASE_0 + idx);
+		return;
+	}
+
 	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
 	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 



