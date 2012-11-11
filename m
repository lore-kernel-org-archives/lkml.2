Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KKJu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 04:50:27 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42212 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2KKJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 04:50:24 -0500
MIME-Version: 1.0
In-Reply-To: <1352408516-21988-5-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
	<1352408516-21988-5-git-send-email-swarren@wwwdotorg.org>
Date: Sun, 11 Nov 2012 10:50:23 +0100
X-Google-Sender-Auth: 9bWwYmKIscvtUtCxeKVTAmrGi1I
Message-ID: <CAMuHMdWP6qnNesTbFTNyUi=GtLef81zW5=FX-fpNVuyH-FXUhQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] m68k: set arch_gettimeoffset directly
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Philip Blundell <philb@gnu.org>, Joshua Thompson <funaho@jurai.org>,
        Sam Creasey <sammy@sammy.net>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 10:01 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> remove m68k's mach_gettimeoffset function pointer, and instead directly
> set the arch_gettimeoffset function pointer. This requires multiplying
> all function results by 1000, since the removed m68k_gettimeoffset() did
> this. Also, s/unsigned long/u32/ just to make the function prototypes
> exactly match that of arch_gettimeoffset.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> Cc: Philip Blundell <philb@gnu.org>
> Cc: Joshua Thompson <funaho@jurai.org>
> Cc: Sam Creasey <sammy@sammy.net>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/m68k/amiga/config.c        |   10 +++++-----
>  arch/m68k/apollo/config.c       |    9 ++++-----
>  arch/m68k/atari/config.c        |    4 ++--
>  arch/m68k/atari/time.c          |    6 +++---
>  arch/m68k/bvme6000/config.c     |   10 +++++-----
>  arch/m68k/hp300/config.c        |    2 +-
>  arch/m68k/hp300/time.c          |    4 ++--
>  arch/m68k/hp300/time.h          |    2 +-
>  arch/m68k/include/asm/machdep.h |    2 +-
>  arch/m68k/kernel/setup_mm.c     |    1 -
>  arch/m68k/kernel/time.c         |    9 ---------
>  arch/m68k/mac/config.c          |    4 ++--
>  arch/m68k/mac/via.c             |    4 ++--
>  arch/m68k/mvme147/config.c      |    8 ++++----
>  arch/m68k/mvme16x/config.c      |    8 ++++----
>  arch/m68k/q40/config.c          |    8 ++++----
>  arch/m68k/sun3/config.c         |    4 ++--
>  arch/m68k/sun3/intersil.c       |    4 ++--
>  arch/m68k/sun3x/config.c        |    2 +-
>  arch/m68k/sun3x/time.c          |    2 +-
>  arch/m68k/sun3x/time.h          |    2 +-
>  21 files changed, 47 insertions(+), 58 deletions(-)
>
> diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
> index ee01b7a..b819390 100644
> --- a/arch/m68k/amiga/config.c
> +++ b/arch/m68k/amiga/config.c
> @@ -95,7 +95,7 @@ static void amiga_sched_init(irq_handler_t handler);
>  static void amiga_get_model(char *model);
>  static void amiga_get_hardware_list(struct seq_file *m);
>  /* amiga specific timer functions */
> -static unsigned long amiga_gettimeoffset(void);
> +static u32 amiga_gettimeoffset(void);
>  extern void amiga_mksound(unsigned int count, unsigned int ticks);
>  static void amiga_reset(void);
>  extern void amiga_init_sound(void);
> @@ -377,7 +377,7 @@ void __init config_amiga(void)
>         mach_init_IRQ        = amiga_init_IRQ;
>         mach_get_model       = amiga_get_model;
>         mach_get_hardware_list = amiga_get_hardware_list;
> -       mach_gettimeoffset   = amiga_gettimeoffset;
> +       arch_gettimeoffset   = amiga_gettimeoffset;
>
>         /*
>          * default MAX_DMA=0xffffffff on all machines. If we don't do so, the SCSI
> @@ -482,10 +482,10 @@ static void __init amiga_sched_init(irq_handler_t timer_routine)
>  #define TICK_SIZE 10000
>
>  /* This is always executed with interrupts disabled.  */
> -static unsigned long amiga_gettimeoffset(void)
> +static u32 amiga_gettimeoffset(void)
>  {
>         unsigned short hi, lo, hi2;
> -       unsigned long ticks, offset = 0;
> +       u32 ticks, offset = 0;
>
>         /* read CIA B timer A current value */
>         hi  = ciab.tahi;
> @@ -507,7 +507,7 @@ static unsigned long amiga_gettimeoffset(void)
>         ticks = jiffy_ticks - ticks;
>         ticks = (10000 * ticks) / jiffy_ticks;
>
> -       return ticks + offset;
> +       return (ticks + offset) * 1000;
>  }
>
>  static void amiga_reset(void)  __noreturn;
> diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
> index f5565d6..3ea56b9 100644
> --- a/arch/m68k/apollo/config.c
> +++ b/arch/m68k/apollo/config.c
> @@ -26,7 +26,7 @@ u_long apollo_model;
>
>  extern void dn_sched_init(irq_handler_t handler);
>  extern void dn_init_IRQ(void);
> -extern unsigned long dn_gettimeoffset(void);
> +extern u32 dn_gettimeoffset(void);
>  extern int dn_dummy_hwclk(int, struct rtc_time *);
>  extern int dn_dummy_set_clock_mmss(unsigned long);
>  extern void dn_dummy_reset(void);
> @@ -151,7 +151,7 @@ void __init config_apollo(void)
>
>         mach_sched_init=dn_sched_init; /* */
>         mach_init_IRQ=dn_init_IRQ;
> -       mach_gettimeoffset   = dn_gettimeoffset;
> +       arch_gettimeoffset   = dn_gettimeoffset;
>         mach_max_dma_address = 0xffffffff;
>         mach_hwclk           = dn_dummy_hwclk; /* */
>         mach_set_clock_mmss  = dn_dummy_set_clock_mmss; /* */
> @@ -203,10 +203,9 @@ void dn_sched_init(irq_handler_t timer_routine)
>                 pr_err("Couldn't register timer interrupt\n");
>  }
>
> -unsigned long dn_gettimeoffset(void) {
> -
> +u32 dn_gettimeoffset(void)
> +{
>         return 0xdeadbeef;
> -
>  }
>
>  int dn_dummy_hwclk(int op, struct rtc_time *t) {
> diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
> index d8eb327..037c11c 100644
> --- a/arch/m68k/atari/config.c
> +++ b/arch/m68k/atari/config.c
> @@ -74,7 +74,7 @@ static void atari_heartbeat(int on);
>
>  /* atari specific timer functions (in time.c) */
>  extern void atari_sched_init(irq_handler_t);
> -extern unsigned long atari_gettimeoffset (void);
> +extern u32 atari_gettimeoffset(void);
>  extern int atari_mste_hwclk (int, struct rtc_time *);
>  extern int atari_tt_hwclk (int, struct rtc_time *);
>  extern int atari_mste_set_clock_mmss (unsigned long);
> @@ -204,7 +204,7 @@ void __init config_atari(void)
>         mach_init_IRQ        = atari_init_IRQ;
>         mach_get_model   = atari_get_model;
>         mach_get_hardware_list = atari_get_hardware_list;
> -       mach_gettimeoffset   = atari_gettimeoffset;
> +       arch_gettimeoffset   = atari_gettimeoffset;
>         mach_reset           = atari_reset;
>         mach_max_dma_address = 0xffffff;
>  #if defined(CONFIG_INPUT_M68K_BEEP) || defined(CONFIG_INPUT_M68K_BEEP_MODULE)
> diff --git a/arch/m68k/atari/time.c b/arch/m68k/atari/time.c
> index c0cc68a..da8f981 100644
> --- a/arch/m68k/atari/time.c
> +++ b/arch/m68k/atari/time.c
> @@ -42,9 +42,9 @@ atari_sched_init(irq_handler_t timer_routine)
>  #define TICK_SIZE 10000
>
>  /* This is always executed with interrupts disabled.  */
> -unsigned long atari_gettimeoffset (void)
> +u32 atari_gettimeoffset(void)
>  {
> -  unsigned long ticks, offset = 0;
> +  u32 ticks, offset = 0;
>
>    /* read MFP timer C current value */
>    ticks = st_mfp.tim_dt_c;
> @@ -57,7 +57,7 @@ unsigned long atari_gettimeoffset (void)
>    ticks = INT_TICKS - ticks;
>    ticks = ticks * 10000L / INT_TICKS;
>
> -  return ticks + offset;
> +  return (ticks + offset) * 1000;
>  }
>
>
> diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
> index 0bf850a..8943aa4 100644
> --- a/arch/m68k/bvme6000/config.c
> +++ b/arch/m68k/bvme6000/config.c
> @@ -38,7 +38,7 @@
>
>  static void bvme6000_get_model(char *model);
>  extern void bvme6000_sched_init(irq_handler_t handler);
> -extern unsigned long bvme6000_gettimeoffset (void);
> +extern u32 bvme6000_gettimeoffset(void);
>  extern int bvme6000_hwclk (int, struct rtc_time *);
>  extern int bvme6000_set_clock_mmss (unsigned long);
>  extern void bvme6000_reset (void);
> @@ -110,7 +110,7 @@ void __init config_bvme6000(void)
>      mach_max_dma_address = 0xffffffff;
>      mach_sched_init      = bvme6000_sched_init;
>      mach_init_IRQ        = bvme6000_init_IRQ;
> -    mach_gettimeoffset   = bvme6000_gettimeoffset;
> +    arch_gettimeoffset   = bvme6000_gettimeoffset;
>      mach_hwclk           = bvme6000_hwclk;
>      mach_set_clock_mmss         = bvme6000_set_clock_mmss;
>      mach_reset          = bvme6000_reset;
> @@ -216,13 +216,13 @@ void bvme6000_sched_init (irq_handler_t timer_routine)
>   * results...
>   */
>
> -unsigned long bvme6000_gettimeoffset (void)
> +u32 bvme6000_gettimeoffset(void)
>  {
>      volatile RtcPtr_t rtc = (RtcPtr_t)BVME_RTC_BASE;
>      volatile PitRegsPtr pit = (PitRegsPtr)BVME_PIT_BASE;
>      unsigned char msr = rtc->msr & 0xc0;
>      unsigned char t1int, t1op;
> -    unsigned long v = 800000, ov;
> +    u32 v = 800000, ov;
>
>      rtc->msr = 0;      /* Ensure timer registers accessible */
>
> @@ -246,7 +246,7 @@ unsigned long bvme6000_gettimeoffset (void)
>         v += 10000;                     /* Int pending, + 10ms */
>      rtc->msr = msr;
>
> -    return v;
> +    return v * 1000;
>  }
>
>  /*
> diff --git a/arch/m68k/hp300/config.c b/arch/m68k/hp300/config.c
> index bf16af1..b7609f7 100644
> --- a/arch/m68k/hp300/config.c
> +++ b/arch/m68k/hp300/config.c
> @@ -251,7 +251,7 @@ void __init config_hp300(void)
>         mach_sched_init      = hp300_sched_init;
>         mach_init_IRQ        = hp300_init_IRQ;
>         mach_get_model       = hp300_get_model;
> -       mach_gettimeoffset   = hp300_gettimeoffset;
> +       arch_gettimeoffset   = hp300_gettimeoffset;
>         mach_hwclk           = hp300_hwclk;
>         mach_get_ss          = hp300_get_ss;
>         mach_reset           = hp300_reset;
> diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
> index 29a71be..749543b 100644
> --- a/arch/m68k/hp300/time.c
> +++ b/arch/m68k/hp300/time.c
> @@ -46,7 +46,7 @@ static irqreturn_t hp300_tick(int irq, void *dev_id)
>         return vector(irq, NULL);
>  }
>
> -unsigned long hp300_gettimeoffset(void)
> +u32 hp300_gettimeoffset(void)
>  {
>    /* Read current timer 1 value */
>    unsigned char lsb, msb1, msb2;
> @@ -59,7 +59,7 @@ unsigned long hp300_gettimeoffset(void)
>      /* A carry happened while we were reading.  Read it again */
>      lsb = in_8(CLOCKBASE + 7);
>    ticks = INTVAL - ((msb2 << 8) | lsb);
> -  return (USECS_PER_JIFFY * ticks) / INTVAL;
> +  return ((USECS_PER_JIFFY * ticks) / INTVAL) * 1000;
>  }
>
>  void __init hp300_sched_init(irq_handler_t vector)
> diff --git a/arch/m68k/hp300/time.h b/arch/m68k/hp300/time.h
> index 7b98242..f5583ec 100644
> --- a/arch/m68k/hp300/time.h
> +++ b/arch/m68k/hp300/time.h
> @@ -1,2 +1,2 @@
>  extern void hp300_sched_init(irq_handler_t vector);
> -extern unsigned long hp300_gettimeoffset(void);
> +extern u32 hp300_gettimeoffset(void);
> diff --git a/arch/m68k/include/asm/machdep.h b/arch/m68k/include/asm/machdep.h
> index 825c1c8..953ca21 100644
> --- a/arch/m68k/include/asm/machdep.h
> +++ b/arch/m68k/include/asm/machdep.h
> @@ -3,6 +3,7 @@
>
>  #include <linux/seq_file.h>
>  #include <linux/interrupt.h>
> +#include <linux/time.h>
>
>  struct pt_regs;
>  struct mktime;
> @@ -16,7 +17,6 @@ extern void (*mach_init_IRQ) (void);
>  extern void (*mach_get_model) (char *model);
>  extern void (*mach_get_hardware_list) (struct seq_file *m);
>  /* machine dependent timer functions */
> -extern unsigned long (*mach_gettimeoffset)(void);
>  extern int (*mach_hwclk)(int, struct rtc_time*);
>  extern unsigned int (*mach_get_ss)(void);
>  extern int (*mach_get_rtc_pll)(struct rtc_pll_info *);
> diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
> index d872ce4..80cfbe5 100644
> --- a/arch/m68k/kernel/setup_mm.c
> +++ b/arch/m68k/kernel/setup_mm.c
> @@ -84,7 +84,6 @@ void (*mach_init_IRQ) (void) __initdata = NULL;
>  void (*mach_get_model) (char *model);
>  void (*mach_get_hardware_list) (struct seq_file *m);
>  /* machine dependent timer functions */
> -unsigned long (*mach_gettimeoffset) (void);
>  int (*mach_hwclk) (int, struct rtc_time*);
>  EXPORT_SYMBOL(mach_hwclk);
>  int (*mach_set_clock_mmss) (unsigned long);
> diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
> index c2994c8..bea6bcf 100644
> --- a/arch/m68k/kernel/time.c
> +++ b/arch/m68k/kernel/time.c
> @@ -82,11 +82,6 @@ void read_persistent_clock(struct timespec *ts)
>
>  #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
>
> -static u32 m68k_gettimeoffset(void)
> -{
> -       return mach_gettimeoffset() * 1000;
> -}
> -
>  static int __init rtc_init(void)
>  {
>         struct platform_device *pdev;
> @@ -104,9 +99,5 @@ module_init(rtc_init);
>
>  void __init time_init(void)
>  {
> -#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
> -       arch_gettimeoffset = m68k_gettimeoffset;
> -#endif
> -
>         mach_sched_init(timer_interrupt);
>  }
> diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
> index d9f62e0..afb95d5 100644
> --- a/arch/m68k/mac/config.c
> +++ b/arch/m68k/mac/config.c
> @@ -52,7 +52,7 @@ struct mac_booter_data mac_bi_data;
>  static unsigned long mac_orig_videoaddr;
>
>  /* Mac specific timer functions */
> -extern unsigned long mac_gettimeoffset(void);
> +extern u32 mac_gettimeoffset(void);
>  extern int mac_hwclk(int, struct rtc_time *);
>  extern int mac_set_clock_mmss(unsigned long);
>  extern void iop_preinit(void);
> @@ -177,7 +177,7 @@ void __init config_mac(void)
>         mach_sched_init = mac_sched_init;
>         mach_init_IRQ = mac_init_IRQ;
>         mach_get_model = mac_get_model;
> -       mach_gettimeoffset = mac_gettimeoffset;
> +       arch_gettimeoffset = mac_gettimeoffset;
>         mach_hwclk = mac_hwclk;
>         mach_set_clock_mmss = mac_set_clock_mmss;
>         mach_reset = mac_reset;
> diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
> index 2d85662..5d1458b 100644
> --- a/arch/m68k/mac/via.c
> +++ b/arch/m68k/mac/via.c
> @@ -327,7 +327,7 @@ void via_debug_dump(void)
>   * TBI: get time offset between scheduling timer ticks
>   */
>
> -unsigned long mac_gettimeoffset (void)
> +u32 mac_gettimeoffset(void)
>  {
>         unsigned long ticks, offset = 0;
>
> @@ -341,7 +341,7 @@ unsigned long mac_gettimeoffset (void)
>         ticks = MAC_CLOCK_TICK - ticks;
>         ticks = ticks * 10000L / MAC_CLOCK_TICK;
>
> -       return ticks + offset;
> +       return (ticks + offset) * 1000;
>  }
>
>  /*
> diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
> index a41c091..1c62628 100644
> --- a/arch/m68k/mvme147/config.c
> +++ b/arch/m68k/mvme147/config.c
> @@ -37,7 +37,7 @@
>
>  static void mvme147_get_model(char *model);
>  extern void mvme147_sched_init(irq_handler_t handler);
> -extern unsigned long mvme147_gettimeoffset (void);
> +extern u32 mvme147_gettimeoffset(void);
>  extern int mvme147_hwclk (int, struct rtc_time *);
>  extern int mvme147_set_clock_mmss (unsigned long);
>  extern void mvme147_reset (void);
> @@ -88,7 +88,7 @@ void __init config_mvme147(void)
>         mach_max_dma_address    = 0x01000000;
>         mach_sched_init         = mvme147_sched_init;
>         mach_init_IRQ           = mvme147_init_IRQ;
> -       mach_gettimeoffset      = mvme147_gettimeoffset;
> +       arch_gettimeoffset      = mvme147_gettimeoffset;
>         mach_hwclk              = mvme147_hwclk;
>         mach_set_clock_mmss     = mvme147_set_clock_mmss;
>         mach_reset              = mvme147_reset;
> @@ -127,7 +127,7 @@ void mvme147_sched_init (irq_handler_t timer_routine)
>
>  /* This is always executed with interrupts disabled.  */
>  /* XXX There are race hazards in this code XXX */
> -unsigned long mvme147_gettimeoffset (void)
> +u32 mvme147_gettimeoffset(void)
>  {
>         volatile unsigned short *cp = (volatile unsigned short *)0xfffe1012;
>         unsigned short n;
> @@ -137,7 +137,7 @@ unsigned long mvme147_gettimeoffset (void)
>                 n = *cp;
>
>         n -= PCC_TIMER_PRELOAD;
> -       return (unsigned long)n * 25 / 4;
> +       return ((unsigned long)n * 25 / 4) * 1000;
>  }
>
>  static int bcd2int (unsigned char b)
> diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
> index b6d7d8a..080a342 100644
> --- a/arch/m68k/mvme16x/config.c
> +++ b/arch/m68k/mvme16x/config.c
> @@ -43,7 +43,7 @@ static MK48T08ptr_t volatile rtc = (MK48T08ptr_t)MVME_RTC_BASE;
>
>  static void mvme16x_get_model(char *model);
>  extern void mvme16x_sched_init(irq_handler_t handler);
> -extern unsigned long mvme16x_gettimeoffset (void);
> +extern u32 mvme16x_gettimeoffset(void);
>  extern int mvme16x_hwclk (int, struct rtc_time *);
>  extern int mvme16x_set_clock_mmss (unsigned long);
>  extern void mvme16x_reset (void);
> @@ -289,7 +289,7 @@ void __init config_mvme16x(void)
>      mach_max_dma_address = 0xffffffff;
>      mach_sched_init      = mvme16x_sched_init;
>      mach_init_IRQ        = mvme16x_init_IRQ;
> -    mach_gettimeoffset   = mvme16x_gettimeoffset;
> +    arch_gettimeoffset   = mvme16x_gettimeoffset;
>      mach_hwclk           = mvme16x_hwclk;
>      mach_set_clock_mmss         = mvme16x_set_clock_mmss;
>      mach_reset          = mvme16x_reset;
> @@ -405,9 +405,9 @@ void mvme16x_sched_init (irq_handler_t timer_routine)
>
>
>  /* This is always executed with interrupts disabled.  */
> -unsigned long mvme16x_gettimeoffset (void)
> +u32 mvme16x_gettimeoffset(void)
>  {
> -    return (*(volatile unsigned long *)0xfff42008);
> +    return (*(volatile u32 *)0xfff42008) * 1000;
>  }
>
>  int bcd2int (unsigned char b)
> diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
> index 1adb5b7..658542b 100644
> --- a/arch/m68k/q40/config.c
> +++ b/arch/m68k/q40/config.c
> @@ -40,7 +40,7 @@ extern void q40_init_IRQ(void);
>  static void q40_get_model(char *model);
>  extern void q40_sched_init(irq_handler_t handler);
>
> -static unsigned long q40_gettimeoffset(void);
> +static u32 q40_gettimeoffset(void);
>  static int q40_hwclk(int, struct rtc_time *);
>  static unsigned int q40_get_ss(void);
>  static int q40_set_clock_mmss(unsigned long);
> @@ -170,7 +170,7 @@ void __init config_q40(void)
>         mach_sched_init = q40_sched_init;
>
>         mach_init_IRQ = q40_init_IRQ;
> -       mach_gettimeoffset = q40_gettimeoffset;
> +       arch_gettimeoffset = q40_gettimeoffset;
>         mach_hwclk = q40_hwclk;
>         mach_get_ss = q40_get_ss;
>         mach_get_rtc_pll = q40_get_rtc_pll;
> @@ -204,9 +204,9 @@ int q40_parse_bootinfo(const struct bi_record *rec)
>  }
>
>
> -static unsigned long q40_gettimeoffset(void)
> +static u32 q40_gettimeoffset(void)
>  {
> -       return 5000 * (ql_ticks != 0);
> +       return 5000 * (ql_ticks != 0) * 1000;
>  }
>
>
> diff --git a/arch/m68k/sun3/config.c b/arch/m68k/sun3/config.c
> index 2ca25bd..f59ec58 100644
> --- a/arch/m68k/sun3/config.c
> +++ b/arch/m68k/sun3/config.c
> @@ -36,7 +36,7 @@
>
>  char sun3_reserved_pmeg[SUN3_PMEGS_NUM];
>
> -extern unsigned long sun3_gettimeoffset(void);
> +extern u32 sun3_gettimeoffset(void);
>  static void sun3_sched_init(irq_handler_t handler);
>  extern void sun3_get_model (char* model);
>  extern int sun3_hwclk(int set, struct rtc_time *t);
> @@ -141,7 +141,7 @@ void __init config_sun3(void)
>          mach_sched_init      =  sun3_sched_init;
>          mach_init_IRQ        =  sun3_init_IRQ;
>          mach_reset           =  sun3_reboot;
> -       mach_gettimeoffset   =  sun3_gettimeoffset;
> +       arch_gettimeoffset   =  sun3_gettimeoffset;
>         mach_get_model       =  sun3_get_model;
>         mach_hwclk           =  sun3_hwclk;
>         mach_halt            =  sun3_halt;
> diff --git a/arch/m68k/sun3/intersil.c b/arch/m68k/sun3/intersil.c
> index 94fe801..889829e 100644
> --- a/arch/m68k/sun3/intersil.c
> +++ b/arch/m68k/sun3/intersil.c
> @@ -23,9 +23,9 @@
>  #define START_VAL (INTERSIL_RUN | INTERSIL_INT_ENABLE | INTERSIL_24H_MODE)
>
>  /* does this need to be implemented? */
> -unsigned long sun3_gettimeoffset(void)
> +u32 sun3_gettimeoffset(void)
>  {
> -  return 1;
> +  return 1000;
>  }
>
>
> diff --git a/arch/m68k/sun3x/config.c b/arch/m68k/sun3x/config.c
> index dd306c8..0532d64 100644
> --- a/arch/m68k/sun3x/config.c
> +++ b/arch/m68k/sun3x/config.c
> @@ -48,7 +48,7 @@ void __init config_sun3x(void)
>         mach_sched_init      = sun3x_sched_init;
>         mach_init_IRQ        = sun3_init_IRQ;
>
> -       mach_gettimeoffset   = sun3x_gettimeoffset;
> +       arch_gettimeoffset   = sun3x_gettimeoffset;
>         mach_reset           = sun3x_reboot;
>
>         mach_hwclk           = sun3x_hwclk;
> diff --git a/arch/m68k/sun3x/time.c b/arch/m68k/sun3x/time.c
> index 1d0a724..c8eb08a 100644
> --- a/arch/m68k/sun3x/time.c
> +++ b/arch/m68k/sun3x/time.c
> @@ -71,7 +71,7 @@ int sun3x_hwclk(int set, struct rtc_time *t)
>         return 0;
>  }
>  /* Not much we can do here */
> -unsigned long sun3x_gettimeoffset (void)
> +u32 sun3x_gettimeoffset(void)
>  {
>      return 0L;
>  }
> diff --git a/arch/m68k/sun3x/time.h b/arch/m68k/sun3x/time.h
> index 6909e12..a4f9126 100644
> --- a/arch/m68k/sun3x/time.h
> +++ b/arch/m68k/sun3x/time.h
> @@ -2,7 +2,7 @@
>  #define SUN3X_TIME_H
>
>  extern int sun3x_hwclk(int set, struct rtc_time *t);
> -unsigned long sun3x_gettimeoffset (void);
> +u32 sun3x_gettimeoffset(void);
>  void sun3x_sched_init(irq_handler_t vector);
>
>  struct mostek_dt {
> --

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
