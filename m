Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0LHIEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:04:32 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:58033 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0LHIEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:04:31 -0500
Date: Wed, 8 Dec 2010 09:04:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [121/127] [S390] nmi: fix clock comparator revalidation
Message-ID: <20101208080428.GA2523@osiris.boeblingen.de.ibm.com>
References: <20101208004456.GA23578@kroah.com>
 <20101208004436.427324416@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101208004436.427324416@clark.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 04:45:07PM -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> commit e8129c642155616d9e2160a75f103e127c8c3708 upstream.
> 
> On each machine check all registers are revalidated. The save area for
> the clock comparator however only contains the upper most seven bytes
> of the former contents, if valid.
> Therefore the machine check handler uses a store clock instruction to
> get the current time and writes that to the clock comparator register
> which in turn will generate an immediate timer interrupt.
> However within the lowcore the expected time of the next timer
> interrupt is stored. If the interrupt happens before that time the
> handler won't be called. In turn the clock comparator won't be
> reprogrammed and therefore the interrupt condition stays pending which
> causes an interrupt loop until the expected time is reached.
> 
> On NOHZ machines this can result in unresponsive machines since the
> time of the next expected interrupted can be a couple of days in the
> future.
> 
> To fix this just revalidate the clock comparator register with the
> expected value.
> In addition the special handling for udelay must be changed as well.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

[...]

> ---
>  arch/s390/kernel/nmi.c |   10 ++++------
>  arch/s390/lib/delay.c  |   14 +++++++++-----
>  2 files changed, 13 insertions(+), 11 deletions(-)
> 
> --- a/arch/s390/kernel/nmi.c
> +++ b/arch/s390/kernel/nmi.c
> @@ -95,7 +95,6 @@ EXPORT_SYMBOL_GPL(s390_handle_mcck);
>  static int notrace s390_revalidate_registers(struct mci *mci)
>  {
>  	int kill_task;
> -	u64 tmpclock;
>  	u64 zero;
>  	void *fpt_save_area, *fpt_creg_save_area;
> 
> @@ -214,11 +213,10 @@ static int notrace s390_revalidate_regis
>  			: "0", "cc");
>  #endif
>  	/* Revalidate clock comparator register */
> -	asm volatile(
> -		"	stck	0(%1)\n"
> -		"	sckc	0(%1)"
> -		: "=m" (tmpclock) : "a" (&(tmpclock)) : "cc", "memory");
> -
> +	if (S390_lowcore.clock_comparator == -1)
> +		set_clock_comparator(S390_lowcore.mcck_clock);
^^^
This line won't compile on 2.6.32. That's why I sent a slightly different
patch to -stable (and also the reason why I removed Martin's Sign-off) ;)

Here is the version I sent to stable@kernel.org again:

Subject: [S390] nmi: fix clock comparator revalidation

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit e8129c642155616d9e2160a75f103e127c8c3708 upstream

On each machine check all registers are revalidated. The save area for
the clock comparator however only contains the upper most seven bytes
of the former contents, if valid.
Therefore the machine check handler uses a store clock instruction to
get the current time and writes that to the clock comparator register
which in turn will generate an immediate timer interrupt.
However within the lowcore the expected time of the next timer
interrupt is stored. If the interrupt happens before that time the
handler won't be called. In turn the clock comparator won't be
reprogrammed and therefore the interrupt condition stays pending which
causes an interrupt loop until the expected time is reached.

On NOHZ machines this can result in unresponsive machines since the
time of the next expected interrupted can be a couple of days in the
future.

To fix this just revalidate the clock comparator register with the
expected value.
In addition the special handling for udelay must be changed as well.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Patch applies against 2.6.32.26.

 arch/s390/kernel/nmi.c |   10 ++++------
 arch/s390/lib/delay.c  |   14 +++++++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -95,7 +95,6 @@ EXPORT_SYMBOL_GPL(s390_handle_mcck);
 static int notrace s390_revalidate_registers(struct mci *mci)
 {
 	int kill_task;
-	u64 tmpclock;
 	u64 zero;
 	void *fpt_save_area, *fpt_creg_save_area;
 
@@ -214,11 +213,10 @@ static int notrace s390_revalidate_regis
 			: "0", "cc");
 #endif
 	/* Revalidate clock comparator register */
-	asm volatile(
-		"	stck	0(%1)\n"
-		"	sckc	0(%1)"
-		: "=m" (tmpclock) : "a" (&(tmpclock)) : "cc", "memory");
-
+	if (S390_lowcore.clock_comparator == -1)
+		set_clock_comparator(get_clock());
+	else
+		set_clock_comparator(S390_lowcore.clock_comparator);
 	/* Check if old PSW is valid */
 	if (!mci->wp)
 		/*
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -29,17 +29,21 @@ static void __udelay_disabled(unsigned l
 {
 	unsigned long mask, cr0, cr0_saved;
 	u64 clock_saved;
+	u64 end;
 
+	mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_EXT;
+	end = get_clock() + (usecs << 12);
 	clock_saved = local_tick_disable();
-	set_clock_comparator(get_clock() + (usecs << 12));
 	__ctl_store(cr0_saved, 0, 0);
 	cr0 = (cr0_saved & 0xffff00e0) | 0x00000800;
 	__ctl_load(cr0 , 0, 0);
-	mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_EXT;
 	lockdep_off();
-	trace_hardirqs_on();
-	__load_psw_mask(mask);
-	local_irq_disable();
+	do {
+		set_clock_comparator(end);
+		trace_hardirqs_on();
+		__load_psw_mask(mask);
+		local_irq_disable();
+	} while (get_clock() < end);
 	lockdep_on();
 	__ctl_load(cr0_saved, 0, 0);
 	local_tick_enable(clock_saved);
