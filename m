Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0INXgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:36:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0INXgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OX6H7EfYypX+9OOAJqUTFcNouvj8L2F/Qiat3cwJAxxXwcMwozMTAh0DDqCfj2H1Bw
         7hhifK6sEySWCeJqK/RA==
MIME-Version: 1.0
In-Reply-To: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
Date: Tue, 14 Sep 2010 16:36:38 -0700
Message-ID: <AANLkTin47LCphC2=CNkbYAHX085CJ=wzrpHQf-tTjSsO@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: hpet: Work around hardware stupidity
From: Venkatesh Pallipadi <venki@google.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        arjan@linux.intel.com, andreas.herrmann3@amd.com, drescherjm@gmail.com,
        art.08.09@gmail.com, damien.wyart@free.fr, suresh.b.siddha@intel.com,
        tglx@linutronix.de, nix@esperi.org.uk, mingo@elte.hu,
        borislav.petkov@amd.com, venki@google.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 4:10 PM, tip-bot for Thomas Gleixner
<tglx@linutronix.de> wrote:
> Commit-ID:  54ff7e595d763d894104d421b103a89f7becf47c
> Gitweb:     http://git.kernel.org/tip/54ff7e595d763d894104d421b103a89f7becf47c
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Tue, 14 Sep 2010 22:10:21 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 15 Sep 2010 00:55:13 +0200
>
> x86: hpet: Work around hardware stupidity
>
> This more or less reverts commits 08be979 (x86: Force HPET
> readback_cmp for all ATI chipsets) and 30a564be (x86, hpet: Restrict
> read back to affected ATI chipsets) to the status of commit 8da854c
> (x86, hpet: Erratum workaround for read after write of HPET
> comparator).
>
> The delta to commit 8da854c is mostly comments and the change from
> WARN_ONCE to printk_once as we know the call path of this function
> already.
>
> This needs really in depth explanation:
>
> First of all the HPET design is a complete failure. Having a counter
> compare register which generates an interrupt on matching values
> forces the software to do at least one superfluous readback of the
> counter register.
>
> While it is nice in theory to program "absolute" time events it is
> practically useless because the timer runs at some absurd frequency
> which can never be matched to real world units. So we are forced to
> calculate a relative delta and this forces a readout of the actual
> counter value, adding the delta and programming the compare
> register. When the delta is small enough we run into the danger that
> we program a compare value which is already in the past. Due to the
> compare for equal nature of HPET we need to read back the counter
> value after writing the compare rehgister (btw. this is necessary for
> absolute timeouts as well) to make sure that we did not miss the timer
> event. We try to work around that by setting the minimum delta to a
> value which is larger than the theoretical time which elapses between
> the counter readout and the compare register write, but that's only
> true in theory. A NMI or SMI which hits between the readout and the
> write can easily push us beyond that limit. This would result in
> waiting for the next HPET timer interrupt until the 32bit wraparound
> of the counter happens which takes about 306 seconds.
>
> So we designed the next event function to look like:
>
>   match = read_cnt() + delta;
>   write_compare_ref(match);
>   return read_cnt() < match ? 0 : -ETIME;
>
> At some point we got into trouble with certain ATI chipsets. Even the
> above "safe" procedure failed. The reason was that the write to the
> compare register was delayed probably for performance reasons. The
> theory was that they wanted to avoid the synchronization of the write
> with the HPET clock, which is understandable. So the write does not
> hit the compare register directly instead it goes to some intermediate
> register which is copied to the real compare register in sync with the
> HPET clock. That opens another window for hitting the dreaded "wait
> for a wraparound" problem.
>
> To work around that "optimization" we added a read back of the compare
> register which either enforced the update of the just written value or
> just delayed the readout of the counter enough to avoid the issue. We
> unfortunately never got any affirmative info from ATI/AMD about this.
>
> One thing is sure, that we nuked the performance "optimization" that
> way completely and I'm pretty sure that the result is worse than
> before some HW folks came up with those.
>
> Just for paranoia reasons I added a check whether the read back
> compare register value was the same as the value we wrote right
> before. That paranoia check triggered a couple of years after it was
> added on an Intel ICH9 chipset. Venki added a workaround (commit
> 8da854c) which was reading the compare register twice when the first
> check failed. We considered this to be a penalty in general and
> restricted the readback (thus the wasted CPU cycles) to the known to
> be affected ATI chipsets.
>
> This turned out to be a utterly wrong decision. 2.6.35 testers
> experienced massive problems and finally one of them bisected it down
> to commit 30a564be which spured some further investigation.
>
> Finally we got confirmation that the write to the compare register can
> be delayed by up to two HPET clock cycles which explains the problems
> nicely. All we can do about this is to go back to Venki's initial
> workaround in a slightly modified version.
>
> Just for the record I need to say, that all of this could have been
> avoided if hardware designers and of course the HPET committee would
> have thought about the consequences for a split second. It's out of my
> comprehension why designing a working timer is so hard. There are two
> ways to achieve it:
>
>  1) Use a counter wrap around aware compare_reg <= counter_reg
>    implementation instead of the easy compare_reg == counter_reg
>
>    Downsides:
>
>        - It needs more silicon.
>
>        - It needs a readout of the counter to apply a relative
>          timeout. This is necessary as the counter does not run in
>          any useful (and adjustable) frequency and there is no
>          guarantee that the counter which is used for timer events is
>          the same which is used for reading the actual time (and
>          therefor for calculating the delta)
>
>    Upsides:
>
>        - None
>
>  2) Use a simple down counter for relative timer events
>
>    Downsides:
>
>        - Absolute timeouts are not possible, which is not a problem
>          at all in the context of an OS and the expected
>          max. latencies/jitter (also see Downsides of #1)
>
>   Upsides:
>
>        - It needs less or equal silicon.
>
>        - It works ALWAYS
>
>        - It is way faster than a compare register based solution (One
>          write versus one write plus at least one and up to four
>          reads)
>
> I would not be so grumpy about all of this, if I would not have been
> ignored for many years when pointing out these flaws to various
> hardware folks. I really hate timers (at least those which seem to be
> designed by janitors).
>
> Though finally we got a reasonable explanation plus a solution and I
> want to thank all the folks involved in chasing it down and providing
> valuable input to this.
>
> Bisected-by: Nix <nix@esperi.org.uk>
> Reported-by: Artur Skawina <art.08.09@gmail.com>
> Reported-by: Damien Wyart <damien.wyart@free.fr>
> Reported-by: John Drescher <drescherjm@gmail.com>
> Cc: Venkatesh Pallipadi <venki@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: stable@kernel.org
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/hpet.h    |    1 -
>  arch/x86/kernel/early-quirks.c |   18 ------------------
>  arch/x86/kernel/hpet.c         |   31 +++++++++++++++++--------------
>  3 files changed, 17 insertions(+), 33 deletions(-)
>
> diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
> index 004e6e2..1d5c08a 100644
> --- a/arch/x86/include/asm/hpet.h
> +++ b/arch/x86/include/asm/hpet.h
> @@ -68,7 +68,6 @@ extern unsigned long force_hpet_address;
>  extern u8 hpet_blockid;
>  extern int hpet_force_user;
>  extern u8 hpet_msi_disable;
> -extern u8 hpet_readback_cmp;
>  extern int is_hpet_enabled(void);
>  extern int hpet_enable(void);
>  extern void hpet_disable(void);
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index e5cc7e8..ebdb85c 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -18,7 +18,6 @@
>  #include <asm/apic.h>
>  #include <asm/iommu.h>
>  #include <asm/gart.h>
> -#include <asm/hpet.h>
>
>  static void __init fix_hypertransport_config(int num, int slot, int func)
>  {
> @@ -192,21 +191,6 @@ static void __init ati_bugs_contd(int num, int slot, int func)
>  }
>  #endif
>
> -/*
> - * Force the read back of the CMP register in hpet_next_event()
> - * to work around the problem that the CMP register write seems to be
> - * delayed. See hpet_next_event() for details.
> - *
> - * We do this on all SMBUS incarnations for now until we have more
> - * information about the affected chipsets.
> - */
> -static void __init ati_hpet_bugs(int num, int slot, int func)
> -{
> -#ifdef CONFIG_HPET_TIMER
> -       hpet_readback_cmp = 1;
> -#endif
> -}
> -
>  #define QFLAG_APPLY_ONCE       0x1
>  #define QFLAG_APPLIED          0x2
>  #define QFLAG_DONE             (QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> @@ -236,8 +220,6 @@ static struct chipset early_qrk[] __initdata = {
>          PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
>        { PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
>          PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
> -       { PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> -         PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_hpet_bugs },
>        {}
>  };
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 351f9c0..410fdb3 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -35,7 +35,6 @@
>  unsigned long                          hpet_address;
>  u8                                     hpet_blockid; /* OS timer block num */
>  u8                                     hpet_msi_disable;
> -u8                                     hpet_readback_cmp;
>
>  #ifdef CONFIG_PCI_MSI
>  static unsigned long                   hpet_num_timers;
> @@ -395,23 +394,27 @@ static int hpet_next_event(unsigned long delta,
>         * at that point and we would wait for the next hpet interrupt
>         * forever. We found out that reading the CMP register back
>         * forces the transfer so we can rely on the comparison with
> -        * the counter register below.
> +        * the counter register below. If the read back from the
> +        * compare register does not match the value we programmed
> +        * then we might have a real hardware problem. We can not do
> +        * much about it here, but at least alert the user/admin with
> +        * a prominent warning.
>         *
> -        * That works fine on those ATI chipsets, but on newer Intel
> -        * chipsets (ICH9...) this triggers due to an erratum: Reading
> -        * the comparator immediately following a write is returning
> -        * the old value.
> +        * An erratum on some chipsets (ICH9,..), results in
> +        * comparator read immediately following a write returning old
> +        * value. Workaround for this is to read this value second
> +        * time, when first read returns old value.
>         *
> -        * We restrict the read back to the affected ATI chipsets (set
> -        * by quirks) and also run it with hpet=verbose for debugging
> -        * purposes.
> +        * In fact the write to the comparator register is delayed up
> +        * to two HPET cycles so the workaround we tried to restrict
> +        * the readback to those known to be borked ATI chipsets
> +        * failed miserably. So we give up on optimizations forever
> +        * and penalize all HPET incarnations unconditionally.
>         */
> -       if (hpet_readback_cmp || hpet_verbose) {
> -               u32 cmp = hpet_readl(HPET_Tn_CMP(timer));
> -
> -               if (cmp != cnt)
> +       if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt)) {
> +               if (hpet_readl(HPET_Tn_CMP(timer)) != cnt)

Minor nit.
I guess (u32) in first check above is not needed as hpet_readl
actually returns unsigned int.
Otherwise
Acked-by: Venkatesh Pallipadi <venki@google.com>

>                        printk_once(KERN_WARNING
> -                           "hpet: compare register read back failed.\n");
> +                               "hpet: compare register read back failed.\n");
>        }
>
>        return (s32)(hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
>
