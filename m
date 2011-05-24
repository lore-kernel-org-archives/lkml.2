Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1EXRpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:45:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:22163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1EXRpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:45:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,262,1304319600"; 
   d="scan'208";a="4058811"
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>
In-Reply-To: <20110524061525.GA29815@elte.hu>
References: <20110523193035.GA9170@elte.hu>
	 <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
	 <20110524060321.GA20904@elte.hu>  <20110524061525.GA29815@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 24 May 2011 10:45:31 -0700
Message-Id: <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 23:15 -0700, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Possibly the resume fix in the APIC merge :-/
> > 
> > It's these commits:
> > 
> >  31dce14a3269: x86, ioapic: Use ioapic_saved_data while enabling intr-remapping
> >  4c79185cdb14: x86, ioapic: Allocate ioapic_saved_data early
> >  b64ce24daffb: x86, ioapic: Fix potential resume deadlock
> > 
> > The first one fixes the resume bug in an easily backportable way (although 
> > the GFP_ATOMIC is not nice), the later two do it cleaner.
> > 
> > So if b64ce24daffb works for you and 31dce14a3269 breaks this would signal 
> > that the fix from Suresh is the source of the Atom regression.
> 
> In particular the lapic_resume() bit looks suspect. Does save_ioapic_entries() 
> get called? It's called in enable_IR_x2apic() but your Atom is probably not 
> x2apic. Non-x2apic system do not get save_ioapic_entries() called, so there's 
> nothing to restore at resume time AFAICS ... Suresh?

Patch appended(I am sorry, should have caught this earlier. Looks like
my system does keep the ioapic state intact during suspend/resume.)

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, ioapic: restore ioapic entries during resume properly

In mask/restore_ioapic_entries, we should be restoring ioapic entries when
ioapics[apic].saved_registers is not NULL.  Fix the typo and address
the resume regression.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9488dcf..e529339 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -676,7 +676,7 @@ void mask_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (ioapics[apic].saved_registers)
+		if (!ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
@@ -699,7 +699,7 @@ int restore_ioapic_entries(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (ioapics[apic].saved_registers)
+		if (!ioapics[apic].saved_registers)
 			continue;
 
 		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)



