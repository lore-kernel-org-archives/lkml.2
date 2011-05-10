Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab1EJX5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:57:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:2844 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab1EJX5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:57:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,348,1301900400"; 
   d="scan'208";a="40995"
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
	 <20110510073551.GH11595@elte.hu>
	 <BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 10 May 2011 16:58:14 -0700
Message-Id: <1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 03:53 -0700, Daniel J Blueman wrote:
> On 10 May 2011 15:35, Ingo Molnar <mingo@elte.hu> wrote:
> > Hm, there must be some other bug here.
> >
> > ioapic entries should be allocated on system bootup and should never really be
> > deallocated.
> >
> > The bug might be in the idea to call to enable_IR_x2apic() on resume - why are
> > ioapic entries reallocated there? That call in default_setup_apic_routing() was
> > introduced some time ago in:
> >
> >  fa47f7e52874: x86, x2apic: Simplify apic init in SMP and UP builds
> >
> > and that it results in reallocation in the suspend patch is distinctly wrong.
> >
> > I suspect the reason why this has not triggered for others is the relative
> > rarity of affected systems?
> >
> > Suresh?

This will happen only on interrupt-remapping enabled systems and hence
hidden so far.

enable_IR_x2apic() / default_setup_apic_routing() routines don't get
called during resume. Problem is with the lapic_resume() path which is
trying to re-enable x2apic mode and this requires masking io-apic
entries, re-enabling x2apic and interrupt-remapping, restoring io-apic
entries etc. ioapic entry allocation that is happening in lapic_resume()
is just for storing the original io-apic RTE's during the mask/restore
operations that happen around re-enabling x2apic.

Anyways looking at that code, there is some duplicate code between
x2apic code and the io-apic suspend/resume sequence. So a better fix
will be to remove this duplicate code.

Daniel, I appended a quick patch which should fix the problem you
reported. This is not a final patch, as I can do some more cleanup and
re-use the io-apic suspend/resume code a bit more.

If this patch works for you, then I can spend some more time to do the
complete cleanup patch in a day or two. Thanks.

 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/apic.c    |   26 ++++----------------------
 arch/x86/kernel/apic/io_apic.c |    2 +-
 3 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a97a240..9e229be 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -177,6 +177,7 @@ extern void __init pre_init_apic_IRQ0(void);
 extern void mp_save_irq(struct mpc_intsrc *m);
 
 extern void disable_ioapic_support(void);
+extern struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
 
 #else  /* !CONFIG_X86_IO_APIC */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..9000409 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2088,28 +2088,14 @@ static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
-	int maxlvt, ret;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	int maxlvt;
 
 	if (!apic_pm_state.active)
 		return;
 
 	local_irq_save(flags);
 	if (intr_remapping_enabled) {
-		ioapic_entries = alloc_ioapic_entries();
-		if (!ioapic_entries) {
-			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			goto restore;
-		}
-
-		ret = save_IO_APIC_setup(ioapic_entries);
-		if (ret) {
-			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
-			free_ioapic_entries(ioapic_entries);
-			goto restore;
-		}
-
-		mask_IO_APIC_setup(ioapic_entries);
+		mask_IO_APIC_setup(ioapic_saved_data);
 		legacy_pic->mask_all();
 	}
 
@@ -2152,13 +2138,9 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (intr_remapping_enabled) {
+	if (intr_remapping_enabled)
 		reenable_intr_remapping(x2apic_mode);
-		legacy_pic->restore_mask();
-		restore_IO_APIC_setup(ioapic_entries);
-		free_ioapic_entries(ioapic_entries);
-	}
-restore:
+
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 45fd33d..5e6a78e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2918,7 +2918,7 @@ static int __init io_apic_bug_finalize(void)
 
 late_initcall(io_apic_bug_finalize);
 
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
+struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
 
 static void suspend_ioapic(int ioapic_id)
 {


