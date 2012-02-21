Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2BUWId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:08:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab2BUWIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:08:32 -0500
Date: Tue, 21 Feb 2012 23:08:10 +0100
From: Mark Wielaard <mjw@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "Frederic Weisbecker (commit_signer:4/25=16%)" <fweisbec@gmail.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Thomas Gleixner(maintainer:X86 ARCHITECTURE...)" 
	<tglx@linutronix.de>,
        "Andi Kleen(commit_signer:5/25=20%)" <ak@linux.intel.com>,
        "commit_signer:11/25=44%)Ingo Molnar (maintainer:X86 ARCHITECTURE..." 
	<mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "commit_signer:4/25=16%) H. Peter Anvin(maintainer:X86 ARCHITECTURE..." 
	<hpa@zytor.com>
Subject: Re: [PATCH] x86-64: Fix CFI data for common_interrupt
Message-ID: <20120221220810.GE2590@toonder.wildebeest.org>
References: <1329833177-13030-1-git-send-email-mjw@redhat.com>
 <4F43B78D020000780007435B@nat28.tlf.novell.com>
 <1329835436.12079.10.camel@springer.wildebeest.org>
 <4F43C5B60200007800074392@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <4F43C5B60200007800074392@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2012 at 03:26:30PM +0000, Jan Beulich wrote:
> >>> On 21.02.12 at 15:43, Mark Wielaard <mjw@redhat.com> wrote:
> > For DW_CFA_def_register DWARF4 explicitly says so: "This operation is
> > valid only if the current CFA rule is defined to use a register and
> > offset." So one needs to use CFI_DEF_CFA with both a register and an
> > offset here after the def_cfa_expression.
> 
> Hmm, that's in contrast to the gas implementation (but I'd certainly
> give the specification preference if it explicitly states so, so gas
> should at least emit a warning here rather than considering this
> valid).

I am afraid gas cannot help us here. Since like you pointed out in your
patch:

    This requires the use of .cfi_escape (allowing arbitrary byte
    streams to be emitted into .eh_frame), as there is no
    .cfi_def_cfa_expression (which also cannot reasonably be
    expected, as it would require a full expression parser).

So we are on our own here.

> But provided the specification mandates this, I'm okay with the change
> in principle. Just that specifying an offset of 0 doesn't look right then.

Yeah, I dunno what I was thinking. The offset should be set to the offset
that was there before when rsi was pushed. The attached patch does that
by using the same value as was used at the start of common_interrupt.
Does that look OK?

Thanks,

Mark

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-64-Fix-CFI-data-for-common_interrupt.patch"

>From 5b48b64319463a4ccab560304ce3cf72c71d081d Mon Sep 17 00:00:00 2001
From: Mark Wielaard <mjw@redhat.com>
Date: Tue, 21 Feb 2012 14:45:52 +0100
Subject: [PATCH] x86-64: Fix CFI data for common_interrupt

Commit eab9e6 "x86-64: Fix CFI data for interrupt frames" introduced
a DW_CFA_def_cfa_expression in the SAVE_ARGS_IRQ macro. To later define
the CFA using a simple register+offset rule both register and offset
need to be supplied. Just using CFI_DEF_CFA_REGISTER leaves the offset
undefined. So use CFI_DEF_CFA with reg+off explicitly at the end of
common_interrupt.

Signed-off-by: Mark Wielaard <mjw@redhat.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3fe8239..308b604 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -813,7 +813,7 @@ ret_from_intr:
 
 	/* Restore saved previous stack */
 	popq %rsi
-	CFI_DEF_CFA_REGISTER	rsi
+	CFI_DEF_CFA rsi,16+SS-RBP	/* reg/off reset after def_cfa_expr */
 	leaq ARGOFFSET-RBP(%rsi), %rsp
 	CFI_DEF_CFA_REGISTER	rsp
 	CFI_ADJUST_CFA_OFFSET	RBP-ARGOFFSET
-- 
1.7.7.6


--RnlQjJ0d97Da+TV1--
