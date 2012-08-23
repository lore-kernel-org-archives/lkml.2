Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030712Ab2HWTJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:09:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56378 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2HWTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:09:40 -0400
Date: Thu, 23 Aug 2012 12:09:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
Message-ID: <20120823190905.GL2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
 <alpine.LFD.2.02.1208231245510.2856@ionos>
 <20120823154346.GB2465@linux.vnet.ibm.com>
 <CA+icZUXq9p4yOuse5dzCb2FGmgSKdU8ufDkDcTjWJ0dE79tvUg@mail.gmail.com>
 <20120823171431.GG2465@linux.vnet.ibm.com>
 <CA+icZUV+UMXGJTyfsUYBcbRVouVRv6pzvzUVUu7QEoAJKU0j7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUV+UMXGJTyfsUYBcbRVouVRv6pzvzUVUu7QEoAJKU0j7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082319-7606-0000-0000-0000030ADA55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 08:55:09PM +0200, Sedat Dilek wrote:
> On Thu, Aug 23, 2012 at 7:14 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Aug 23, 2012 at 06:06:23PM +0200, Sedat Dilek wrote:
> >> On Thu, Aug 23, 2012 at 5:43 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >
> > [ . . . ]
> >
> >> Applying this patch on top of my local GIT tree results in error-messages:
> >>
> >> [...]
> >>   CC      kernel/rcupdate.o
> >>   AS      arch/x86/platform/efi/efi_stub_64.o
> >>   CC      arch/x86/kernel/irqinit.o
> >>   LD      arch/x86/platform/efi/built-in.o
> >> arch/x86/platform/efi/efi_64.o:(.rodata+0x0): multiple definition of
> >> `softirq_stop_idle_mask'
> >> arch/x86/platform/efi/efi.o:(.rodata+0x50): first defined here
> >> make[5]: *** [arch/x86/platform/efi/built-in.o] Error 1
> >> make[4]: *** [arch/x86/platform/efi] Error 2
> >> make[3]: *** [arch/x86/platform] Error 2
> >> make[3]: *** Waiting for unfinished jobs....
> >> [...]
> >>
> >> $ LC_ALL=C grep softirq_stop_idle_mask -nr linux-next/arch/x86/platform/efi/
> >> Binary file linux-next/arch/x86/platform/efi/efi.o matches
> >> Binary file linux-next/arch/x86/platform/efi/efi_64.o matches
> >
> > Right...  Clearly I was spinning a bit too quickly on that one.  :-/
> > So back to old tech: C-preprocessor macros.
> >
> > This one actually builds, boots, and passes mild rcutorture testing
> > under KVM.
> >
> 
> This fixes the issue with NOHZ - no messages in the logs.
> 
> There seems to remain an old PM issue (call-trace) I have seen before
> this time-rcu-issue with apps needing to long to freeze.
> So, this is another story.
> 
> I have added below my reported-by/tested-by.

Thank you, I will add them into -rcu.

							Thanx, Paul

> - Sedat -
> 
> >                                                         Thanx, Paul
> >
> > -------------------------------------------------------------------------
> >
> > time: RCU permitted to stop idle entry via softirq
> >
> > The can_stop_idle_tick() function complains if a softirq vector is
> > raised too late in the idle-entry process, presumably in order to
> > prevent dangling softirq invocations from being delayed across the
> > full idle period, which might be indefinitely long -- and if softirq
> > was asserted any later than the call to this function, such a delay
> > might well happen.
> >
> > However, RCU needs to be able to use softirq to stop idle entry in
> > order to be able to drain RCU callbacks from the current CPU, which in
> > turn enables faster entry into dyntick-idle mode, which in turn reduces
> > power consumption.  Because RCU takes this action at a well-defined
> > point in the idle-entry path, it is safe for RCU to take this approach.
> >
> > This commit therefore silences the error message that is sometimes
> > produced when the going-idle CPU suddenly finds that it has an RCU_SOFTIRQ
> > to process.  The error message will continue to be issued for other
> > softirq vectors.
> >
> 
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> >
> > diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> > index c5f856a..5e4e617 100644
> > --- a/include/linux/interrupt.h
> > +++ b/include/linux/interrupt.h
> > @@ -430,6 +430,8 @@ enum
> >         NR_SOFTIRQS
> >  };
> >
> > +#define SOFTIRQ_STOP_IDLE_MASK (~(1 << RCU_SOFTIRQ))
> > +
> >  /* map softirq index to softirq name. update 'softirq_to_name' in
> >   * kernel/softirq.c when adding a new softirq.
> >   */
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 024540f..4b1785a 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -436,7 +436,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
> >         if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
> >                 static int ratelimit;
> >
> > -               if (ratelimit < 10) {
> > +               if (ratelimit < 10 &&
> > +                   (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
> >                         printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> >                                (unsigned int) local_softirq_pending());
> >                         ratelimit++;
> >

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.6.0-rc3-next20120823-2-iniza-generic (sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Thu Aug 23 20:24:23 CEST 2012
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc3-next20120823-2-iniza-generic root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro init=/lib/systemd/systemd
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000d9c9efff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000d9c9f000-0x00000000dae7efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dae7f000-0x00000000daf9efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fdfffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.6 present.
> [    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 09XK 08/03/2012
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x11fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 base 0C0000000 mask FE0000000 write-back
> [    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
> [    0.000000]   4 base 0DB000000 mask FFF000000 uncachable
> [    0.000000]   5 base 100000000 mask FE0000000 write-back
> [    0.000000]   6 base 11FE00000 mask FFFE00000 uncachable
> [    0.000000]   7 base 0FFC00000 mask FFFC00000 write-protect
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f00e0-0x000f00ef] mapped at [ffff8800000f00e0]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0xdaffffff]
> [    0.000000]  [mem 0x00000000-0xdaffffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0xdaffffff @ [mem 0x1f923000-0x1fffffff]
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x11fdfffff]
> [    0.000000]  [mem 0x100000000-0x11fdfffff] page 2M
> [    0.000000] kernel direct mapping tables up to 0x11fdfffff @ [mem 0xd9c99000-0xd9c9efff]
> [    0.000000] RAMDISK: [mem 0x364a6000-0x3724afff]
> [    0.000000] ACPI: RSDP 00000000000f0100 00024 (v02 SECCSD)
> [    0.000000] ACPI: XSDT 00000000daffe120 0008C (v01 SECCSD LH43STAR 00000002 PTEC 00000002)
> [    0.000000] ACPI: FACP 00000000dafef000 000F4 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: DSDT 00000000daff2000 082E8 (v02 SECCSD  SNB-CPT 00000000 INTL 20061109)
> [    0.000000] ACPI: FACS 00000000daf47000 00040
> [    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 SECCSD LH43STAR 00000002 PTEC 00000001)
> [    0.000000] ACPI: SSDT 00000000daffb000 01068 (v01 SECCSD PtidDevc 00001000 INTL 20061109)
> [    0.000000] ACPI: ASF! 00000000daff1000 000A5 (v32 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: HPET 00000000dafee000 00038 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: APIC 00000000dafed000 00098 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: MCFG 00000000dafec000 0003C (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafeb000 00804 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
> [    0.000000] ACPI: SSDT 00000000dafea000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
> [    0.000000] ACPI: UEFI 00000000dafe9000 0003E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: UEFI 00000000dafe8000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
> [    0.000000] ACPI: UEFI 00000000dafe7000 0026A (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafe6000 000D0 (v01   Iffs  IffsAsl 00003000 INTL 20061109)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fdfffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fdfffff]
> [    0.000000]   NODE_DATA [mem 0x11fdfc000-0x11fdfffff]
> [    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b400000-ffff88011f3fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x11fdfffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
> [    0.000000]   node   0: [mem 0x40200000-0xd9c9efff]
> [    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x11fdfffff]
> [    0.000000] On node 0 totalpages: 1021485
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 6 pages reserved
> [    0.000000]   DMA zone: 3911 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 870624 pages, LIFO batch:31
> [    0.000000]   Normal zone: 2040 pages used for memmap
> [    0.000000]   Normal zone: 128520 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 00000000d9c9f000 - 00000000dae7f000
> [    0.000000] PM: Registered nosave memory: 00000000dae7f000 - 00000000daf9f000
> [    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
> [    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
> [    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
> [    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
> [    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
> [    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011fa00000 s84864 r8192 d21632 u262144
> [    0.000000] pcpu-alloc: s84864 r8192 d21632 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1003055
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-rc3-next20120823-2-iniza-generic root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro init=/lib/systemd/systemd
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 3923680k/4716544k available (6406k kernel code, 630604k absent, 162260k reserved, 6745k data, 924k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 1596.350 MHz processor
> [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.70 BogoMIPS (lpj=6385400)
> [    0.000009] pid_max: default: 32768 minimum: 301
> [    0.000032] Security Framework initialized
> [    0.000046] AppArmor: AppArmor initialized
> [    0.000380] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.001423] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.001870] Mount-cache hash table entries: 256
> [    0.002073] Initializing cgroup subsys cpuacct
> [    0.002078] Initializing cgroup subsys devices
> [    0.002081] Initializing cgroup subsys freezer
> [    0.002084] Initializing cgroup subsys blkio
> [    0.002087] Initializing cgroup subsys perf_event
> [    0.002112] Disabled fast string operations
> [    0.002115] CPU: Physical Processor ID: 0
> [    0.002117] CPU: Processor Core ID: 0
> [    0.002123] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.002123] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.002130] mce: CPU supports 7 MCE banks
> [    0.002144] CPU0: Thermal monitoring enabled (TM1)
> [    0.002152] process: using mwait in idle threads
> [    0.002157] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.002157] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.002157] tlb_flushall_shift: 5
> [    0.004245] ACPI: Core revision 20120711
> [    0.011359] ftrace: allocating 24595 entries in 97 pages
> [    0.025047] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.064708] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz stepping 07
> [    0.172241] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
> [    0.172252] ... version:                3
> [    0.172254] ... bit width:              48
> [    0.172256] ... generic registers:      4
> [    0.172258] ... value mask:             0000ffffffffffff
> [    0.172261] ... max period:             000000007fffffff
> [    0.172263] ... fixed-purpose events:   3
> [    0.172265] ... event mask:             000000070000000f
> [    0.183567] Disabled fast string operations
> [    0.185786] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.196907] Disabled fast string operations
> [    0.210156] Disabled fast string operations
> [    0.172536] smpboot: Booting Node   0, Processors  #1 #2 #3
> [    0.212276] Brought up 4 CPUs
> [    0.212284] smpboot: Total of 4 processors activated (12770.80 BogoMIPS)
> [    0.216084] devtmpfs: initialized
> [    0.217003] EVM: security.selinux
> [    0.217006] EVM: security.SMACK64
> [    0.217008] EVM: security.capability
> [    0.217050] PM: Registering ACPI NVS region [mem 0xdae7f000-0xdaf9efff] (1179648 bytes)
> [    0.217848] regulator-dummy: no parameters
> [    0.217882] RTC time: 20:39:34, date: 08/23/12
> [    0.217920] NET: Registered protocol family 16
> [    0.218067] ACPI: bus type pci registered
> [    0.218136] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.218142] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.225600] PCI: Using configuration type 1 for base access
> [    0.226445] bio: create slab <bio-0> at 0
> [    0.226524] ACPI: Added _OSI(Module Device)
> [    0.226527] ACPI: Added _OSI(Processor Device)
> [    0.226530] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.226533] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.228045] ACPI: EC: Look up EC in DSDT
> [    0.240260] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.242837] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.244158] ACPI: SSDT 00000000dae70718 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.244557] ACPI: Dynamic OEM Table Load:
> [    0.244561] ACPI: SSDT           (null) 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.244842] ACPI: SSDT 00000000dae71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.245266] ACPI: Dynamic OEM Table Load:
> [    0.245270] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.245399] ACPI: SSDT 00000000dae6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.245787] ACPI: Dynamic OEM Table Load:
> [    0.245791] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.247262] ACPI: Interpreter enabled
> [    0.247268] ACPI: (supports S0 S1 S3 S5)
> [    0.247289] ACPI: Using IOAPIC for interrupt routing
> [    0.252292] ACPI: Power Resource [FN00] (off)
> [    0.252367] ACPI: Power Resource [FN01] (off)
> [    0.252439] ACPI: Power Resource [FN02] (off)
> [    0.252510] ACPI: Power Resource [FN03] (off)
> [    0.252582] ACPI: Power Resource [FN04] (off)
> [    0.252881] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    0.253053] ACPI: No dock devices found.
> [    0.253058] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.253449] \_SB_.PCI0:_OSC invalid UUID
> [    0.253450] _OSC request data:1 8 1f 
> [    0.253455] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.253881] PCI host bridge to bus 0000:00
> [    0.253887] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
> [    0.253889] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.253892] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.253896] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.253899] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.253902] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
> [    0.253906] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    0.253917] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
> [    0.253958] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
> [    0.253969] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
> [    0.253976] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.253981] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
> [    0.254042] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
> [    0.254066] pci 0000:00:16.0: reg 10: [mem 0xf0705000-0xf070500f 64bit]
> [    0.254150] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.254191] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
> [    0.254213] pci 0000:00:1a.0: reg 10: [mem 0xf070a000-0xf070a3ff]
> [    0.254310] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.254340] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
> [    0.254356] pci 0000:00:1b.0: reg 10: [mem 0xf0700000-0xf0703fff 64bit]
> [    0.254430] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.254456] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
> [    0.254542] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.254574] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
> [    0.254659] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.254693] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
> [    0.254825] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.254869] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
> [    0.254891] pci 0000:00:1d.0: reg 10: [mem 0xf0709000-0xf07093ff]
> [    0.254989] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.255018] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
> [    0.255152] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
> [    0.255172] pci 0000:00:1f.2: reg 10: [io  0x3088-0x308f]
> [    0.255181] pci 0000:00:1f.2: reg 14: [io  0x3094-0x3097]
> [    0.255190] pci 0000:00:1f.2: reg 18: [io  0x3080-0x3087]
> [    0.255199] pci 0000:00:1f.2: reg 1c: [io  0x3090-0x3093]
> [    0.255207] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
> [    0.255216] pci 0000:00:1f.2: reg 24: [mem 0xf0708000-0xf07087ff]
> [    0.255266] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.255287] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
> [    0.255303] pci 0000:00:1f.3: reg 10: [mem 0xf0704000-0xf07040ff 64bit]
> [    0.255326] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
> [    0.255405] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-3e]
> [    0.255569] pci 0000:01:00.0: [8086:0091] type 00 class 0x028000
> [    0.255723] pci 0000:01:00.0: reg 10: [mem 0xf0600000-0xf0601fff 64bit]
> [    0.256475] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> [    0.264324] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.264334] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
> [    0.264386] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-3e]
> [    0.264470] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
> [    0.264533] pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
> [    0.264649] pci 0000:02:00.0: reg 18: [mem 0xf0404000-0xf0404fff 64bit pref]
> [    0.264724] pci 0000:02:00.0: reg 20: [mem 0xf0400000-0xf0403fff 64bit pref]
> [    0.265067] pci 0000:02:00.0: supports D1 D2
> [    0.265068] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.272236] pci 0000:00:1c.3: PCI bridge to [bus 02]
> [    0.272250] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.272275] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.272345] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
> [    0.272406] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
> [    0.272441] pci 0000:03:00.0: reg 10: [mem 0xf0500000-0xf0507fff 64bit]
> [    0.272641] pci 0000:03:00.0: PME# supported from D3hot D3cold
> [    0.280222] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.280240] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
> [    0.280281] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.280387] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    0.280422] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
> [    0.280453] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
> [    0.280584] \_SB_.PCI0:_OSC invalid UUID
> [    0.280586] _OSC request data:1 1f 1f 
> [    0.280589]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> [    0.280594]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.283299] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
> [    0.283349] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.283399] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
> [    0.283445] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
> [    0.283491] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
> [    0.283538] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.283585] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
> [    0.283632] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
> [    0.283722] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.283730] vgaarb: loaded
> [    0.283732] vgaarb: bridge control possible 0000:00:02.0
> [    0.283867] SCSI subsystem initialized
> [    0.283870] ACPI: bus type scsi registered
> [    0.283912] libata version 3.00 loaded.
> [    0.283930] ACPI: bus type usb registered
> [    0.283946] usbcore: registered new interface driver usbfs
> [    0.283956] usbcore: registered new interface driver hub
> [    0.283977] usbcore: registered new device driver usb
> [    0.284044] PCI: Using ACPI for IRQ routing
> [    0.285683] PCI: pci_cache_line_size set to 64 bytes
> [    0.285803] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.285807] e820: reserve RAM buffer [mem 0xd9c9f000-0xdbffffff]
> [    0.285809] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
> [    0.285810] e820: reserve RAM buffer [mem 0x11fe00000-0x11fffffff]
> [    0.285889] NetLabel: Initializing
> [    0.285892] NetLabel:  domain hash size = 128
> [    0.285894] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.285905] NetLabel:  unlabeled traffic allowed by default
> [    0.285961] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.285969] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.287983] Switching to clocksource hpet
> [    0.293030] AppArmor: AppArmor Filesystem Enabled
> [    0.293058] pnp: PnP ACPI init
> [    0.293072] ACPI: bus type pnp registered
> [    0.293324] pnp 00:00: [bus 00-3e]
> [    0.293327] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    0.293329] pnp 00:00: [io  0x0cf8-0x0cff]
> [    0.293331] pnp 00:00: [io  0x0d00-0xffff window]
> [    0.293333] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    0.293334] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> [    0.293336] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> [    0.293337] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> [    0.293339] pnp 00:00: [mem 0x000cc000-0x000cffff window]
> [    0.293341] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> [    0.293342] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> [    0.293344] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> [    0.293346] pnp 00:00: [mem 0x000dc000-0x000dffff window]
> [    0.293347] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> [    0.293349] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> [    0.293350] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> [    0.293352] pnp 00:00: [mem 0x000ec000-0x000effff window]
> [    0.293353] pnp 00:00: [mem 0x000f0000-0x000fffff window]
> [    0.293355] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
> [    0.293357] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    0.293425] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    0.293622] pnp 00:01: [io  0x0000-0x001f]
> [    0.293624] pnp 00:01: [io  0x0081-0x0091]
> [    0.293625] pnp 00:01: [io  0x0093-0x009f]
> [    0.293626] pnp 00:01: [io  0x00c0-0x00df]
> [    0.293628] pnp 00:01: [dma 4]
> [    0.293718] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.293726] pnp 00:02: [mem 0xff000000-0xffffffff]
> [    0.293744] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.293816] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    0.293835] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.293843] pnp 00:04: [io  0x00f0]
> [    0.293853] pnp 00:04: [irq 13]
> [    0.293872] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.293883] pnp 00:05: [io  0x002e-0x002f]
> [    0.293884] pnp 00:05: [io  0x004e-0x004f]
> [    0.293886] pnp 00:05: [io  0x0061]
> [    0.293887] pnp 00:05: [io  0x0063]
> [    0.293888] pnp 00:05: [io  0x0065]
> [    0.293890] pnp 00:05: [io  0x0067]
> [    0.293891] pnp 00:05: [io  0x0070]
> [    0.293892] pnp 00:05: [io  0x0080]
> [    0.293893] pnp 00:05: [io  0x0092]
> [    0.293895] pnp 00:05: [io  0x00b2-0x00b3]
> [    0.293896] pnp 00:05: [io  0x0680-0x069f]
> [    0.293899] pnp 00:05: [io  0x1000-0x100f]
> [    0.293901] pnp 00:05: [io  0x5000-0x5003]
> [    0.293902] pnp 00:05: [io  0xffff]
> [    0.293904] pnp 00:05: [io  0x0400-0x0453]
> [    0.293905] pnp 00:05: [io  0x0458-0x047f]
> [    0.293907] pnp 00:05: [io  0x0500-0x057f]
> [    0.293908] pnp 00:05: [io  0x0a00-0x0a0f]
> [    0.293909] pnp 00:05: [io  0x164e-0x164f]
> [    0.293911] pnp 00:05: [io  0x5000-0x500f]
> [    0.293950] system 00:05: [io  0x0680-0x069f] has been reserved
> [    0.293955] system 00:05: [io  0x1000-0x100f] has been reserved
> [    0.293958] system 00:05: [io  0x5000-0x5003] has been reserved
> [    0.293961] system 00:05: [io  0xffff] has been reserved
> [    0.293965] system 00:05: [io  0x0400-0x0453] has been reserved
> [    0.293968] system 00:05: [io  0x0458-0x047f] has been reserved
> [    0.293971] system 00:05: [io  0x0500-0x057f] has been reserved
> [    0.293974] system 00:05: [io  0x0a00-0x0a0f] has been reserved
> [    0.293977] system 00:05: [io  0x164e-0x164f] has been reserved
> [    0.293981] system 00:05: [io  0x5000-0x500f] could not be reserved
> [    0.293985] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.293992] pnp 00:06: [io  0x0070-0x0077]
> [    0.293998] pnp 00:06: [irq 8]
> [    0.294017] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.294042] pnp 00:07: [io  0x0454-0x0457]
> [    0.294070] system 00:07: [io  0x0454-0x0457] has been reserved
> [    0.294074] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    0.294087] pnp 00:08: [io  0x0060]
> [    0.294089] pnp 00:08: [io  0x0064]
> [    0.294094] pnp 00:08: [irq 1]
> [    0.294114] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.294142] pnp 00:09: [irq 12]
> [    0.294163] pnp 00:09: Plug and Play ACPI device, IDs ETD0b00 SYN0002 PNP0f13 (active)
> [    0.294287] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
> [    0.294289] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
> [    0.294290] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
> [    0.294292] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
> [    0.294293] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
> [    0.294295] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
> [    0.294296] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
> [    0.294298] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
> [    0.294299] pnp 00:0a: [mem 0xff000000-0xffffffff]
> [    0.294301] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
> [    0.294302] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
> [    0.294338] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.294342] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.294346] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.294349] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.294353] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.294356] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.294360] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
> [    0.294363] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.294367] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
> [    0.294370] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.294374] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.294720] ACPI Error: Invalid/unsupported resource descriptor: Type 0x00 (20120711/utresrc-650)
> [    0.294764] pnp 00:0b: can't evaluate _CRS: 12311
> [    0.294847] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.294872] pnp: PnP ACPI: found 12 devices
> [    0.294874] ACPI: ACPI bus type pnp unregistered
> [    0.301300] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.301309] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
> [    0.301320] pci 0000:00:1c.3: PCI bridge to [bus 02]
> [    0.301325] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.301336] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.301345] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.301352] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
> [    0.301390] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.301392] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.301394] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.301395] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
> [    0.301397] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
> [    0.301399] pci_bus 0000:01: resource 1 [mem 0xf0600000-0xf06fffff]
> [    0.301401] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> [    0.301403] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.301405] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
> [    0.301433] NET: Registered protocol family 2
> [    0.302096] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.303928] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.304186] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.304220] TCP: reno registered
> [    0.304231] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.304253] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.304336] NET: Registered protocol family 1
> [    0.304351] pci 0000:00:02.0: Boot video device
> [    0.304527] PCI: CLS 64 bytes, default 64
> [    0.304569] Trying to unpack rootfs image as initramfs...
> [    0.586990] Freeing initrd memory: 13972k freed
> [    0.590178] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.590188] software IO TLB [mem 0xd5c99000-0xd9c98fff] (64MB) mapped at [ffff8800d5c99000-ffff8800d9c98fff]
> [    0.590617] audit: initializing netlink socket (disabled)
> [    0.590634] type=2000 audit(1345754373.476:1): initialized
> [    0.613227] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.614659] VFS: Disk quotas dquot_6.5.2
> [    0.614699] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.615027] fuse init (API version 7.20)
> [    0.615093] msgmni has been set to 7690
> [    0.615451] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.615479] io scheduler noop registered
> [    0.615483] io scheduler deadline registered (default)
> [    0.615506] io scheduler cfq registered
> [    0.615730] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.615748] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.615818] intel_idle: MWAIT substates: 0x21120
> [    0.615820] intel_idle: v0.4 model 0x2A
> [    0.615821] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.616290] ACPI: AC Adapter [ADP1] (on-line)
> [    0.616484] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    0.616760] ACPI: Lid Switch [LID0]
> [    0.616803] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    0.616815] ACPI: Power Button [PWRB]
> [    0.616850] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.616855] ACPI: Power Button [PWRF]
> [    0.616914] ACPI: Fan [FAN0] (off)
> [    0.616943] ACPI: Fan [FAN1] (off)
> [    0.616967] ACPI: Fan [FAN2] (off)
> [    0.616993] ACPI: Fan [FAN3] (off)
> [    0.617018] ACPI: Fan [FAN4] (off)
> [    0.617064] ACPI: Requesting acpi_cpufreq
> [    0.623052] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.623057] ACPI: Thermal Zone [TZ00] (72 C)
> [    0.623210] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.623213] ACPI: Thermal Zone [TZ01] (30 C)
> [    0.623241] GHES: HEST is not enabled!
> [    0.623302] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    0.632489] Linux agpgart interface v0.103
> [    0.634046] brd: module loaded
> [    0.634736] ACPI: Battery Slot [BAT1] (battery present)
> [    0.634955] loop: module loaded
> [    0.635039] ahci 0000:00:1f.2: version 3.0
> [    0.635104] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
> [    0.635140] ahci: SSS flag set, parallel bus scan disabled
> [    0.647791] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
> [    0.647807] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
> [    0.647823] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.672138] scsi0 : ahci
> [    0.672206] scsi1 : ahci
> [    0.672264] scsi2 : ahci
> [    0.672323] scsi3 : ahci
> [    0.672379] scsi4 : ahci
> [    0.672435] scsi5 : ahci
> [    0.672469] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708100 irq 40
> [    0.672474] ata2: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708180 irq 40
> [    0.672478] ata3: DUMMY
> [    0.672482] ata4: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708280 irq 40
> [    0.672487] ata5: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708300 irq 40
> [    0.672490] ata6: DUMMY
> [    0.672718] libphy: Fixed MDIO Bus: probed
> [    0.672753] tun: Universal TUN/TAP device driver, 1.6
> [    0.672756] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.672802] PPP generic driver version 2.4.2
> [    0.672845] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.672880] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [    0.672884] ehci_hcd 0000:00:1a.0: EHCI Host Controller
> [    0.672891] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    0.676807] ehci_hcd 0000:00:1a.0: debug port 2
> [    0.676818] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
> [    0.676833] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf070a000
> [    0.687729] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    0.687785] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.687794] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.687809] usb usb1: Product: EHCI Host Controller
> [    0.687812] usb usb1: Manufacturer: Linux 3.6.0-rc3-next20120823-2-iniza-generic ehci_hcd
> [    0.687816] usb usb1: SerialNumber: 0000:00:1a.0
> [    0.687917] hub 1-0:1.0: USB hub found
> [    0.687922] hub 1-0:1.0: 2 ports detected
> [    0.687986] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [    0.687990] ehci_hcd 0000:00:1d.0: EHCI Host Controller
> [    0.687997] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    0.691904] ehci_hcd 0000:00:1d.0: debug port 2
> [    0.691913] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
> [    0.691927] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf0709000
> [    0.703716] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.703762] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.703771] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.703780] usb usb2: Product: EHCI Host Controller
> [    0.703796] usb usb2: Manufacturer: Linux 3.6.0-rc3-next20120823-2-iniza-generic ehci_hcd
> [    0.703800] usb usb2: SerialNumber: 0000:00:1d.0
> [    0.703884] hub 2-0:1.0: USB hub found
> [    0.703889] hub 2-0:1.0: 2 ports detected
> [    0.703938] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.703953] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.703995] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.704001] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
> [    0.713681] xhci_hcd 0000:03:00.0: irq 16, io mem 0xf0500000
> [    0.713749] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [    0.713754] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [    0.713759] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [    0.713764] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [    0.713769] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [    0.713874] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.713877] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.713881] usb usb3: Product: xHCI Host Controller
> [    0.713884] usb usb3: Manufacturer: Linux 3.6.0-rc3-next20120823-2-iniza-generic xhci_hcd
> [    0.713888] usb usb3: SerialNumber: 0000:03:00.0
> [    0.713949] xHCI xhci_add_endpoint called for root hub
> [    0.713950] xHCI xhci_check_bandwidth called for root hub
> [    0.713968] hub 3-0:1.0: USB hub found
> [    0.713977] hub 3-0:1.0: 2 ports detected
> [    0.714032] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.714037] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
> [    0.714073] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    0.714076] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.714080] usb usb4: Product: xHCI Host Controller
> [    0.714083] usb usb4: Manufacturer: Linux 3.6.0-rc3-next20120823-2-iniza-generic xhci_hcd
> [    0.714086] usb usb4: SerialNumber: 0000:03:00.0
> [    0.714140] xHCI xhci_add_endpoint called for root hub
> [    0.714141] xHCI xhci_check_bandwidth called for root hub
> [    0.714158] hub 4-0:1.0: USB hub found
> [    0.714167] hub 4-0:1.0: 2 ports detected
> [    0.714288] usbcore: registered new interface driver libusual
> [    0.714325] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
> [    0.722510] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.722516] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.722641] mousedev: PS/2 mouse device common for all mice
> [    0.723124] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    0.723155] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    0.723219] device-mapper: uevent: version 1.0.3
> [    0.723272] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
> [    0.723341] cpuidle: using governor ladder
> [    0.723431] cpuidle: using governor menu
> [    0.723434] EFI Variables Facility v0.08 2004-May-17
> [    0.723606] ashmem: initialized
> [    0.723745] TCP: cubic registered
> [    0.723831] NET: Registered protocol family 10
> [    0.723967] NET: Registered protocol family 17
> [    0.723976] Key type dns_resolver registered
> [    0.724316] PM: Hibernation image not present or could not be loaded.
> [    0.724328] registered taskstats version 1
> [    0.726988] Key type trusted registered
> [    0.729210] Key type encrypted registered
> [    0.730631] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    0.731756]   Magic number: 8:994:700
> [    0.731867] rtc_cmos 00:06: setting system clock to 2012-08-23 20:39:34 UTC (1345754374)
> [    0.732518] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    0.732522] EDD information not available.
> [    0.991606] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.992806] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
> [    0.992824] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    0.994056] ata1.00: configured for UDMA/133
> [    0.994307] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 GG2O PQ: 0 ANSI: 5
> [    0.994479] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.994484] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    0.994486] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    0.994569] sd 0:0:0:0: [sda] Write Protect is off
> [    0.994576] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 10
> [    0.994622] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    0.999545] usb 1-1: new high-speed USB device number 2 using ehci_hcd
> [    1.011341]  sda: sda1 sda2 sda3
> [    1.011926] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.131882] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.131890] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.132315] hub 1-1:1.0: USB hub found
> [    1.132489] hub 1-1:1.0: 6 ports detected
> [    1.243424] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> [    1.311385] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.311973] ata2.00: ATA-8: SanDisk iSSD P4 16GB, SSD 9.14, max UDMA/133
> [    1.311998] ata2.00: 31277232 sectors, multi 1: LBA48 
> [    1.312655] ata2.00: configured for UDMA/133
> [    1.312886] scsi 1:0:0:0: Direct-Access     ATA      SanDisk iSSD P4  SSD  PQ: 0 ANSI: 5
> [    1.313057] sd 1:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
> [    1.313060] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    1.313187] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.313194] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 10
> [    1.313286] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    1.314437]  sdb: sdb1 sdb2
> [    1.314917] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.375662] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.375681] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.376142] hub 2-1:1.0: USB hub found
> [    1.376314] hub 2-1:1.0: 6 ports detected
> [    1.447377] usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
> [    1.587167] tsc: Refined TSC clocksource calibration: 1596.373 MHz
> [    1.587189] Switching to clocksource tsc
> [    1.631143] ata4: SATA link down (SStatus 0 SControl 300)
> [    1.699532] usb 1-1.4: New USB device found, idVendor=2232, idProduct=1018
> [    1.699551] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.699562] usb 1-1.4: Product: WebCam SC-13HDL11431N
> [    1.699570] usb 1-1.4: Manufacturer: 123
> [    1.943018] usb 2-1.4: new low-speed USB device number 3 using ehci_hcd
> [    1.950901] ata5: SATA link down (SStatus 0 SControl 300)
> [    1.952798] Freeing unused kernel memory: 924k freed
> [    1.952951] Write protecting the kernel read-only data: 12288k
> [    1.958040] Freeing unused kernel memory: 1776k freed
> [    1.961651] Freeing unused kernel memory: 1236k freed
> [    1.977515] udevd[119]: starting version 175
> [    2.040538] usb 2-1.4: New USB device found, idVendor=046d, idProduct=c00e
> [    2.040556] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.040567] usb 2-1.4: Product: USB-PS/2 Optical Mouse
> [    2.040575] usb 2-1.4: Manufacturer: Logitech
> [    2.110935] usb 2-1.5: new full-speed USB device number 4 using ehci_hcd
> [    2.207271] usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
> [    2.207289] usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.513031] usbcore: registered new interface driver usbhid
> [    2.513040] usbhid: USB HID core driver
> [    2.524161] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    2.525697] r8169 0000:02:00.0: irq 46 for MSI/MSI-X
> [    2.525951] r8169 0000:02:00.0: eth0: RTL8168evl/8111evl at 0xffffc9000066a000, e8:03:9a:36:17:a9, XID 0c900800 IRQ 46
> [    2.525963] r8169 0000:02:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    3.339738] EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
> [    5.832425] udevd[293]: starting version 175
> [    6.075066] lp: driver loaded but no devices found
> [    6.635709] tty_init_dev: 9 callbacks suppressed
> [    6.646596] EXT4-fs (loop0): re-mounted. Opts: errors=remount-ro
> [    8.181735] ACPI Warning: 0x0000000000000460-0x000000000000047f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
> [    8.181745] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    8.181748] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
> [    8.181752] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
> [    8.181757] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    8.181762] ACPI Warning: 0x0000000000000500-0x000000000000057f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
> [    8.181766] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    8.181768] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    8.348320] mei 0000:00:16.0: setting latency timer to 64
> [    8.348392] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [    8.353528] mei 0000:00:16.0: wd: failed to find the client
> [    8.363675] wmi: Mapper loaded
> [    8.373425] samsung_laptop: detected SABI interface: SwSmi@
> [    8.373428] samsung_laptop: Backlight controlled by ACPI video driver
> [    8.543187] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x28
> [    8.655258] Bluetooth: Core ver 2.16
> [    8.655282] NET: Registered protocol family 31
> [    8.655284] Bluetooth: HCI device and connection manager initialized
> [    8.655291] Bluetooth: HCI socket layer initialized
> [    8.655293] Bluetooth: L2CAP socket layer initialized
> [    8.655297] Bluetooth: SCO socket layer initialized
> [    8.655375] cfg80211: Calling CRDA to update world regulatory domain
> [    8.954932] usbcore: registered new interface driver btusb
> [    9.024117] [drm] Initialized drm 1.1.0 20060810
> [    9.343079] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input4
> [    9.343242] hid-generic 0003:046D:C00E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.4/input0
> [    9.354333] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x28
> [    9.355561] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x28
> [    9.356718] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x28
> [    9.357934] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    9.380481] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f00)
> [    9.381785] Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    9.381789] Copyright(c) 2003-2012 Intel Corporation
> [    9.381931] iwlwifi 0000:01:00.0: pci_resource_len = 0x00002000
> [    9.381935] iwlwifi 0000:01:00.0: pci_resource_base = ffffc90004f94000
> [    9.381938] iwlwifi 0000:01:00.0: HW Revision ID = 0x34
> [    9.382183] iwlwifi 0000:01:00.0: irq 48 for MSI/MSI-X
> [    9.397336] psmouse serio1: elantech: Synaptics capabilities query result 0x08, 0x17, 0x0c.
> [    9.481397] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input5
> [    9.805478] Linux video capture interface: v2.00
> [   10.004985] pci 0000:00:00.0: Intel Sandybridge Chipset
> [   10.005070] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [   10.006164] pci 0000:00:00.0: detected 65536K stolen memory
> [   10.006214] i915 0000:00:02.0: setting latency timer to 64
> [   10.037728] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1
> [   10.044976] i915 0000:00:02.0: irq 49 for MSI/MSI-X
> [   10.044986] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   10.044987] [drm] Driver supports precise vblank timestamp query.
> [   10.045027] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [   10.307640] uvcvideo: Found UVC 1.00 device WebCam SC-13HDL11431N (2232:1018)
> [   10.327018] input: WebCam SC-13HDL11431N as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input6
> [   10.327093] usbcore: registered new interface driver uvcvideo
> [   10.327095] USB Video Class driver (1.1.1)
> [   10.536949] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
> [   10.536953] iwldvm: Copyright(c) 2003-2012 Intel Corporation
> [   10.536982] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [   10.536985] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   10.536988] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
> [   10.536990] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
> [   10.536992] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
> [   10.536994] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
> [   10.537103] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   10.552594] iwlwifi 0000:01:00.0: device EEPROM VER=0x716, CALIB=0x6
> [   10.552597] iwlwifi 0000:01:00.0: Device SKU: 0x1F0
> [   10.552600] iwlwifi 0000:01:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
> [   10.552745] Registered led device: phy0-led
> [   10.552771] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [   10.614273] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   10.687293] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [   10.812653] type=1400 audit(1345754384.584:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=415 comm="apparmor_parser"
> [   10.853835] type=1400 audit(1345754384.624:3): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=416 comm="apparmor_parser"
> [   10.854231] type=1400 audit(1345754384.624:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=416 comm="apparmor_parser"
> [   10.854452] type=1400 audit(1345754384.624:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=416 comm="apparmor_parser"
> [   10.880671] fbcon: inteldrmfb (fb0) is primary device
> [   10.892584] type=1400 audit(1345754384.664:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=546 comm="apparmor_parser"
> [   10.893108] type=1400 audit(1345754384.664:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=546 comm="apparmor_parser"
> [   10.963001] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [   10.963001] cfg80211: World regulatory domain updated:
> [   10.963002] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   10.963004] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   10.963005] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   10.963006] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   10.963006] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   10.963007] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   10.972493] type=1400 audit(1345754384.744:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=612 comm="apparmor_parser"
> [   10.972950] type=1400 audit(1345754384.744:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=612 comm="apparmor_parser"
> [   11.024868] type=1400 audit(1345754384.796:10): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=618 comm="apparmor_parser"
> [   11.056554] Console: switching to colour frame buffer device 170x48
> [   11.059061] fb0: inteldrmfb frame buffer device
> [   11.059063] drm: registered panic notifier
> [   11.061286] acpi device:33: registered as cooling_device9
> [   11.061438] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [   11.061484] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
> [   11.061698] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [   11.061820] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [   11.233862] type=1400 audit(1345754385.004:11): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=417 comm="apparmor_parser"
> [   11.732283] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [   11.732362] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [   11.732424] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [   12.712707] Adding 262140k swap on /host/ubuntu/disks/swap.disk.  Priority:0 extents:1 across:262140k 
> [   12.713045] tty_init_dev: 26 callbacks suppressed
> [   16.536281] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   16.542923] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   16.839795] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   16.846469] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   16.954155] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   17.506092] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [   23.575772] wlan0: authenticate with 00:04:0e:e4:00:3d
> [   23.584532] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [   23.586352] wlan0: authenticated
> [   23.586573] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [   23.586578] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [   23.587510] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [   23.591205] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [   23.597217] wlan0: associated
> [   23.599511] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   45.462259] usb 2-1.5: USB disconnect, device number 4
> [   48.508961] tty_init_dev: 44 callbacks suppressed
> [   50.006392] audit_printk_skb: 21 callbacks suppressed
> [   50.006396] type=1400 audit(1345747223.732:19): apparmor="DENIED" operation="open" parent=1 profile="/usr/lib/telepathy/mission-control-5" name="/run/user/wearefam/dconf/user" pid=1735 comm="mission-control" requested_mask="rwc" denied_mask="rwc" fsuid=1000 ouid=1000
> [  100.862287] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  100.899205] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  100.899219] cfg80211: Restoring regulatory settings
> [  100.899229] cfg80211: Calling CRDA to update world regulatory domain
> [  100.905056] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  100.905060] cfg80211: World regulatory domain updated:
> [  100.905062] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  100.905064] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  100.905067] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  100.905069] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  100.905071] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  100.905072] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  103.988283] PM: Syncing filesystems ... done.
> [  104.395071] PM: Preparing system for mem sleep
> [  104.666039] Freezing user space processes ... 
> [  124.668059] Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze, wq_busy=0):
> [  124.668090] aptd            D ffffffff8180cbc0     0  2112      1 0x00000004
> [  124.668094]  ffff88004ad5fdd8 0000000000000082 ffff88004ad5fd78 0000000300000001
> [  124.668097]  ffff880062965b40 ffff88004ad5ffd8 ffff88004ad5ffd8 ffff88004ad5ffd8
> [  124.668100]  ffff88011ab2ada0 ffff880062965b40 ffff88004ad5fde8 ffff88011a50c800
> [  124.668102] Call Trace:
> [  124.668110]  [<ffffffff816344b9>] schedule+0x29/0x70
> [  124.668125]  [<ffffffffa0051b65>] jbd2_log_wait_commit+0xb5/0x130 [jbd2]
> [  124.668128]  [<ffffffff8107cbd0>] ? add_wait_queue+0x60/0x60
> [  124.668138]  [<ffffffffa006fff5>] ext4_sync_file+0x205/0x3d0 [ext4]
> [  124.668141]  [<ffffffff81184a89>] ? __fput+0x189/0x240
> [  124.668144]  [<ffffffff811b23fb>] vfs_fsync+0x2b/0x40
> [  124.668147]  [<ffffffff8115b634>] sys_msync+0x144/0x1d0
> [  124.668150]  [<ffffffff8163dd99>] system_call_fastpath+0x16/0x1b
> [  124.668152] 
> [  124.668153] Restarting tasks ... done.
> [  124.675493] video LNXVIDEO:00: Restoring backlight state
> [  125.469517] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  125.476252] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  125.591942] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  125.874450] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  131.944349] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  131.950524] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  131.952257] wlan0: authenticated
> [  131.952420] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  131.952424] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  131.954756] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  131.958413] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  131.964221] wlan0: associated
> [  131.966773] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  159.803143] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  159.813086] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  159.813099] cfg80211: Restoring regulatory settings
> [  159.813109] cfg80211: Calling CRDA to update world regulatory domain
> [  159.823533] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  159.823543] cfg80211: World regulatory domain updated:
> [  159.823547] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  159.823554] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  159.823560] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  159.823565] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  159.823570] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  159.823576] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  161.836996] PM: Syncing filesystems ... done.
> [  161.838825] PM: Preparing system for mem sleep
> [  162.175275] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  162.191145] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  162.207116] PM: Entering mem sleep
> [  162.207185] Suspending console(s) (use no_console_suspend to debug)
> [  162.207389] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  162.207412] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  162.207540] sd 0:0:0:0: [sda] Stopping disk
> [  162.210548] sd 1:0:0:0: [sdb] Stopping disk
> [  163.270409] PM: suspend of devices complete after 1063.871 msecs
> [  163.270411] PM: suspend devices took 1.064 seconds
> [  163.270502] PM: late suspend of devices complete after 0.090 msecs
> [  163.286385] r8169 0000:02:00.0: wake-up capability enabled by ACPI
> [  163.366255] PM: noirq suspend of devices complete after 95.816 msecs
> [  163.366535] ACPI: Preparing to enter system sleep state S3
> [  163.390327] PM: Saving platform NVS memory
> [  163.395508] Disabling non-boot CPUs ...
> [  163.498080] smpboot: CPU 1 is now offline
> [  163.602010] smpboot: CPU 2 is now offline
> [  163.705931] smpboot: CPU 3 is now offline
> [  163.706298] Extended CMOS year: 2000
> [  163.707559] ACPI: Low-level resume complete
> [  163.707605] PM: Restoring platform NVS memory
> [  163.708804] Extended CMOS year: 2000
> [  163.708870] Enabling non-boot CPUs ...
> [  163.708942] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [  163.719944] Disabled fast string operations
> [  163.722441] CPU1 is up
> [  163.722519] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [  163.733555] Disabled fast string operations
> [  163.736046] CPU2 is up
> [  163.736105] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  163.747139] Disabled fast string operations
> [  163.749664] CPU3 is up
> [  163.754426] ACPI: Waking up from system sleep state S3
> [  163.944498] PM: noirq resume of devices complete after 144.084 msecs
> [  163.944599] PM: early resume of devices complete after 0.062 msecs
> [  163.944631] i915 0000:00:02.0: setting latency timer to 64
> [  163.944654] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [  163.944703] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [  163.944768] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [  163.944770] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [  163.944854] ahci 0000:00:1f.2: setting latency timer to 64
> [  163.944859] r8169 0000:02:00.0: wake-up capability disabled by ACPI
> [  163.944950] usb usb3: root hub lost power or was reset
> [  163.944952] usb usb4: root hub lost power or was reset
> [  163.945035] iwlwifi 0000:01:00.0: RF_KILL bit toggled to enable radio.
> [  163.949161] mei 0000:00:16.0: wd: failed to find the client
> [  163.949644] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [  163.949654] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [  163.949662] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [  163.949669] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [  163.949676] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [  164.004481] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [  164.288149] ata5: SATA link down (SStatus 0 SControl 300)
> [  164.296131] ata4: SATA link down (SStatus 0 SControl 300)
> [  164.304144] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  164.308270] ata2.00: configured for UDMA/133
> [  164.324192] sd 1:0:0:0: [sdb] Starting disk
> [  164.388224] usb 2-1.4: reset low-speed USB device number 3 using ehci_hcd
> [  164.739948] usb 1-1.4: reset high-speed USB device number 3 using ehci_hcd
> [  166.358661] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  166.361061] ata1.00: configured for UDMA/133
> [  166.374771] sd 0:0:0:0: [sda] Starting disk
> [  166.401777] PM: resume of devices complete after 2458.915 msecs
> [  166.401853] PM: resume devices took 2.456 seconds
> [  166.401885] PM: Finishing wakeup.
> [  166.401886] Restarting tasks ... done.
> [  166.408199] video LNXVIDEO:00: Restoring backlight state
> [  167.165873] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  167.172613] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  167.291448] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  167.452873] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  173.523237] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  173.532349] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  173.534078] wlan0: authenticated
> [  173.534394] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  173.534402] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  173.537533] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  173.541217] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  173.544873] wlan0: associated
> [  173.545516] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  211.933017] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  211.949174] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  211.949184] cfg80211: Restoring regulatory settings
> [  211.949193] cfg80211: Calling CRDA to update world regulatory domain
> [  211.958130] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  211.958140] cfg80211: World regulatory domain updated:
> [  211.958144] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  211.958150] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  211.958155] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  211.958160] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  211.958164] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  211.958169] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  213.843778] PM: Syncing filesystems ... done.
> [  213.846441] PM: Preparing system for mem sleep
> [  214.157215] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  214.173317] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  214.189366] PM: Entering mem sleep
> [  214.189431] Suspending console(s) (use no_console_suspend to debug)
> [  214.189667] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  214.189707] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  214.189893] sd 0:0:0:0: [sda] Stopping disk
> [  214.192874] sd 1:0:0:0: [sdb] Stopping disk
> [  214.800628] PM: suspend of devices complete after 611.841 msecs
> [  214.800630] PM: suspend devices took 0.612 seconds
> [  214.800734] PM: late suspend of devices complete after 0.102 msecs
> [  214.816562] r8169 0000:02:00.0: wake-up capability enabled by ACPI
> [  214.896395] PM: noirq suspend of devices complete after 95.772 msecs
> [  214.896675] ACPI: Preparing to enter system sleep state S3
> [  214.920449] PM: Saving platform NVS memory
> [  214.925754] Disabling non-boot CPUs ...
> [  215.028151] smpboot: CPU 1 is now offline
> [  215.132031] smpboot: CPU 2 is now offline
> [  215.235899] smpboot: CPU 3 is now offline
> [  215.236242] Extended CMOS year: 2000
> [  215.237479] ACPI: Low-level resume complete
> [  215.237525] PM: Restoring platform NVS memory
> [  215.238739] Extended CMOS year: 2000
> [  215.238803] Enabling non-boot CPUs ...
> [  215.238876] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [  215.249985] Disabled fast string operations
> [  215.252492] CPU1 is up
> [  215.252560] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [  215.263596] Disabled fast string operations
> [  215.266098] CPU2 is up
> [  215.266157] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  215.277192] Disabled fast string operations
> [  215.279722] CPU3 is up
> [  215.284535] ACPI: Waking up from system sleep state S3
> [  215.474340] PM: noirq resume of devices complete after 144.087 msecs
> [  215.474442] PM: early resume of devices complete after 0.062 msecs
> [  215.474476] i915 0000:00:02.0: setting latency timer to 64
> [  215.474522] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [  215.474606] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [  215.474645] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [  215.474647] ahci 0000:00:1f.2: setting latency timer to 64
> [  215.474724] r8169 0000:02:00.0: wake-up capability disabled by ACPI
> [  215.474812] usb usb3: root hub lost power or was reset
> [  215.474814] usb usb4: root hub lost power or was reset
> [  215.474844] iwlwifi 0000:01:00.0: RF_KILL bit toggled to enable radio.
> [  215.474915] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [  215.479742] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [  215.479752] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [  215.479762] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [  215.479771] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [  215.479780] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [  215.479926] mei 0000:00:16.0: wd: failed to find the client
> [  215.530951] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [  215.817804] ata4: SATA link down (SStatus 0 SControl 300)
> [  215.817837] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  215.822198] ata2.00: configured for UDMA/133
> [  215.833838] ata5: SATA link down (SStatus 0 SControl 300)
> [  215.837883] sd 1:0:0:0: [sdb] Starting disk
> [  215.913826] usb 2-1.4: reset low-speed USB device number 3 using ehci_hcd
> [  216.265490] usb 1-1.4: reset high-speed USB device number 3 using ehci_hcd
> [  217.895303] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  217.897742] ata1.00: configured for UDMA/133
> [  217.911388] sd 0:0:0:0: [sda] Starting disk
> [  217.929917] PM: resume of devices complete after 2458.441 msecs
> [  217.929993] PM: resume devices took 2.456 seconds
> [  217.930025] PM: Finishing wakeup.
> [  217.930027] Restarting tasks ... done.
> [  217.936346] video LNXVIDEO:00: Restoring backlight state
> [  218.553235] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  218.560452] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  218.677269] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  218.934969] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  225.005368] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  225.014012] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  225.015745] wlan0: authenticated
> [  225.015992] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  225.015999] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  225.018647] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  225.022164] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  225.028964] wlan0: associated
> [  225.030604] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  251.908212] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  251.926535] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  251.926549] cfg80211: Restoring regulatory settings
> [  251.926561] cfg80211: Calling CRDA to update world regulatory domain
> [  251.936918] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  251.936926] cfg80211: World regulatory domain updated:
> [  251.936929] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  251.936934] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  251.936938] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  251.936941] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  251.936944] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  251.936947] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  253.675108] PM: Syncing filesystems ... done.
> [  253.677730] PM: Preparing system for mem sleep
> [  253.917246] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  253.933980] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  253.950051] PM: Entering mem sleep
> [  253.950115] Suspending console(s) (use no_console_suspend to debug)
> [  253.950332] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  253.950366] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  253.950554] sd 0:0:0:0: [sda] Stopping disk
> [  253.953363] sd 1:0:0:0: [sdb] Stopping disk
> [  254.553888] PM: suspend of devices complete after 603.801 msecs
> [  254.553890] PM: suspend devices took 0.604 seconds
> [  254.553981] PM: late suspend of devices complete after 0.090 msecs
> [  254.569869] r8169 0000:02:00.0: wake-up capability enabled by ACPI
> [  254.649795] PM: noirq suspend of devices complete after 95.832 msecs
> [  254.650061] ACPI: Preparing to enter system sleep state S3
> [  254.673871] PM: Saving platform NVS memory
> [  254.679216] Disabling non-boot CPUs ...
> [  254.781699] smpboot: CPU 1 is now offline
> [  254.885659] smpboot: CPU 2 is now offline
> [  254.989634] smpboot: CPU 3 is now offline
> [  254.989960] Extended CMOS year: 2000
> [  254.991197] ACPI: Low-level resume complete
> [  254.991243] PM: Restoring platform NVS memory
> [  254.992449] Extended CMOS year: 2000
> [  254.992514] Enabling non-boot CPUs ...
> [  254.992586] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [  255.003682] Disabled fast string operations
> [  255.006174] CPU1 is up
> [  255.006255] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [  255.017291] Disabled fast string operations
> [  255.019756] CPU2 is up
> [  255.019818] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  255.030852] Disabled fast string operations
> [  255.033347] CPU3 is up
> [  255.038154] ACPI: Waking up from system sleep state S3
> [  255.228299] PM: noirq resume of devices complete after 144.064 msecs
> [  255.228406] PM: early resume of devices complete after 0.067 msecs
> [  255.228448] i915 0000:00:02.0: setting latency timer to 64
> [  255.228460] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [  255.228517] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [  255.228555] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [  255.228597] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [  255.228610] ahci 0000:00:1f.2: setting latency timer to 64
> [  255.228682] r8169 0000:02:00.0: wake-up capability disabled by ACPI
> [  255.228761] iwlwifi 0000:01:00.0: RF_KILL bit toggled to enable radio.
> [  255.228775] usb usb3: root hub lost power or was reset
> [  255.228777] usb usb4: root hub lost power or was reset
> [  255.232660] mei 0000:00:16.0: wd: failed to find the client
> [  255.233447] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [  255.233454] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [  255.233460] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [  255.233468] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [  255.233474] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [  255.288320] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [  255.572095] ata4: SATA link down (SStatus 0 SControl 300)
> [  255.580105] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  255.584367] ata2.00: configured for UDMA/133
> [  255.588111] ata5: SATA link down (SStatus 0 SControl 300)
> [  255.600213] sd 1:0:0:0: [sdb] Starting disk
> [  255.672237] usb 2-1.4: reset low-speed USB device number 3 using ehci_hcd
> [  256.024239] usb 1-1.4: reset high-speed USB device number 3 using ehci_hcd
> [  257.635652] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  257.638071] ata1.00: configured for UDMA/133
> [  257.651791] sd 0:0:0:0: [sda] Starting disk
> [  257.673402] PM: resume of devices complete after 2445.502 msecs
> [  257.673479] PM: resume devices took 2.444 seconds
> [  257.673511] PM: Finishing wakeup.
> [  257.673512] Restarting tasks ... done.
> [  257.681351] video LNXVIDEO:00: Restoring backlight state
> [  258.457600] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  258.464412] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  258.584056] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  258.800118] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  264.870731] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  264.879642] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  264.881358] wlan0: authenticated
> [  264.881653] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  264.881664] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  264.882143] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  264.886218] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  264.891884] wlan0: associated
> [  264.894144] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  317.109324] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  317.118379] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  317.118390] cfg80211: Restoring regulatory settings
> [  317.118398] cfg80211: Calling CRDA to update world regulatory domain
> [  317.128426] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  317.128433] cfg80211: World regulatory domain updated:
> [  317.128436] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  317.128441] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  317.128445] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  317.128449] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  317.128452] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  317.128455] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  319.043004] PM: Syncing filesystems ... done.
> [  319.045301] PM: Preparing system for mem sleep
> [  319.382247] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  319.398926] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  319.414929] PM: Entering mem sleep
> [  319.414997] Suspending console(s) (use no_console_suspend to debug)
> [  319.415215] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  319.415236] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  319.418243] sd 1:0:0:0: [sdb] Stopping disk
> [  319.426684] sd 0:0:0:0: [sda] Stopping disk
> [  320.038751] PM: suspend of devices complete after 623.786 msecs
> [  320.038753] PM: suspend devices took 0.624 seconds
> [  320.038846] PM: late suspend of devices complete after 0.091 msecs
> [  320.054731] r8169 0000:02:00.0: wake-up capability enabled by ACPI
> [  320.134654] PM: noirq suspend of devices complete after 95.826 msecs
> [  320.134920] ACPI: Preparing to enter system sleep state S3
> [  320.158730] PM: Saving platform NVS memory
> [  320.163973] Disabling non-boot CPUs ...
> [  320.266540] smpboot: CPU 1 is now offline
> [  320.370519] smpboot: CPU 2 is now offline
> [  320.474495] smpboot: CPU 3 is now offline
> [  320.474844] Extended CMOS year: 2000
> [  320.476084] ACPI: Low-level resume complete
> [  320.476131] PM: Restoring platform NVS memory
> [  320.477343] Extended CMOS year: 2000
> [  320.477408] Enabling non-boot CPUs ...
> [  320.477480] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [  320.488583] Disabled fast string operations
> [  320.491078] CPU1 is up
> [  320.491147] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [  320.502183] Disabled fast string operations
> [  320.504659] CPU2 is up
> [  320.504719] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  320.515753] Disabled fast string operations
> [  320.518284] CPU3 is up
> [  320.523090] ACPI: Waking up from system sleep state S3
> [  320.713167] PM: noirq resume of devices complete after 144.081 msecs
> [  320.713269] PM: early resume of devices complete after 0.062 msecs
> [  320.713299] i915 0000:00:02.0: setting latency timer to 64
> [  320.713319] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [  320.713378] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [  320.713412] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [  320.713453] ahci 0000:00:1f.2: setting latency timer to 64
> [  320.713529] r8169 0000:02:00.0: wake-up capability disabled by ACPI
> [  320.713590] usb usb3: root hub lost power or was reset
> [  320.713592] usb usb4: root hub lost power or was reset
> [  320.713623] iwlwifi 0000:01:00.0: RF_KILL bit toggled to enable radio.
> [  320.713633] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [  320.718308] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [  320.718315] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [  320.718322] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [  320.718328] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [  320.718335] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [  320.719161] mei 0000:00:16.0: wd: failed to find the client
> [  320.770041] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [  321.048985] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  321.053304] ata2.00: configured for UDMA/133
> [  321.064999] ata4: SATA link down (SStatus 0 SControl 300)
> [  321.069077] sd 1:0:0:0: [sdb] Starting disk
> [  321.072999] ata5: SATA link down (SStatus 0 SControl 300)
> [  321.153055] usb 2-1.4: reset low-speed USB device number 3 using ehci_hcd
> [  321.504935] usb 1-1.4: reset high-speed USB device number 3 using ehci_hcd
> [  323.128510] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  323.130954] ata1.00: configured for UDMA/133
> [  323.144660] sd 0:0:0:0: [sda] Starting disk
> [  323.173569] PM: resume of devices complete after 2460.809 msecs
> [  323.173646] PM: resume devices took 2.460 seconds
> [  323.173678] PM: Finishing wakeup.
> [  323.173679] Restarting tasks ... done.
> [  323.183104] video LNXVIDEO:00: Restoring backlight state
> [  323.921285] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  323.927952] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  324.044451] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  324.235343] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  330.306033] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  330.315090] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  330.316838] wlan0: authenticated
> [  330.317181] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  330.317193] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  330.319002] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  330.322719] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  330.328542] wlan0: associated
> [  330.330993] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  422.788545] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  422.801505] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  422.801516] cfg80211: Restoring regulatory settings
> [  422.801526] cfg80211: Calling CRDA to update world regulatory domain
> [  422.811957] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  422.811966] cfg80211: World regulatory domain updated:
> [  422.811971] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  422.811978] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  422.811983] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  422.811988] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  422.811994] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  422.811999] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  424.621348] PM: Syncing filesystems ... done.
> [  424.623617] PM: Preparing system for mem sleep
> [  424.983256] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  424.996278] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  425.012343] PM: Entering mem sleep
> [  425.012425] Suspending console(s) (use no_console_suspend to debug)
> [  425.012654] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  425.012675] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  425.012877] sd 0:0:0:0: [sda] Stopping disk
> [  425.015688] sd 1:0:0:0: [sdb] Stopping disk
> [  425.615604] PM: suspend of devices complete after 603.801 msecs
> [  425.615606] PM: suspend devices took 0.604 seconds
> [  425.615711] PM: late suspend of devices complete after 0.104 msecs
> [  425.631544] r8169 0000:02:00.0: wake-up capability enabled by ACPI
> [  425.711382] PM: noirq suspend of devices complete after 95.768 msecs
> [  425.711648] ACPI: Preparing to enter system sleep state S3
> [  425.735424] PM: Saving platform NVS memory
> [  425.740676] Disabling non-boot CPUs ...
> [  425.843121] smpboot: CPU 1 is now offline
> [  425.947001] smpboot: CPU 2 is now offline
> [  426.050868] smpboot: CPU 3 is now offline
> [  426.051216] Extended CMOS year: 2000
> [  426.052455] ACPI: Low-level resume complete
> [  426.052502] PM: Restoring platform NVS memory
> [  426.053716] Extended CMOS year: 2000
> [  426.053780] Enabling non-boot CPUs ...
> [  426.053852] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [  426.064856] Disabled fast string operations
> [  426.067366] CPU1 is up
> [  426.067432] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [  426.078468] Disabled fast string operations
> [  426.080965] CPU2 is up
> [  426.081022] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  426.092056] Disabled fast string operations
> [  426.094539] CPU3 is up
> [  426.099345] ACPI: Waking up from system sleep state S3
> [  426.289321] PM: noirq resume of devices complete after 144.076 msecs
> [  426.289447] PM: early resume of devices complete after 0.062 msecs
> [  426.289479] i915 0000:00:02.0: setting latency timer to 64
> [  426.289530] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [  426.289579] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [  426.289616] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [  426.289645] ahci 0000:00:1f.2: setting latency timer to 64
> [  426.289780] usb usb3: root hub lost power or was reset
> [  426.289783] r8169 0000:02:00.0: wake-up capability disabled by ACPI
> [  426.289784] usb usb4: root hub lost power or was reset
> [  426.289920] iwlwifi 0000:01:00.0: RF_KILL bit toggled to enable radio.
> [  426.289951] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [  426.294550] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [  426.294559] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [  426.294567] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [  426.294573] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [  426.294580] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [  426.295973] mei 0000:00:16.0: wd: failed to find the client
> [  426.346185] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [  426.624809] ata5: SATA link down (SStatus 0 SControl 300)
> [  426.636778] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  426.640744] ata4: SATA link down (SStatus 0 SControl 300)
> [  426.640998] ata2.00: configured for UDMA/133
> [  426.656843] sd 1:0:0:0: [sdb] Starting disk
> [  426.728861] usb 2-1.4: reset low-speed USB device number 3 using ehci_hcd
> [  427.080357] usb 1-1.4: reset high-speed USB device number 3 using ehci_hcd
> [  428.714274] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  428.716692] ata1.00: configured for UDMA/133
> [  428.730365] sd 0:0:0:0: [sda] Starting disk
> [  428.752606] PM: resume of devices complete after 2466.133 msecs
> [  428.752682] PM: resume devices took 2.464 seconds
> [  428.752714] PM: Finishing wakeup.
> [  428.752715] Restarting tasks ... done.
> [  428.760978] video LNXVIDEO:00: Restoring backlight state
> [  429.443457] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  429.450429] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  429.567698] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  429.806512] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  435.877094] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  435.886109] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  435.887971] wlan0: authenticated
> [  435.888278] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  435.888289] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  435.889560] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  435.893238] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  435.899356] wlan0: associated
> [  435.901520] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  537.359055] wlan0: deauthenticating from 00:04:0e:e4:00:3d by local choice (reason=3)
> [  537.373733] cfg80211: All devices are disconnected, going to restore regulatory settings
> [  537.373747] cfg80211: Restoring regulatory settings
> [  537.373760] cfg80211: Calling CRDA to update world regulatory domain
> [  537.384328] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [  537.384337] cfg80211: World regulatory domain updated:
> [  537.384342] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [  537.384349] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  537.384355] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  537.384361] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [  537.384366] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  537.384371] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [  539.281822] PM: Syncing filesystems ... done.
> [  539.285133] PM: Preparing system for mem sleep
> [  539.616709] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  539.632188] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  539.648246] PM: Entering mem sleep
> [  539.648311] Suspending console(s) (use no_console_suspend to debug)
> [  539.648522] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> [  539.648552] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  539.648745] sd 0:0:0:0: [sda] Stopping disk
> [  539.651585] sd 1:0:0:0: [sdb] Stopping disk
> [  540.255559] PM: suspend of devices complete after 607.884 msecs
> [  540.255574] PM: suspend devices took 0.608 seconds
> [  540.255664] PM: late suspend of devices complete after 0.089 msecs
> [  540.271449] r8169 0000:02:00.0: wake-up capability enabled by ACPI
> [  540.351296] PM: noirq suspend of devices complete after 95.730 msecs
> [  540.351561] ACPI: Preparing to enter system sleep state S3
> [  540.375335] PM: Saving platform NVS memory
> [  540.380513] Disabling non-boot CPUs ...
> [  540.381840] smpboot: CPU 1 is now offline
> [  540.383671] smpboot: CPU 2 is now offline
> [  540.385198] smpboot: CPU 3 is now offline
> [  540.385525] Extended CMOS year: 2000
> [  540.386763] ACPI: Low-level resume complete
> [  540.386809] PM: Restoring platform NVS memory
> [  540.388026] Extended CMOS year: 2000
> [  540.388090] Enabling non-boot CPUs ...
> [  540.388165] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [  540.399260] Disabled fast string operations
> [  540.401770] CPU1 is up
> [  540.401835] smpboot: Booting Node 0 Processor 2 APIC 0x2
> [  540.412872] Disabled fast string operations
> [  540.415369] CPU2 is up
> [  540.415440] smpboot: Booting Node 0 Processor 3 APIC 0x3
> [  540.426569] Disabled fast string operations
> [  540.429117] CPU3 is up
> [  540.433901] ACPI: Waking up from system sleep state S3
> [  540.625594] PM: noirq resume of devices complete after 144.085 msecs
> [  540.625696] PM: early resume of devices complete after 0.062 msecs
> [  540.625727] i915 0000:00:02.0: setting latency timer to 64
> [  540.625749] ehci_hcd 0000:00:1a.0: setting latency timer to 64
> [  540.625800] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [  540.625859] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [  540.625866] ehci_hcd 0000:00:1d.0: setting latency timer to 64
> [  540.625870] ahci 0000:00:1f.2: setting latency timer to 64
> [  540.625950] r8169 0000:02:00.0: wake-up capability disabled by ACPI
> [  540.625996] usb usb3: root hub lost power or was reset
> [  540.625998] usb usb4: root hub lost power or was reset
> [  540.626101] iwlwifi 0000:01:00.0: RF_KILL bit toggled to enable radio.
> [  540.626667] mei 0000:00:16.0: wd: failed to find the client
> [  540.630719] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [  540.630725] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [  540.630731] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [  540.630736] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [  540.630741] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [  540.685581] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [  540.961070] ata4: SATA link down (SStatus 0 SControl 300)
> [  540.977049] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  540.981381] ata2.00: configured for UDMA/133
> [  540.985042] ata5: SATA link down (SStatus 0 SControl 300)
> [  540.997097] sd 1:0:0:0: [sdb] Starting disk
> [  541.069093] usb 2-1.4: reset low-speed USB device number 3 using ehci_hcd
> [  541.420714] usb 1-1.4: reset high-speed USB device number 3 using ehci_hcd
> [  543.038576] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  543.041008] ata1.00: configured for UDMA/133
> [  543.054651] sd 0:0:0:0: [sda] Starting disk
> [  543.075045] PM: resume of devices complete after 2452.307 msecs
> [  543.075120] PM: resume devices took 2.452 seconds
> [  543.075152] PM: Finishing wakeup.
> [  543.075153] Restarting tasks ... done.
> [  543.081026] video LNXVIDEO:00: Restoring backlight state
> [  543.736207] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  543.743232] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [  543.859559] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  544.011104] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
> [  550.184250] wlan0: authenticate with 00:04:0e:e4:00:3d
> [  550.191659] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [  550.193544] wlan0: authenticated
> [  550.193917] iwlwifi 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not supported by the AP
> [  550.193929] iwlwifi 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [  550.197849] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [  550.202647] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=2)
> [  550.210257] wlan0: associated
> [  550.213805] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

