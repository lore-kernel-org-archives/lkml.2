Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0DHLSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 07:18:01 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:55548 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab0DHLR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:17:58 -0400
X-Greylist: delayed 1253 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2010 07:17:58 EDT
Date: Thu, 08 Apr 2010 12:56:53 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 2/2] AT91 slow-clock resume: don't restore the PLL
 settings when the PLL was off
To: Andrew Victor <avictor.za@gmail.com>
Cc: Julien Langer <julien.langer@gmail.com>,
       linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <x2qcd73a99e1004061445j8698c478z9f021d5f3dd8f81b@mail.gmail.com>
	(from avictor.za@gmail.com on Tue Apr  6 23:45:41 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1270724213l.12911l.1l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <x2qcd73a99e1004061445j8698c478z9f021d5f3dd8f81b@mail.gmail.com>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 2010-04-06 23:45:41, Andrew Victor wrote:
> I don't think it's sufficient skip the "wait for lock" if the
> PLLA/PLLB value is 0.
> For example, since bit 29 of PLLA is always 1, the wait_pllalock will
> always run - even if MULA is 0 (which means the PLLA is disabled) and
> will therefore never lock.
> Similarly, for other bits in the register which might happen to be set.
> 
> The code should rather be something like:
>   Save PLLA
>   Save PLLB
>   ... wait for interrupt ....
>   Restore PLLB
>   if (PLLB & AT91_PMC_MUL != 0)
>       Wait for PLLB to lock
>   Restore PLLA
>   if (PLLA & AT91_PMC_MUL != 0)
>       Wait for PLLA to lock

point taken.

The (more simple) patch below should match your suggestion
(added as #6043/1 to rmk's tracker):

at91: slow-clock resume: Don't wait for a disabled PLL to lock.

We run into this problem with the PLLB on the at91: ohci-at91 disables the PLLB
when going to suspend. The slowclock code however tries to do the same: It
saves the PLLB register value and when restoring the value during resume, it
waits for the PLLB to lock again. However the PLL will never lock and the loop
would run into its timeout because the slowclock code just stored and restored
an empty register.
This fixes the problem by only restoring PLLA/PLLB when they were enabled
at suspend time.

Signed-off-by: Anders Larsen <al@alarsen.net>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: Julien Langer <julien.langer@gmail.com>
---

 arch/arm/mach-at91/pm_slowclock.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)


Index: b/arch/arm/mach-at91/pm_slowclock.S
===================================================================
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -201,13 +201,25 @@ ENTRY(at91_slow_clock)
 	ldr	r3, .saved_pllbr
 	str	r3, [r1, #(AT91_CKGR_PLLBR - AT91_PMC)]
 
+	tst	r3, #(AT91_PMC_MUL &  0xff0000)
+	bne	1f
+	tst	r3, #(AT91_PMC_MUL & ~0xff0000)
+	beq	2f
+1:
 	wait_pllblock
+2:
 
 	/* Restore PLLA setting */
 	ldr	r3, .saved_pllar
 	str	r3, [r1, #(AT91_CKGR_PLLAR - AT91_PMC)]
 
+	tst	r3, #(AT91_PMC_MUL &  0xff0000)
+	bne	3f
+	tst	r3, #(AT91_PMC_MUL & ~0xff0000)
+	beq	4f
+3:
 	wait_pllalock
+4:
 
 #ifdef SLOWDOWN_MASTER_CLOCK
 	/*

