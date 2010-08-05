Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab0HEWUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:20:39 -0400
Received: from www.tglx.de ([62.245.132.106]:53975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab0HEWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:20:32 -0400
Date: Fri, 6 Aug 2010 00:19:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timekeeping updates for 2.6.36
Message-ID: <alpine.LFD.2.00.1008060016300.3225@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-timekeeping-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-timekeeping-for-linus

It contains two cherry-picks from the powerpc tree which have changes
in the same area of code. John Stultz selected them with the powerpc
folks to avoid complex fixups in next.

Thanks,

	tglx

------------------>
John Stultz (11):
      x86: Fix vtime/file timestamp inconsistencies
      time: Implement timespec_add
      time: Kill off CONFIG_GENERIC_TIME
      powerpc: Simplify update_vsyscall
      powerpc: Cleanup xtime usage
      timkeeping: Fix update_vsyscall to provide wall_to_monotonic offset
      um: Convert to use read_persistent_clock
      hrtimer: Cleanup direct access to wall_to_monotonic
      timekeeping: Make xtime and wall_to_monotonic static
      x86: Convert common clocksources to use clocksource_register_hz/khz
      clocksource: Add __clocksource_updatefreq_hz/khz methods

Paul Mackerras (2):
      powerpc: Rework VDSO gettimeofday to prevent time going backwards
      powerpc: Clean up obsolete code relating to decrementer and timebase

Thomas Gleixner (2):
      kgdb: Do not access xtime directly
      um: Fix read_persistent_clock fallout


 Documentation/feature-removal-schedule.txt   |   10 --
 Documentation/kernel-parameters.txt          |    3 +-
 arch/alpha/Kconfig                           |    4 -
 arch/arm/Kconfig                             |    4 -
 arch/avr32/Kconfig                           |    3 -
 arch/blackfin/Kconfig                        |    3 -
 arch/cris/Kconfig                            |    3 -
 arch/frv/Kconfig                             |    4 -
 arch/h8300/Kconfig                           |    4 -
 arch/ia64/Kconfig                            |    4 -
 arch/ia64/kernel/time.c                      |    7 +-
 arch/m32r/Kconfig                            |    3 -
 arch/m68k/Kconfig                            |    3 -
 arch/m68knommu/Kconfig                       |    4 -
 arch/microblaze/Kconfig                      |    3 -
 arch/mips/Kconfig                            |    4 -
 arch/mn10300/Kconfig                         |    3 -
 arch/parisc/Kconfig                          |    4 -
 arch/powerpc/Kconfig                         |    3 -
 arch/powerpc/include/asm/machdep.h           |    3 -
 arch/powerpc/include/asm/time.h              |    7 -
 arch/powerpc/include/asm/vdso_datapage.h     |    2 +
 arch/powerpc/kernel/asm-offsets.c            |    1 +
 arch/powerpc/kernel/smp.c                    |    2 -
 arch/powerpc/kernel/time.c                   |  201 +++++---------------------
 arch/powerpc/kernel/vdso32/gettimeofday.S    |  184 ++++++------------------
 arch/powerpc/kernel/vdso64/gettimeofday.S    |   88 +++---------
 arch/powerpc/platforms/52xx/lite5200_pm.c    |    3 -
 arch/powerpc/platforms/52xx/mpc52xx_pm.c     |    3 -
 arch/powerpc/platforms/powermac/cpufreq_32.c |    8 +-
 arch/s390/Kconfig                            |    3 -
 arch/s390/kernel/time.c                      |    8 +-
 arch/score/Kconfig                           |    3 -
 arch/sh/Kconfig                              |    3 -
 arch/sparc/Kconfig                           |    3 -
 arch/um/Kconfig.common                       |    4 -
 arch/um/kernel/time.c                        |   16 +-
 arch/x86/Kconfig                             |    5 +-
 arch/x86/kernel/hpet.c                       |   13 ++-
 arch/x86/kernel/tsc.c                        |    5 +-
 arch/x86/kernel/vsyscall_64.c                |   17 ++-
 arch/xtensa/Kconfig                          |    3 -
 drivers/Makefile                             |    4 +-
 drivers/acpi/acpi_pad.c                      |    2 +-
 drivers/acpi/processor_idle.c                |    2 +-
 drivers/clocksource/acpi_pm.c                |    9 +-
 drivers/misc/Kconfig                         |    4 +-
 include/linux/clocksource.h                  |   17 ++-
 include/linux/time.h                         |   21 +++-
 kernel/debug/kdb/kdb_main.c                  |    4 +-
 kernel/hrtimer.c                             |    9 +-
 kernel/time.c                                |   16 --
 kernel/time/Kconfig                          |    4 +-
 kernel/time/clocksource.c                    |   33 ++++-
 kernel/time/timekeeping.c                    |   79 +++--------
 kernel/trace/Kconfig                         |    4 +-
 56 files changed, 245 insertions(+), 624 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1571c0c..cd648db 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -549,16 +549,6 @@ Who:	Avi Kivity <avi@redhat.com>
 
 ----------------------------
 
-What:	xtime, wall_to_monotonic
-When:	2.6.36+
-Files:	kernel/time/timekeeping.c include/linux/time.h
-Why:	Cleaning up timekeeping internal values. Please use
-	existing timekeeping accessor functions to access
-	the equivalent functionality.
-Who:	John Stultz <johnstul@us.ibm.com>
-
-----------------------------
-
 What:	KVM kernel-allocated memory slots
 When:	July 2010
 Why:	Since 2.6.25, kvm supports user-allocated memory slots, which are
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2b2407d..8abdfd7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -73,7 +73,6 @@ parameter is applicable:
 	MTD	MTD (Memory Technology Device) support is enabled.
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
-	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
@@ -468,7 +467,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
+	clocksource=	Override the default clocksource
 			Format: <string>
 			Override the default clocksource and use the clocksource
 			with the name specified.
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 3e2e540..b9647bb 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -47,10 +47,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
         def_bool y
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 98922f7..655b4ae 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -41,10 +41,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config GENERIC_GPIO
 	bool
 
-config GENERIC_TIME
-	bool
-	default y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default n
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index f2b3193..f515727 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -45,9 +45,6 @@ config GENERIC_IRQ_PROBE
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f66294b..c88fd35 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -614,9 +614,6 @@ comment "Kernel Timer/Scheduler"
 
 source kernel/Kconfig.hz
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
 	default y
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index e25bf44..887ef85 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -20,9 +20,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 4b5830b..16399bd 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -40,10 +40,6 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 53cc669..988b6ff 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -62,10 +62,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_BUG
         bool
         depends on BUG
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9561082..8711d13 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -82,10 +82,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 653b3c4..ed6f22e 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -471,7 +471,8 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c, u32 mult)
+void update_vsyscall(struct timespec *wall, struct timespec *wtm,
+			struct clocksource *c, u32 mult)
 {
         unsigned long flags;
 
@@ -487,9 +488,9 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c, u32 mult)
 	/* copy kernel time structures */
         fsyscall_gtod_data.wall_time.tv_sec = wall->tv_sec;
         fsyscall_gtod_data.wall_time.tv_nsec = wall->tv_nsec;
-        fsyscall_gtod_data.monotonic_time.tv_sec = wall_to_monotonic.tv_sec
+	fsyscall_gtod_data.monotonic_time.tv_sec = wtm->tv_sec
 							+ wall->tv_sec;
-        fsyscall_gtod_data.monotonic_time.tv_nsec = wall_to_monotonic.tv_nsec
+	fsyscall_gtod_data.monotonic_time.tv_nsec = wtm->tv_nsec
 							+ wall->tv_nsec;
 
 	/* normalize */
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 3a9319f..836abbb 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -44,9 +44,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2e3737b..8030e24 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -59,9 +59,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index efeb603..2609c39 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -63,10 +63,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 505a085..14f03ce 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -48,9 +48,6 @@ config GENERIC_IRQ_PROBE
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool n
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cdaae94..01c44cb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -733,10 +733,6 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 1c4565a..444b9f9 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -46,9 +46,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 05a366a..907417d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -66,10 +66,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	depends on SMP
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2031a28..25e6bf4 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -29,9 +29,6 @@ config MMU
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 9f0fc9e..7716e68 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -366,8 +366,5 @@ static inline void log_error(char *buf, unsigned int err_type, int fatal)
 #define machine_late_initcall(mach,fn)		__define_machine_initcall(mach,"7",fn,7)
 #define machine_late_initcall_sync(mach,fn)	__define_machine_initcall(mach,"7s",fn,7s)
 
-void generic_suspend_disable_irqs(void);
-void generic_suspend_enable_irqs(void);
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_MACHDEP_H */
diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 27ccb76..dc779df 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -28,16 +28,12 @@
 extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
-extern u64 tb_to_xs;
-extern unsigned      tb_to_us;
 
 struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
 extern void GregorianDay(struct rtc_time *tm);
-extern time_t last_rtc_update;
 
 extern void generic_calibrate_decr(void);
-extern void wakeup_decrementer(void);
 extern void snapshot_timebase(void);
 
 extern void set_dec_cpu6(unsigned int val);
@@ -204,9 +200,6 @@ static inline unsigned long tb_ticks_since(unsigned long tstamp)
 extern u64 mulhdu(u64, u64);
 #endif
 
-extern void smp_space_timers(unsigned int);
-
-extern unsigned mulhwu_scale_factor(unsigned, unsigned);
 extern void div128_by_32(u64 dividend_high, u64 dividend_low,
 			 unsigned divisor, struct div_result *dr);
 
diff --git a/arch/powerpc/include/asm/vdso_datapage.h b/arch/powerpc/include/asm/vdso_datapage.h
index 13c2c28..08679c5 100644
--- a/arch/powerpc/include/asm/vdso_datapage.h
+++ b/arch/powerpc/include/asm/vdso_datapage.h
@@ -85,6 +85,7 @@ struct vdso_data {
 	__s32 wtom_clock_sec;			/* Wall to monotonic clock */
 	__s32 wtom_clock_nsec;
 	struct timespec stamp_xtime;	/* xtime as at tb_orig_stamp */
+	__u32 stamp_sec_fraction;	/* fractional seconds of stamp_xtime */
    	__u32 syscall_map_64[SYSCALL_MAP_SIZE]; /* map of syscalls  */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 };
@@ -105,6 +106,7 @@ struct vdso_data {
 	__s32 wtom_clock_sec;			/* Wall to monotonic clock */
 	__s32 wtom_clock_nsec;
 	struct timespec stamp_xtime;	/* xtime as at tb_orig_stamp */
+	__u32 stamp_sec_fraction;	/* fractional seconds of stamp_xtime */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 	__u32 dcache_block_size;	/* L1 d-cache block size     */
 	__u32 icache_block_size;	/* L1 i-cache block size     */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 496cc5b..acbbac6 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -342,6 +342,7 @@ int main(void)
 	DEFINE(WTOM_CLOCK_SEC, offsetof(struct vdso_data, wtom_clock_sec));
 	DEFINE(WTOM_CLOCK_NSEC, offsetof(struct vdso_data, wtom_clock_nsec));
 	DEFINE(STAMP_XTIME, offsetof(struct vdso_data, stamp_xtime));
+	DEFINE(STAMP_SEC_FRAC, offsetof(struct vdso_data, stamp_sec_fraction));
 	DEFINE(CFG_ICACHE_BLOCKSZ, offsetof(struct vdso_data, icache_block_size));
 	DEFINE(CFG_DCACHE_BLOCKSZ, offsetof(struct vdso_data, dcache_block_size));
 	DEFINE(CFG_ICACHE_LOGBLOCKSZ, offsetof(struct vdso_data, icache_log_block_size));
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5c196d1..8764daa 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -288,8 +288,6 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 			max_cpus = NR_CPUS;
 	else
 		max_cpus = 1;
- 
-	smp_space_timers(max_cpus);
 
 	for_each_possible_cpu(cpu)
 		if (cpu != boot_cpuid)
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 0441bbd..ce53dfa 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -149,16 +149,6 @@ unsigned long tb_ticks_per_usec = 100; /* sane default */
 EXPORT_SYMBOL(tb_ticks_per_usec);
 unsigned long tb_ticks_per_sec;
 EXPORT_SYMBOL(tb_ticks_per_sec);	/* for cputime_t conversions */
-u64 tb_to_xs;
-unsigned tb_to_us;
-
-#define TICKLEN_SCALE	NTP_SCALE_SHIFT
-static u64 last_tick_len;	/* units are ns / 2^TICKLEN_SCALE */
-static u64 ticklen_to_xs;	/* 0.64 fraction */
-
-/* If last_tick_len corresponds to about 1/HZ seconds, then
-   last_tick_len << TICKLEN_SHIFT will be about 2^63. */
-#define TICKLEN_SHIFT	(63 - 30 - TICKLEN_SCALE + SHIFT_HZ)
 
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL_GPL(rtc_lock);
@@ -174,7 +164,6 @@ unsigned long ppc_proc_freq;
 EXPORT_SYMBOL(ppc_proc_freq);
 unsigned long ppc_tb_freq;
 
-static u64 tb_last_jiffy __cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(u64, last_jiffy);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
@@ -423,30 +412,6 @@ void udelay(unsigned long usecs)
 }
 EXPORT_SYMBOL(udelay);
 
-static inline void update_gtod(u64 new_tb_stamp, u64 new_stamp_xsec,
-			       u64 new_tb_to_xs)
-{
-	/*
-	 * tb_update_count is used to allow the userspace gettimeofday code
-	 * to assure itself that it sees a consistent view of the tb_to_xs and
-	 * stamp_xsec variables.  It reads the tb_update_count, then reads
-	 * tb_to_xs and stamp_xsec and then reads tb_update_count again.  If
-	 * the two values of tb_update_count match and are even then the
-	 * tb_to_xs and stamp_xsec values are consistent.  If not, then it
-	 * loops back and reads them again until this criteria is met.
-	 * We expect the caller to have done the first increment of
-	 * vdso_data->tb_update_count already.
-	 */
-	vdso_data->tb_orig_stamp = new_tb_stamp;
-	vdso_data->stamp_xsec = new_stamp_xsec;
-	vdso_data->tb_to_xs = new_tb_to_xs;
-	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	vdso_data->stamp_xtime = xtime;
-	smp_wmb();
-	++(vdso_data->tb_update_count);
-}
-
 #ifdef CONFIG_SMP
 unsigned long profile_pc(struct pt_regs *regs)
 {
@@ -470,7 +435,6 @@ EXPORT_SYMBOL(profile_pc);
 
 static int __init iSeries_tb_recal(void)
 {
-	struct div_result divres;
 	unsigned long titan, tb;
 
 	/* Make sure we only run on iSeries */
@@ -501,10 +465,7 @@ static int __init iSeries_tb_recal(void)
 				tb_ticks_per_jiffy = new_tb_ticks_per_jiffy;
 				tb_ticks_per_sec   = new_tb_ticks_per_sec;
 				calc_cputime_factors();
-				div128_by_32( XSEC_PER_SEC, 0, tb_ticks_per_sec, &divres );
-				tb_to_xs = divres.result_low;
 				vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
-				vdso_data->tb_to_xs = tb_to_xs;
 				setup_cputime_one_jiffy();
 			}
 			else {
@@ -667,27 +628,9 @@ void timer_interrupt(struct pt_regs * regs)
 	trace_timer_interrupt_exit(regs);
 }
 
-void wakeup_decrementer(void)
-{
-	unsigned long ticks;
-
-	/*
-	 * The timebase gets saved on sleep and restored on wakeup,
-	 * so all we need to do is to reset the decrementer.
-	 */
-	ticks = tb_ticks_since(__get_cpu_var(last_jiffy));
-	if (ticks < tb_ticks_per_jiffy)
-		ticks = tb_ticks_per_jiffy - ticks;
-	else
-		ticks = 1;
-	set_dec(ticks);
-}
-
 #ifdef CONFIG_SUSPEND
-void generic_suspend_disable_irqs(void)
+static void generic_suspend_disable_irqs(void)
 {
-	preempt_disable();
-
 	/* Disable the decrementer, so that it doesn't interfere
 	 * with suspending.
 	 */
@@ -697,12 +640,9 @@ void generic_suspend_disable_irqs(void)
 	set_dec(0x7fffffff);
 }
 
-void generic_suspend_enable_irqs(void)
+static void generic_suspend_enable_irqs(void)
 {
-	wakeup_decrementer();
-
 	local_irq_enable();
-	preempt_enable();
 }
 
 /* Overrides the weak version in kernel/power/main.c */
@@ -722,23 +662,6 @@ void arch_suspend_enable_irqs(void)
 }
 #endif
 
-#ifdef CONFIG_SMP
-void __init smp_space_timers(unsigned int max_cpus)
-{
-	int i;
-	u64 previous_tb = per_cpu(last_jiffy, boot_cpuid);
-
-	/* make sure tb > per_cpu(last_jiffy, cpu) for all cpus always */
-	previous_tb -= tb_ticks_per_jiffy;
-
-	for_each_possible_cpu(i) {
-		if (i == boot_cpuid)
-			continue;
-		per_cpu(last_jiffy, i) = previous_tb;
-	}
-}
-#endif
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  *
@@ -873,10 +796,11 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
-		     u32 mult)
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+			struct clocksource *clock, u32 mult)
 {
-	u64 t2x, stamp_xsec;
+	u64 new_tb_to_xs, new_stamp_xsec;
+	u32 frac_sec;
 
 	if (clock != &clocksource_timebase)
 		return;
@@ -887,11 +811,35 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) mult * 4611686018ULL;
-	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
-	do_div(stamp_xsec, 1000000000);
-	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
-	update_gtod(clock->cycle_last, stamp_xsec, t2x);
+	new_tb_to_xs = (u64) mult * 4611686018ULL;
+	new_stamp_xsec = (u64) wall_time->tv_nsec * XSEC_PER_SEC;
+	do_div(new_stamp_xsec, 1000000000);
+	new_stamp_xsec += (u64) wall_time->tv_sec * XSEC_PER_SEC;
+
+	BUG_ON(wall_time->tv_nsec >= NSEC_PER_SEC);
+	/* this is tv_nsec / 1e9 as a 0.32 fraction */
+	frac_sec = ((u64) wall_time->tv_nsec * 18446744073ULL) >> 32;
+
+	/*
+	 * tb_update_count is used to allow the userspace gettimeofday code
+	 * to assure itself that it sees a consistent view of the tb_to_xs and
+	 * stamp_xsec variables.  It reads the tb_update_count, then reads
+	 * tb_to_xs and stamp_xsec and then reads tb_update_count again.  If
+	 * the two values of tb_update_count match and are even then the
+	 * tb_to_xs and stamp_xsec values are consistent.  If not, then it
+	 * loops back and reads them again until this criteria is met.
+	 * We expect the caller to have done the first increment of
+	 * vdso_data->tb_update_count already.
+	 */
+	vdso_data->tb_orig_stamp = clock->cycle_last;
+	vdso_data->stamp_xsec = new_stamp_xsec;
+	vdso_data->tb_to_xs = new_tb_to_xs;
+	vdso_data->wtom_clock_sec = wtm->tv_sec;
+	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
+	vdso_data->stamp_xtime = *wall_time;
+	vdso_data->stamp_sec_fraction = frac_sec;
+	smp_wmb();
+	++(vdso_data->tb_update_count);
 }
 
 void update_vsyscall_tz(void)
@@ -1007,15 +955,13 @@ void secondary_cpu_time_init(void)
 /* This function is only called on the boot processor */
 void __init time_init(void)
 {
-	unsigned long flags;
 	struct div_result res;
-	u64 scale, x;
+	u64 scale;
 	unsigned shift;
 
 	if (__USE_RTC()) {
 		/* 601 processor: dec counts down by 128 every 128ns */
 		ppc_tb_freq = 1000000000;
-		tb_last_jiffy = get_rtcl();
 	} else {
 		/* Normal PowerPC with timebase register */
 		ppc_md.calibrate_decr();
@@ -1023,50 +969,15 @@ void __init time_init(void)
 		       ppc_tb_freq / 1000000, ppc_tb_freq % 1000000);
 		printk(KERN_DEBUG "time_init: processor frequency   = %lu.%.6lu MHz\n",
 		       ppc_proc_freq / 1000000, ppc_proc_freq % 1000000);
-		tb_last_jiffy = get_tb();
 	}
 
 	tb_ticks_per_jiffy = ppc_tb_freq / HZ;
 	tb_ticks_per_sec = ppc_tb_freq;
 	tb_ticks_per_usec = ppc_tb_freq / 1000000;
-	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
 	calc_cputime_factors();
 	setup_cputime_one_jiffy();
 
 	/*
-	 * Calculate the length of each tick in ns.  It will not be
-	 * exactly 1e9/HZ unless ppc_tb_freq is divisible by HZ.
-	 * We compute 1e9 * tb_ticks_per_jiffy / ppc_tb_freq,
-	 * rounded up.
-	 */
-	x = (u64) NSEC_PER_SEC * tb_ticks_per_jiffy + ppc_tb_freq - 1;
-	do_div(x, ppc_tb_freq);
-	tick_nsec = x;
-	last_tick_len = x << TICKLEN_SCALE;
-
-	/*
-	 * Compute ticklen_to_xs, which is a factor which gets multiplied
-	 * by (last_tick_len << TICKLEN_SHIFT) to get a tb_to_xs value.
-	 * It is computed as:
-	 * ticklen_to_xs = 2^N / (tb_ticks_per_jiffy * 1e9)
-	 * where N = 64 + 20 - TICKLEN_SCALE - TICKLEN_SHIFT
-	 * which turns out to be N = 51 - SHIFT_HZ.
-	 * This gives the result as a 0.64 fixed-point fraction.
-	 * That value is reduced by an offset amounting to 1 xsec per
-	 * 2^31 timebase ticks to avoid problems with time going backwards
-	 * by 1 xsec when we do timer_recalc_offset due to losing the
-	 * fractional xsec.  That offset is equal to ppc_tb_freq/2^51
-	 * since there are 2^20 xsec in a second.
-	 */
-	div128_by_32((1ULL << 51) - ppc_tb_freq, 0,
-		     tb_ticks_per_jiffy << SHIFT_HZ, &res);
-	div128_by_32(res.result_high, res.result_low, NSEC_PER_SEC, &res);
-	ticklen_to_xs = res.result_low;
-
-	/* Compute tb_to_xs from tick_nsec */
-	tb_to_xs = mulhdu(last_tick_len << TICKLEN_SHIFT, ticklen_to_xs);
-
-	/*
 	 * Compute scale factor for sched_clock.
 	 * The calibrate_decr() function has set tb_ticks_per_sec,
 	 * which is the timebase frequency.
@@ -1087,21 +998,14 @@ void __init time_init(void)
 	/* Save the current timebase to pretty up CONFIG_PRINTK_TIME */
 	boot_tb = get_tb_or_rtc();
 
-	write_seqlock_irqsave(&xtime_lock, flags);
-
 	/* If platform provided a timezone (pmac), we correct the time */
         if (timezone_offset) {
 		sys_tz.tz_minuteswest = -timezone_offset / 60;
 		sys_tz.tz_dsttime = 0;
         }
 
-	vdso_data->tb_orig_stamp = tb_last_jiffy;
 	vdso_data->tb_update_count = 0;
 	vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
-	vdso_data->stamp_xsec = (u64) xtime.tv_sec * XSEC_PER_SEC;
-	vdso_data->tb_to_xs = tb_to_xs;
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* Start the decrementer on CPUs that have manual control
 	 * such as BookE
@@ -1195,39 +1099,6 @@ void to_tm(int tim, struct rtc_time * tm)
 	GregorianDay(tm);
 }
 
-/* Auxiliary function to compute scaling factors */
-/* Actually the choice of a timebase running at 1/4 the of the bus
- * frequency giving resolution of a few tens of nanoseconds is quite nice.
- * It makes this computation very precise (27-28 bits typically) which
- * is optimistic considering the stability of most processor clock
- * oscillators and the precision with which the timebase frequency
- * is measured but does not harm.
- */
-unsigned mulhwu_scale_factor(unsigned inscale, unsigned outscale)
-{
-        unsigned mlt=0, tmp, err;
-        /* No concern for performance, it's done once: use a stupid
-         * but safe and compact method to find the multiplier.
-         */
-  
-        for (tmp = 1U<<31; tmp != 0; tmp >>= 1) {
-                if (mulhwu(inscale, mlt|tmp) < outscale)
-			mlt |= tmp;
-        }
-  
-        /* We might still be off by 1 for the best approximation.
-         * A side effect of this is that if outscale is too large
-         * the returned value will be zero.
-         * Many corner cases have been checked and seem to work,
-         * some might have been forgotten in the test however.
-         */
-  
-        err = inscale * (mlt+1);
-        if (err <= inscale/2)
-		mlt++;
-        return mlt;
-}
-
 /*
  * Divide a 128-bit dividend by a 32-bit divisor, leaving a 128 bit
  * result.
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index ee038d4..4ee09ee 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -19,8 +19,10 @@
 /* Offset for the low 32-bit part of a field of long type */
 #ifdef CONFIG_PPC64
 #define LOPART	4
+#define TSPEC_TV_SEC	TSPC64_TV_SEC+LOPART
 #else
 #define LOPART	0
+#define TSPEC_TV_SEC	TSPC32_TV_SEC
 #endif
 
 	.text
@@ -41,23 +43,11 @@ V_FUNCTION_BEGIN(__kernel_gettimeofday)
 	mr	r9, r3			/* datapage ptr in r9 */
 	cmplwi	r10,0			/* check if tv is NULL */
 	beq	3f
-	bl	__do_get_xsec@local	/* get xsec from tb & kernel */
-	bne-	2f			/* out of line -> do syscall */
-
-	/* seconds are xsec >> 20 */
-	rlwinm	r5,r4,12,20,31
-	rlwimi	r5,r3,12,0,19
-	stw	r5,TVAL32_TV_SEC(r10)
-
-	/* get remaining xsec and convert to usec. we scale
-	 * up remaining xsec by 12 bits and get the top 32 bits
-	 * of the multiplication
-	 */
-	rlwinm	r5,r4,12,0,19
-	lis	r6,1000000@h
-	ori	r6,r6,1000000@l
-	mulhwu	r5,r5,r6
-	stw	r5,TVAL32_TV_USEC(r10)
+	lis	r7,1000000@ha		/* load up USEC_PER_SEC */
+	addi	r7,r7,1000000@l		/* so we get microseconds in r4 */
+	bl	__do_get_tspec@local	/* get sec/usec from tb & kernel */
+	stw	r3,TVAL32_TV_SEC(r10)
+	stw	r4,TVAL32_TV_USEC(r10)
 
 3:	cmplwi	r11,0			/* check if tz is NULL */
 	beq	1f
@@ -70,14 +60,6 @@ V_FUNCTION_BEGIN(__kernel_gettimeofday)
 	crclr	cr0*4+so
 	li	r3,0
 	blr
-
-2:
-	mtlr	r12
-	mr	r3,r10
-	mr	r4,r11
-	li	r0,__NR_gettimeofday
-	sc
-	blr
   .cfi_endproc
 V_FUNCTION_END(__kernel_gettimeofday)
 
@@ -100,7 +82,8 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
 	mr	r11,r4			/* r11 saves tp */
 	bl	__get_datapage@local	/* get data page */
 	mr	r9,r3			/* datapage ptr in r9 */
-
+	lis	r7,NSEC_PER_SEC@h	/* want nanoseconds */
+	ori	r7,r7,NSEC_PER_SEC@l
 50:	bl	__do_get_tspec@local	/* get sec/nsec from tb & kernel */
 	bne	cr1,80f			/* not monotonic -> all done */
 
@@ -198,83 +181,12 @@ V_FUNCTION_END(__kernel_clock_getres)
 
 
 /*
- * This is the core of gettimeofday() & friends, it returns the xsec
- * value in r3 & r4 and expects the datapage ptr (non clobbered)
- * in r9. clobbers r0,r4,r5,r6,r7,r8.
- * When returning, r8 contains the counter value that can be reused
- * by the monotonic clock implementation
- */
-__do_get_xsec:
-  .cfi_startproc
-	/* Check for update count & load values. We use the low
-	 * order 32 bits of the update count
-	 */
-1:	lwz	r8,(CFG_TB_UPDATE_COUNT+LOPART)(r9)
-	andi.	r0,r8,1			/* pending update ? loop */
-	bne-	1b
-	xor	r0,r8,r8		/* create dependency */
-	add	r9,r9,r0
-
-	/* Load orig stamp (offset to TB) */
-	lwz	r5,CFG_TB_ORIG_STAMP(r9)
-	lwz	r6,(CFG_TB_ORIG_STAMP+4)(r9)
-
-	/* Get a stable TB value */
-2:	mftbu	r3
-	mftbl	r4
-	mftbu	r0
-	cmpl	cr0,r3,r0
-	bne-	2b
-
-	/* Substract tb orig stamp. If the high part is non-zero, we jump to
-	 * the slow path which call the syscall.
-	 * If it's ok, then we have our 32 bits tb_ticks value in r7
-	 */
-	subfc	r7,r6,r4
-	subfe.	r0,r5,r3
-	bne-	3f
-
-	/* Load scale factor & do multiplication */
-	lwz	r5,CFG_TB_TO_XS(r9)	/* load values */
-	lwz	r6,(CFG_TB_TO_XS+4)(r9)
-	mulhwu	r4,r7,r5
-	mulhwu	r6,r7,r6
-	mullw	r0,r7,r5
-	addc	r6,r6,r0
-
-	/* At this point, we have the scaled xsec value in r4 + XER:CA
-	 * we load & add the stamp since epoch
-	 */
-	lwz	r5,CFG_STAMP_XSEC(r9)
-	lwz	r6,(CFG_STAMP_XSEC+4)(r9)
-	adde	r4,r4,r6
-	addze	r3,r5
-
-	/* We now have our result in r3,r4. We create a fake dependency
-	 * on that result and re-check the counter
-	 */
-	or	r6,r4,r3
-	xor	r0,r6,r6
-	add	r9,r9,r0
-	lwz	r0,(CFG_TB_UPDATE_COUNT+LOPART)(r9)
-        cmpl    cr0,r8,r0		/* check if updated */
-	bne-	1b
-
-	/* Warning ! The caller expects CR:EQ to be set to indicate a
-	 * successful calculation (so it won't fallback to the syscall
-	 * method). We have overriden that CR bit in the counter check,
-	 * but fortunately, the loop exit condition _is_ CR:EQ set, so
-	 * we can exit safely here. If you change this code, be careful
-	 * of that side effect.
-	 */
-3:	blr
-  .cfi_endproc
-
-/*
- * This is the core of clock_gettime(), it returns the current
- * time in seconds and nanoseconds in r3 and r4.
+ * This is the core of clock_gettime() and gettimeofday(),
+ * it returns the current time in r3 (seconds) and r4.
+ * On entry, r7 gives the resolution of r4, either USEC_PER_SEC
+ * or NSEC_PER_SEC, giving r4 in microseconds or nanoseconds.
  * It expects the datapage ptr in r9 and doesn't clobber it.
- * It clobbers r0, r5, r6, r10 and returns NSEC_PER_SEC in r7.
+ * It clobbers r0, r5 and r6.
  * On return, r8 contains the counter value that can be reused.
  * This clobbers cr0 but not any other cr field.
  */
@@ -297,70 +209,58 @@ __do_get_tspec:
 2:	mftbu	r3
 	mftbl	r4
 	mftbu	r0
-	cmpl	cr0,r3,r0
+	cmplw	cr0,r3,r0
 	bne-	2b
 
 	/* Subtract tb orig stamp and shift left 12 bits.
 	 */
-	subfc	r7,r6,r4
+	subfc	r4,r6,r4
 	subfe	r0,r5,r3
 	slwi	r0,r0,12
-	rlwimi.	r0,r7,12,20,31
-	slwi	r7,r7,12
+	rlwimi.	r0,r4,12,20,31
+	slwi	r4,r4,12
 
-	/* Load scale factor & do multiplication */
+	/*
+	 * Load scale factor & do multiplication.
+	 * We only use the high 32 bits of the tb_to_xs value.
+	 * Even with a 1GHz timebase clock, the high 32 bits of
+	 * tb_to_xs will be at least 4 million, so the error from
+	 * ignoring the low 32 bits will be no more than 0.25ppm.
+	 * The error will just make the clock run very very slightly
+	 * slow until the next time the kernel updates the VDSO data,
+	 * at which point the clock will catch up to the kernel's value,
+	 * so there is no long-term error accumulation.
+	 */
 	lwz	r5,CFG_TB_TO_XS(r9)	/* load values */
-	lwz	r6,(CFG_TB_TO_XS+4)(r9)
-	mulhwu	r3,r7,r6
-	mullw	r10,r7,r5
-	mulhwu	r4,r7,r5
-	addc	r10,r3,r10
+	mulhwu	r4,r4,r5
 	li	r3,0
 
 	beq+	4f			/* skip high part computation if 0 */
 	mulhwu	r3,r0,r5
-	mullw	r7,r0,r5
-	mulhwu	r5,r0,r6
-	mullw	r6,r0,r6
-	adde	r4,r4,r7
-	addze	r3,r3
+	mullw	r5,r0,r5
 	addc	r4,r4,r5
 	addze	r3,r3
-	addc	r10,r10,r6
-
-4:	addze	r4,r4			/* add in carry */
-	lis	r7,NSEC_PER_SEC@h
-	ori	r7,r7,NSEC_PER_SEC@l
-	mulhwu	r4,r4,r7		/* convert to nanoseconds */
-
-	/* At this point, we have seconds & nanoseconds since the xtime
-	 * stamp in r3+CA and r4.  Load & add the xtime stamp.
+4:
+	/* At this point, we have seconds since the xtime stamp
+	 * as a 32.32 fixed-point number in r3 and r4.
+	 * Load & add the xtime stamp.
 	 */
-#ifdef CONFIG_PPC64
-	lwz	r5,STAMP_XTIME+TSPC64_TV_SEC+LOPART(r9)
-	lwz	r6,STAMP_XTIME+TSPC64_TV_NSEC+LOPART(r9)
-#else
-	lwz	r5,STAMP_XTIME+TSPC32_TV_SEC(r9)
-	lwz	r6,STAMP_XTIME+TSPC32_TV_NSEC(r9)
-#endif
-	add	r4,r4,r6
+	lwz	r5,STAMP_XTIME+TSPEC_TV_SEC(r9)
+	lwz	r6,STAMP_SEC_FRAC(r9)
+	addc	r4,r4,r6
 	adde	r3,r3,r5
 
-	/* We now have our result in r3,r4. We create a fake dependency
-	 * on that result and re-check the counter
+	/* We create a fake dependency on the result in r3/r4
+	 * and re-check the counter
 	 */
 	or	r6,r4,r3
 	xor	r0,r6,r6
 	add	r9,r9,r0
 	lwz	r0,(CFG_TB_UPDATE_COUNT+LOPART)(r9)
-        cmpl    cr0,r8,r0		/* check if updated */
+        cmplw	cr0,r8,r0		/* check if updated */
 	bne-	1b
 
-	/* check for nanosecond overflow and adjust if necessary */
-	cmpw	r4,r7
-	bltlr				/* all done if no overflow */
-	subf	r4,r7,r4		/* adjust if overflow */
-	addi	r3,r3,1
+	mulhwu	r4,r4,r7		/* convert to micro or nanoseconds */
 
 	blr
   .cfi_endproc
diff --git a/arch/powerpc/kernel/vdso64/gettimeofday.S b/arch/powerpc/kernel/vdso64/gettimeofday.S
index 262cd58..e97a9a0 100644
--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
@@ -33,18 +33,11 @@ V_FUNCTION_BEGIN(__kernel_gettimeofday)
 	bl	V_LOCAL_FUNC(__get_datapage)	/* get data page */
 	cmpldi	r11,0			/* check if tv is NULL */
 	beq	2f
-	bl	V_LOCAL_FUNC(__do_get_xsec)	/* get xsec from tb & kernel */
-	lis     r7,15			/* r7 = 1000000 = USEC_PER_SEC */
-	ori     r7,r7,16960
-	rldicl  r5,r4,44,20		/* r5 = sec = xsec / XSEC_PER_SEC */
-	rldicr  r6,r5,20,43		/* r6 = sec * XSEC_PER_SEC */
-	std	r5,TVAL64_TV_SEC(r11)	/* store sec in tv */
-	subf	r0,r6,r4		/* r0 = xsec = (xsec - r6) */
-	mulld   r0,r0,r7		/* usec = (xsec * USEC_PER_SEC) /
-					 * XSEC_PER_SEC
-					 */
-	rldicl  r0,r0,44,20
-	std	r0,TVAL64_TV_USEC(r11)	/* store usec in tv */
+	lis	r7,1000000@ha		/* load up USEC_PER_SEC */
+	addi	r7,r7,1000000@l
+	bl	V_LOCAL_FUNC(__do_get_tspec) /* get sec/us from tb & kernel */
+	std	r4,TVAL64_TV_SEC(r11)	/* store sec in tv */
+	std	r5,TVAL64_TV_USEC(r11)	/* store usec in tv */
 2:	cmpldi	r10,0			/* check if tz is NULL */
 	beq	1f
 	lwz	r4,CFG_TZ_MINUTEWEST(r3)/* fill tz */
@@ -77,6 +70,8 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
   .cfi_register lr,r12
 	mr	r11,r4			/* r11 saves tp */
 	bl	V_LOCAL_FUNC(__get_datapage)	/* get data page */
+	lis	r7,NSEC_PER_SEC@h	/* want nanoseconds */
+	ori	r7,r7,NSEC_PER_SEC@l
 50:	bl	V_LOCAL_FUNC(__do_get_tspec)	/* get time from tb & kernel */
 	bne	cr1,80f			/* if not monotonic, all done */
 
@@ -171,49 +166,12 @@ V_FUNCTION_END(__kernel_clock_getres)
 
 
 /*
- * This is the core of gettimeofday(), it returns the xsec
- * value in r4 and expects the datapage ptr (non clobbered)
- * in r3. clobbers r0,r4,r5,r6,r7,r8
- * When returning, r8 contains the counter value that can be reused
- */
-V_FUNCTION_BEGIN(__do_get_xsec)
-  .cfi_startproc
-	/* check for update count & load values */
-1:	ld	r8,CFG_TB_UPDATE_COUNT(r3)
-	andi.	r0,r8,1			/* pending update ? loop */
-	bne-	1b
-	xor	r0,r8,r8		/* create dependency */
-	add	r3,r3,r0
-
-	/* Get TB & offset it. We use the MFTB macro which will generate
-	 * workaround code for Cell.
-	 */
-	MFTB(r7)
-	ld	r9,CFG_TB_ORIG_STAMP(r3)
-	subf	r7,r9,r7
-
-	/* Scale result */
-	ld	r5,CFG_TB_TO_XS(r3)
-	mulhdu	r7,r7,r5
-
-	/* Add stamp since epoch */
-	ld	r6,CFG_STAMP_XSEC(r3)
-	add	r4,r6,r7
-
-	xor	r0,r4,r4
-	add	r3,r3,r0
-	ld	r0,CFG_TB_UPDATE_COUNT(r3)
-        cmpld   cr0,r0,r8		/* check if updated */
-	bne-	1b
-	blr
-  .cfi_endproc
-V_FUNCTION_END(__do_get_xsec)
-
-/*
- * This is the core of clock_gettime(), it returns the current
- * time in seconds and nanoseconds in r4 and r5.
+ * This is the core of clock_gettime() and gettimeofday(),
+ * it returns the current time in r4 (seconds) and r5.
+ * On entry, r7 gives the resolution of r5, either USEC_PER_SEC
+ * or NSEC_PER_SEC, giving r5 in microseconds or nanoseconds.
  * It expects the datapage ptr in r3 and doesn't clobber it.
- * It clobbers r0 and r6 and returns NSEC_PER_SEC in r7.
+ * It clobbers r0, r6 and r9.
  * On return, r8 contains the counter value that can be reused.
  * This clobbers cr0 but not any other cr field.
  */
@@ -229,18 +187,18 @@ V_FUNCTION_BEGIN(__do_get_tspec)
 	/* Get TB & offset it. We use the MFTB macro which will generate
 	 * workaround code for Cell.
 	 */
-	MFTB(r7)
+	MFTB(r6)
 	ld	r9,CFG_TB_ORIG_STAMP(r3)
-	subf	r7,r9,r7
+	subf	r6,r9,r6
 
 	/* Scale result */
 	ld	r5,CFG_TB_TO_XS(r3)
-	sldi	r7,r7,12		/* compute time since stamp_xtime */
-	mulhdu	r6,r7,r5		/* in units of 2^-32 seconds */
+	sldi	r6,r6,12		/* compute time since stamp_xtime */
+	mulhdu	r6,r6,r5		/* in units of 2^-32 seconds */
 
 	/* Add stamp since epoch */
 	ld	r4,STAMP_XTIME+TSPC64_TV_SEC(r3)
-	ld	r5,STAMP_XTIME+TSPC64_TV_NSEC(r3)
+	lwz	r5,STAMP_SEC_FRAC(r3)
 	or	r0,r4,r5
 	or	r0,r0,r6
 	xor	r0,r0,r0
@@ -250,17 +208,11 @@ V_FUNCTION_BEGIN(__do_get_tspec)
 	bne-	1b			/* reload if so */
 
 	/* convert to seconds & nanoseconds and add to stamp */
-	lis	r7,NSEC_PER_SEC@h
-	ori	r7,r7,NSEC_PER_SEC@l
-	mulhwu	r0,r6,r7		/* compute nanoseconds and */
+	add	r6,r6,r5		/* add on fractional seconds of xtime */
+	mulhwu	r5,r6,r7		/* compute micro or nanoseconds and */
 	srdi	r6,r6,32		/* seconds since stamp_xtime */
-	clrldi	r0,r0,32
-	add	r5,r5,r0		/* add nanoseconds together */
-	cmpd	r5,r7			/* overflow? */
+	clrldi	r5,r5,32
 	add	r4,r4,r6
-	bltlr				/* all done if no overflow */
-	subf	r5,r7,r5		/* if overflow, adjust */
-	addi	r4,r4,1
 	blr
   .cfi_endproc
 V_FUNCTION_END(__do_get_tspec)
diff --git a/arch/powerpc/platforms/52xx/lite5200_pm.c b/arch/powerpc/platforms/52xx/lite5200_pm.c
index b5c753d..80234e5 100644
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ b/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -216,9 +216,6 @@ static int lite5200_pm_enter(suspend_state_t state)
 
 	lite5200_restore_regs();
 
-	/* restart jiffies */
-	wakeup_decrementer();
-
 	iounmap(mbar);
 	return 0;
 }
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pm.c b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
index 7672253..568cef6 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pm.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pm.c
@@ -171,9 +171,6 @@ int mpc52xx_pm_enter(suspend_state_t state)
 	/* restore SRAM */
 	memcpy(sram, saved_sram, sram_size);
 
-	/* restart jiffies */
-	wakeup_decrementer();
-
 	/* reenable interrupts in PIC */
 	out_be32(&intr->main_mask, intr_main_mask);
 
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 1e9eba1..415ca6d 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -310,8 +310,12 @@ static int pmu_set_cpu_speed(int low_speed)
 	/* Restore low level PMU operations */
 	pmu_unlock();
 
-	/* Restore decrementer */
-	wakeup_decrementer();
+	/*
+	 * Restore decrementer; we'll take a decrementer interrupt
+	 * as soon as interrupts are re-enabled and the generic
+	 * clockevents code will reprogram it with the right value.
+	 */
+	set_dec(1);
 
 	/* Restore interrupts */
  	mpic_cpu_set_priority(pic_prio);
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bee1c0f..f0777a4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -40,9 +40,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a2163c9..aeb30c6 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -207,8 +207,8 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
-		     u32 mult)
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+			struct clocksource *clock, u32 mult)
 {
 	if (clock != &clocksource_tod)
 		return;
@@ -219,8 +219,8 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vdso_data->xtime_tod_stamp = clock->cycle_last;
 	vdso_data->xtime_clock_sec = wall_time->tv_sec;
 	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
-	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
+	vdso_data->wtom_clock_sec = wtm->tv_sec;
+	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
 	vdso_data->ntp_mult = mult;
 	smp_wmb();
 	++vdso_data->tb_update_count;
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 55d413e..be4a155 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -55,9 +55,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 82868fe..33990fa 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -98,9 +98,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_IOMAP
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index c0015db..1cd0d9d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -66,9 +66,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y if SPARC32
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 0d207e7..7c8e277 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -55,10 +55,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index c8b9c46..a08d9fa 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -102,16 +102,16 @@ static void __init setup_itimer(void)
 	clockevents_register_device(&itimer_clockevent);
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
-	long long nsecs;
-
-	timer_init();
+	long long nsecs = os_nsecs();
 
-	nsecs = os_nsecs();
-	set_normalized_timespec(&wall_to_monotonic, -nsecs / NSEC_PER_SEC,
-				-nsecs % NSEC_PER_SEC);
-	set_normalized_timespec(&xtime, nsecs / NSEC_PER_SEC,
+	set_normalized_timespec(ts, nsecs / NSEC_PER_SEC,
 				nsecs % NSEC_PER_SEC);
+}
+
+void __init time_init(void)
+{
+	timer_init();
 	late_time_init = setup_itimer;
 }
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..546b610 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,9 +72,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
@@ -2046,7 +2043,7 @@ config SCx200
 
 config SCx200HR_TIMER
 	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
+	depends on SCx200
 	default y
 	---help---
 	  This driver provides a clocksource built upon the on-chip
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ba390d7..33dbcc4 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -16,7 +16,6 @@
 #include <asm/hpet.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
-#define HPET_SHIFT			22
 
 /* FSEC = 10^-15
    NSEC = 10^-9 */
@@ -787,7 +786,6 @@ static struct clocksource clocksource_hpet = {
 	.rating		= 250,
 	.read		= read_hpet,
 	.mask		= HPET_MASK,
-	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
@@ -798,6 +796,7 @@ static struct clocksource clocksource_hpet = {
 static int hpet_clocksource_register(void)
 {
 	u64 start, now;
+	u64 hpet_freq;
 	cycle_t t1;
 
 	/* Start the counter */
@@ -832,9 +831,15 @@ static int hpet_clocksource_register(void)
 	 *  mult = (hpet_period * 2^shift)/10^6
 	 *  mult = (hpet_period << shift)/FSEC_PER_NSEC
 	 */
-	clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
 
-	clocksource_register(&clocksource_hpet);
+	/* Need to convert hpet_period (fsec/cyc) to cyc/sec:
+	 *
+	 * cyc/sec = FSEC_PER_SEC/hpet_period(fsec/cyc)
+	 * cyc/sec = (FSEC_PER_NSEC * NSEC_PER_SEC)/hpet_period
+	 */
+	hpet_freq = FSEC_PER_NSEC * NSEC_PER_SEC;
+	do_div(hpet_freq, hpet_period);
+	clocksource_register_hz(&clocksource_hpet, (u32)hpet_freq);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 9faf91a..ce8e502 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -751,7 +751,6 @@ static struct clocksource clocksource_tsc = {
 	.read                   = read_tsc,
 	.resume			= resume_tsc,
 	.mask                   = CLOCKSOURCE_MASK(64),
-	.shift                  = 22,
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 #ifdef CONFIG_X86_64
@@ -845,8 +844,6 @@ __cpuinit int unsynchronized_tsc(void)
 
 static void __init init_tsc_clocksource(void)
 {
-	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
-			clocksource_tsc.shift);
 	if (tsc_clocksource_reliable)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
 	/* lower the rating if we already know its unstable: */
@@ -854,7 +851,7 @@ static void __init init_tsc_clocksource(void)
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
-	clocksource_register(&clocksource_tsc);
+	clocksource_register_khz(&clocksource_tsc, tsc_khz);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1c0c6ab..dcbb28c 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -73,8 +73,8 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
-		     u32 mult)
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+			struct clocksource *clock, u32 mult)
 {
 	unsigned long flags;
 
@@ -87,7 +87,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
+	vsyscall_gtod_data.wall_to_monotonic = *wtm;
 	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
@@ -169,13 +169,18 @@ int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
-	struct timeval tv;
+	unsigned seq;
 	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
-	vgettimeofday(&tv, NULL);
-	result = tv.tv_sec;
+	do {
+		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
+
+		result = __vsyscall_gtod_data.wall_time_sec;
+
+	} while (read_seqretry(&__vsyscall_gtod_data.lock, seq));
+
 	if (t)
 		*t = result;
 	return result;
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ebe228d..0859bfd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -48,9 +48,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/drivers/Makefile b/drivers/Makefile
index 91874e0..ae47344 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -101,7 +101,9 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
-obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
+obj-y				+= clocksource/
+endif
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 446aced..b76848c 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -77,7 +77,7 @@ static void power_saving_mwait_init(void)
 	power_saving_mwait_eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
 		(highest_subcstate - 1);
 
-#if defined(CONFIG_GENERIC_TIME) && defined(CONFIG_X86)
+#if defined(CONFIG_X86)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_INTEL:
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e9a8026..294e10b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -264,7 +264,7 @@ int acpi_processor_resume(struct acpi_device * device)
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 static void tsc_check_state(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 72a633a..cfb0f52 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -68,10 +68,7 @@ static struct clocksource clocksource_acpi_pm = {
 	.rating		= 200,
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
-	.mult		= 0, /*to be calculated*/
-	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-
 };
 
 
@@ -190,9 +187,6 @@ static int __init init_acpi_pm_clocksource(void)
 	if (!pmtmr_ioport)
 		return -ENODEV;
 
-	clocksource_acpi_pm.mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC,
-						clocksource_acpi_pm.shift);
-
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
 		udelay(100 * j);
@@ -220,7 +214,8 @@ static int __init init_acpi_pm_clocksource(void)
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
-	return clocksource_register(&clocksource_acpi_pm);
+	return clocksource_register_hz(&clocksource_acpi_pm,
+						PMTMR_TICKS_PER_SEC);
 }
 
 /* We use fs_initcall because we want the PCI fixups to have run
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 26386a9..5b9ba48 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -72,7 +72,7 @@ config ATMEL_TCLIB
 
 config ATMEL_TCB_CLKSRC
 	bool "TC Block Clocksource"
-	depends on ATMEL_TCLIB && GENERIC_TIME
+	depends on ATMEL_TCLIB
 	default y
 	help
 	  Select this to get a high precision clocksource based on a
@@ -240,7 +240,7 @@ config CS5535_MFGPT_DEFAULT_IRQ
 
 config CS5535_CLOCK_EVENT_SRC
 	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
+	depends on GENERIC_CLOCKEVENTS && CS5535_MFGPT
 	help
 	  This driver provides a clock event source based on the MFGPT
 	  timer(s) in the CS5535 and CS5536 companion chips.
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5ea3c60..c37b21a 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -292,6 +292,8 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
  */
 extern int
 __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
+extern void
+__clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq);
 
 static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
 {
@@ -303,6 +305,15 @@ static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
 	return __clocksource_register_scale(cs, 1000, khz);
 }
 
+static inline void __clocksource_updatefreq_hz(struct clocksource *cs, u32 hz)
+{
+	__clocksource_updatefreq_scale(cs, 1, hz);
+}
+
+static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
+{
+	__clocksource_updatefreq_scale(cs, 1000, khz);
+}
 
 static inline void
 clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
@@ -313,11 +324,13 @@ clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void
-update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult);
+update_vsyscall(struct timespec *ts, struct timespec *wtm,
+			struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
 static inline void
-update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult)
+update_vsyscall(struct timespec *ts, struct timespec *wtm,
+			struct clocksource *c, u32 mult)
 {
 }
 
diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..cb34e35 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -76,9 +76,25 @@ extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int min, const unsigned int sec);
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
+
+/*
+ * timespec_add_safe assumes both values are positive and checks
+ * for overflow. It will return TIME_T_MAX if the reutrn would be
+ * smaller then either of the arguments.
+ */
 extern struct timespec timespec_add_safe(const struct timespec lhs,
 					 const struct timespec rhs);
 
+
+static inline struct timespec timespec_add(struct timespec lhs,
+						struct timespec rhs)
+{
+	struct timespec ts_delta;
+	set_normalized_timespec(&ts_delta, lhs.tv_sec + rhs.tv_sec,
+				lhs.tv_nsec + rhs.tv_nsec);
+	return ts_delta;
+}
+
 /*
  * sub = lhs - rhs, in normalized form
  */
@@ -97,8 +113,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 #define timespec_valid(ts) \
 	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
 
-extern struct timespec xtime;
-extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock;
 
 extern void read_persistent_clock(struct timespec *ts);
@@ -110,7 +124,8 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
-struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
+struct timespec __current_kernel_time(void); /* does not take xtime_lock */
+struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index ebe4a28..a7b9f8d 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2440,6 +2440,7 @@ static void kdb_sysinfo(struct sysinfo *val)
  */
 static int kdb_summary(int argc, const char **argv)
 {
+	struct timespec now;
 	struct kdb_tm tm;
 	struct sysinfo val;
 
@@ -2454,7 +2455,8 @@ static int kdb_summary(int argc, const char **argv)
 	kdb_printf("domainname %s\n", init_uts_ns.name.domainname);
 	kdb_printf("ccversion  %s\n", __stringify(CCVERSION));
 
-	kdb_gmtime(&xtime, &tm);
+	now = __current_kernel_time();
+	kdb_gmtime(&now, &tm);
 	kdb_printf("date       %04d-%02d-%02d %02d:%02d:%02d "
 		   "tz_minuteswest %d\n",
 		1900+tm.tm_year, tm.tm_mon+1, tm.tm_mday,
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5c69e99..809f48c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -90,7 +90,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		xts = __current_kernel_time();
-		tom = wall_to_monotonic;
+		tom = __get_wall_to_monotonic();
 	} while (read_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
@@ -612,7 +612,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset;
+	struct timespec realtime_offset, wtm;
 	unsigned long seq;
 
 	if (!hrtimer_hres_active())
@@ -620,10 +620,9 @@ static void retrigger_next_event(void *arg)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		set_normalized_timespec(&realtime_offset,
-					-wall_to_monotonic.tv_sec,
-					-wall_to_monotonic.tv_nsec);
+		wtm = __get_wall_to_monotonic();
 	} while (read_seqretry(&xtime_lock, seq));
+	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
 
diff --git a/kernel/time.c b/kernel/time.c
index 848b1c2..ba9b338 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -300,22 +300,6 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-#ifndef CONFIG_GENERIC_TIME
-/*
- * Simulate gettimeofday using do_gettimeofday which only allows a timeval
- * and therefore only yields usec accuracy
- */
-void getnstimeofday(struct timespec *tv)
-{
-	struct timeval x;
-
-	do_gettimeofday(&x);
-	tv->tv_sec = x.tv_sec;
-	tv->tv_nsec = x.tv_usec * NSEC_PER_USEC;
-}
-EXPORT_SYMBOL_GPL(getnstimeofday);
-#endif
-
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 95ed429..f06a8a3 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -6,7 +6,7 @@ config TICK_ONESHOT
 
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
@@ -15,7 +15,7 @@ config NO_HZ
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables high resolution timer support. If your
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index f08e99c..c18d7ef 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -531,7 +531,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	return max_nsecs - (max_nsecs >> 5);
 }
 
-#ifdef CONFIG_GENERIC_TIME
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
 /**
  * clocksource_select - Select the best clocksource available
@@ -577,7 +577,7 @@ static void clocksource_select(void)
 	}
 }
 
-#else /* CONFIG_GENERIC_TIME */
+#else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 static inline void clocksource_select(void) { }
 
@@ -639,19 +639,18 @@ static void clocksource_enqueue(struct clocksource *cs)
 #define MAX_UPDATE_LENGTH 5 /* Seconds */
 
 /**
- * __clocksource_register_scale - Used to install new clocksources
+ * __clocksource_updatefreq_scale - Used update clocksource with new freq
  * @t:		clocksource to be registered
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * This should only be called from the clocksource->enable() method.
  *
  * This *SHOULD NOT* be called directly! Please use the
- * clocksource_register_hz() or clocksource_register_khz helper functions.
+ * clocksource_updatefreq_hz() or clocksource_updatefreq_khz helper functions.
  */
-int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
-
 	/*
 	 * Ideally we want to use  some of the limits used in
 	 * clocksource_max_deferment, to provide a more informed
@@ -662,7 +661,27 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 				      NSEC_PER_SEC/scale,
 				      MAX_UPDATE_LENGTH*scale);
 	cs->max_idle_ns = clocksource_max_deferment(cs);
+}
+EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
+
+/**
+ * __clocksource_register_scale - Used to install new clocksources
+ * @t:		clocksource to be registered
+ * @scale:	Scale factor multiplied against freq to get clocksource hz
+ * @freq:	clocksource frequency (cycles per second) divided by scale
+ *
+ * Returns -EBUSY if registration fails, zero otherwise.
+ *
+ * This *SHOULD NOT* be called directly! Please use the
+ * clocksource_register_hz() or clocksource_register_khz helper functions.
+ */
+int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+{
+
+	/* Intialize mult/shift and max_idle_ns */
+	__clocksource_updatefreq_scale(cs, scale, freq);
 
+	/* Add clocksource to the clcoksource list */
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_select();
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..e14c839 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -153,8 +153,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
  * - wall_to_monotonic is no longer the boot time, getboottime must be
  * used instead.
  */
-struct timespec xtime __attribute__ ((aligned (16)));
-struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+static struct timespec xtime __attribute__ ((aligned (16)));
+static struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static struct timespec total_sleep_time;
 
 /*
@@ -170,11 +170,10 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+			timekeeper.mult);
 }
 
-#ifdef CONFIG_GENERIC_TIME
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -328,7 +327,8 @@ int do_settimeofday(struct timespec *tv)
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -376,52 +376,6 @@ void timekeeping_notify(struct clocksource *clock)
 	tick_clock_notify();
 }
 
-#else /* GENERIC_TIME */
-
-static inline void timekeeping_forward_now(void) { }
-
-/**
- * ktime_get - get the monotonic time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get(void)
-{
-	struct timespec now;
-
-	ktime_get_ts(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	struct timespec tomono;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		getnstimeofday(ts);
-		tomono = wall_to_monotonic;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-
-#endif /* !GENERIC_TIME */
-
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
  *
@@ -579,9 +533,9 @@ static int timekeeping_resume(struct sys_device *dev)
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
-		xtime = timespec_add_safe(xtime, ts);
+		xtime = timespec_add(xtime, ts);
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
-		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
+		total_sleep_time = timespec_add(total_sleep_time, ts);
 	}
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
@@ -784,10 +738,11 @@ void update_wall_time(void)
 		return;
 
 	clock = timekeeper.clock;
-#ifdef CONFIG_GENERIC_TIME
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
-#else
+
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = timekeeper.cycle_interval;
+#else
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
@@ -856,7 +811,8 @@ void update_wall_time(void)
 	}
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
 }
 
 /**
@@ -887,7 +843,7 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	*ts = timespec_add_safe(*ts, total_sleep_time);
+	*ts = timespec_add(*ts, total_sleep_time);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
@@ -902,6 +858,11 @@ struct timespec __current_kernel_time(void)
 	return xtime;
 }
 
+struct timespec __get_wall_to_monotonic(void)
+{
+	return wall_to_monotonic;
+}
+
 struct timespec current_kernel_time(void)
 {
 	struct timespec now;
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8b1797c..7531dda 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -153,7 +153,7 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	select TRACE_IRQFLAGS
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
@@ -175,7 +175,7 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPT
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
