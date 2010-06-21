Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab0FUUp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:45:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422Ab0FUUp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:45:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jerome Glisse <glisse@freedesktop.org>
Subject: Re: [PATCH] DRM / radeon / PM: Do not evict VRAM during freeze phase of hibernation
Date: Mon, 21 Jun 2010 22:44:09 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <201006182221.57333.rjw@sisk.pl> <201006200143.06059.rjw@sisk.pl> <20100621075741.GB2350@barney.localdomain>
In-Reply-To: <20100621075741.GB2350@barney.localdomain>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Z88HMEqBdWrtKqn"
Message-Id: <201006212244.09466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Z88HMEqBdWrtKqn
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Monday, June 21, 2010, Jerome Glisse wrote:
> On Sun, Jun 20, 2010 at 01:43:05AM +0200, Rafael J. Wysocki wrote:
> > On Saturday, June 19, 2010, Rafael J. Wysocki wrote:
> > > On Saturday, June 19, 2010, Dave Airlie wrote:
> > > > On Sat, 2010-06-19 at 01:23 +0200, Rafael J. Wysocki wrote:
> > > > > On Friday, June 18, 2010, Dave Airlie wrote:
> > > > > > On Fri, 2010-06-18 at 22:21 +0200, Rafael J. Wysocki wrote:
> > > > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > > 
> > > > > > > I have recently noticed a 55 sec. delay during the "device freeze"
> > > > > > > phase of hibernation on my test-bed HP nx6325.  Due to the 100%
> > > > > > > reproducibility of it I was able to narrow it down to
> > > > > > > radeon_suspend_kms() and then it turned out that the delay occured
> > > > > > > somewhere in radeon_bo_evict_vram().  However, it doesn't seem really
> > > > > > > necessary or even very useful to me to evict VRAM at this particular
> > > > > > > point, because we're going to create an image and bring the device
> > > > > > > back to the fully functional state in a little while.  Thus, I think
> > > > > > > the VRAM evicition can be skipped for state.event == PM_EVENT_FREEZE,
> > > > > > > which makes the delay go away.
> > > > > > 
> > > > > > I'm not 100% sure of the hibernate sequencing and its early in the
> > > > > > morning, but we want to evict VRAM before image building so we can have
> > > > > > the contents of VRAM in the image so we can restore them on resume. Does
> > > > > > this just avoid evicting them a second time after we created the image?
> > > > > 
> > > > > No, it's the first time, before creating the image, but I didn't seen any
> > > > > difference on resume with and without the patch, so I thought it was a good
> > > > > idea. :-)
> > > > 
> > > > On the machine you have its most likely not going to show up unless you
> > > > are running a 3D app or something across suspend, since currently X
> > > > re-exposes most apps on VT switch, so they just redraw.
> > > 
> > > Yes.  Moreover, hibernation is always done after a VT switch.  That's why
> > > I said I thought the eviction wasn't necessary in the changelog.
> > > 
> > > BTW, I have three different test boxes with radeon hardware and the
> > > $subject patch is not a problem on any of them.
> > > 
> > > > Was it always this slow?
> > > 
> > > Nope.  It definitely is a regression, although I'm not sure what's the last
> > > good kernel.
> > > 
> > > > you can see how many objects are in vram using
> > > > debugfs (/sys/kernel/debug/dri/0/radeon_vram_mm), it sounds like the TTM
> > > > eviction process is blocking on something,
> > 
> > I did some more debug work (the _total_ lack of comments inside of the
> > relevant radeon and ttm code makes this a next-to-impossible task, though)
> > and found that all of the delays (up to 5 seconds) happen inside of
> > ttm_bo_move_accel_cleanup() called from radeon_move_blit(), where the "new"
> > memory type is TTL_PL_TT and the "old" one is TTL_PL_VRAM.  The preceding
> > radeon_copy() always returns 0.
> > 
> > Please let me know if you need more information.
> > 
> > Thanks,
> > Rafael
> 
> Can you confirm that this is trigger by first radeon_bo_evict_vram in
> radeon_suspend_kms() ?

Not really.

I used the attached debug patch and I got the attached dmesg output from
a "core" hibernate test.

It looks like the first one is relatively sane (71 usecs), but things get worse
going forward.

> Also can you check if irq is enabled (put some
> debug in the irq handler of your gpu). My guess is that irq are stop
> (likely stop before radeon suspend callback)

No, interrupts are not switched off at this point yet.  At least not
permanently.

> and that we endup waiting that the fence timeout expire in radeon_fence_wait().

I guess something like this happens, although I'm not sure about the root
cause.

It looks like it interferes with something happening in parallel with it.
I wonder, however, why it is a problem for hibernation and it's not a problem
for suspend to RAM and why the other machines are not affected.

Rafael

--Boundary-00=_Z88HMEqBdWrtKqn
Content-Type: text/x-patch;
  charset="UTF-8";
  name="drm-ttm-debug-list-cleaning.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="drm-ttm-debug-list-cleaning.patch"

---
 drivers/gpu/drm/radeon/radeon_ttm.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6/drivers/gpu/drm/radeon/radeon_ttm.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/radeon/radeon_ttm.c
+++ linux-2.6/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -240,6 +240,7 @@ static int radeon_move_blit(struct ttm_b
 	uint64_t old_start, new_start;
 	struct radeon_fence *fence;
 	int r;
+	ktime_t delta, calltime, rettime;
 
 	rdev = radeon_get_rdev(bo->bdev);
 	r = radeon_fence_create(rdev, &fence);
@@ -275,10 +276,29 @@ static int radeon_move_blit(struct ttm_b
 		DRM_ERROR("Trying to move memory with CP turned off.\n");
 		return -EINVAL;
 	}
+
+	calltime = ktime_get();
+	pr_info("%s: new type: %s, old type: %s\n", __func__,
+		new_mem->mem_type == TTM_PL_VRAM ? "vram" : "tt",
+		old_mem->mem_type == TTM_PL_VRAM ? "vram" : "tt");
+
 	r = radeon_copy(rdev, old_start, new_start, new_mem->num_pages, fence);
 	/* FIXME: handle copy error */
+
+	rettime = ktime_get();
+	delta = ktime_sub(rettime, calltime);
+	pr_info("radeon_copy: result: %d, elapsed %Ld usecs\n", r,
+		(unsigned long long)ktime_to_ns(delta) >> 10);
+	calltime = ktime_get();
+
 	r = ttm_bo_move_accel_cleanup(bo, (void *)fence, NULL,
 				      evict, no_wait_reserve, no_wait_gpu, new_mem);
+
+	rettime = ktime_get();
+	delta = ktime_sub(rettime, calltime);
+	pr_info("ttm_bo_move_accel_cleanup: result: %d, elapsed %Ld usecs\n", r,
+		(unsigned long long)ktime_to_ns(delta) >> 10);
+
 	radeon_fence_unref(&fence);
 	return r;
 }

--Boundary-00=_Z88HMEqBdWrtKqn
Content-Type: text/x-log;
  charset="UTF-8";
  name="nx6325-dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nx6325-dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.35-rc3+ (rafael@chimera) (gcc version 4.2.1 (SUSE Linux)) #34 SMP PREEMPT Sun Jun 20 01:38:09 CEST 2010
[    0.000000] Command line: root=/dev/sda3 resume=/dev/sda1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000077fd0000 - 0000000077fe5600 (reserved)
[    0.000000]  BIOS-e820: 0000000077fe5600 - 0000000077ff8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077ff8000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77fd0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C0FFF write-protect
[    0.000000]   C1000-C3FFF write-back
[    0.000000]   C4000-C4FFF write-protect
[    0.000000]   C5000-C7FFF write-back
[    0.000000]   C8000-C8FFF write-protect
[    0.000000]   C9000-CBFFF write-back
[    0.000000]   CC000-CCFFF write-protect
[    0.000000]   CD000-CFFFF write-back
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
[    0.000000]   2 base 0060000000 mask FFF0000000 write-back
[    0.000000]   3 base 0070000000 mask FFF8000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000077fd0000
[    0.000000]  0000000000 - 0077fd0000 page 4k
[    0.000000] kernel direct mapping tables up to 77fd0000 @ 100000-4c3000
[    0.000000] RAMDISK: 37556000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f7d30 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 0000000077fe57b4 00054 (v01 HP     0944     06070620 HP   00000001)
[    0.000000] ACPI: FACP 0000000077fe5684 000F4 (v04 HP     0944     00000003 HP   00000001)
[    0.000000] ACPI: DSDT 0000000077fe58dc 0EE7A (v01 HP        SB400 00010000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0000000077ff7e80 00040
[    0.000000] ACPI: APIC 0000000077fe5808 00062 (v01 HP     0944     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 0000000077fe586c 0003C (v01 HP     0944     00000001 HP   00000001)
[    0.000000] ACPI: TCPA 0000000077fe58a8 00032 (v02 HP     0944     00000001 HP   00000001)
[    0.000000] ACPI: SSDT 0000000077ff4756 00059 (v01 HP       HPQNLP 00000001 MSFT 0100000E)
[    0.000000] ACPI: SSDT 0000000077ff47af 00206 (v01 HP     PSSTBLID 00000001 HP   00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002600000-ffff8800041fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00077fd0
[    0.000000] On node 0 totalpages: 491374
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3942 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6664 pages used for memmap
[    0.000000]   DMA32 zone: 480712 pages, LIFO batch:31
[    0.000000] SB4X0 revision 0x82
[    0.000000] Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001e00000 s81408 r8192 d20992 u1048576
[    0.000000] pcpu-alloc: s81408 r8192 d20992 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 484654
[    0.000000] Kernel command line: root=/dev/sda3 resume=/dev/sda1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 308000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Subtract (44 early reservations)
[    0.000000]   #1 [0001000000 - 0001d339f8]   TEXT DATA BSS
[    0.000000]   #2 [0037556000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0001d34000 - 0001d3419c]             BRK
[    0.000000]   #5 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #6 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #7 [0000100000 - 00004c1000]         PGTABLE
[    0.000000]   #8 [0001d341c0 - 0001d351c0]         BOOTMEM
[    0.000000]   #9 [0001d33a00 - 0001d33b68]         BOOTMEM
[    0.000000]   #10 [0002536000 - 0002537000]         BOOTMEM
[    0.000000]   #11 [0002537000 - 0002538000]         BOOTMEM
[    0.000000]   #12 [0002600000 - 0004200000]        MEMMAP 0
[    0.000000]   #13 [0001d33b80 - 0001d33d00]         BOOTMEM
[    0.000000]   #14 [0001d351c0 - 0001d411c0]         BOOTMEM
[    0.000000]   #15 [0001d42000 - 0001d43000]         BOOTMEM
[    0.000000]   #16 [0001d33d00 - 0001d33d43]         BOOTMEM
[    0.000000]   #17 [0001d411c0 - 0001d41460]         BOOTMEM
[    0.000000]   #18 [0001d33d80 - 0001d33de8]         BOOTMEM
[    0.000000]   #19 [0001d33e00 - 0001d33e68]         BOOTMEM
[    0.000000]   #20 [0001d33e80 - 0001d33ee8]         BOOTMEM
[    0.000000]   #21 [0001d33f00 - 0001d33f68]         BOOTMEM
[    0.000000]   #22 [0001d33f80 - 0001d33fe8]         BOOTMEM
[    0.000000]   #23 [0001d41480 - 0001d414e8]         BOOTMEM
[    0.000000]   #24 [0001d41500 - 0001d41568]         BOOTMEM
[    0.000000]   #25 [0001d41580 - 0001d415e8]         BOOTMEM
[    0.000000]   #26 [0001d41600 - 0001d41668]         BOOTMEM
[    0.000000]   #27 [0001d41680 - 0001d416e8]         BOOTMEM
[    0.000000]   #28 [0001d41700 - 0001d41768]         BOOTMEM
[    0.000000]   #29 [0001d41780 - 0001d417a0]         BOOTMEM
[    0.000000]   #30 [0001d417c0 - 0001d417e0]         BOOTMEM
[    0.000000]   #31 [0001d41800 - 0001d41820]         BOOTMEM
[    0.000000]   #32 [0001e00000 - 0001e1b000]         BOOTMEM
[    0.000000]   #33 [0001f00000 - 0001f1b000]         BOOTMEM
[    0.000000]   #34 [0001d41840 - 0001d41848]         BOOTMEM
[    0.000000]   #35 [0001d41880 - 0001d41888]         BOOTMEM
[    0.000000]   #36 [0001d418c0 - 0001d418c8]         BOOTMEM
[    0.000000]   #37 [0001d41900 - 0001d41910]         BOOTMEM
[    0.000000]   #38 [0001d41940 - 0001d41a80]         BOOTMEM
[    0.000000]   #39 [0001d41a80 - 0001d41ae0]         BOOTMEM
[    0.000000]   #40 [0001d41b00 - 0001d41b60]         BOOTMEM
[    0.000000]   #41 [0001d43000 - 0001d4b000]         BOOTMEM
[    0.000000]   #42 [0001f1b000 - 000211b000]         BOOTMEM
[    0.000000]   #43 [000211b000 - 000221b000]         BOOTMEM
[    0.000000] Memory: 1905192k/1965888k available (3472k kernel code, 392k absent, 60304k reserved, 6184k data, 456k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] ODEBUG: 10 of 10 active objects replaced
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1994.930 MHz processor.
[    0.008006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.86 BogoMIPS (lpj=7979720)
[    0.008195] pid_max: default: 32768 minimum: 301
[    0.008322] Security Framework initialized
[    0.008429] Mount-cache hash table entries: 256
[    0.008743] tseg: 0000000000
[    0.008751] CPU: Physical Processor ID: 0
[    0.008849] CPU: Processor Core ID: 0
[    0.008943] mce: CPU supports 5 MCE banks
[    0.009048] using C1E aware idle routine
[    0.009142] Performance Events: AMD PMU driver.
[    0.009277] ... version:                0
[    0.009371] ... bit width:              48
[    0.009465] ... generic registers:      4
[    0.009559] ... value mask:             0000ffffffffffff
[    0.009654] ... max period:             00007fffffffffff
[    0.009748] ... fixed-purpose events:   0
[    0.009841] ... event mask:             000000000000000f
[    0.009965] ACPI: Core revision 20100428
[    0.028112] Setting APIC routing to flat
[    0.032474] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.071427] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
[    0.072000] System has AMD C1E enabled
[    0.072000] Switch to broadcast mode on CPU0
[    0.088035] Booting Node   0, Processors  #1 Ok.
[    0.012000] Switch to broadcast mode on CPU1
[    0.176072] Brought up 2 CPUs
[    0.176075] Total of 2 processors activated (7980.20 BogoMIPS).
[    0.176494] Time:  0:04:54  Date: 06/20/10
[    0.176494] NET: Registered protocol family 16
[    0.176494] node 0 link 0: io port [1000, fffff]
[    0.176494] TOM: 0000000080000000 aka 2048M
[    0.176494] node 0 link 0: mmio [f0000000, ffffffff]
[    0.176494] node 0 link 0: mmio [e0000000, efffffff]
[    0.176494] node 0 link 0: mmio [c8000000, dfffffff]
[    0.176494] node 0 link 0: mmio [c0000000, c7ffffff]
[    0.176494] node 0 link 0: mmio [a0000, bffff]
[    0.176494] node 0 link 0: mmio [80000000, bfffffff]
[    0.176494] bus: [00, ff] on node 0 link 0
[    0.176494] bus: 00 index 0 [io  0x0000-0xffff]
[    0.176494] bus: 00 index 1 [mem 0x80000000-0xfcffffffff]
[    0.176494] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.176494] ACPI: bus type pci registered
[    0.176494] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.176494] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.201030] PCI: Using configuration type 1 for base access
[    0.204120] bio: create slab <bio-0> at 0
[    0.205510] ACPI: EC: Look up EC in DSDT
[    0.240242] ACPI: Interpreter enabled
[    0.240345] ACPI: (supports S0 S3 S4 S5)
[    0.240619] ACPI: Using IOAPIC for interrupt routing
[    0.240912] [Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
[    0.260112] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.260268] ACPI: Power Resource [C223] (off)
[    0.260432] ACPI: Power Resource [C1FE] (off)
[    0.260577] ACPI: Power Resource [C217] (on)
[    0.260778] ACPI: Power Resource [C34B] (off)
[    0.260963] ACPI: Power Resource [C34C] (off)
[    0.261147] ACPI: Power Resource [C34D] (off)
[    0.261331] ACPI: Power Resource [C34E] (off)
[    0.261450] ACPI: No dock devices found.
[    0.261450] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.268242] ACPI: PCI Root Bridge [C074] (domain 0000 [bus 00-ff])
[    0.281011] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.281015] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.281019] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.281023] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfedfffff] (ignored)
[    0.281026] pci_root PNP0A03:00: host bridge window [mem 0xfee01000-0xffffffff] (ignored)
[    0.281030] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.281135] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.281140] pci 0000:00:04.0: PME# disabled
[    0.281178] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.281182] pci 0000:00:05.0: PME# disabled
[    0.281220] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.281224] pci 0000:00:06.0: PME# disabled
[    0.281291] pci 0000:00:12.0: reg 10: [io  0x9000-0x9007]
[    0.281301] pci 0000:00:12.0: reg 14: [io  0x9008-0x900b]
[    0.281310] pci 0000:00:12.0: reg 18: [io  0x9010-0x9017]
[    0.281319] pci 0000:00:12.0: reg 1c: [io  0x7018-0x701b]
[    0.281329] pci 0000:00:12.0: reg 20: [io  0x7020-0x702f]
[    0.281338] pci 0000:00:12.0: reg 24: [mem 0xd4409000-0xd44091ff]
[    0.281348] pci 0000:00:12.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.281383] pci 0000:00:12.0: supports D1 D2
[    0.281428] pci 0000:00:13.0: reg 10: [mem 0xd4401000-0xd4401fff]
[    0.281532] pci 0000:00:13.1: reg 10: [mem 0xd4402000-0xd4402fff]
[    0.281641] pci 0000:00:13.2: reg 10: [mem 0xd4403000-0xd4403fff]
[    0.281713] pci 0000:00:13.2: supports D1 D2
[    0.281716] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.281722] pci 0000:00:13.2: PME# disabled
[    0.281772] pci 0000:00:14.0: reg 10: [io  0x8200-0x820f]
[    0.281782] pci 0000:00:14.0: reg 14: [mem 0xd4404000-0xd44043ff]
[    0.281820] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.281975] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.281984] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.281994] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.282003] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.282012] pci 0000:00:14.1: reg 20: [io  0x7040-0x704f]
[    0.282104] pci 0000:00:14.2: reg 10: [mem 0xd4408000-0xd440bfff 64bit]
[    0.282169] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.282175] pci 0000:00:14.2: PME# disabled
[    0.282396] PCI: peer root bus 00 res updated from pci conf
[    0.282428] pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xc7ffffff pref]
[    0.282433] pci 0000:01:05.0: reg 14: [io  0x6000-0x60ff]
[    0.282438] pci 0000:01:05.0: reg 18: [mem 0xd4300000-0xd430ffff]
[    0.282448] pci 0000:01:05.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.282459] pci 0000:01:05.0: supports D1 D2
[    0.282475] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.282574] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    0.282578] pci 0000:00:01.0:   bridge window [mem 0xd4300000-0xd43fffff]
[    0.282583] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
[    0.282612] pci 0000:00:04.0: PCI bridge to [bus 10-10]
[    0.282710] pci 0000:00:04.0:   bridge window [io  0x4000-0x5fff]
[    0.282714] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd3ffffff]
[    0.282719] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.282747] pci 0000:00:05.0: PCI bridge to [bus 20-20]
[    0.282846] pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
[    0.282850] pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
[    0.282855] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.282911] pci 0000:30:00.0: reg 10: [mem 0xc8000000-0xc8003fff]
[    0.282980] pci 0000:30:00.0: supports D1 D2
[    0.282999] pci 0000:30:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.283156] pci 0000:00:06.0: PCI bridge to [bus 30-30]
[    0.283253] pci 0000:00:06.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.283257] pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
[    0.283262] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.283338] pci 0000:02:01.0: reg 10: [mem 0xd4000000-0xd400ffff]
[    0.283439] pci 0000:02:01.0: PME# supported from D3hot D3cold
[    0.283446] pci 0000:02:01.0: PME# disabled
[    0.283503] pci 0000:02:04.0: reg 10: [mem 0xd4010000-0xd4010fff]
[    0.283537] pci 0000:02:04.0: supports D1 D2
[    0.283540] pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.283547] pci 0000:02:04.0: PME# disabled
[    0.283597] pci 0000:02:04.1: reg 10: [mem 0xd4011000-0xd40117ff]
[    0.283609] pci 0000:02:04.1: reg 14: [mem 0xd4014000-0xd4017fff]
[    0.283683] pci 0000:02:04.1: supports D1 D2
[    0.283686] pci 0000:02:04.1: PME# supported from D0 D1 D2 D3hot
[    0.283693] pci 0000:02:04.1: PME# disabled
[    0.283742] pci 0000:02:04.2: reg 10: [mem 0xd4018000-0xd4018fff]
[    0.283823] pci 0000:02:04.2: supports D1 D2
[    0.283825] pci 0000:02:04.2: PME# supported from D0 D1 D2 D3hot
[    0.283832] pci 0000:02:04.2: PME# disabled
[    0.283881] pci 0000:02:04.3: reg 10: [mem 0xd4019000-0xd40190ff]
[    0.283960] pci 0000:02:04.3: supports D1 D2
[    0.283963] pci 0000:02:04.3: PME# supported from D0 D1 D2 D3hot
[    0.283970] pci 0000:02:04.3: PME# disabled
[    0.284052] pci 0000:00:14.4: PCI bridge to [bus 02-03] (subtractive decode)
[    0.284155] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.284162] pci 0000:00:14.4:   bridge window [mem 0xd4000000-0xd42fffff]
[    0.284169] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.284173] pci 0000:00:14.4:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.284176] pci 0000:00:14.4:   bridge window [mem 0x80000000-0xfcffffffff] (subtractive decode)
[    0.284180] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.284242] pci_bus 0000:03: [bus 03-06] partially hidden behind transparent bridge 0000:02 [bus 02-03]
[    0.284406] pci_bus 0000:00: on NUMA node 0
[    0.284412] ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
[    0.284658] ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
[    0.284741] ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
[    0.312200] ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
[    0.312714] ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
[    0.313216] ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
[    0.313719] ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
[    0.314222] ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
[    0.314693] ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
[    0.314693] ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
[    0.314693] ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
[    0.316053] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.316199] vgaarb: loaded
[    0.316398] SCSI subsystem initialized
[    0.316398] libata version 3.00 loaded.
[    0.316398] PCI: Using ACPI for IRQ routing
[    0.316398] PCI: pci_cache_line_size set to 64 bytes
[    0.316398] pci 0000:00:14.2: address space collision: [mem 0xd4408000-0xd440bfff 64bit] conflicts with 0000:00:12.0 [mem 0xd4409000-0xd44091ff]
[    0.316412] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.316415] reserve RAM buffer: 0000000077fd0000 - 0000000077ffffff 
[    0.316443] NetLabel: Initializing
[    0.316443] NetLabel:  domain hash size = 128
[    0.316443] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.316443] NetLabel:  unlabeled traffic allowed by default
[    0.317702] pnp: PnP ACPI init
[    0.317826] ACPI: bus type pnp registered
[    0.334153] pnp: PnP ACPI: found 13 devices
[    0.334153] ACPI: ACPI bus type pnp unregistered
[    0.334153] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.334153] system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.334153] system 00:00: [mem 0x00100000-0x77ffffff] could not be reserved
[    0.334153] system 00:0a: [io  0x040b] has been reserved
[    0.334153] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.334153] system 00:0a: [io  0x04d6] has been reserved
[    0.334153] system 00:0a: [io  0x0500-0x051f] has been reserved
[    0.334153] system 00:0a: [io  0x0c00-0x0c01] has been reserved
[    0.334153] system 00:0a: [io  0x0c14] has been reserved
[    0.334153] system 00:0a: [io  0x0c50-0x0c51] has been reserved
[    0.334153] system 00:0a: [io  0x0c52] has been reserved
[    0.334153] system 00:0a: [io  0x0c6c] has been reserved
[    0.334153] system 00:0a: [io  0x0c6f] has been reserved
[    0.334153] system 00:0a: [io  0x0cd4-0x0cdf] has been reserved
[    0.334153] system 00:0a: [mem 0xffb00000-0xffbfffff] could not be reserved
[    0.334153] system 00:0a: [mem 0xfff00000-0xffffffff] has been reserved
[    0.334153] system 00:0b: [io  0x8000-0x802f] has been reserved
[    0.334153] system 00:0b: [io  0x8100-0x811f] has been reserved
[    0.334153] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.334153] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.334153] system 00:0c: [mem 0x000cf000-0x000cffff] has been reserved
[    0.334153] system 00:0c: [mem 0x78000000-0x7fffffff] has been reserved
[    0.334153] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.340002] Switching to clocksource acpi_pm
[    0.340011] pci 0000:00:14.4: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
[    0.340011] pci 0000:00:12.0: BAR 6: assigned [mem 0x84000000-0x8407ffff pref]
[    0.340011] pci 0000:00:14.2: BAR 0: assigned [mem 0x84080000-0x84083fff 64bit]
[    0.340011] pci 0000:00:14.2: BAR 0: set to [mem 0x84080000-0x84083fff 64bit] (PCI address [0x84080000-0x84083fff]
[    0.340011] pci 0000:00:14.4: BAR 7: assigned [io  0x1000-0x1fff]
[    0.340011] pci 0000:01:05.0: BAR 6: assigned [mem 0xd4320000-0xd433ffff pref]
[    0.340011] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.340011] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    0.340011] pci 0000:00:01.0:   bridge window [mem 0xd4300000-0xd43fffff]
[    0.340011] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc7ffffff 64bit pref]
[    0.340011] pci 0000:00:04.0: PCI bridge to [bus 10-10]
[    0.341507] pci 0000:00:04.0:   bridge window [io  0x4000-0x5fff]
[    0.341609] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd3ffffff]
[    0.341707] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.341805] pci 0000:00:05.0: PCI bridge to [bus 20-20]
[    0.341903] pci 0000:00:05.0:   bridge window [io  0x2000-0x3fff]
[    0.342000] pci 0000:00:05.0:   bridge window [mem 0xcc000000-0xcfffffff]
[    0.342097] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    0.342195] pci 0000:00:06.0: PCI bridge to [bus 30-30]
[    0.342292] pci 0000:00:06.0:   bridge window [io  disabled]
[    0.342390] pci 0000:00:06.0:   bridge window [mem 0xc8000000-0xc80fffff]
[    0.342488] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.342589] pci 0000:02:04.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
[    0.342736] pci 0000:02:04.0: BAR 10: assigned [mem 0x88000000-0x8bffffff]
[    0.342834] pci 0000:02:04.0: BAR 7: assigned [io  0x1000-0x10ff]
[    0.342932] pci 0000:02:04.0: BAR 8: assigned [io  0x1400-0x14ff]
[    0.343030] pci 0000:02:04.0: CardBus bridge to [bus 03-06]
[    0.343126] pci 0000:02:04.0:   bridge window [io  0x1000-0x10ff]
[    0.343227] pci 0000:02:04.0:   bridge window [io  0x1400-0x14ff]
[    0.343328] pci 0000:02:04.0:   bridge window [mem 0x80000000-0x83ffffff pref]
[    0.343478] pci 0000:02:04.0:   bridge window [mem 0x88000000-0x8bffffff]
[    0.343579] pci 0000:00:14.4: PCI bridge to [bus 02-03]
[    0.343676] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    0.343778] pci 0000:00:14.4:   bridge window [mem 0xd4000000-0xd42fffff]
[    0.343879] pci 0000:00:14.4:   bridge window [mem 0x80000000-0x83ffffff pref]
[    0.344056] pci 0000:00:04.0: setting latency timer to 64
[    0.344064] pci 0000:00:05.0: setting latency timer to 64
[    0.344071] pci 0000:00:06.0: setting latency timer to 64
[    0.344100] pci 0000:02:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.344202] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.344205] pci_bus 0000:00: resource 5 [mem 0x80000000-0xfcffffffff]
[    0.344209] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.344212] pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
[    0.344215] pci_bus 0000:01: resource 1 [mem 0xd4300000-0xd43fffff]
[    0.344219] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc7ffffff 64bit pref]
[    0.344222] pci_bus 0000:10: resource 0 [io  0x4000-0x5fff]
[    0.344225] pci_bus 0000:10: resource 1 [mem 0xd0000000-0xd3ffffff]
[    0.344229] pci_bus 0000:20: resource 0 [io  0x2000-0x3fff]
[    0.344232] pci_bus 0000:20: resource 1 [mem 0xcc000000-0xcfffffff]
[    0.344236] pci_bus 0000:30: resource 1 [mem 0xc8000000-0xc80fffff]
[    0.344239] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.344242] pci_bus 0000:02: resource 1 [mem 0xd4000000-0xd42fffff]
[    0.344246] pci_bus 0000:02: resource 2 [mem 0x80000000-0x83ffffff pref]
[    0.344249] pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
[    0.344252] pci_bus 0000:02: resource 5 [mem 0x80000000-0xfcffffffff]
[    0.344256] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.344259] pci_bus 0000:03: resource 0 [io  0x1000-0x10ff]
[    0.344263] pci_bus 0000:03: resource 1 [io  0x1400-0x14ff]
[    0.344266] pci_bus 0000:03: resource 2 [mem 0x80000000-0x83ffffff pref]
[    0.344269] pci_bus 0000:03: resource 3 [mem 0x88000000-0x8bffffff]
[    0.344316] NET: Registered protocol family 2
[    0.344514] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.345525] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.347684] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.348350] TCP: Hash tables configured (established 262144 bind 65536)
[    0.348452] TCP reno registered
[    0.348553] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.348675] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.348905] NET: Registered protocol family 1
[    0.349051] pci 0000:00:00.0: MSI quirk detected; MSI disabled
[    0.349154] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.349376] pci 0000:01:05.0: Boot video device
[    0.349406] PCI: CLS 64 bytes, default 64
[    0.349481] Trying to unpack rootfs image as initramfs...
[    0.640879] debug: unmapping init memory ffff880037556000..ffff880037ff0000
[    0.643882] audit: initializing netlink socket (disabled)
[    0.644022] type=2000 audit(1276992293.640:1): initialized
[    0.644438] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.650404] VFS: Disk quotas dquot_6.5.2
[    0.650669] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.651195] msgmni has been set to 3721
[    0.652079] alg: No test for stdrng (krng)
[    0.652199] io scheduler noop registered
[    0.652297] io scheduler deadline registered
[    0.652549] io scheduler cfq registered (default)
[    0.652873] pcieport 0000:00:04.0: setting latency timer to 64
[    0.653005] pcieport 0000:00:05.0: setting latency timer to 64
[    0.653395] pcieport 0000:00:06.0: setting latency timer to 64
[    0.678979] Non-volatile memory driver v1.3
[    0.679192] Linux agpgart interface v0.103
[    0.679287] ramoops: invalid size specification
[    0.679431] [drm] Initialized drm 1.1.0 20060810
[    0.679701] [drm] radeon defaulting to kernel modesetting.
[    0.679798] [drm] radeon kernel modesetting enabled.
[    0.679982] radeon 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.684496] [drm] initializing kernel modesetting (RS480 0x1002:0x5975).
[    0.684759] [drm] register mmio base: 0xD4300000
[    0.684854] [drm] register mmio size: 65536
[    0.685138] [drm:rs400_gart_adjust_size] *ERROR* Forcing to 32M GART size (because of ASIC bug ?)
[    0.685287] [drm] Generation 2 PCI interface, using max accessible memory
[    0.685386] radeon 0000:01:05.0: VRAM: 128M 0x78000000 - 0x7FFFFFFF (128M used)
[    0.685531] radeon 0000:01:05.0: GTT: 32M 0x80000000 - 0x81FFFFFF
[    0.685670] [drm] radeon: irq initialized.
[    0.685976] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.686077] [drm] RAM width 128bits DDR
[    0.686309] [TTM] Zone  kernel: Available graphics memory: 952596 kiB.
[    0.686411] [TTM] Initializing pool allocator.
[    0.686531] [drm] radeon: 128M of VRAM memory ready
[    0.686625] [drm] radeon: 32M of GTT memory ready.
[    0.686753] [drm] GART: num cpu pages 8192, num gpu pages 8192
[    0.687041] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    0.687782] [drm] Loading R300 Microcode
[    0.688415] [drm] radeon: ring at 0x0000000080000000
[    0.688529] [drm] ring test succeeded in 1 usecs
[    0.689060] [drm] radeon: ib pool ready.
[    0.689240] [drm] ib test succeeded in 0 usecs
[    0.689372] [drm] Default TV standard: NTSC
[    0.689465] [drm] 14.318180000 MHz TV ref clk
[    0.689849] [drm] Panel ID String: LGP                     
[    0.689945] [drm] Panel Size 1400x1050
[    0.690298] [drm] Default TV standard: NTSC
[    0.690392] [drm] 14.318180000 MHz TV ref clk
[    0.690654] [drm] Radeon Display Connectors
[    0.690748] [drm] Connector 0:
[    0.690840] [drm]   VGA
[    0.690933] [drm]   DDC: 0x68 0x68 0x68 0x68 0x68 0x68 0x68 0x68
[    0.691028] [drm]   Encoders:
[    0.691120] [drm]     CRT1: INTERNAL_DAC2
[    0.691213] [drm] Connector 1:
[    0.691305] [drm]   LVDS
[    0.691397] [drm]   DDC: 0x198 0x198 0x19c 0x19c 0x1a0 0x1a0 0x1a4 0x1a4
[    0.691493] [drm]   Encoders:
[    0.691585] [drm]     LCD1: INTERNAL_LVDS
[    0.691677] [drm] Connector 2:
[    0.691769] [drm]   S-video
[    0.691860] [drm]   Encoders:
[    0.691952] [drm]     TV1: INTERNAL_DAC2
[    0.744616] [drm] radeon: power management initialized
[    0.831678] [drm] fb mappable at 0xC0040000
[    0.831774] [drm] vram apper at 0xC0000000
[    0.831866] [drm] size 5914624
[    0.831957] [drm] fb depth is 24
[    0.832049] [drm]    pitch is 5632
[    0.832299] fbcon: radeondrmfb (fb0) is primary device
[    0.884291] Console: switching to colour frame buffer device 175x65
[    0.898169] fb0: radeondrmfb frame buffer device
[    0.898247] drm: registered panic notifier
[    0.898318] Slow work thread pool: Starting up
[    0.898520] Slow work thread pool: Ready
[    0.898596] [drm] Initialized radeon 2.5.0 20080528 for 0000:01:05.0 on minor 0
[    0.898849] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.903638] brd: module loaded
[    0.903711] sata_sil 0000:00:12.0: version 2.4
[    0.903715] sata_sil 0000:00:12.0: quirky BIOS, skipping spindown on poweroff and hibernation
[    0.903917] sata_sil 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.904199] scsi0 : sata_sil
[    0.904602] scsi1 : sata_sil
[    0.905365] ata1: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd4409080 irq 16
[    0.905487] ata2: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd44090c0 irq 16
[    0.905961] PNP: PS/2 Controller [PNP0303:C214,PNP0f13:C215] at 0x60,0x64 irq 1,12
[    0.907808] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.908676] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.908771] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.908874] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.908972] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.909210] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.909655] mice: PS/2 mouse device common for all mice
[    0.909844] cpuidle: using governor ladder
[    0.909919] cpuidle: using governor menu
[    0.910403] lib80211: common routines for IEEE802.11 drivers
[    0.910513] lib80211_crypt: registered algorithm 'NULL'
[    0.910842] PM: Checking image partition /dev/sda1
[    0.931068] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.224089] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.232383] ata1.00: ATA-7: FUJITSU MHV2080BH, 892C, max UDMA/100
[    1.232487] ata1.00: 156301488 sectors, multi 16: LBA48 
[    1.248380] ata1.00: configured for UDMA/100
[    1.248668] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
[    1.568072] ata2: SATA link down (SStatus 0 SControl 300)
[    1.568221] PM: Resume from disk failed.
[    1.568234] registered taskstats version 1
[    1.568655]   Magic number: 14:12:52
[    1.568861] Initalizing network drop monitor service
[    1.569006] debug: unmapping init memory ffffffff81970000..ffffffff819e2000
[    1.569188] Write protecting the kernel read-only data: 8192k
[    1.569515] debug: unmapping init memory ffff880001369000..ffff880001400000
[    1.569678] debug: unmapping init memory ffff880001616000..ffff880001800000
[    1.649661] thermal LNXTHERM:01: registered as thermal_zone0
[    1.652841] ACPI: Thermal Zone [TZ1] (56 C)
[    1.660472] thermal LNXTHERM:02: registered as thermal_zone1
[    1.663799] ACPI: Thermal Zone [TZ2] (54 C)
[    1.678150] thermal LNXTHERM:03: registered as thermal_zone2
[    1.681661] ACPI: Thermal Zone [TZ3] (34 C)
[    1.709875] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.713799] scsi2 : pata_atiixp
[    1.717922] scsi3 : pata_atiixp
[    1.722913] ata3: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x7040 irq 14
[    1.726805] ata4: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x7048 irq 15
[    1.892635] ata3.00: ATAPI: HL-DT-ST DVDRAM GMA-4082N, HQ04, max MWDMA2
[    1.912585] ata3.00: configured for MWDMA2
[    1.921953] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4082N HQ04 PQ: 0 ANSI: 5
[    1.983406] ACPI: acpi_idle registered with cpuidle
[    1.995243] ACPI: Fan [C34F] (off)
[    1.999791] ACPI: Fan [C350] (off)
[    2.004235] ACPI: Fan [C351] (off)
[    2.008751] ACPI: Fan [C352] (off)
[    2.064546] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.081265] udev: starting version 146
[    2.190950] rtc_cmos 00:07: RTC can wake from S4
[    2.195450] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    2.199577] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    2.298188] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    2.302445] sd 0:0:0:0: [sda] Write Protect is off
[    2.306570] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.306610] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.311123]  sda:
[    2.311403] usbcore: registered new interface driver usbfs
[    2.324438] usbcore: registered new interface driver hub
[    2.331523] usbcore: registered new device driver usb
[    2.342982] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.344881]  sda1 sda2 sda3 sda4 <
[    2.347353] ehci_hcd 0000:00:13.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.363071] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.366826]  sda5
[    2.369936] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[    2.379102] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd4403000
[    2.383535]  sda6
[    2.392123] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.401686]  sda7
[    2.402407] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.411063] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.415840] usb usb1: Product: EHCI Host Controller
[    2.420214] usb usb1: Manufacturer: Linux 2.6.35-rc3+ ehci_hcd
[    2.420250]  sda8 >
[    2.432612] usb usb1: SerialNumber: 0000:00:13.2
[    2.440464] hub 1-0:1.0: USB hub found
[    2.443388] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.449180] hub 1-0:1.0: 8 ports detected
[    2.470416] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.475027] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.479475] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.484008] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    2.488481] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd4401000
[    2.553101] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.557476] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.561832] usb usb2: Product: OHCI Host Controller
[    2.566142] usb usb2: Manufacturer: Linux 2.6.35-rc3+ ohci_hcd
[    2.570455] usb usb2: SerialNumber: 0000:00:13.0
[    2.575235] hub 2-0:1.0: USB hub found
[    2.579447] hub 2-0:1.0: 4 ports detected
[    2.583880] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.588151] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    2.592324] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    2.596602] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd4402000
[    2.661075] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.665376] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.669678] usb usb3: Product: OHCI Host Controller
[    2.674020] usb usb3: Manufacturer: Linux 2.6.35-rc3+ ohci_hcd
[    2.678274] usb usb3: SerialNumber: 0000:00:13.1
[    2.683014] hub 3-0:1.0: USB hub found
[    2.687211] hub 3-0:1.0: 4 ports detected
[    3.180055] usb 2-2: new full speed USB device using ohci_hcd and address 2
[    3.407133] usb 2-2: New USB device found, idVendor=03f0, idProduct=171d
[    3.411688] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.416184] usb 2-2: Product: HP Integrated Module
[    3.431362] usb 2-2: Manufacturer: Broadcom Corp
[    3.502470] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    3.502477] PM: Basic memory bitmaps created
[    3.547810] PM: Basic memory bitmaps freed
[    3.613005] PM: Starting manual resume from disk
[    3.617062] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    3.626457] PM: Resume from partition 8:1
[    3.626459] PM: Checking hibernation image.
[    3.626783] PM: Error -22 checking image file
[    3.626787] PM: Resume from disk failed.
[    3.821122] usb 3-1: New USB device found, idVendor=08ff, idProduct=2580
[    3.825685] usb 3-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.830168] usb 3-1: Product: Fingerprint Sensor
[    4.061723] EXT3-fs: barriers not enabled
[    4.066501] kjournald starting.  Commit interval 5 seconds
[    4.070974] EXT3-fs (sda3): using internal journal
[    4.075461] EXT3-fs (sda3): mounted filesystem with ordered data mode
[    8.652435] udev: starting version 146
[    8.801910] ACPI: AC Adapter [C1BD] (on-line)
[    9.014055] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    9.019089] ACPI: Sleep Button [C25A]
[    9.025518] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    9.031643] ACPI: Lid Switch [C25B]
[    9.036835] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    9.042037] ACPI: Power Button [PWRF]
[    9.545885] ACPI: Battery Slot [C1BF] (battery present)
[    9.551427] ACPI: Battery Slot [C1BE] (battery absent)
[    9.809333] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    9.885418] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0x8200, revision 0
[   10.146168] [Firmware Bug]: ACPI: ACPI brightness control misses _BQC function
[   10.151569] [Firmware Bug]: _BCQ is used instead of _BQC
[   10.157670] acpi device:02: registered as cooling_device6
[   10.163107] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:00/LNXVIDEO:00/input/input4
[   10.168421] ACPI: Video Device [C076] (multi-head: yes  rom: no  post: no)
[   10.313592] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.319092] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[   10.410999] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   10.850205] tg3.c:v3.110 (April 9, 2010)
[   10.855460] tg3 0000:02:01.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.902964] tg3 0000:02:01.0: eth0: Tigon3 [partno(BCM95788A50) rev 3003] (PCI:33MHz:32-bit) MAC address 00:17:08:2e:2e:f3
[   10.908364] tg3 0000:02:01.0: eth0: attached PHY is 5705 (10/100/1000Base-T Ethernet) (WireSpeed[0])
[   10.913841] tg3 0000:02:01.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   10.919572] tg3 0000:02:01.0: eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   10.945421] udev: renamed network interface eth0 to eth2
[   11.038573] tifm_7xx1 0000:02:04.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.098986] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   11.104479] Uniform CD-ROM driver Revision: 3.20
[   11.110225] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   11.648167] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.020194] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000/0x0
[   12.025943] serio: Synaptics pass-through port at isa0060/serio4/input0
[   12.050721] yenta_cardbus 0000:02:04.0: CardBus bridge found [103c:30b0]
[   12.056485] yenta_cardbus 0000:02:04.0: Enabling burst memory read transactions
[   12.062131] yenta_cardbus 0000:02:04.0: Using INTVAL to route CSC interrupts to PCI
[   12.067724] yenta_cardbus 0000:02:04.0: Routing CardBus interrupts to PCI
[   12.073317] yenta_cardbus 0000:02:04.0: TI: mfunc 0x01a11002, devctl 0x64
[   12.081692] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
[   12.200356] b43-pci-bridge 0000:30:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.206147] b43-pci-bridge 0000:30:00.0: setting latency timer to 64
[   12.225105] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
[   12.225120] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
[   12.225128] ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
[   12.225136] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
[   12.245882] ssb: SPROM revision 2 detected.
[   12.265120] ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
[   12.314038] yenta_cardbus 0000:02:04.0: ISA IRQ mask 0x0cf8, PCI irq 20
[   12.319837] yenta_cardbus 0000:02:04.0: Socket status: 30000006
[   12.325571] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
[   12.331394] yenta_cardbus 0000:02:04.0: pcmcia: parent PCI bridge window: [io  0x1000-0x1fff]
[   12.337211] yenta_cardbus 0000:02:04.0: pcmcia: parent PCI bridge window: [mem 0xd4000000-0xd42fffff]
[   12.343003] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd4000000-0xd42fffff: excluding 0xd4000000-0xd402ffff
[   12.348879] yenta_cardbus 0000:02:04.0: pcmcia: parent PCI bridge window: [mem 0x80000000-0x83ffffff pref]
[   12.354849] pcmcia_socket pcmcia_socket0: cs: memory probe 0x80000000-0x83ffffff: excluding 0x80000000-0x83ffffff
[   12.361541] ohci1394 0000:02:04.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   12.402288] Bluetooth: Core ver 2.15
[   12.408568] NET: Registered protocol family 31
[   12.414613] Bluetooth: HCI device and connection manager initialized
[   12.420700] Bluetooth: HCI socket layer initialized
[   12.425161] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   12.804137] sdhci: Secure Digital Host Controller Interface driver
[   12.810292] sdhci: Copyright(c) Pierre Ossman
[   13.001246] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xfffff
[   13.007348] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   13.013333] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   13.189577] sdhci-pci 0000:02:04.3: SDHCI controller found [104c:803c] (rev 0)
[   13.195518] sdhci-pci 0000:02:04.3: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   13.201473] Registered led device: mmc0::
[   13.201524] mmc0: SDHCI controller on PCI [0000:02:04.3] using PIO
[   13.614569] cfg80211: Calling CRDA to update world regulatory domain
[   13.664653] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   13.670807] usbcore: registered new interface driver btusb
[   13.701411] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929613f0c]
[   14.332482] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.246759] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[   16.786409] b43-phy0: Broadcom 4311 WLAN found (core revision 10)
[   16.836060] b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
[   16.836081] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
[   16.934787] phy0: Selected rate control algorithm 'minstrel'
[   16.935294] Registered led device: b43-phy0::tx
[   16.935328] Registered led device: b43-phy0::rx
[   16.935350] Registered led device: b43-phy0::radio
[   16.935432] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
[   17.149516] Adding 1052220k swap on /dev/sda1.  Priority:-1 extents:1 across:1052220k 
[   18.420453] device-mapper: uevent: version 1.0.3
[   18.426434] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[   22.229320] loop: module loaded
[   22.278733] EXT3-fs: barriers not enabled
[   22.293262] kjournald starting.  Commit interval 5 seconds
[   22.297906] EXT3-fs (sda2): using internal journal
[   22.302525] EXT3-fs (sda2): mounted filesystem with ordered data mode
[   22.308853] EXT3-fs: barriers not enabled
[   22.326103] kjournald starting.  Commit interval 5 seconds
[   22.330578] EXT3-fs (sda7): using internal journal
[   22.335001] EXT3-fs (sda7): mounted filesystem with ordered data mode
[   22.364775] EXT3-fs: barriers not enabled
[   22.377225] kjournald starting.  Commit interval 5 seconds
[   22.381634] EXT3-fs (sda8): using internal journal
[   22.385969] EXT3-fs (sda8): mounted filesystem with ordered data mode
[   22.412758] EXT3-fs: barriers not enabled
[   22.429248] kjournald starting.  Commit interval 5 seconds
[   22.433553] EXT3-fs (sda5): using internal journal
[   22.437859] EXT3-fs (sda5): mounted filesystem with ordered data mode
[   22.443323] EXT3-fs: barriers not enabled
[   22.447836] kjournald starting.  Commit interval 5 seconds
[   22.448186] EXT3-fs (sda6): using internal journal
[   22.448192] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   23.085761] fuse init (API version 7.14)
[   33.247443] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   33.766065] ip_tables: (C) 2000-2006 Netfilter Core Team
[   34.264459] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   34.264876] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   34.264885] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   34.264892] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   35.255622] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-60 (2 cpu cores) (version 2.20.00)
[   35.255712] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x13
[   35.255719] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x15
[   35.255727] powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x17
[   35.255734] powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
[   35.255811] powernow-k8: ph2 null fid transition 0xc
[   46.719961] Bluetooth: L2CAP ver 2.14
[   46.719969] Bluetooth: L2CAP socket layer initialized
[   47.006285] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   47.006296] Bluetooth: BNEP filters: protocol multicast
[   47.096022] Bluetooth: SCO (Voice Link) ver 0.6
[   47.096032] Bluetooth: SCO socket layer initialized
[   47.328156] Bluetooth: RFCOMM TTY layer initialized
[   47.328172] Bluetooth: RFCOMM socket layer initialized
[   47.328178] Bluetooth: RFCOMM ver 1.11
[   56.853057] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[   56.904093] b43-phy0 debug: Chip initialized
[   56.904330] b43-phy0 debug: 32-bit DMA initialized
[   56.904399] b43-phy0 debug: QoS enabled
[   56.928670] b43-phy0 debug: Wireless interface started
[   56.928692] b43-phy0 debug: Adding Interface type 2
[   57.430930] NET: Registered protocol family 17
[   58.885492] tg3 0000:02:01.0: eth2: Link is up at 1000 Mbps, full duplex
[   58.885503] tg3 0000:02:01.0: eth2: Flow control is on for TX and on for RX
[   67.796184] RPC: Registered udp transport module.
[   67.796194] RPC: Registered tcp transport module.
[   67.796202] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   82.032150] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   82.679507] Clocksource tsc unstable (delta = -301523047 ns)
[  139.961332] wlan0: deauthenticating from 00:1d:7e:aa:87:ee by local choice (reason=3)
[  139.962029] wlan0: authenticate with 00:1d:7e:aa:87:ee (try 1)
[  139.965561] wlan0: authenticated
[  139.965938] wlan0: associate with 00:1d:7e:aa:87:ee (try 1)
[  139.969091] wlan0: RX AssocResp from 00:1d:7e:aa:87:ee (capab=0x411 status=0 aid=1)
[  139.969104] wlan0: associated
[  142.751058] Intel AES-NI instructions are not detected.
[  142.776242] b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:7e:aa:87:ee
[  142.776347] b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[  204.356919] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0
[  204.436454] tg3 0000:02:01.0: PME# enabled
[  204.436483] tg3 0000:02:01.0: wake-up capability enabled by ACPI
[  204.692289] b43-phy0 debug: Disabling hardware based encryption for keyidx: 0, mac: 00:1d:7e:aa:87:ee
[  204.704131] wlan0: deauthenticating from 00:1d:7e:aa:87:ee by local choice (reason=3)
[  204.705560] b43-phy0 debug: Disabling hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[  204.744069] b43-phy0 debug: Removing Interface type 2
[  204.744330] b43-phy0 debug: Wireless interface stopped
[  204.744338] b43-phy0 debug: DMA-32 rx_ring: Used slots 1/64, Failed frames 0/0 = 0.0%, Average tries 0.00
[  204.744452] b43-phy0 debug: DMA-32 tx_ring_AC_BK: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
[  204.752110] b43-phy0 debug: DMA-32 tx_ring_AC_BE: Used slots 2/256, Failed frames 0/3 = 0.0%, Average tries 1.00
[  204.760078] b43-phy0 debug: DMA-32 tx_ring_AC_VI: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
[  204.768092] b43-phy0 debug: DMA-32 tx_ring_AC_VO: Used slots 4/256, Failed frames 0/93 = 0.0%, Average tries 1.00
[  204.776069] b43-phy0 debug: DMA-32 tx_ring_mcast: Used slots 0/256, Failed frames 0/0 = 0.0%, Average tries 0.00
[  204.786952] cfg80211: Calling CRDA to update world regulatory domain
[  205.867739] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  205.867746] PM: Basic memory bitmaps created
[  206.108098] Syncing filesystems ... done.
[  206.152079] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  206.168091] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  206.184206] PM: Preallocating image memory... done (allocated 187396 pages)
[  206.495887] PM: Allocated 749584 kbytes in 0.31 seconds (2418.01 MB/s)
[  206.495890] Suspending console(s) (use no_console_suspend to debug)
[  206.513341] ACPI handle has no context!
[  206.513352] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  206.513635] ACPI handle has no context!
[  206.513647] sdhci-pci 0000:02:04.3: PCI INT A disabled
[  206.513655] ACPI handle has no context!
[  206.513704] btusb_intr_complete: hci0 urb ffff880075d8e0c0 failed to resubmit (1)
[  206.513736] ACPI handle has no context!
[  206.513744] tifm_7xx1 0000:02:04.2: PCI INT A disabled
[  206.513752] ACPI handle has no context!
[  206.513902] ACPI handle has no context!
[  206.514046] b43-pci-bridge 0000:30:00.0: PCI INT A disabled
[  206.514694] btusb_bulk_complete: hci0 urb ffff880075d8e840 failed to resubmit (1)
[  206.515683] btusb_bulk_complete: hci0 urb ffff880075d8ecc0 failed to resubmit (1)
[  206.516427] pata_atiixp 0000:00:14.1: PCI INT A disabled
[  206.516541] sata_sil 0000:00:12.0: PCI INT A disabled
[  206.526923] radeon_move_blit: new type: tt, old type: vram
[  206.526930] radeon_copy: result: 0, elapsed 9 usecs
[  206.527008] ttm_bo_move_accel_cleanup: result: 0, elapsed 71 usecs
[  206.527048] radeon_move_blit: new type: tt, old type: vram
[  206.527054] radeon_copy: result: 0, elapsed 6 usecs
[  206.527085] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  206.527119] radeon_move_blit: new type: tt, old type: vram
[  206.527124] radeon_copy: result: 0, elapsed 6 usecs
[  206.527172] ttm_bo_move_accel_cleanup: result: 0, elapsed 40 usecs
[  206.527207] radeon_move_blit: new type: tt, old type: vram
[  206.527214] radeon_copy: result: 0, elapsed 7 usecs
[  206.528057] ttm_bo_move_accel_cleanup: result: 0, elapsed 818 usecs
[  206.528072] radeon_move_blit: new type: tt, old type: vram
[  206.528078] radeon_copy: result: 0, elapsed 6 usecs
[  206.529050] ttm_bo_move_accel_cleanup: result: 0, elapsed 945 usecs
[  206.529063] radeon_move_blit: new type: tt, old type: vram
[  206.529114] radeon_copy: result: 0, elapsed 49 usecs
[  206.529122] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  206.529135] radeon_move_blit: new type: tt, old type: vram
[  206.529141] radeon_copy: result: 0, elapsed 5 usecs
[  206.532070] ttm_bo_move_accel_cleanup: result: 0, elapsed 2855 usecs
[  206.536259] radeon_move_blit: new type: tt, old type: vram
[  206.536265] radeon_copy: result: 0, elapsed 6 usecs
[  206.720146] HDA Intel 0000:00:14.2: PCI INT A disabled
[  209.196078] ttm_bo_move_accel_cleanup: result: 0, elapsed 2597468 usecs
[  209.196093] radeon_move_blit: new type: tt, old type: vram
[  209.196099] radeon_copy: result: 0, elapsed 5 usecs
[  209.196137] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  209.196151] radeon_move_blit: new type: tt, old type: vram
[  209.196157] radeon_copy: result: 0, elapsed 5 usecs
[  209.200053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3800 usecs
[  209.200064] radeon_move_blit: new type: tt, old type: vram
[  209.200070] radeon_copy: result: 0, elapsed 5 usecs
[  209.200115] ttm_bo_move_accel_cleanup: result: 0, elapsed 40 usecs
[  209.200129] radeon_move_blit: new type: tt, old type: vram
[  209.200135] radeon_copy: result: 0, elapsed 5 usecs
[  209.200173] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  209.200184] radeon_move_blit: new type: tt, old type: vram
[  209.200190] radeon_copy: result: 0, elapsed 5 usecs
[  209.204054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3768 usecs
[  209.204066] radeon_move_blit: new type: tt, old type: vram
[  209.204072] radeon_copy: result: 0, elapsed 5 usecs
[  209.204088] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  209.204099] radeon_move_blit: new type: tt, old type: vram
[  209.204104] radeon_copy: result: 0, elapsed 5 usecs
[  209.204133] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  209.204145] radeon_move_blit: new type: tt, old type: vram
[  209.204150] radeon_copy: result: 0, elapsed 5 usecs
[  209.204171] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  209.204183] radeon_move_blit: new type: tt, old type: vram
[  209.204188] radeon_copy: result: 0, elapsed 5 usecs
[  209.204204] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  209.204215] radeon_move_blit: new type: tt, old type: vram
[  209.204221] radeon_copy: result: 0, elapsed 5 usecs
[  209.204242] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  209.204253] radeon_move_blit: new type: tt, old type: vram
[  209.204258] radeon_copy: result: 0, elapsed 5 usecs
[  209.204279] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.204289] radeon_move_blit: new type: tt, old type: vram
[  209.204295] radeon_copy: result: 0, elapsed 5 usecs
[  209.204316] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.204328] radeon_move_blit: new type: tt, old type: vram
[  209.204333] radeon_copy: result: 0, elapsed 5 usecs
[  209.204353] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.204365] radeon_move_blit: new type: tt, old type: vram
[  209.204370] radeon_copy: result: 0, elapsed 5 usecs
[  209.204390] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.204402] radeon_move_blit: new type: tt, old type: vram
[  209.204408] radeon_copy: result: 0, elapsed 5 usecs
[  209.204428] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.204440] radeon_move_blit: new type: tt, old type: vram
[  209.204446] radeon_copy: result: 0, elapsed 5 usecs
[  209.204466] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.204477] radeon_move_blit: new type: tt, old type: vram
[  209.204483] radeon_copy: result: 0, elapsed 5 usecs
[  209.204503] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  209.206408] radeon_move_blit: new type: tt, old type: vram
[  209.206414] radeon_copy: result: 0, elapsed 6 usecs
[  210.231571] ttm_bo_move_accel_cleanup: result: 0, elapsed 1001124 usecs
[  210.231584] radeon_move_blit: new type: tt, old type: vram
[  210.231590] radeon_copy: result: 0, elapsed 5 usecs
[  210.231628] ttm_bo_move_accel_cleanup: result: 0, elapsed 32 usecs
[  210.231639] radeon_move_blit: new type: tt, old type: vram
[  210.231645] radeon_copy: result: 0, elapsed 5 usecs
[  210.231678] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  210.231691] radeon_move_blit: new type: tt, old type: vram
[  210.231696] radeon_copy: result: 0, elapsed 5 usecs
[  210.232054] ttm_bo_move_accel_cleanup: result: 0, elapsed 344 usecs
[  210.232065] radeon_move_blit: new type: tt, old type: vram
[  210.232071] radeon_copy: result: 0, elapsed 5 usecs
[  210.232087] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  210.232098] radeon_move_blit: new type: tt, old type: vram
[  210.232103] radeon_copy: result: 0, elapsed 5 usecs
[  210.232124] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  210.232136] radeon_move_blit: new type: tt, old type: vram
[  210.232142] radeon_copy: result: 0, elapsed 5 usecs
[  210.232163] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  210.232281] radeon_move_blit: new type: tt, old type: vram
[  210.232286] radeon_copy: result: 0, elapsed 5 usecs
[  211.314545] ttm_bo_move_accel_cleanup: result: 0, elapsed 1056888 usecs
[  211.314559] radeon_move_blit: new type: tt, old type: vram
[  211.314564] radeon_copy: result: 0, elapsed 6 usecs
[  211.314602] ttm_bo_move_accel_cleanup: result: 0, elapsed 32 usecs
[  211.314615] radeon_move_blit: new type: tt, old type: vram
[  211.314621] radeon_copy: result: 0, elapsed 5 usecs
[  211.314655] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  211.314666] radeon_move_blit: new type: tt, old type: vram
[  211.314671] radeon_copy: result: 0, elapsed 5 usecs
[  211.316053] ttm_bo_move_accel_cleanup: result: 0, elapsed 1344 usecs
[  211.316066] radeon_move_blit: new type: tt, old type: vram
[  211.316072] radeon_copy: result: 0, elapsed 5 usecs
[  211.316105] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  211.316116] radeon_move_blit: new type: tt, old type: vram
[  211.316121] radeon_copy: result: 0, elapsed 5 usecs
[  211.316142] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.317924] radeon_move_blit: new type: tt, old type: vram
[  211.317930] radeon_copy: result: 0, elapsed 6 usecs
[  211.320053] ttm_bo_move_accel_cleanup: result: 0, elapsed 2067 usecs
[  211.320064] radeon_move_blit: new type: tt, old type: vram
[  211.320070] radeon_copy: result: 0, elapsed 5 usecs
[  211.320086] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  211.320097] radeon_move_blit: new type: tt, old type: vram
[  211.320103] radeon_copy: result: 0, elapsed 5 usecs
[  211.320132] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  211.320147] radeon_move_blit: new type: tt, old type: vram
[  211.320152] radeon_copy: result: 0, elapsed 5 usecs
[  211.320169] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  211.320181] radeon_move_blit: new type: tt, old type: vram
[  211.320187] radeon_copy: result: 0, elapsed 5 usecs
[  211.320208] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.320218] radeon_move_blit: new type: tt, old type: vram
[  211.320224] radeon_copy: result: 0, elapsed 5 usecs
[  211.320245] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.320256] radeon_move_blit: new type: tt, old type: vram
[  211.320261] radeon_copy: result: 0, elapsed 5 usecs
[  211.320282] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.320292] radeon_move_blit: new type: tt, old type: vram
[  211.320298] radeon_copy: result: 0, elapsed 5 usecs
[  211.320318] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.320330] radeon_move_blit: new type: tt, old type: vram
[  211.320336] radeon_copy: result: 0, elapsed 5 usecs
[  211.324054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3626 usecs
[  211.324066] radeon_move_blit: new type: tt, old type: vram
[  211.324071] radeon_copy: result: 0, elapsed 5 usecs
[  211.351597] ttm_bo_move_accel_cleanup: result: 0, elapsed 26875 usecs
[  211.351607] radeon_move_blit: new type: tt, old type: vram
[  211.351613] radeon_copy: result: 0, elapsed 5 usecs
[  211.351642] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  211.351652] radeon_move_blit: new type: tt, old type: vram
[  211.351657] radeon_copy: result: 0, elapsed 5 usecs
[  211.351679] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.351689] radeon_move_blit: new type: tt, old type: vram
[  211.351694] radeon_copy: result: 0, elapsed 5 usecs
[  211.351715] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.351726] radeon_move_blit: new type: tt, old type: vram
[  211.351732] radeon_copy: result: 0, elapsed 5 usecs
[  211.351753] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.351763] radeon_move_blit: new type: tt, old type: vram
[  211.351769] radeon_copy: result: 0, elapsed 5 usecs
[  211.351790] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  211.351804] radeon_move_blit: new type: tt, old type: vram
[  211.351809] radeon_copy: result: 0, elapsed 5 usecs
[  211.352054] ttm_bo_move_accel_cleanup: result: 0, elapsed 234 usecs
[  211.352065] radeon_move_blit: new type: tt, old type: vram
[  211.352071] radeon_copy: result: 0, elapsed 5 usecs
[  211.352091] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352101] radeon_move_blit: new type: tt, old type: vram
[  211.352107] radeon_copy: result: 0, elapsed 5 usecs
[  211.352127] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352138] radeon_move_blit: new type: tt, old type: vram
[  211.352143] radeon_copy: result: 0, elapsed 5 usecs
[  211.352163] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352174] radeon_move_blit: new type: tt, old type: vram
[  211.352179] radeon_copy: result: 0, elapsed 5 usecs
[  211.352199] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352210] radeon_move_blit: new type: tt, old type: vram
[  211.352215] radeon_copy: result: 0, elapsed 5 usecs
[  211.352235] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352247] radeon_move_blit: new type: tt, old type: vram
[  211.352252] radeon_copy: result: 0, elapsed 5 usecs
[  211.352272] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352283] radeon_move_blit: new type: tt, old type: vram
[  211.352288] radeon_copy: result: 0, elapsed 5 usecs
[  211.352308] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352319] radeon_move_blit: new type: tt, old type: vram
[  211.352324] radeon_copy: result: 0, elapsed 5 usecs
[  211.352345] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352355] radeon_move_blit: new type: tt, old type: vram
[  211.352361] radeon_copy: result: 0, elapsed 5 usecs
[  211.352381] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352391] radeon_move_blit: new type: tt, old type: vram
[  211.352397] radeon_copy: result: 0, elapsed 5 usecs
[  211.352416] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352428] radeon_move_blit: new type: tt, old type: vram
[  211.352434] radeon_copy: result: 0, elapsed 5 usecs
[  211.352454] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352465] radeon_move_blit: new type: tt, old type: vram
[  211.352470] radeon_copy: result: 0, elapsed 5 usecs
[  211.352490] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352503] radeon_move_blit: new type: tt, old type: vram
[  211.352508] radeon_copy: result: 0, elapsed 5 usecs
[  211.352529] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352540] radeon_move_blit: new type: tt, old type: vram
[  211.352545] radeon_copy: result: 0, elapsed 5 usecs
[  211.352566] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352578] radeon_move_blit: new type: tt, old type: vram
[  211.352584] radeon_copy: result: 0, elapsed 5 usecs
[  211.352604] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352615] radeon_move_blit: new type: tt, old type: vram
[  211.352621] radeon_copy: result: 0, elapsed 5 usecs
[  211.352641] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352653] radeon_move_blit: new type: tt, old type: vram
[  211.352658] radeon_copy: result: 0, elapsed 5 usecs
[  211.352678] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352694] radeon_move_blit: new type: tt, old type: vram
[  211.352699] radeon_copy: result: 0, elapsed 5 usecs
[  211.352720] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352731] radeon_move_blit: new type: tt, old type: vram
[  211.352736] radeon_copy: result: 0, elapsed 5 usecs
[  211.352756] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352767] radeon_move_blit: new type: tt, old type: vram
[  211.352772] radeon_copy: result: 0, elapsed 5 usecs
[  211.352792] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352802] radeon_move_blit: new type: tt, old type: vram
[  211.352807] radeon_copy: result: 0, elapsed 5 usecs
[  211.352828] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352838] radeon_move_blit: new type: tt, old type: vram
[  211.352844] radeon_copy: result: 0, elapsed 5 usecs
[  211.352864] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352874] radeon_move_blit: new type: tt, old type: vram
[  211.352879] radeon_copy: result: 0, elapsed 5 usecs
[  211.352900] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352910] radeon_move_blit: new type: tt, old type: vram
[  211.352915] radeon_copy: result: 0, elapsed 5 usecs
[  211.352935] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352946] radeon_move_blit: new type: tt, old type: vram
[  211.352951] radeon_copy: result: 0, elapsed 5 usecs
[  211.352972] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.352983] radeon_move_blit: new type: tt, old type: vram
[  211.352988] radeon_copy: result: 0, elapsed 5 usecs
[  211.353029] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  211.353040] radeon_move_blit: new type: tt, old type: vram
[  211.353046] radeon_copy: result: 0, elapsed 5 usecs
[  211.353065] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.353076] radeon_move_blit: new type: tt, old type: vram
[  211.353082] radeon_copy: result: 0, elapsed 5 usecs
[  211.353102] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.353113] radeon_move_blit: new type: tt, old type: vram
[  211.353118] radeon_copy: result: 0, elapsed 5 usecs
[  211.353138] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.353149] radeon_move_blit: new type: tt, old type: vram
[  211.353155] radeon_copy: result: 0, elapsed 5 usecs
[  211.353175] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  211.353293] radeon_move_blit: new type: tt, old type: vram
[  211.353298] radeon_copy: result: 0, elapsed 5 usecs
[  212.396062] ttm_bo_move_accel_cleanup: result: 0, elapsed 1018319 usecs
[  212.397919] radeon_move_blit: new type: tt, old type: vram
[  212.397925] radeon_copy: result: 0, elapsed 6 usecs
[  213.596064] ttm_bo_move_accel_cleanup: result: 0, elapsed 1170051 usecs
[  213.596079] radeon_move_blit: new type: tt, old type: vram
[  213.596084] radeon_copy: result: 0, elapsed 5 usecs
[  213.596126] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  213.596137] radeon_move_blit: new type: tt, old type: vram
[  213.596142] radeon_copy: result: 0, elapsed 5 usecs
[  213.596175] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  213.596187] radeon_move_blit: new type: tt, old type: vram
[  213.596192] radeon_copy: result: 0, elapsed 5 usecs
[  213.596214] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.596225] radeon_move_blit: new type: tt, old type: vram
[  213.596231] radeon_copy: result: 0, elapsed 5 usecs
[  213.600051] ttm_bo_move_accel_cleanup: result: 0, elapsed 3726 usecs
[  213.600064] radeon_move_blit: new type: tt, old type: vram
[  213.600069] radeon_copy: result: 0, elapsed 5 usecs
[  213.600112] ttm_bo_move_accel_cleanup: result: 0, elapsed 37 usecs
[  213.600122] radeon_move_blit: new type: tt, old type: vram
[  213.600128] radeon_copy: result: 0, elapsed 5 usecs
[  213.600144] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  213.600155] radeon_move_blit: new type: tt, old type: vram
[  213.600161] radeon_copy: result: 0, elapsed 5 usecs
[  213.600199] ttm_bo_move_accel_cleanup: result: 0, elapsed 32 usecs
[  213.600209] radeon_move_blit: new type: tt, old type: vram
[  213.600215] radeon_copy: result: 0, elapsed 5 usecs
[  213.604053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3743 usecs
[  213.604065] radeon_move_blit: new type: tt, old type: vram
[  213.604070] radeon_copy: result: 0, elapsed 5 usecs
[  213.604112] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  213.604124] radeon_move_blit: new type: tt, old type: vram
[  213.604129] radeon_copy: result: 0, elapsed 5 usecs
[  213.604145] ttm_bo_move_accel_cleanup: result: 0, elapsed 10 usecs
[  213.604156] radeon_move_blit: new type: tt, old type: vram
[  213.604162] radeon_copy: result: 0, elapsed 5 usecs
[  213.604195] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  213.604207] radeon_move_blit: new type: tt, old type: vram
[  213.604212] radeon_copy: result: 0, elapsed 5 usecs
[  213.608053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3746 usecs
[  213.608064] radeon_move_blit: new type: tt, old type: vram
[  213.608070] radeon_copy: result: 0, elapsed 5 usecs
[  213.608099] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  213.608114] radeon_move_blit: new type: tt, old type: vram
[  213.608120] radeon_copy: result: 0, elapsed 5 usecs
[  213.608154] ttm_bo_move_accel_cleanup: result: 0, elapsed 29 usecs
[  213.608165] radeon_move_blit: new type: tt, old type: vram
[  213.608170] radeon_copy: result: 0, elapsed 5 usecs
[  213.612053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3787 usecs
[  213.612064] radeon_move_blit: new type: tt, old type: vram
[  213.612069] radeon_copy: result: 0, elapsed 5 usecs
[  213.612120] ttm_bo_move_accel_cleanup: result: 0, elapsed 45 usecs
[  213.612131] radeon_move_blit: new type: tt, old type: vram
[  213.612136] radeon_copy: result: 0, elapsed 5 usecs
[  213.612170] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  213.612180] radeon_move_blit: new type: tt, old type: vram
[  213.612185] radeon_copy: result: 0, elapsed 5 usecs
[  213.612206] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.612217] radeon_move_blit: new type: tt, old type: vram
[  213.612223] radeon_copy: result: 0, elapsed 5 usecs
[  213.616054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3736 usecs
[  213.616063] radeon_move_blit: new type: tt, old type: vram
[  213.616069] radeon_copy: result: 0, elapsed 5 usecs
[  213.616098] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  213.616109] radeon_move_blit: new type: tt, old type: vram
[  213.616114] radeon_copy: result: 0, elapsed 5 usecs
[  213.616136] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.616145] radeon_move_blit: new type: tt, old type: vram
[  213.616150] radeon_copy: result: 0, elapsed 5 usecs
[  213.616171] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.616181] radeon_move_blit: new type: tt, old type: vram
[  213.616186] radeon_copy: result: 0, elapsed 5 usecs
[  213.616207] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.616217] radeon_move_blit: new type: tt, old type: vram
[  213.616222] radeon_copy: result: 0, elapsed 5 usecs
[  213.616243] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.616253] radeon_move_blit: new type: tt, old type: vram
[  213.616258] radeon_copy: result: 0, elapsed 5 usecs
[  213.616279] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  213.616288] radeon_move_blit: new type: tt, old type: vram
[  213.616294] radeon_copy: result: 0, elapsed 5 usecs
[  213.616314] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  213.616327] radeon_move_blit: new type: tt, old type: vram
[  213.616333] radeon_copy: result: 0, elapsed 5 usecs
[  213.620055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3630 usecs
[  213.620064] radeon_move_blit: new type: tt, old type: vram
[  213.620069] radeon_copy: result: 0, elapsed 5 usecs
[  213.620098] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  213.620109] radeon_move_blit: new type: tt, old type: vram
[  213.620114] radeon_copy: result: 0, elapsed 5 usecs
[  213.620135] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.620145] radeon_move_blit: new type: tt, old type: vram
[  213.620150] radeon_copy: result: 0, elapsed 5 usecs
[  213.620184] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  213.620196] radeon_move_blit: new type: tt, old type: vram
[  213.620201] radeon_copy: result: 0, elapsed 5 usecs
[  213.624054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3757 usecs
[  213.624083] radeon_move_blit: new type: tt, old type: vram
[  213.624089] radeon_copy: result: 0, elapsed 5 usecs
[  213.823580] ttm_bo_move_accel_cleanup: result: 0, elapsed 194811 usecs
[  213.823594] radeon_move_blit: new type: tt, old type: vram
[  213.823600] radeon_copy: result: 0, elapsed 5 usecs
[  213.878543] ttm_bo_move_accel_cleanup: result: 0, elapsed 53651 usecs
[  213.878554] radeon_move_blit: new type: tt, old type: vram
[  213.878559] radeon_copy: result: 0, elapsed 5 usecs
[  213.878581] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  213.878591] radeon_move_blit: new type: tt, old type: vram
[  213.878596] radeon_copy: result: 0, elapsed 5 usecs
[  213.878624] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  213.880486] radeon_move_blit: new type: tt, old type: vram
[  213.880492] radeon_copy: result: 0, elapsed 6 usecs
[  214.851062] ttm_bo_move_accel_cleanup: result: 0, elapsed 947817 usecs
[  214.851090] radeon_move_blit: new type: tt, old type: vram
[  214.851096] radeon_copy: result: 0, elapsed 5 usecs
[  214.996062] ttm_bo_move_accel_cleanup: result: 0, elapsed 141564 usecs
[  214.996073] radeon_move_blit: new type: tt, old type: vram
[  214.996078] radeon_copy: result: 0, elapsed 4 usecs
[  214.996107] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  214.996118] radeon_move_blit: new type: tt, old type: vram
[  214.996123] radeon_copy: result: 0, elapsed 5 usecs
[  214.996144] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  214.996155] radeon_move_blit: new type: tt, old type: vram
[  214.996161] radeon_copy: result: 0, elapsed 5 usecs
[  214.996195] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  214.996207] radeon_move_blit: new type: tt, old type: vram
[  214.996213] radeon_copy: result: 0, elapsed 5 usecs
[  215.000055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3747 usecs
[  215.000070] radeon_move_blit: new type: tt, old type: vram
[  215.000076] radeon_copy: result: 0, elapsed 6 usecs
[  215.000093] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  215.000104] radeon_move_blit: new type: tt, old type: vram
[  215.000109] radeon_copy: result: 0, elapsed 5 usecs
[  215.000138] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  215.000149] radeon_move_blit: new type: tt, old type: vram
[  215.000154] radeon_copy: result: 0, elapsed 5 usecs
[  215.000175] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  215.000186] radeon_move_blit: new type: tt, old type: vram
[  215.000191] radeon_copy: result: 0, elapsed 5 usecs
[  215.000212] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  215.000222] radeon_move_blit: new type: tt, old type: vram
[  215.000227] radeon_copy: result: 0, elapsed 5 usecs
[  215.000248] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  215.000259] radeon_move_blit: new type: tt, old type: vram
[  215.000264] radeon_copy: result: 0, elapsed 5 usecs
[  215.000285] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  215.000296] radeon_move_blit: new type: tt, old type: vram
[  215.000301] radeon_copy: result: 0, elapsed 5 usecs
[  215.000338] ttm_bo_move_accel_cleanup: result: 0, elapsed 31 usecs
[  215.000347] radeon_move_blit: new type: tt, old type: vram
[  215.000353] radeon_copy: result: 0, elapsed 5 usecs
[  215.000372] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  215.000406] radeon_move_blit: new type: tt, old type: vram
[  215.000411] radeon_copy: result: 0, elapsed 5 usecs
[  215.278544] ttm_bo_move_accel_cleanup: result: 0, elapsed 271608 usecs
[  215.278554] radeon_move_blit: new type: tt, old type: vram
[  215.278559] radeon_copy: result: 0, elapsed 5 usecs
[  215.278589] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  215.278635] radeon_move_blit: new type: tt, old type: vram
[  215.278640] radeon_copy: result: 0, elapsed 5 usecs
[  215.588481] ttm_bo_move_accel_cleanup: result: 0, elapsed 302574 usecs
[  215.588491] radeon_move_blit: new type: tt, old type: vram
[  215.588497] radeon_copy: result: 0, elapsed 5 usecs
[  215.588526] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  215.588537] radeon_move_blit: new type: tt, old type: vram
[  215.588542] radeon_copy: result: 0, elapsed 5 usecs
[  215.588563] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  215.588574] radeon_move_blit: new type: tt, old type: vram
[  215.588579] radeon_copy: result: 0, elapsed 5 usecs
[  215.588601] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  215.590449] radeon_move_blit: new type: tt, old type: vram
[  215.590454] radeon_copy: result: 0, elapsed 6 usecs
[  216.651070] ttm_bo_move_accel_cleanup: result: 0, elapsed 1035752 usecs
[  216.651087] radeon_move_blit: new type: tt, old type: vram
[  216.651093] radeon_copy: result: 0, elapsed 6 usecs
[  216.678541] ttm_bo_move_accel_cleanup: result: 0, elapsed 26800 usecs
[  216.678553] radeon_move_blit: new type: tt, old type: vram
[  216.678559] radeon_copy: result: 0, elapsed 5 usecs
[  216.678575] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.678591] radeon_move_blit: new type: tt, old type: vram
[  216.678597] radeon_copy: result: 0, elapsed 5 usecs
[  216.678613] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.678623] radeon_move_blit: new type: tt, old type: vram
[  216.678628] radeon_copy: result: 0, elapsed 5 usecs
[  216.678657] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.678668] radeon_move_blit: new type: tt, old type: vram
[  216.678673] radeon_copy: result: 0, elapsed 5 usecs
[  216.678707] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.678716] radeon_move_blit: new type: tt, old type: vram
[  216.678722] radeon_copy: result: 0, elapsed 5 usecs
[  216.678743] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.678755] radeon_move_blit: new type: tt, old type: vram
[  216.678761] radeon_copy: result: 0, elapsed 5 usecs
[  216.680054] ttm_bo_move_accel_cleanup: result: 0, elapsed 1258 usecs
[  216.680067] radeon_move_blit: new type: tt, old type: vram
[  216.680072] radeon_copy: result: 0, elapsed 5 usecs
[  216.680111] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  216.680122] radeon_move_blit: new type: tt, old type: vram
[  216.680128] radeon_copy: result: 0, elapsed 5 usecs
[  216.684053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3828 usecs
[  216.684066] radeon_move_blit: new type: tt, old type: vram
[  216.684071] radeon_copy: result: 0, elapsed 5 usecs
[  216.684117] ttm_bo_move_accel_cleanup: result: 0, elapsed 40 usecs
[  216.684130] radeon_move_blit: new type: tt, old type: vram
[  216.684135] radeon_copy: result: 0, elapsed 5 usecs
[  216.684177] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  216.684190] radeon_move_blit: new type: tt, old type: vram
[  216.684195] radeon_copy: result: 0, elapsed 5 usecs
[  216.688054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3763 usecs
[  216.688064] radeon_move_blit: new type: tt, old type: vram
[  216.688070] radeon_copy: result: 0, elapsed 5 usecs
[  216.688086] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.688097] radeon_move_blit: new type: tt, old type: vram
[  216.688102] radeon_copy: result: 0, elapsed 5 usecs
[  216.688131] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.688142] radeon_move_blit: new type: tt, old type: vram
[  216.688148] radeon_copy: result: 0, elapsed 5 usecs
[  216.688187] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  216.688196] radeon_move_blit: new type: tt, old type: vram
[  216.688201] radeon_copy: result: 0, elapsed 5 usecs
[  216.688222] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.688233] radeon_move_blit: new type: tt, old type: vram
[  216.688239] radeon_copy: result: 0, elapsed 5 usecs
[  216.688259] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688270] radeon_move_blit: new type: tt, old type: vram
[  216.688275] radeon_copy: result: 0, elapsed 5 usecs
[  216.688296] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.688306] radeon_move_blit: new type: tt, old type: vram
[  216.688312] radeon_copy: result: 0, elapsed 5 usecs
[  216.688332] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688342] radeon_move_blit: new type: tt, old type: vram
[  216.688347] radeon_copy: result: 0, elapsed 5 usecs
[  216.688367] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688377] radeon_move_blit: new type: tt, old type: vram
[  216.688383] radeon_copy: result: 0, elapsed 5 usecs
[  216.688403] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688413] radeon_move_blit: new type: tt, old type: vram
[  216.688419] radeon_copy: result: 0, elapsed 5 usecs
[  216.688439] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688451] radeon_move_blit: new type: tt, old type: vram
[  216.688456] radeon_copy: result: 0, elapsed 5 usecs
[  216.688476] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688487] radeon_move_blit: new type: tt, old type: vram
[  216.688493] radeon_copy: result: 0, elapsed 5 usecs
[  216.688513] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688523] radeon_move_blit: new type: tt, old type: vram
[  216.688529] radeon_copy: result: 0, elapsed 5 usecs
[  216.688549] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688559] radeon_move_blit: new type: tt, old type: vram
[  216.688565] radeon_copy: result: 0, elapsed 5 usecs
[  216.688585] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.688598] radeon_move_blit: new type: tt, old type: vram
[  216.688604] radeon_copy: result: 0, elapsed 5 usecs
[  216.692053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3364 usecs
[  216.692064] radeon_move_blit: new type: tt, old type: vram
[  216.692070] radeon_copy: result: 0, elapsed 6 usecs
[  216.692086] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.692097] radeon_move_blit: new type: tt, old type: vram
[  216.692102] radeon_copy: result: 0, elapsed 5 usecs
[  216.692118] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.692133] radeon_move_blit: new type: tt, old type: vram
[  216.692139] radeon_copy: result: 0, elapsed 5 usecs
[  216.692155] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  216.692166] radeon_move_blit: new type: tt, old type: vram
[  216.692172] radeon_copy: result: 0, elapsed 5 usecs
[  216.692193] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.692205] radeon_move_blit: new type: tt, old type: vram
[  216.692210] radeon_copy: result: 0, elapsed 5 usecs
[  216.692231] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.692242] radeon_move_blit: new type: tt, old type: vram
[  216.692247] radeon_copy: result: 0, elapsed 5 usecs
[  216.692276] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.692294] radeon_move_blit: new type: tt, old type: vram
[  216.692299] radeon_copy: result: 0, elapsed 5 usecs
[  216.692338] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  216.692349] radeon_move_blit: new type: tt, old type: vram
[  216.692354] radeon_copy: result: 0, elapsed 5 usecs
[  216.692374] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692385] radeon_move_blit: new type: tt, old type: vram
[  216.692390] radeon_copy: result: 0, elapsed 5 usecs
[  216.692410] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692420] radeon_move_blit: new type: tt, old type: vram
[  216.692426] radeon_copy: result: 0, elapsed 5 usecs
[  216.692445] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692456] radeon_move_blit: new type: tt, old type: vram
[  216.692461] radeon_copy: result: 0, elapsed 5 usecs
[  216.692481] ttm_bo_move_accel_cleanup: result: 0, elapsed 14 usecs
[  216.692491] radeon_move_blit: new type: tt, old type: vram
[  216.692496] radeon_copy: result: 0, elapsed 5 usecs
[  216.692516] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692526] radeon_move_blit: new type: tt, old type: vram
[  216.692531] radeon_copy: result: 0, elapsed 5 usecs
[  216.692551] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692561] radeon_move_blit: new type: tt, old type: vram
[  216.692567] radeon_copy: result: 0, elapsed 5 usecs
[  216.692586] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692596] radeon_move_blit: new type: tt, old type: vram
[  216.692601] radeon_copy: result: 0, elapsed 5 usecs
[  216.692621] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692631] radeon_move_blit: new type: tt, old type: vram
[  216.692636] radeon_copy: result: 0, elapsed 5 usecs
[  216.692656] ttm_bo_move_accel_cleanup: result: 0, elapsed 14 usecs
[  216.692666] radeon_move_blit: new type: tt, old type: vram
[  216.692671] radeon_copy: result: 0, elapsed 5 usecs
[  216.692691] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692702] radeon_move_blit: new type: tt, old type: vram
[  216.692707] radeon_copy: result: 0, elapsed 5 usecs
[  216.692727] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692737] radeon_move_blit: new type: tt, old type: vram
[  216.692742] radeon_copy: result: 0, elapsed 5 usecs
[  216.692763] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692773] radeon_move_blit: new type: tt, old type: vram
[  216.692778] radeon_copy: result: 0, elapsed 5 usecs
[  216.692806] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.692815] radeon_move_blit: new type: tt, old type: vram
[  216.692821] radeon_copy: result: 0, elapsed 5 usecs
[  216.692849] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.692858] radeon_move_blit: new type: tt, old type: vram
[  216.692864] radeon_copy: result: 0, elapsed 5 usecs
[  216.692892] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.692901] radeon_move_blit: new type: tt, old type: vram
[  216.692906] radeon_copy: result: 0, elapsed 5 usecs
[  216.692934] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.692943] radeon_move_blit: new type: tt, old type: vram
[  216.692949] radeon_copy: result: 0, elapsed 5 usecs
[  216.692969] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.692978] radeon_move_blit: new type: tt, old type: vram
[  216.692983] radeon_copy: result: 0, elapsed 5 usecs
[  216.693003] ttm_bo_move_accel_cleanup: result: 0, elapsed 14 usecs
[  216.693014] radeon_move_blit: new type: tt, old type: vram
[  216.693019] radeon_copy: result: 0, elapsed 5 usecs
[  216.696054] ttm_bo_move_accel_cleanup: result: 0, elapsed 2959 usecs
[  216.696064] radeon_move_blit: new type: tt, old type: vram
[  216.696070] radeon_copy: result: 0, elapsed 5 usecs
[  216.696116] ttm_bo_move_accel_cleanup: result: 0, elapsed 40 usecs
[  216.696127] radeon_move_blit: new type: tt, old type: vram
[  216.696132] radeon_copy: result: 0, elapsed 5 usecs
[  216.696170] ttm_bo_move_accel_cleanup: result: 0, elapsed 32 usecs
[  216.696181] radeon_move_blit: new type: tt, old type: vram
[  216.696187] radeon_copy: result: 0, elapsed 5 usecs
[  216.700053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3771 usecs
[  216.700064] radeon_move_blit: new type: tt, old type: vram
[  216.700069] radeon_copy: result: 0, elapsed 5 usecs
[  216.700116] ttm_bo_move_accel_cleanup: result: 0, elapsed 41 usecs
[  216.700130] radeon_move_blit: new type: tt, old type: vram
[  216.700135] radeon_copy: result: 0, elapsed 5 usecs
[  216.700152] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.700162] radeon_move_blit: new type: tt, old type: vram
[  216.700167] radeon_copy: result: 0, elapsed 5 usecs
[  216.700201] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  216.700210] radeon_move_blit: new type: tt, old type: vram
[  216.700215] radeon_copy: result: 0, elapsed 5 usecs
[  216.700244] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700253] radeon_move_blit: new type: tt, old type: vram
[  216.700259] radeon_copy: result: 0, elapsed 5 usecs
[  216.700287] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700297] radeon_move_blit: new type: tt, old type: vram
[  216.700302] radeon_copy: result: 0, elapsed 5 usecs
[  216.700330] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700340] radeon_move_blit: new type: tt, old type: vram
[  216.700345] radeon_copy: result: 0, elapsed 5 usecs
[  216.700365] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.700376] radeon_move_blit: new type: tt, old type: vram
[  216.700381] radeon_copy: result: 0, elapsed 5 usecs
[  216.700409] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700420] radeon_move_blit: new type: tt, old type: vram
[  216.700426] radeon_copy: result: 0, elapsed 5 usecs
[  216.700453] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.700463] radeon_move_blit: new type: tt, old type: vram
[  216.700468] radeon_copy: result: 0, elapsed 5 usecs
[  216.700496] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.700505] radeon_move_blit: new type: tt, old type: vram
[  216.700511] radeon_copy: result: 0, elapsed 5 usecs
[  216.700539] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700550] radeon_move_blit: new type: tt, old type: vram
[  216.700555] radeon_copy: result: 0, elapsed 5 usecs
[  216.700576] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.700586] radeon_move_blit: new type: tt, old type: vram
[  216.700591] radeon_copy: result: 0, elapsed 5 usecs
[  216.700620] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700629] radeon_move_blit: new type: tt, old type: vram
[  216.700635] radeon_copy: result: 0, elapsed 5 usecs
[  216.700663] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.700675] radeon_move_blit: new type: tt, old type: vram
[  216.700681] radeon_copy: result: 0, elapsed 5 usecs
[  216.704054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3289 usecs
[  216.704064] radeon_move_blit: new type: tt, old type: vram
[  216.704069] radeon_copy: result: 0, elapsed 5 usecs
[  216.704110] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  216.704120] radeon_move_blit: new type: tt, old type: vram
[  216.704126] radeon_copy: result: 0, elapsed 5 usecs
[  216.704159] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.704170] radeon_move_blit: new type: tt, old type: vram
[  216.704176] radeon_copy: result: 0, elapsed 5 usecs
[  216.708054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3782 usecs
[  216.708065] radeon_move_blit: new type: tt, old type: vram
[  216.708070] radeon_copy: result: 0, elapsed 5 usecs
[  216.708086] ttm_bo_move_accel_cleanup: result: 0, elapsed 10 usecs
[  216.708097] radeon_move_blit: new type: tt, old type: vram
[  216.708102] radeon_copy: result: 0, elapsed 5 usecs
[  216.708143] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  216.708154] radeon_move_blit: new type: tt, old type: vram
[  216.708159] radeon_copy: result: 0, elapsed 5 usecs
[  216.708192] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.708202] radeon_move_blit: new type: tt, old type: vram
[  216.708207] radeon_copy: result: 0, elapsed 5 usecs
[  216.708235] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.708245] radeon_move_blit: new type: tt, old type: vram
[  216.708251] radeon_copy: result: 0, elapsed 5 usecs
[  216.708280] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.708291] radeon_move_blit: new type: tt, old type: vram
[  216.708296] radeon_copy: result: 0, elapsed 5 usecs
[  216.712054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3665 usecs
[  216.712065] radeon_move_blit: new type: tt, old type: vram
[  216.712070] radeon_copy: result: 0, elapsed 5 usecs
[  216.712091] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.712101] radeon_move_blit: new type: tt, old type: vram
[  216.712106] radeon_copy: result: 0, elapsed 5 usecs
[  216.712147] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  216.712159] radeon_move_blit: new type: tt, old type: vram
[  216.712164] radeon_copy: result: 0, elapsed 5 usecs
[  216.712212] ttm_bo_move_accel_cleanup: result: 0, elapsed 41 usecs
[  216.712222] radeon_move_blit: new type: tt, old type: vram
[  216.712227] radeon_copy: result: 0, elapsed 5 usecs
[  216.712255] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.712271] radeon_move_blit: new type: tt, old type: vram
[  216.712276] radeon_copy: result: 0, elapsed 5 usecs
[  216.712305] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.712317] radeon_move_blit: new type: tt, old type: vram
[  216.712322] radeon_copy: result: 0, elapsed 5 usecs
[  216.716059] ttm_bo_move_accel_cleanup: result: 0, elapsed 3644 usecs
[  216.716069] radeon_move_blit: new type: tt, old type: vram
[  216.716074] radeon_copy: result: 0, elapsed 5 usecs
[  216.716104] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.716114] radeon_move_blit: new type: tt, old type: vram
[  216.716119] radeon_copy: result: 0, elapsed 5 usecs
[  216.716140] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.716150] radeon_move_blit: new type: tt, old type: vram
[  216.716155] radeon_copy: result: 0, elapsed 5 usecs
[  216.716176] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.716190] radeon_move_blit: new type: tt, old type: vram
[  216.716196] radeon_copy: result: 0, elapsed 5 usecs
[  216.716212] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.716224] radeon_move_blit: new type: tt, old type: vram
[  216.716229] radeon_copy: result: 0, elapsed 5 usecs
[  216.716263] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.716272] radeon_move_blit: new type: tt, old type: vram
[  216.716278] radeon_copy: result: 0, elapsed 5 usecs
[  216.716307] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.716316] radeon_move_blit: new type: tt, old type: vram
[  216.716321] radeon_copy: result: 0, elapsed 5 usecs
[  216.716349] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.716359] radeon_move_blit: new type: tt, old type: vram
[  216.716364] radeon_copy: result: 0, elapsed 5 usecs
[  216.716384] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.716394] radeon_move_blit: new type: tt, old type: vram
[  216.716399] radeon_copy: result: 0, elapsed 5 usecs
[  216.716419] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.716429] radeon_move_blit: new type: tt, old type: vram
[  216.716434] radeon_copy: result: 0, elapsed 5 usecs
[  216.716462] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.716471] radeon_move_blit: new type: tt, old type: vram
[  216.716477] radeon_copy: result: 0, elapsed 5 usecs
[  216.720053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3487 usecs
[  216.720062] radeon_move_blit: new type: tt, old type: vram
[  216.720067] radeon_copy: result: 0, elapsed 5 usecs
[  216.720109] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  216.720122] radeon_move_blit: new type: tt, old type: vram
[  216.720127] radeon_copy: result: 0, elapsed 5 usecs
[  216.724054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3830 usecs
[  216.724066] radeon_move_blit: new type: tt, old type: vram
[  216.724071] radeon_copy: result: 0, elapsed 5 usecs
[  216.724101] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.724112] radeon_move_blit: new type: tt, old type: vram
[  216.724117] radeon_copy: result: 0, elapsed 5 usecs
[  216.724133] ttm_bo_move_accel_cleanup: result: 0, elapsed 10 usecs
[  216.724143] radeon_move_blit: new type: tt, old type: vram
[  216.724148] radeon_copy: result: 0, elapsed 5 usecs
[  216.724171] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  216.724183] radeon_move_blit: new type: tt, old type: vram
[  216.724188] radeon_copy: result: 0, elapsed 5 usecs
[  216.724209] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.724220] radeon_move_blit: new type: tt, old type: vram
[  216.724225] radeon_copy: result: 0, elapsed 5 usecs
[  216.724246] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.724257] radeon_move_blit: new type: tt, old type: vram
[  216.724263] radeon_copy: result: 0, elapsed 5 usecs
[  216.724284] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.724295] radeon_move_blit: new type: tt, old type: vram
[  216.724301] radeon_copy: result: 0, elapsed 5 usecs
[  216.724321] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.724332] radeon_move_blit: new type: tt, old type: vram
[  216.724337] radeon_copy: result: 0, elapsed 5 usecs
[  216.724358] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.724370] radeon_move_blit: new type: tt, old type: vram
[  216.724375] radeon_copy: result: 0, elapsed 5 usecs
[  216.724395] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.724412] radeon_move_blit: new type: tt, old type: vram
[  216.724417] radeon_copy: result: 0, elapsed 5 usecs
[  216.724450] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.724462] radeon_move_blit: new type: tt, old type: vram
[  216.724467] radeon_copy: result: 0, elapsed 5 usecs
[  216.728055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3498 usecs
[  216.728067] radeon_move_blit: new type: tt, old type: vram
[  216.728072] radeon_copy: result: 0, elapsed 5 usecs
[  216.728119] ttm_bo_move_accel_cleanup: result: 0, elapsed 41 usecs
[  216.728129] radeon_move_blit: new type: tt, old type: vram
[  216.728135] radeon_copy: result: 0, elapsed 5 usecs
[  216.728155] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.728166] radeon_move_blit: new type: tt, old type: vram
[  216.728172] radeon_copy: result: 0, elapsed 5 usecs
[  216.728205] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.728215] radeon_move_blit: new type: tt, old type: vram
[  216.728221] radeon_copy: result: 0, elapsed 5 usecs
[  216.732052] ttm_bo_move_accel_cleanup: result: 0, elapsed 3737 usecs
[  216.732066] radeon_move_blit: new type: tt, old type: vram
[  216.732072] radeon_copy: result: 0, elapsed 5 usecs
[  216.732088] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.732098] radeon_move_blit: new type: tt, old type: vram
[  216.732104] radeon_copy: result: 0, elapsed 5 usecs
[  216.732145] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  216.732155] radeon_move_blit: new type: tt, old type: vram
[  216.732160] radeon_copy: result: 0, elapsed 5 usecs
[  216.732181] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.732192] radeon_move_blit: new type: tt, old type: vram
[  216.732198] radeon_copy: result: 0, elapsed 5 usecs
[  216.732219] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.732230] radeon_move_blit: new type: tt, old type: vram
[  216.732235] radeon_copy: result: 0, elapsed 5 usecs
[  216.732257] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  216.732268] radeon_move_blit: new type: tt, old type: vram
[  216.732273] radeon_copy: result: 0, elapsed 5 usecs
[  216.732290] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  216.732302] radeon_move_blit: new type: tt, old type: vram
[  216.732307] radeon_copy: result: 0, elapsed 5 usecs
[  216.732328] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.732337] radeon_move_blit: new type: tt, old type: vram
[  216.732343] radeon_copy: result: 0, elapsed 5 usecs
[  216.732375] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  216.732385] radeon_move_blit: new type: tt, old type: vram
[  216.732390] radeon_copy: result: 0, elapsed 5 usecs
[  216.732418] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.732428] radeon_move_blit: new type: tt, old type: vram
[  216.732433] radeon_copy: result: 0, elapsed 5 usecs
[  216.732454] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.732464] radeon_move_blit: new type: tt, old type: vram
[  216.732469] radeon_copy: result: 0, elapsed 5 usecs
[  216.732497] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.732506] radeon_move_blit: new type: tt, old type: vram
[  216.732511] radeon_copy: result: 0, elapsed 5 usecs
[  216.732532] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.732541] radeon_move_blit: new type: tt, old type: vram
[  216.732547] radeon_copy: result: 0, elapsed 5 usecs
[  216.732567] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.732577] radeon_move_blit: new type: tt, old type: vram
[  216.732582] radeon_copy: result: 0, elapsed 5 usecs
[  216.732610] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.732622] radeon_move_blit: new type: tt, old type: vram
[  216.732627] radeon_copy: result: 0, elapsed 5 usecs
[  216.736054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3341 usecs
[  216.736064] radeon_move_blit: new type: tt, old type: vram
[  216.736069] radeon_copy: result: 0, elapsed 5 usecs
[  216.736111] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  216.736120] radeon_move_blit: new type: tt, old type: vram
[  216.736126] radeon_copy: result: 0, elapsed 5 usecs
[  216.736147] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.736159] radeon_move_blit: new type: tt, old type: vram
[  216.736164] radeon_copy: result: 0, elapsed 5 usecs
[  216.740053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3793 usecs
[  216.740063] radeon_move_blit: new type: tt, old type: vram
[  216.740068] radeon_copy: result: 0, elapsed 5 usecs
[  216.740110] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  216.740120] radeon_move_blit: new type: tt, old type: vram
[  216.740125] radeon_copy: result: 0, elapsed 5 usecs
[  216.740147] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.740158] radeon_move_blit: new type: tt, old type: vram
[  216.740163] radeon_copy: result: 0, elapsed 5 usecs
[  216.740205] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  216.740216] radeon_move_blit: new type: tt, old type: vram
[  216.740221] radeon_copy: result: 0, elapsed 5 usecs
[  216.744055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3739 usecs
[  216.744067] radeon_move_blit: new type: tt, old type: vram
[  216.744072] radeon_copy: result: 0, elapsed 5 usecs
[  216.771599] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  216.771609] radeon_move_blit: new type: tt, old type: vram
[  216.771615] radeon_copy: result: 0, elapsed 5 usecs
[  216.771644] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.771657] radeon_move_blit: new type: tt, old type: vram
[  216.771662] radeon_copy: result: 0, elapsed 5 usecs
[  216.771701] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  216.771720] radeon_move_blit: new type: tt, old type: vram
[  216.771725] radeon_copy: result: 0, elapsed 5 usecs
[  216.776055] ttm_bo_move_accel_cleanup: result: 0, elapsed 4223 usecs
[  216.776066] radeon_move_blit: new type: tt, old type: vram
[  216.776071] radeon_copy: result: 0, elapsed 5 usecs
[  216.776112] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  216.776123] radeon_move_blit: new type: tt, old type: vram
[  216.776128] radeon_copy: result: 0, elapsed 5 usecs
[  216.776162] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.776172] radeon_move_blit: new type: tt, old type: vram
[  216.776177] radeon_copy: result: 0, elapsed 5 usecs
[  216.776198] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.776209] radeon_move_blit: new type: tt, old type: vram
[  216.776214] radeon_copy: result: 0, elapsed 5 usecs
[  216.776236] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.776247] radeon_move_blit: new type: tt, old type: vram
[  216.776253] radeon_copy: result: 0, elapsed 5 usecs
[  216.776274] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.776285] radeon_move_blit: new type: tt, old type: vram
[  216.776290] radeon_copy: result: 0, elapsed 5 usecs
[  216.776311] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.776322] radeon_move_blit: new type: tt, old type: vram
[  216.776327] radeon_copy: result: 0, elapsed 5 usecs
[  216.776348] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.776358] radeon_move_blit: new type: tt, old type: vram
[  216.776364] radeon_copy: result: 0, elapsed 5 usecs
[  216.776392] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.776402] radeon_move_blit: new type: tt, old type: vram
[  216.776407] radeon_copy: result: 0, elapsed 5 usecs
[  216.776427] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.776438] radeon_move_blit: new type: tt, old type: vram
[  216.776443] radeon_copy: result: 0, elapsed 5 usecs
[  216.776463] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.776473] radeon_move_blit: new type: tt, old type: vram
[  216.776479] radeon_copy: result: 0, elapsed 5 usecs
[  216.776499] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.776509] radeon_move_blit: new type: tt, old type: vram
[  216.776515] radeon_copy: result: 0, elapsed 5 usecs
[  216.776543] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  216.776554] radeon_move_blit: new type: tt, old type: vram
[  216.776559] radeon_copy: result: 0, elapsed 5 usecs
[  216.780053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3407 usecs
[  216.780064] radeon_move_blit: new type: tt, old type: vram
[  216.780070] radeon_copy: result: 0, elapsed 5 usecs
[  216.780116] ttm_bo_move_accel_cleanup: result: 0, elapsed 40 usecs
[  216.780126] radeon_move_blit: new type: tt, old type: vram
[  216.780132] radeon_copy: result: 0, elapsed 5 usecs
[  216.780153] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.780165] radeon_move_blit: new type: tt, old type: vram
[  216.780170] radeon_copy: result: 0, elapsed 6 usecs
[  216.780212] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  216.780228] radeon_move_blit: new type: tt, old type: vram
[  216.780233] radeon_copy: result: 0, elapsed 5 usecs
[  216.784052] ttm_bo_move_accel_cleanup: result: 0, elapsed 3724 usecs
[  216.784064] radeon_move_blit: new type: tt, old type: vram
[  216.784069] radeon_copy: result: 0, elapsed 5 usecs
[  216.784091] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.784102] radeon_move_blit: new type: tt, old type: vram
[  216.784107] radeon_copy: result: 0, elapsed 5 usecs
[  216.784136] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.784148] radeon_move_blit: new type: tt, old type: vram
[  216.784153] radeon_copy: result: 0, elapsed 5 usecs
[  216.784169] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.784180] radeon_move_blit: new type: tt, old type: vram
[  216.784185] radeon_copy: result: 0, elapsed 5 usecs
[  216.784207] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.784217] radeon_move_blit: new type: tt, old type: vram
[  216.784223] radeon_copy: result: 0, elapsed 5 usecs
[  216.784244] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.784256] radeon_move_blit: new type: tt, old type: vram
[  216.784262] radeon_copy: result: 0, elapsed 5 usecs
[  216.784301] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  216.784311] radeon_move_blit: new type: tt, old type: vram
[  216.784317] radeon_copy: result: 0, elapsed 5 usecs
[  216.788053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3644 usecs
[  216.788063] radeon_move_blit: new type: tt, old type: vram
[  216.788068] radeon_copy: result: 0, elapsed 5 usecs
[  216.788098] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  216.788109] radeon_move_blit: new type: tt, old type: vram
[  216.788114] radeon_copy: result: 0, elapsed 5 usecs
[  216.788130] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.788142] radeon_move_blit: new type: tt, old type: vram
[  216.788147] radeon_copy: result: 0, elapsed 5 usecs
[  216.788169] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.788179] radeon_move_blit: new type: tt, old type: vram
[  216.788185] radeon_copy: result: 0, elapsed 5 usecs
[  216.788200] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  216.788211] radeon_move_blit: new type: tt, old type: vram
[  216.788216] radeon_copy: result: 0, elapsed 5 usecs
[  216.788237] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.788248] radeon_move_blit: new type: tt, old type: vram
[  216.788253] radeon_copy: result: 0, elapsed 5 usecs
[  216.788286] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.788296] radeon_move_blit: new type: tt, old type: vram
[  216.788302] radeon_copy: result: 0, elapsed 5 usecs
[  216.788322] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.788331] radeon_move_blit: new type: tt, old type: vram
[  216.788337] radeon_copy: result: 0, elapsed 5 usecs
[  216.788357] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.788367] radeon_move_blit: new type: tt, old type: vram
[  216.788372] radeon_copy: result: 0, elapsed 5 usecs
[  216.788392] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.788403] radeon_move_blit: new type: tt, old type: vram
[  216.788409] radeon_copy: result: 0, elapsed 5 usecs
[  216.788436] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  216.788446] radeon_move_blit: new type: tt, old type: vram
[  216.788451] radeon_copy: result: 0, elapsed 5 usecs
[  216.788471] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  216.788482] radeon_move_blit: new type: tt, old type: vram
[  216.788488] radeon_copy: result: 0, elapsed 5 usecs
[  216.792054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3478 usecs
[  216.792064] radeon_move_blit: new type: tt, old type: vram
[  216.792070] radeon_copy: result: 0, elapsed 5 usecs
[  216.792092] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  216.792105] radeon_move_blit: new type: tt, old type: vram
[  216.792110] radeon_copy: result: 0, elapsed 5 usecs
[  216.792131] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.792143] radeon_move_blit: new type: tt, old type: vram
[  216.792149] radeon_copy: result: 0, elapsed 5 usecs
[  216.792170] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  216.792182] radeon_move_blit: new type: tt, old type: vram
[  216.792187] radeon_copy: result: 0, elapsed 5 usecs
[  216.792221] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  216.792236] radeon_move_blit: new type: tt, old type: vram
[  216.792241] radeon_copy: result: 0, elapsed 5 usecs
[  216.796062] ttm_bo_move_accel_cleanup: result: 0, elapsed 3727 usecs
[  216.801811] radeon_move_blit: new type: tt, old type: vram
[  216.801817] radeon_copy: result: 0, elapsed 6 usecs
[  222.223589] ttm_bo_move_accel_cleanup: result: 0, elapsed 5294693 usecs
[  222.223608] radeon_move_blit: new type: tt, old type: vram
[  222.223614] radeon_copy: result: 0, elapsed 6 usecs
[  222.251062] ttm_bo_move_accel_cleanup: result: 0, elapsed 26799 usecs
[  222.251074] radeon_move_blit: new type: tt, old type: vram
[  222.251079] radeon_copy: result: 0, elapsed 5 usecs
[  222.278548] ttm_bo_move_accel_cleanup: result: 0, elapsed 26820 usecs
[  222.278560] radeon_move_blit: new type: tt, old type: vram
[  222.278566] radeon_copy: result: 0, elapsed 5 usecs
[  222.278583] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  222.278595] radeon_move_blit: new type: tt, old type: vram
[  222.278601] radeon_copy: result: 0, elapsed 5 usecs
[  222.306031] ttm_bo_move_accel_cleanup: result: 0, elapsed 26782 usecs
[  222.306043] radeon_move_blit: new type: tt, old type: vram
[  222.306048] radeon_copy: result: 0, elapsed 5 usecs
[  222.333514] ttm_bo_move_accel_cleanup: result: 0, elapsed 26817 usecs
[  222.333525] radeon_move_blit: new type: tt, old type: vram
[  222.333530] radeon_copy: result: 0, elapsed 5 usecs
[  222.333546] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  222.333561] radeon_move_blit: new type: tt, old type: vram
[  222.333566] radeon_copy: result: 0, elapsed 5 usecs
[  222.333605] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  222.335382] radeon_move_blit: new type: tt, old type: vram
[  222.335388] radeon_copy: result: 0, elapsed 6 usecs
[  222.733507] ttm_bo_move_accel_cleanup: result: 0, elapsed 388782 usecs
[  222.733560] radeon_move_blit: new type: tt, old type: vram
[  222.733565] radeon_copy: result: 0, elapsed 5 usecs
[  223.196063] ttm_bo_move_accel_cleanup: result: 0, elapsed 451653 usecs
[  223.196103] radeon_move_blit: new type: tt, old type: vram
[  223.196109] radeon_copy: result: 0, elapsed 5 usecs
[  223.561008] ttm_bo_move_accel_cleanup: result: 0, elapsed 356343 usecs
[  223.561023] radeon_move_blit: new type: tt, old type: vram
[  223.561028] radeon_copy: result: 0, elapsed 5 usecs
[  223.596064] ttm_bo_move_accel_cleanup: result: 0, elapsed 34210 usecs
[  223.596074] radeon_move_blit: new type: tt, old type: vram
[  223.596080] radeon_copy: result: 0, elapsed 5 usecs
[  223.596096] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.596107] radeon_move_blit: new type: tt, old type: vram
[  223.596112] radeon_copy: result: 0, elapsed 5 usecs
[  223.596154] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  223.596165] radeon_move_blit: new type: tt, old type: vram
[  223.596170] radeon_copy: result: 0, elapsed 5 usecs
[  223.596203] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  223.596213] radeon_move_blit: new type: tt, old type: vram
[  223.596218] radeon_copy: result: 0, elapsed 5 usecs
[  223.596247] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.596258] radeon_move_blit: new type: tt, old type: vram
[  223.596263] radeon_copy: result: 0, elapsed 5 usecs
[  223.596284] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.596295] radeon_move_blit: new type: tt, old type: vram
[  223.596300] radeon_copy: result: 0, elapsed 5 usecs
[  223.596329] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.596338] radeon_move_blit: new type: tt, old type: vram
[  223.596344] radeon_copy: result: 0, elapsed 5 usecs
[  223.596371] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.596382] radeon_move_blit: new type: tt, old type: vram
[  223.596387] radeon_copy: result: 0, elapsed 5 usecs
[  223.596408] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.596417] radeon_move_blit: new type: tt, old type: vram
[  223.596423] radeon_copy: result: 0, elapsed 5 usecs
[  223.596451] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.596460] radeon_move_blit: new type: tt, old type: vram
[  223.596465] radeon_copy: result: 0, elapsed 5 usecs
[  223.596493] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.596503] radeon_move_blit: new type: tt, old type: vram
[  223.596509] radeon_copy: result: 0, elapsed 5 usecs
[  223.596529] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.596539] radeon_move_blit: new type: tt, old type: vram
[  223.596545] radeon_copy: result: 0, elapsed 5 usecs
[  223.596573] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.596582] radeon_move_blit: new type: tt, old type: vram
[  223.596587] radeon_copy: result: 0, elapsed 5 usecs
[  223.596615] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.596626] radeon_move_blit: new type: tt, old type: vram
[  223.596632] radeon_copy: result: 0, elapsed 5 usecs
[  223.596653] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.596665] radeon_move_blit: new type: tt, old type: vram
[  223.596670] radeon_copy: result: 0, elapsed 5 usecs
[  223.600053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3298 usecs
[  223.600065] radeon_move_blit: new type: tt, old type: vram
[  223.600070] radeon_copy: result: 0, elapsed 5 usecs
[  223.600122] ttm_bo_move_accel_cleanup: result: 0, elapsed 45 usecs
[  223.600133] radeon_move_blit: new type: tt, old type: vram
[  223.600138] radeon_copy: result: 0, elapsed 5 usecs
[  223.600154] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.600165] radeon_move_blit: new type: tt, old type: vram
[  223.600171] radeon_copy: result: 0, elapsed 5 usecs
[  223.600204] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  223.600214] radeon_move_blit: new type: tt, old type: vram
[  223.600219] radeon_copy: result: 0, elapsed 5 usecs
[  223.600248] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.600259] radeon_move_blit: new type: tt, old type: vram
[  223.600265] radeon_copy: result: 0, elapsed 5 usecs
[  223.600286] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.600296] radeon_move_blit: new type: tt, old type: vram
[  223.600302] radeon_copy: result: 0, elapsed 5 usecs
[  223.600330] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.600340] radeon_move_blit: new type: tt, old type: vram
[  223.600345] radeon_copy: result: 0, elapsed 5 usecs
[  223.600374] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.600384] radeon_move_blit: new type: tt, old type: vram
[  223.600390] radeon_copy: result: 0, elapsed 5 usecs
[  223.600418] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.600427] radeon_move_blit: new type: tt, old type: vram
[  223.600433] radeon_copy: result: 0, elapsed 5 usecs
[  223.600465] ttm_bo_move_accel_cleanup: result: 0, elapsed 26 usecs
[  223.600474] radeon_move_blit: new type: tt, old type: vram
[  223.600480] radeon_copy: result: 0, elapsed 5 usecs
[  223.600507] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.600517] radeon_move_blit: new type: tt, old type: vram
[  223.600522] radeon_copy: result: 0, elapsed 5 usecs
[  223.600551] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.600560] radeon_move_blit: new type: tt, old type: vram
[  223.600566] radeon_copy: result: 0, elapsed 5 usecs
[  223.600586] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600597] radeon_move_blit: new type: tt, old type: vram
[  223.600603] radeon_copy: result: 0, elapsed 5 usecs
[  223.600623] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600633] radeon_move_blit: new type: tt, old type: vram
[  223.600639] radeon_copy: result: 0, elapsed 5 usecs
[  223.600659] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600670] radeon_move_blit: new type: tt, old type: vram
[  223.600675] radeon_copy: result: 0, elapsed 5 usecs
[  223.600695] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600705] radeon_move_blit: new type: tt, old type: vram
[  223.600711] radeon_copy: result: 0, elapsed 5 usecs
[  223.600738] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.600749] radeon_move_blit: new type: tt, old type: vram
[  223.600754] radeon_copy: result: 0, elapsed 5 usecs
[  223.600775] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600785] radeon_move_blit: new type: tt, old type: vram
[  223.600790] radeon_copy: result: 0, elapsed 5 usecs
[  223.600810] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600823] radeon_move_blit: new type: tt, old type: vram
[  223.600828] radeon_copy: result: 0, elapsed 5 usecs
[  223.600848] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600859] radeon_move_blit: new type: tt, old type: vram
[  223.600864] radeon_copy: result: 0, elapsed 5 usecs
[  223.600884] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600895] radeon_move_blit: new type: tt, old type: vram
[  223.600900] radeon_copy: result: 0, elapsed 5 usecs
[  223.600921] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600932] radeon_move_blit: new type: tt, old type: vram
[  223.600937] radeon_copy: result: 0, elapsed 5 usecs
[  223.600957] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.600968] radeon_move_blit: new type: tt, old type: vram
[  223.600974] radeon_copy: result: 0, elapsed 5 usecs
[  223.600994] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601005] radeon_move_blit: new type: tt, old type: vram
[  223.601010] radeon_copy: result: 0, elapsed 5 usecs
[  223.601030] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601046] radeon_move_blit: new type: tt, old type: vram
[  223.601051] radeon_copy: result: 0, elapsed 5 usecs
[  223.601072] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.601083] radeon_move_blit: new type: tt, old type: vram
[  223.601088] radeon_copy: result: 0, elapsed 5 usecs
[  223.601108] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601118] radeon_move_blit: new type: tt, old type: vram
[  223.601123] radeon_copy: result: 0, elapsed 5 usecs
[  223.601144] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601153] radeon_move_blit: new type: tt, old type: vram
[  223.601158] radeon_copy: result: 0, elapsed 5 usecs
[  223.601179] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601189] radeon_move_blit: new type: tt, old type: vram
[  223.601195] radeon_copy: result: 0, elapsed 5 usecs
[  223.601215] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601227] radeon_move_blit: new type: tt, old type: vram
[  223.601233] radeon_copy: result: 0, elapsed 5 usecs
[  223.601253] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601263] radeon_move_blit: new type: tt, old type: vram
[  223.601268] radeon_copy: result: 0, elapsed 5 usecs
[  223.601288] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601298] radeon_move_blit: new type: tt, old type: vram
[  223.601304] radeon_copy: result: 0, elapsed 5 usecs
[  223.601324] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601335] radeon_move_blit: new type: tt, old type: vram
[  223.601340] radeon_copy: result: 0, elapsed 5 usecs
[  223.601360] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601371] radeon_move_blit: new type: tt, old type: vram
[  223.601376] radeon_copy: result: 0, elapsed 5 usecs
[  223.601396] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601406] radeon_move_blit: new type: tt, old type: vram
[  223.601412] radeon_copy: result: 0, elapsed 5 usecs
[  223.601432] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601443] radeon_move_blit: new type: tt, old type: vram
[  223.601448] radeon_copy: result: 0, elapsed 5 usecs
[  223.601468] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601479] radeon_move_blit: new type: tt, old type: vram
[  223.601484] radeon_copy: result: 0, elapsed 5 usecs
[  223.601504] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601515] radeon_move_blit: new type: tt, old type: vram
[  223.601520] radeon_copy: result: 0, elapsed 5 usecs
[  223.601541] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601552] radeon_move_blit: new type: tt, old type: vram
[  223.601557] radeon_copy: result: 0, elapsed 5 usecs
[  223.601578] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601589] radeon_move_blit: new type: tt, old type: vram
[  223.601594] radeon_copy: result: 0, elapsed 5 usecs
[  223.601614] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601625] radeon_move_blit: new type: tt, old type: vram
[  223.601630] radeon_copy: result: 0, elapsed 5 usecs
[  223.601650] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.601662] radeon_move_blit: new type: tt, old type: vram
[  223.601667] radeon_copy: result: 0, elapsed 5 usecs
[  223.604053] ttm_bo_move_accel_cleanup: result: 0, elapsed 2325 usecs
[  223.604064] radeon_move_blit: new type: tt, old type: vram
[  223.604069] radeon_copy: result: 0, elapsed 5 usecs
[  223.604098] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.604110] radeon_move_blit: new type: tt, old type: vram
[  223.604115] radeon_copy: result: 0, elapsed 5 usecs
[  223.604136] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.604147] radeon_move_blit: new type: tt, old type: vram
[  223.604152] radeon_copy: result: 0, elapsed 5 usecs
[  223.604169] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.604179] radeon_move_blit: new type: tt, old type: vram
[  223.604185] radeon_copy: result: 0, elapsed 5 usecs
[  223.604206] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.604220] radeon_move_blit: new type: tt, old type: vram
[  223.604225] radeon_copy: result: 0, elapsed 5 usecs
[  223.604266] ttm_bo_move_accel_cleanup: result: 0, elapsed 34 usecs
[  223.604276] radeon_move_blit: new type: tt, old type: vram
[  223.604281] radeon_copy: result: 0, elapsed 5 usecs
[  223.604302] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.604313] radeon_move_blit: new type: tt, old type: vram
[  223.604319] radeon_copy: result: 0, elapsed 5 usecs
[  223.604339] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604350] radeon_move_blit: new type: tt, old type: vram
[  223.604355] radeon_copy: result: 0, elapsed 5 usecs
[  223.604375] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604386] radeon_move_blit: new type: tt, old type: vram
[  223.604392] radeon_copy: result: 0, elapsed 5 usecs
[  223.604411] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604422] radeon_move_blit: new type: tt, old type: vram
[  223.604428] radeon_copy: result: 0, elapsed 5 usecs
[  223.604448] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604459] radeon_move_blit: new type: tt, old type: vram
[  223.604465] radeon_copy: result: 0, elapsed 5 usecs
[  223.604485] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604495] radeon_move_blit: new type: tt, old type: vram
[  223.604500] radeon_copy: result: 0, elapsed 5 usecs
[  223.604520] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604531] radeon_move_blit: new type: tt, old type: vram
[  223.604536] radeon_copy: result: 0, elapsed 5 usecs
[  223.604556] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.604569] radeon_move_blit: new type: tt, old type: vram
[  223.604574] radeon_copy: result: 0, elapsed 5 usecs
[  223.608054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3393 usecs
[  223.608068] radeon_move_blit: new type: tt, old type: vram
[  223.608074] radeon_copy: result: 0, elapsed 5 usecs
[  223.608091] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  223.608101] radeon_move_blit: new type: tt, old type: vram
[  223.608107] radeon_copy: result: 0, elapsed 5 usecs
[  223.608136] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.608147] radeon_move_blit: new type: tt, old type: vram
[  223.608152] radeon_copy: result: 0, elapsed 5 usecs
[  223.608186] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.608195] radeon_move_blit: new type: tt, old type: vram
[  223.608201] radeon_copy: result: 0, elapsed 5 usecs
[  223.608222] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.608233] radeon_move_blit: new type: tt, old type: vram
[  223.608238] radeon_copy: result: 0, elapsed 5 usecs
[  223.608259] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.608269] radeon_move_blit: new type: tt, old type: vram
[  223.608274] radeon_copy: result: 0, elapsed 5 usecs
[  223.608295] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608305] radeon_move_blit: new type: tt, old type: vram
[  223.608310] radeon_copy: result: 0, elapsed 5 usecs
[  223.608331] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608341] radeon_move_blit: new type: tt, old type: vram
[  223.608346] radeon_copy: result: 0, elapsed 5 usecs
[  223.608366] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608377] radeon_move_blit: new type: tt, old type: vram
[  223.608382] radeon_copy: result: 0, elapsed 5 usecs
[  223.608410] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.608421] radeon_move_blit: new type: tt, old type: vram
[  223.608426] radeon_copy: result: 0, elapsed 5 usecs
[  223.608446] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608457] radeon_move_blit: new type: tt, old type: vram
[  223.608462] radeon_copy: result: 0, elapsed 5 usecs
[  223.608482] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608494] radeon_move_blit: new type: tt, old type: vram
[  223.608500] radeon_copy: result: 0, elapsed 5 usecs
[  223.608521] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.608532] radeon_move_blit: new type: tt, old type: vram
[  223.608537] radeon_copy: result: 0, elapsed 5 usecs
[  223.608557] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608568] radeon_move_blit: new type: tt, old type: vram
[  223.608573] radeon_copy: result: 0, elapsed 5 usecs
[  223.608594] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608604] radeon_move_blit: new type: tt, old type: vram
[  223.608610] radeon_copy: result: 0, elapsed 5 usecs
[  223.608630] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608641] radeon_move_blit: new type: tt, old type: vram
[  223.608647] radeon_copy: result: 0, elapsed 5 usecs
[  223.608667] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.608678] radeon_move_blit: new type: tt, old type: vram
[  223.608684] radeon_copy: result: 0, elapsed 5 usecs
[  223.612055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3286 usecs
[  223.612068] radeon_move_blit: new type: tt, old type: vram
[  223.612073] radeon_copy: result: 0, elapsed 5 usecs
[  223.612120] ttm_bo_move_accel_cleanup: result: 0, elapsed 41 usecs
[  223.612131] radeon_move_blit: new type: tt, old type: vram
[  223.612137] radeon_copy: result: 0, elapsed 5 usecs
[  223.612153] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.612165] radeon_move_blit: new type: tt, old type: vram
[  223.612170] radeon_copy: result: 0, elapsed 5 usecs
[  223.612192] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.612210] radeon_move_blit: new type: tt, old type: vram
[  223.612215] radeon_copy: result: 0, elapsed 5 usecs
[  223.643560] ttm_bo_move_accel_cleanup: result: 0, elapsed 30605 usecs
[  223.643571] radeon_move_blit: new type: tt, old type: vram
[  223.643577] radeon_copy: result: 0, elapsed 5 usecs
[  223.671047] ttm_bo_move_accel_cleanup: result: 0, elapsed 26821 usecs
[  223.671059] radeon_move_blit: new type: tt, old type: vram
[  223.671065] radeon_copy: result: 0, elapsed 5 usecs
[  223.698533] ttm_bo_move_accel_cleanup: result: 0, elapsed 26820 usecs
[  223.698544] radeon_move_blit: new type: tt, old type: vram
[  223.698550] radeon_copy: result: 0, elapsed 5 usecs
[  223.726020] ttm_bo_move_accel_cleanup: result: 0, elapsed 26822 usecs
[  223.726032] radeon_move_blit: new type: tt, old type: vram
[  223.726037] radeon_copy: result: 0, elapsed 5 usecs
[  223.753508] ttm_bo_move_accel_cleanup: result: 0, elapsed 26822 usecs
[  223.753519] radeon_move_blit: new type: tt, old type: vram
[  223.753524] radeon_copy: result: 0, elapsed 5 usecs
[  223.753541] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  223.753554] radeon_move_blit: new type: tt, old type: vram
[  223.753559] radeon_copy: result: 0, elapsed 5 usecs
[  223.753601] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  223.753613] radeon_move_blit: new type: tt, old type: vram
[  223.753618] radeon_copy: result: 0, elapsed 5 usecs
[  223.753652] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.753663] radeon_move_blit: new type: tt, old type: vram
[  223.753668] radeon_copy: result: 0, elapsed 5 usecs
[  223.753684] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.753700] radeon_move_blit: new type: tt, old type: vram
[  223.753706] radeon_copy: result: 0, elapsed 5 usecs
[  223.753743] ttm_bo_move_accel_cleanup: result: 0, elapsed 31 usecs
[  223.753754] radeon_move_blit: new type: tt, old type: vram
[  223.753760] radeon_copy: result: 0, elapsed 6 usecs
[  223.753776] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.753787] radeon_move_blit: new type: tt, old type: vram
[  223.753793] radeon_copy: result: 0, elapsed 5 usecs
[  223.753813] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.753824] radeon_move_blit: new type: tt, old type: vram
[  223.753829] radeon_copy: result: 0, elapsed 5 usecs
[  223.753849] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.753861] radeon_move_blit: new type: tt, old type: vram
[  223.753867] radeon_copy: result: 0, elapsed 5 usecs
[  223.753887] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.753898] radeon_move_blit: new type: tt, old type: vram
[  223.753904] radeon_copy: result: 0, elapsed 5 usecs
[  223.753924] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.753938] radeon_move_blit: new type: tt, old type: vram
[  223.753943] radeon_copy: result: 0, elapsed 5 usecs
[  223.756055] ttm_bo_move_accel_cleanup: result: 0, elapsed 2058 usecs
[  223.756067] radeon_move_blit: new type: tt, old type: vram
[  223.756073] radeon_copy: result: 0, elapsed 5 usecs
[  223.756103] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.756114] radeon_move_blit: new type: tt, old type: vram
[  223.756119] radeon_copy: result: 0, elapsed 6 usecs
[  223.756153] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.756163] radeon_move_blit: new type: tt, old type: vram
[  223.756168] radeon_copy: result: 0, elapsed 5 usecs
[  223.756189] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.756199] radeon_move_blit: new type: tt, old type: vram
[  223.756204] radeon_copy: result: 0, elapsed 5 usecs
[  223.756225] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.756235] radeon_move_blit: new type: tt, old type: vram
[  223.756241] radeon_copy: result: 0, elapsed 5 usecs
[  223.756261] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.756272] radeon_move_blit: new type: tt, old type: vram
[  223.756277] radeon_copy: result: 0, elapsed 5 usecs
[  223.756298] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.756309] radeon_move_blit: new type: tt, old type: vram
[  223.756315] radeon_copy: result: 0, elapsed 5 usecs
[  223.760052] ttm_bo_move_accel_cleanup: result: 0, elapsed 3645 usecs
[  223.760062] radeon_move_blit: new type: tt, old type: vram
[  223.760068] radeon_copy: result: 0, elapsed 5 usecs
[  223.760097] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.760109] radeon_move_blit: new type: tt, old type: vram
[  223.760114] radeon_copy: result: 0, elapsed 5 usecs
[  223.760135] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.760147] radeon_move_blit: new type: tt, old type: vram
[  223.760152] radeon_copy: result: 0, elapsed 5 usecs
[  223.760174] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.760184] radeon_move_blit: new type: tt, old type: vram
[  223.760190] radeon_copy: result: 0, elapsed 5 usecs
[  223.760211] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.760222] radeon_move_blit: new type: tt, old type: vram
[  223.760228] radeon_copy: result: 0, elapsed 5 usecs
[  223.760244] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.760263] radeon_move_blit: new type: tt, old type: vram
[  223.760268] radeon_copy: result: 0, elapsed 5 usecs
[  223.760285] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  223.760297] radeon_move_blit: new type: tt, old type: vram
[  223.760302] radeon_copy: result: 0, elapsed 5 usecs
[  223.760322] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.760333] radeon_move_blit: new type: tt, old type: vram
[  223.760338] radeon_copy: result: 0, elapsed 5 usecs
[  223.760375] ttm_bo_move_accel_cleanup: result: 0, elapsed 31 usecs
[  223.760385] radeon_move_blit: new type: tt, old type: vram
[  223.760390] radeon_copy: result: 0, elapsed 5 usecs
[  223.760419] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.760428] radeon_move_blit: new type: tt, old type: vram
[  223.760434] radeon_copy: result: 0, elapsed 5 usecs
[  223.760462] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  223.760472] radeon_move_blit: new type: tt, old type: vram
[  223.760477] radeon_copy: result: 0, elapsed 5 usecs
[  223.760505] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.760516] radeon_move_blit: new type: tt, old type: vram
[  223.760521] radeon_copy: result: 0, elapsed 5 usecs
[  223.764054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3445 usecs
[  223.764066] radeon_move_blit: new type: tt, old type: vram
[  223.764071] radeon_copy: result: 0, elapsed 5 usecs
[  223.791595] ttm_bo_move_accel_cleanup: result: 0, elapsed 26874 usecs
[  223.791607] radeon_move_blit: new type: tt, old type: vram
[  223.791612] radeon_copy: result: 0, elapsed 5 usecs
[  223.796066] ttm_bo_move_accel_cleanup: result: 0, elapsed 4344 usecs
[  223.796076] radeon_move_blit: new type: tt, old type: vram
[  223.796081] radeon_copy: result: 0, elapsed 5 usecs
[  223.796110] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.796122] radeon_move_blit: new type: tt, old type: vram
[  223.796128] radeon_copy: result: 0, elapsed 5 usecs
[  223.796149] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.796160] radeon_move_blit: new type: tt, old type: vram
[  223.796165] radeon_copy: result: 0, elapsed 5 usecs
[  223.796187] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  223.796198] radeon_move_blit: new type: tt, old type: vram
[  223.796203] radeon_copy: result: 0, elapsed 5 usecs
[  223.796225] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.796236] radeon_move_blit: new type: tt, old type: vram
[  223.796241] radeon_copy: result: 0, elapsed 5 usecs
[  223.796262] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.796273] radeon_move_blit: new type: tt, old type: vram
[  223.796278] radeon_copy: result: 0, elapsed 5 usecs
[  223.796312] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.796322] radeon_move_blit: new type: tt, old type: vram
[  223.796327] radeon_copy: result: 0, elapsed 5 usecs
[  223.796355] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.796366] radeon_move_blit: new type: tt, old type: vram
[  223.796371] radeon_copy: result: 0, elapsed 5 usecs
[  223.796392] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.796403] radeon_move_blit: new type: tt, old type: vram
[  223.796408] radeon_copy: result: 0, elapsed 5 usecs
[  223.796428] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.796439] radeon_move_blit: new type: tt, old type: vram
[  223.796444] radeon_copy: result: 0, elapsed 5 usecs
[  223.796465] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.796477] radeon_move_blit: new type: tt, old type: vram
[  223.796483] radeon_copy: result: 0, elapsed 5 usecs
[  223.800055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3484 usecs
[  223.800066] radeon_move_blit: new type: tt, old type: vram
[  223.800072] radeon_copy: result: 0, elapsed 5 usecs
[  223.800123] ttm_bo_move_accel_cleanup: result: 0, elapsed 45 usecs
[  223.800135] radeon_move_blit: new type: tt, old type: vram
[  223.800140] radeon_copy: result: 0, elapsed 5 usecs
[  223.804053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3816 usecs
[  223.805798] radeon_move_blit: new type: tt, old type: vram
[  223.805803] radeon_copy: result: 0, elapsed 6 usecs
[  223.833330] ttm_bo_move_accel_cleanup: result: 0, elapsed 26876 usecs
[  223.833342] radeon_move_blit: new type: tt, old type: vram
[  223.833347] radeon_copy: result: 0, elapsed 5 usecs
[  223.833380] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.833391] radeon_move_blit: new type: tt, old type: vram
[  223.833396] radeon_copy: result: 0, elapsed 5 usecs
[  223.833413] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  223.833427] radeon_move_blit: new type: tt, old type: vram
[  223.833432] radeon_copy: result: 0, elapsed 5 usecs
[  223.833466] ttm_bo_move_accel_cleanup: result: 0, elapsed 29 usecs
[  223.833477] radeon_move_blit: new type: tt, old type: vram
[  223.833483] radeon_copy: result: 0, elapsed 5 usecs
[  223.833512] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.833522] radeon_move_blit: new type: tt, old type: vram
[  223.833527] radeon_copy: result: 0, elapsed 5 usecs
[  223.833557] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.833568] radeon_move_blit: new type: tt, old type: vram
[  223.833573] radeon_copy: result: 0, elapsed 5 usecs
[  223.833589] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  223.833600] radeon_move_blit: new type: tt, old type: vram
[  223.833606] radeon_copy: result: 0, elapsed 5 usecs
[  223.833626] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.833637] radeon_move_blit: new type: tt, old type: vram
[  223.833642] radeon_copy: result: 0, elapsed 5 usecs
[  223.833663] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.833674] radeon_move_blit: new type: tt, old type: vram
[  223.833679] radeon_copy: result: 0, elapsed 5 usecs
[  223.833700] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.833712] radeon_move_blit: new type: tt, old type: vram
[  223.833718] radeon_copy: result: 0, elapsed 5 usecs
[  223.833738] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  223.833755] radeon_move_blit: new type: tt, old type: vram
[  223.833761] radeon_copy: result: 0, elapsed 5 usecs
[  223.891053] ttm_bo_move_accel_cleanup: result: 0, elapsed 55945 usecs
[  223.891065] radeon_move_blit: new type: tt, old type: vram
[  223.891070] radeon_copy: result: 0, elapsed 5 usecs
[  223.891108] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  223.891125] radeon_move_blit: new type: tt, old type: vram
[  223.891131] radeon_copy: result: 0, elapsed 5 usecs
[  223.896053] ttm_bo_move_accel_cleanup: result: 0, elapsed 4802 usecs
[  223.896064] radeon_move_blit: new type: tt, old type: vram
[  223.896069] radeon_copy: result: 0, elapsed 5 usecs
[  223.896111] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  223.896121] radeon_move_blit: new type: tt, old type: vram
[  223.896126] radeon_copy: result: 0, elapsed 5 usecs
[  223.896160] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.896171] radeon_move_blit: new type: tt, old type: vram
[  223.896176] radeon_copy: result: 0, elapsed 5 usecs
[  223.896205] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  223.896217] radeon_move_blit: new type: tt, old type: vram
[  223.896222] radeon_copy: result: 0, elapsed 5 usecs
[  223.896239] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  223.896252] radeon_move_blit: new type: tt, old type: vram
[  223.896257] radeon_copy: result: 0, elapsed 5 usecs
[  223.900054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3702 usecs
[  223.900065] radeon_move_blit: new type: tt, old type: vram
[  223.900070] radeon_copy: result: 0, elapsed 5 usecs
[  223.900099] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.900110] radeon_move_blit: new type: tt, old type: vram
[  223.900116] radeon_copy: result: 0, elapsed 5 usecs
[  223.900150] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.900160] radeon_move_blit: new type: tt, old type: vram
[  223.900165] radeon_copy: result: 0, elapsed 5 usecs
[  223.900187] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  223.900198] radeon_move_blit: new type: tt, old type: vram
[  223.900203] radeon_copy: result: 0, elapsed 5 usecs
[  223.900232] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  223.900249] radeon_move_blit: new type: tt, old type: vram
[  223.900254] radeon_copy: result: 0, elapsed 5 usecs
[  223.959043] ttm_bo_move_accel_cleanup: result: 0, elapsed 57406 usecs
[  223.959054] radeon_move_blit: new type: tt, old type: vram
[  223.959059] radeon_copy: result: 0, elapsed 5 usecs
[  223.959093] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  223.959121] radeon_move_blit: new type: tt, old type: vram
[  223.959126] radeon_copy: result: 0, elapsed 5 usecs
[  224.051063] ttm_bo_move_accel_cleanup: result: 0, elapsed 89777 usecs
[  224.051073] radeon_move_blit: new type: tt, old type: vram
[  224.051078] radeon_copy: result: 0, elapsed 5 usecs
[  224.051108] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  224.051123] radeon_move_blit: new type: tt, old type: vram
[  224.051129] radeon_copy: result: 0, elapsed 5 usecs
[  224.052071] ttm_bo_move_accel_cleanup: result: 0, elapsed 915 usecs
[  224.052082] radeon_move_blit: new type: tt, old type: vram
[  224.052087] radeon_copy: result: 0, elapsed 5 usecs
[  224.056053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3868 usecs
[  224.056068] radeon_move_blit: new type: tt, old type: vram
[  224.056073] radeon_copy: result: 0, elapsed 5 usecs
[  224.056090] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.056102] radeon_move_blit: new type: tt, old type: vram
[  224.056107] radeon_copy: result: 0, elapsed 5 usecs
[  224.056137] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  224.056149] radeon_move_blit: new type: tt, old type: vram
[  224.056155] radeon_copy: result: 0, elapsed 5 usecs
[  224.056171] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  224.056189] radeon_move_blit: new type: tt, old type: vram
[  224.056194] radeon_copy: result: 0, elapsed 5 usecs
[  224.087563] ttm_bo_move_accel_cleanup: result: 0, elapsed 30628 usecs
[  224.087574] radeon_move_blit: new type: tt, old type: vram
[  224.087579] radeon_copy: result: 0, elapsed 5 usecs
[  224.115049] ttm_bo_move_accel_cleanup: result: 0, elapsed 26821 usecs
[  224.115062] radeon_move_blit: new type: tt, old type: vram
[  224.115068] radeon_copy: result: 0, elapsed 5 usecs
[  224.142537] ttm_bo_move_accel_cleanup: result: 0, elapsed 26820 usecs
[  224.142548] radeon_move_blit: new type: tt, old type: vram
[  224.142553] radeon_copy: result: 0, elapsed 5 usecs
[  224.142575] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  224.142586] radeon_move_blit: new type: tt, old type: vram
[  224.142591] radeon_copy: result: 0, elapsed 5 usecs
[  224.142607] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.142619] radeon_move_blit: new type: tt, old type: vram
[  224.142624] radeon_copy: result: 0, elapsed 5 usecs
[  224.142665] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  224.142676] radeon_move_blit: new type: tt, old type: vram
[  224.142681] radeon_copy: result: 0, elapsed 5 usecs
[  224.142698] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  224.142709] radeon_move_blit: new type: tt, old type: vram
[  224.142714] radeon_copy: result: 0, elapsed 5 usecs
[  224.142752] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  224.142763] radeon_move_blit: new type: tt, old type: vram
[  224.142768] radeon_copy: result: 0, elapsed 5 usecs
[  224.142784] ttm_bo_move_accel_cleanup: result: 0, elapsed 10 usecs
[  224.142796] radeon_move_blit: new type: tt, old type: vram
[  224.142801] radeon_copy: result: 0, elapsed 5 usecs
[  224.142822] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.142833] radeon_move_blit: new type: tt, old type: vram
[  224.142839] radeon_copy: result: 0, elapsed 5 usecs
[  224.142860] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.142872] radeon_move_blit: new type: tt, old type: vram
[  224.142877] radeon_copy: result: 0, elapsed 5 usecs
[  224.142898] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.142908] radeon_move_blit: new type: tt, old type: vram
[  224.142913] radeon_copy: result: 0, elapsed 5 usecs
[  224.142934] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.142945] radeon_move_blit: new type: tt, old type: vram
[  224.142950] radeon_copy: result: 0, elapsed 5 usecs
[  224.142970] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.142982] radeon_move_blit: new type: tt, old type: vram
[  224.142987] radeon_copy: result: 0, elapsed 5 usecs
[  224.143007] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.143018] radeon_move_blit: new type: tt, old type: vram
[  224.143024] radeon_copy: result: 0, elapsed 5 usecs
[  224.143044] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.143061] radeon_move_blit: new type: tt, old type: vram
[  224.143066] radeon_copy: result: 0, elapsed 5 usecs
[  224.148055] ttm_bo_move_accel_cleanup: result: 0, elapsed 4867 usecs
[  224.148066] radeon_move_blit: new type: tt, old type: vram
[  224.148072] radeon_copy: result: 0, elapsed 5 usecs
[  224.148118] ttm_bo_move_accel_cleanup: result: 0, elapsed 40 usecs
[  224.148130] radeon_move_blit: new type: tt, old type: vram
[  224.148136] radeon_copy: result: 0, elapsed 5 usecs
[  224.148174] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  224.148185] radeon_move_blit: new type: tt, old type: vram
[  224.148191] radeon_copy: result: 0, elapsed 5 usecs
[  224.148212] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.148225] radeon_move_blit: new type: tt, old type: vram
[  224.148231] radeon_copy: result: 0, elapsed 5 usecs
[  224.152053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3727 usecs
[  224.152070] radeon_move_blit: new type: tt, old type: vram
[  224.152075] radeon_copy: result: 0, elapsed 5 usecs
[  224.196065] ttm_bo_move_accel_cleanup: result: 0, elapsed 42954 usecs
[  224.196075] radeon_move_blit: new type: tt, old type: vram
[  224.196080] radeon_copy: result: 0, elapsed 5 usecs
[  224.196110] ttm_bo_move_accel_cleanup: result: 0, elapsed 25 usecs
[  224.196122] radeon_move_blit: new type: tt, old type: vram
[  224.196127] radeon_copy: result: 0, elapsed 5 usecs
[  224.196148] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196160] radeon_move_blit: new type: tt, old type: vram
[  224.196165] radeon_copy: result: 0, elapsed 5 usecs
[  224.196186] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196197] radeon_move_blit: new type: tt, old type: vram
[  224.196203] radeon_copy: result: 0, elapsed 5 usecs
[  224.196223] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196234] radeon_move_blit: new type: tt, old type: vram
[  224.196239] radeon_copy: result: 0, elapsed 5 usecs
[  224.196261] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196272] radeon_move_blit: new type: tt, old type: vram
[  224.196277] radeon_copy: result: 0, elapsed 5 usecs
[  224.196298] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196309] radeon_move_blit: new type: tt, old type: vram
[  224.196314] radeon_copy: result: 0, elapsed 5 usecs
[  224.196335] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196345] radeon_move_blit: new type: tt, old type: vram
[  224.196351] radeon_copy: result: 0, elapsed 5 usecs
[  224.196371] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.196383] radeon_move_blit: new type: tt, old type: vram
[  224.196389] radeon_copy: result: 0, elapsed 5 usecs
[  224.196409] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.196420] radeon_move_blit: new type: tt, old type: vram
[  224.196426] radeon_copy: result: 0, elapsed 5 usecs
[  224.196447] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196459] radeon_move_blit: new type: tt, old type: vram
[  224.196464] radeon_copy: result: 0, elapsed 5 usecs
[  224.196505] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  224.196515] radeon_move_blit: new type: tt, old type: vram
[  224.196521] radeon_copy: result: 0, elapsed 5 usecs
[  224.196542] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.196553] radeon_move_blit: new type: tt, old type: vram
[  224.196558] radeon_copy: result: 0, elapsed 5 usecs
[  224.196578] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.196589] radeon_move_blit: new type: tt, old type: vram
[  224.196595] radeon_copy: result: 0, elapsed 5 usecs
[  224.196623] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  224.196633] radeon_move_blit: new type: tt, old type: vram
[  224.196639] radeon_copy: result: 0, elapsed 5 usecs
[  224.196667] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  224.196677] radeon_move_blit: new type: tt, old type: vram
[  224.196682] radeon_copy: result: 0, elapsed 5 usecs
[  224.196710] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  224.196720] radeon_move_blit: new type: tt, old type: vram
[  224.196725] radeon_copy: result: 0, elapsed 5 usecs
[  224.196753] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  224.196764] radeon_move_blit: new type: tt, old type: vram
[  224.196769] radeon_copy: result: 0, elapsed 5 usecs
[  224.196789] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.196800] radeon_move_blit: new type: tt, old type: vram
[  224.196805] radeon_copy: result: 0, elapsed 5 usecs
[  224.200054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3167 usecs
[  224.200066] radeon_move_blit: new type: tt, old type: vram
[  224.200071] radeon_copy: result: 0, elapsed 5 usecs
[  224.227598] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  224.227608] radeon_move_blit: new type: tt, old type: vram
[  224.227613] radeon_copy: result: 0, elapsed 5 usecs
[  224.227629] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.227640] radeon_move_blit: new type: tt, old type: vram
[  224.227645] radeon_copy: result: 0, elapsed 5 usecs
[  224.227675] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  224.227684] radeon_move_blit: new type: tt, old type: vram
[  224.227690] radeon_copy: result: 0, elapsed 5 usecs
[  224.227711] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.227722] radeon_move_blit: new type: tt, old type: vram
[  224.227728] radeon_copy: result: 0, elapsed 5 usecs
[  224.227749] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.227759] radeon_move_blit: new type: tt, old type: vram
[  224.227765] radeon_copy: result: 0, elapsed 5 usecs
[  224.227799] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  224.227809] radeon_move_blit: new type: tt, old type: vram
[  224.227814] radeon_copy: result: 0, elapsed 5 usecs
[  224.227836] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.227849] radeon_move_blit: new type: tt, old type: vram
[  224.227854] radeon_copy: result: 0, elapsed 5 usecs
[  224.228054] ttm_bo_move_accel_cleanup: result: 0, elapsed 190 usecs
[  224.228066] radeon_move_blit: new type: tt, old type: vram
[  224.228072] radeon_copy: result: 0, elapsed 5 usecs
[  224.228093] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.228104] radeon_move_blit: new type: tt, old type: vram
[  224.228109] radeon_copy: result: 0, elapsed 5 usecs
[  224.228130] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.228140] radeon_move_blit: new type: tt, old type: vram
[  224.228146] radeon_copy: result: 0, elapsed 5 usecs
[  224.228166] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.228177] radeon_move_blit: new type: tt, old type: vram
[  224.228182] radeon_copy: result: 0, elapsed 5 usecs
[  224.228202] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.228219] radeon_move_blit: new type: tt, old type: vram
[  224.228224] radeon_copy: result: 0, elapsed 5 usecs
[  224.228246] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.228257] radeon_move_blit: new type: tt, old type: vram
[  224.228263] radeon_copy: result: 0, elapsed 5 usecs
[  224.228283] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.228293] radeon_move_blit: new type: tt, old type: vram
[  224.228298] radeon_copy: result: 0, elapsed 5 usecs
[  224.228318] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.228329] radeon_move_blit: new type: tt, old type: vram
[  224.228335] radeon_copy: result: 0, elapsed 5 usecs
[  224.228355] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.228370] radeon_move_blit: new type: tt, old type: vram
[  224.228376] radeon_copy: result: 0, elapsed 5 usecs
[  224.232052] ttm_bo_move_accel_cleanup: result: 0, elapsed 3584 usecs
[  224.232065] radeon_move_blit: new type: tt, old type: vram
[  224.232070] radeon_copy: result: 0, elapsed 5 usecs
[  224.232122] ttm_bo_move_accel_cleanup: result: 0, elapsed 46 usecs
[  224.232133] radeon_move_blit: new type: tt, old type: vram
[  224.232139] radeon_copy: result: 0, elapsed 5 usecs
[  224.232161] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.232172] radeon_move_blit: new type: tt, old type: vram
[  224.232177] radeon_copy: result: 0, elapsed 5 usecs
[  224.232219] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  224.232229] radeon_move_blit: new type: tt, old type: vram
[  224.232234] radeon_copy: result: 0, elapsed 5 usecs
[  224.232255] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.232265] radeon_move_blit: new type: tt, old type: vram
[  224.232270] radeon_copy: result: 0, elapsed 5 usecs
[  224.232291] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.232301] radeon_move_blit: new type: tt, old type: vram
[  224.232307] radeon_copy: result: 0, elapsed 5 usecs
[  224.232328] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.232337] radeon_move_blit: new type: tt, old type: vram
[  224.232343] radeon_copy: result: 0, elapsed 5 usecs
[  224.232363] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232373] radeon_move_blit: new type: tt, old type: vram
[  224.232378] radeon_copy: result: 0, elapsed 5 usecs
[  224.232399] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.232409] radeon_move_blit: new type: tt, old type: vram
[  224.232414] radeon_copy: result: 0, elapsed 5 usecs
[  224.232434] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232445] radeon_move_blit: new type: tt, old type: vram
[  224.232450] radeon_copy: result: 0, elapsed 5 usecs
[  224.232471] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232482] radeon_move_blit: new type: tt, old type: vram
[  224.232487] radeon_copy: result: 0, elapsed 5 usecs
[  224.232507] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232517] radeon_move_blit: new type: tt, old type: vram
[  224.232522] radeon_copy: result: 0, elapsed 5 usecs
[  224.232542] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232551] radeon_move_blit: new type: tt, old type: vram
[  224.232557] radeon_copy: result: 0, elapsed 5 usecs
[  224.232577] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232587] radeon_move_blit: new type: tt, old type: vram
[  224.232592] radeon_copy: result: 0, elapsed 5 usecs
[  224.232612] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232621] radeon_move_blit: new type: tt, old type: vram
[  224.232627] radeon_copy: result: 0, elapsed 5 usecs
[  224.232647] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232656] radeon_move_blit: new type: tt, old type: vram
[  224.232661] radeon_copy: result: 0, elapsed 5 usecs
[  224.232681] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232692] radeon_move_blit: new type: tt, old type: vram
[  224.232697] radeon_copy: result: 0, elapsed 5 usecs
[  224.232717] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232729] radeon_move_blit: new type: tt, old type: vram
[  224.232734] radeon_copy: result: 0, elapsed 5 usecs
[  224.232755] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.232766] radeon_move_blit: new type: tt, old type: vram
[  224.232772] radeon_copy: result: 0, elapsed 5 usecs
[  224.232792] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232804] radeon_move_blit: new type: tt, old type: vram
[  224.232809] radeon_copy: result: 0, elapsed 5 usecs
[  224.232829] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232841] radeon_move_blit: new type: tt, old type: vram
[  224.232846] radeon_copy: result: 0, elapsed 5 usecs
[  224.232866] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232878] radeon_move_blit: new type: tt, old type: vram
[  224.232884] radeon_copy: result: 0, elapsed 5 usecs
[  224.232904] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232916] radeon_move_blit: new type: tt, old type: vram
[  224.232921] radeon_copy: result: 0, elapsed 5 usecs
[  224.232941] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.232953] radeon_move_blit: new type: tt, old type: vram
[  224.232959] radeon_copy: result: 0, elapsed 5 usecs
[  224.236055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3018 usecs
[  224.236072] radeon_move_blit: new type: tt, old type: vram
[  224.236078] radeon_copy: result: 0, elapsed 5 usecs
[  224.291104] ttm_bo_move_accel_cleanup: result: 0, elapsed 53731 usecs
[  224.291115] radeon_move_blit: new type: tt, old type: vram
[  224.291120] radeon_copy: result: 0, elapsed 5 usecs
[  224.291162] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  224.291172] radeon_move_blit: new type: tt, old type: vram
[  224.291178] radeon_copy: result: 0, elapsed 5 usecs
[  224.291200] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.291210] radeon_move_blit: new type: tt, old type: vram
[  224.291215] radeon_copy: result: 0, elapsed 5 usecs
[  224.291236] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.291246] radeon_move_blit: new type: tt, old type: vram
[  224.291251] radeon_copy: result: 0, elapsed 5 usecs
[  224.291272] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.291283] radeon_move_blit: new type: tt, old type: vram
[  224.291288] radeon_copy: result: 0, elapsed 5 usecs
[  224.291309] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.291320] radeon_move_blit: new type: tt, old type: vram
[  224.291325] radeon_copy: result: 0, elapsed 5 usecs
[  224.291347] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.291357] radeon_move_blit: new type: tt, old type: vram
[  224.291363] radeon_copy: result: 0, elapsed 5 usecs
[  224.291383] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.291412] radeon_move_blit: new type: tt, old type: vram
[  224.291418] radeon_copy: result: 0, elapsed 5 usecs
[  224.396090] ttm_bo_move_accel_cleanup: result: 0, elapsed 102214 usecs
[  224.396101] radeon_move_blit: new type: tt, old type: vram
[  224.396106] radeon_copy: result: 0, elapsed 5 usecs
[  224.396122] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.396134] radeon_move_blit: new type: tt, old type: vram
[  224.396139] radeon_copy: result: 0, elapsed 5 usecs
[  224.396160] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.396171] radeon_move_blit: new type: tt, old type: vram
[  224.396176] radeon_copy: result: 0, elapsed 5 usecs
[  224.396197] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.396208] radeon_move_blit: new type: tt, old type: vram
[  224.396213] radeon_copy: result: 0, elapsed 5 usecs
[  224.396234] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.396246] radeon_move_blit: new type: tt, old type: vram
[  224.396251] radeon_copy: result: 0, elapsed 5 usecs
[  224.396272] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.396283] radeon_move_blit: new type: tt, old type: vram
[  224.396288] radeon_copy: result: 0, elapsed 5 usecs
[  224.396308] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396319] radeon_move_blit: new type: tt, old type: vram
[  224.396324] radeon_copy: result: 0, elapsed 5 usecs
[  224.396345] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396355] radeon_move_blit: new type: tt, old type: vram
[  224.396361] radeon_copy: result: 0, elapsed 5 usecs
[  224.396381] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396391] radeon_move_blit: new type: tt, old type: vram
[  224.396397] radeon_copy: result: 0, elapsed 5 usecs
[  224.396417] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396427] radeon_move_blit: new type: tt, old type: vram
[  224.396433] radeon_copy: result: 0, elapsed 5 usecs
[  224.396453] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396463] radeon_move_blit: new type: tt, old type: vram
[  224.396469] radeon_copy: result: 0, elapsed 5 usecs
[  224.396489] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396500] radeon_move_blit: new type: tt, old type: vram
[  224.396505] radeon_copy: result: 0, elapsed 5 usecs
[  224.396525] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396535] radeon_move_blit: new type: tt, old type: vram
[  224.396540] radeon_copy: result: 0, elapsed 5 usecs
[  224.396560] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396570] radeon_move_blit: new type: tt, old type: vram
[  224.396575] radeon_copy: result: 0, elapsed 5 usecs
[  224.396595] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396605] radeon_move_blit: new type: tt, old type: vram
[  224.396611] radeon_copy: result: 0, elapsed 5 usecs
[  224.396631] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396641] radeon_move_blit: new type: tt, old type: vram
[  224.396646] radeon_copy: result: 0, elapsed 5 usecs
[  224.396667] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396675] radeon_move_blit: new type: tt, old type: vram
[  224.396681] radeon_copy: result: 0, elapsed 5 usecs
[  224.396701] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396711] radeon_move_blit: new type: tt, old type: vram
[  224.396717] radeon_copy: result: 0, elapsed 5 usecs
[  224.396737] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.396771] radeon_move_blit: new type: tt, old type: vram
[  224.396776] radeon_copy: result: 0, elapsed 5 usecs
[  224.596095] ttm_bo_move_accel_cleanup: result: 0, elapsed 194642 usecs
[  224.596107] radeon_move_blit: new type: tt, old type: vram
[  224.596112] radeon_copy: result: 0, elapsed 5 usecs
[  224.596129] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.596140] radeon_move_blit: new type: tt, old type: vram
[  224.596145] radeon_copy: result: 0, elapsed 5 usecs
[  224.596179] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  224.596188] radeon_move_blit: new type: tt, old type: vram
[  224.596194] radeon_copy: result: 0, elapsed 5 usecs
[  224.596215] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.597965] radeon_move_blit: new type: tt, old type: vram
[  224.597970] radeon_copy: result: 0, elapsed 6 usecs
[  224.597988] ttm_bo_move_accel_cleanup: result: 0, elapsed 13 usecs
[  224.598001] radeon_move_blit: new type: tt, old type: vram
[  224.598006] radeon_copy: result: 0, elapsed 5 usecs
[  224.598029] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.598041] radeon_move_blit: new type: tt, old type: vram
[  224.598047] radeon_copy: result: 0, elapsed 5 usecs
[  224.600054] ttm_bo_move_accel_cleanup: result: 0, elapsed 1955 usecs
[  224.600066] radeon_move_blit: new type: tt, old type: vram
[  224.600072] radeon_copy: result: 0, elapsed 5 usecs
[  224.627598] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  224.627610] radeon_move_blit: new type: tt, old type: vram
[  224.627616] radeon_copy: result: 0, elapsed 5 usecs
[  224.655089] ttm_bo_move_accel_cleanup: result: 0, elapsed 26824 usecs
[  224.655099] radeon_move_blit: new type: tt, old type: vram
[  224.655105] radeon_copy: result: 0, elapsed 5 usecs
[  224.655122] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  224.655132] radeon_move_blit: new type: tt, old type: vram
[  224.655137] radeon_copy: result: 0, elapsed 5 usecs
[  224.655166] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  224.655183] radeon_move_blit: new type: tt, old type: vram
[  224.655189] radeon_copy: result: 0, elapsed 5 usecs
[  224.656056] ttm_bo_move_accel_cleanup: result: 0, elapsed 841 usecs
[  224.656066] radeon_move_blit: new type: tt, old type: vram
[  224.656071] radeon_copy: result: 0, elapsed 5 usecs
[  224.656093] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.656105] radeon_move_blit: new type: tt, old type: vram
[  224.656111] radeon_copy: result: 0, elapsed 5 usecs
[  224.660054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3846 usecs
[  224.660063] radeon_move_blit: new type: tt, old type: vram
[  224.660069] radeon_copy: result: 0, elapsed 5 usecs
[  224.660085] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.660097] radeon_move_blit: new type: tt, old type: vram
[  224.660103] radeon_copy: result: 0, elapsed 5 usecs
[  224.660154] ttm_bo_move_accel_cleanup: result: 0, elapsed 45 usecs
[  224.660164] radeon_move_blit: new type: tt, old type: vram
[  224.660169] radeon_copy: result: 0, elapsed 5 usecs
[  224.660191] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  224.660202] radeon_move_blit: new type: tt, old type: vram
[  224.660207] radeon_copy: result: 0, elapsed 5 usecs
[  224.660223] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  224.660234] radeon_move_blit: new type: tt, old type: vram
[  224.660240] radeon_copy: result: 0, elapsed 5 usecs
[  224.660262] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.660272] radeon_move_blit: new type: tt, old type: vram
[  224.660277] radeon_copy: result: 0, elapsed 5 usecs
[  224.660298] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  224.660309] radeon_move_blit: new type: tt, old type: vram
[  224.660315] radeon_copy: result: 0, elapsed 5 usecs
[  224.660335] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.660345] radeon_move_blit: new type: tt, old type: vram
[  224.660351] radeon_copy: result: 0, elapsed 5 usecs
[  224.660371] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  224.660539] radeon_move_blit: new type: tt, old type: vram
[  224.660544] radeon_copy: result: 0, elapsed 5 usecs
[  226.149234] ttm_bo_move_accel_cleanup: result: 0, elapsed 1453793 usecs
[  226.151166] radeon_move_blit: new type: tt, old type: vram
[  226.151172] radeon_copy: result: 0, elapsed 6 usecs
[  226.153541] ttm_bo_move_accel_cleanup: result: 0, elapsed 2307 usecs
[  226.153576] radeon_move_blit: new type: tt, old type: vram
[  226.153581] radeon_copy: result: 0, elapsed 5 usecs
[  226.153745] ttm_bo_move_accel_cleanup: result: 0, elapsed 156 usecs
[  226.153758] radeon_move_blit: new type: tt, old type: vram
[  226.153764] radeon_copy: result: 0, elapsed 5 usecs
[  226.153831] ttm_bo_move_accel_cleanup: result: 0, elapsed 61 usecs
[  226.153844] radeon_move_blit: new type: tt, old type: vram
[  226.153849] radeon_copy: result: 0, elapsed 5 usecs
[  226.153916] ttm_bo_move_accel_cleanup: result: 0, elapsed 60 usecs
[  226.153929] radeon_move_blit: new type: tt, old type: vram
[  226.153935] radeon_copy: result: 0, elapsed 5 usecs
[  226.153946] ttm_bo_move_accel_cleanup: result: 0, elapsed 6 usecs
[  226.153957] radeon_move_blit: new type: tt, old type: vram
[  226.153962] radeon_copy: result: 0, elapsed 5 usecs
[  226.153989] ttm_bo_move_accel_cleanup: result: 0, elapsed 21 usecs
[  226.154000] radeon_move_blit: new type: tt, old type: vram
[  226.154006] radeon_copy: result: 0, elapsed 5 usecs
[  226.154046] ttm_bo_move_accel_cleanup: result: 0, elapsed 34 usecs
[  226.154055] radeon_move_blit: new type: tt, old type: vram
[  226.154061] radeon_copy: result: 0, elapsed 5 usecs
[  226.154087] ttm_bo_move_accel_cleanup: result: 0, elapsed 21 usecs
[  226.154097] radeon_move_blit: new type: tt, old type: vram
[  226.154103] radeon_copy: result: 0, elapsed 5 usecs
[  226.154128] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.156032] radeon_move_blit: new type: tt, old type: vram
[  226.156038] radeon_copy: result: 0, elapsed 6 usecs
[  226.156479] ttm_bo_move_accel_cleanup: result: 0, elapsed 425 usecs
[  226.156489] radeon_move_blit: new type: tt, old type: vram
[  226.156495] radeon_copy: result: 0, elapsed 5 usecs
[  226.156519] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.156528] radeon_move_blit: new type: tt, old type: vram
[  226.156534] radeon_copy: result: 0, elapsed 5 usecs
[  226.156558] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.156569] radeon_move_blit: new type: tt, old type: vram
[  226.156574] radeon_copy: result: 0, elapsed 5 usecs
[  226.156600] ttm_bo_move_accel_cleanup: result: 0, elapsed 21 usecs
[  226.156609] radeon_move_blit: new type: tt, old type: vram
[  226.156615] radeon_copy: result: 0, elapsed 5 usecs
[  226.156640] ttm_bo_move_accel_cleanup: result: 0, elapsed 20 usecs
[  226.156650] radeon_move_blit: new type: tt, old type: vram
[  226.156656] radeon_copy: result: 0, elapsed 5 usecs
[  226.156681] ttm_bo_move_accel_cleanup: result: 0, elapsed 20 usecs
[  226.156691] radeon_move_blit: new type: tt, old type: vram
[  226.156697] radeon_copy: result: 0, elapsed 5 usecs
[  226.156722] ttm_bo_move_accel_cleanup: result: 0, elapsed 20 usecs
[  226.156732] radeon_move_blit: new type: tt, old type: vram
[  226.156738] radeon_copy: result: 0, elapsed 5 usecs
[  226.156762] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.156772] radeon_move_blit: new type: tt, old type: vram
[  226.156777] radeon_copy: result: 0, elapsed 5 usecs
[  226.156802] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.156814] radeon_move_blit: new type: tt, old type: vram
[  226.156819] radeon_copy: result: 0, elapsed 5 usecs
[  226.156844] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.156854] radeon_move_blit: new type: tt, old type: vram
[  226.156860] radeon_copy: result: 0, elapsed 5 usecs
[  226.156886] ttm_bo_move_accel_cleanup: result: 0, elapsed 21 usecs
[  226.156898] radeon_move_blit: new type: tt, old type: vram
[  226.156903] radeon_copy: result: 0, elapsed 5 usecs
[  226.156929] ttm_bo_move_accel_cleanup: result: 0, elapsed 20 usecs
[  226.156945] radeon_move_blit: new type: tt, old type: vram
[  226.156950] radeon_copy: result: 0, elapsed 5 usecs
[  226.157060] ttm_bo_move_accel_cleanup: result: 0, elapsed 102 usecs
[  226.157092] radeon_move_blit: new type: tt, old type: vram
[  226.157098] radeon_copy: result: 0, elapsed 5 usecs
[  226.248066] ttm_bo_move_accel_cleanup: result: 0, elapsed 88831 usecs
[  226.248076] radeon_move_blit: new type: tt, old type: vram
[  226.248082] radeon_copy: result: 0, elapsed 5 usecs
[  226.248093] ttm_bo_move_accel_cleanup: result: 0, elapsed 6 usecs
[  226.248104] radeon_move_blit: new type: tt, old type: vram
[  226.248110] radeon_copy: result: 0, elapsed 5 usecs
[  226.248150] ttm_bo_move_accel_cleanup: result: 0, elapsed 34 usecs
[  226.248164] radeon_move_blit: new type: tt, old type: vram
[  226.248169] radeon_copy: result: 0, elapsed 5 usecs
[  226.248256] ttm_bo_move_accel_cleanup: result: 0, elapsed 79 usecs
[  226.248266] radeon_move_blit: new type: tt, old type: vram
[  226.248271] radeon_copy: result: 0, elapsed 5 usecs
[  226.248305] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  226.248318] radeon_move_blit: new type: tt, old type: vram
[  226.248324] radeon_copy: result: 0, elapsed 5 usecs
[  226.248389] ttm_bo_move_accel_cleanup: result: 0, elapsed 59 usecs
[  226.248400] radeon_move_blit: new type: tt, old type: vram
[  226.248406] radeon_copy: result: 0, elapsed 5 usecs
[  226.248440] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  226.248449] radeon_move_blit: new type: tt, old type: vram
[  226.248455] radeon_copy: result: 0, elapsed 5 usecs
[  226.248480] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.248507] radeon_move_blit: new type: tt, old type: vram
[  226.248512] radeon_copy: result: 0, elapsed 5 usecs
[  226.248808] ttm_bo_move_accel_cleanup: result: 0, elapsed 283 usecs
[  226.248826] radeon_move_blit: new type: tt, old type: vram
[  226.248831] radeon_copy: result: 0, elapsed 5 usecs
[  226.248981] ttm_bo_move_accel_cleanup: result: 0, elapsed 141 usecs
[  226.248992] radeon_move_blit: new type: tt, old type: vram
[  226.248997] radeon_copy: result: 0, elapsed 5 usecs
[  226.249019] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  226.249030] radeon_move_blit: new type: tt, old type: vram
[  226.249035] radeon_copy: result: 0, elapsed 5 usecs
[  226.249070] ttm_bo_move_accel_cleanup: result: 0, elapsed 29 usecs
[  226.249080] radeon_move_blit: new type: tt, old type: vram
[  226.249086] radeon_copy: result: 0, elapsed 5 usecs
[  226.249125] ttm_bo_move_accel_cleanup: result: 0, elapsed 34 usecs
[  226.249135] radeon_move_blit: new type: tt, old type: vram
[  226.249141] radeon_copy: result: 0, elapsed 5 usecs
[  226.249164] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249174] radeon_move_blit: new type: tt, old type: vram
[  226.249180] radeon_copy: result: 0, elapsed 5 usecs
[  226.249208] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  226.249218] radeon_move_blit: new type: tt, old type: vram
[  226.249224] radeon_copy: result: 0, elapsed 5 usecs
[  226.249247] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249257] radeon_move_blit: new type: tt, old type: vram
[  226.249262] radeon_copy: result: 0, elapsed 5 usecs
[  226.249285] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249296] radeon_move_blit: new type: tt, old type: vram
[  226.249302] radeon_copy: result: 0, elapsed 5 usecs
[  226.249357] ttm_bo_move_accel_cleanup: result: 0, elapsed 48 usecs
[  226.249367] radeon_move_blit: new type: tt, old type: vram
[  226.249372] radeon_copy: result: 0, elapsed 5 usecs
[  226.249397] ttm_bo_move_accel_cleanup: result: 0, elapsed 20 usecs
[  226.249410] radeon_move_blit: new type: tt, old type: vram
[  226.249415] radeon_copy: result: 0, elapsed 5 usecs
[  226.249471] ttm_bo_move_accel_cleanup: result: 0, elapsed 49 usecs
[  226.249481] radeon_move_blit: new type: tt, old type: vram
[  226.249487] radeon_copy: result: 0, elapsed 5 usecs
[  226.249516] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  226.249527] radeon_move_blit: new type: tt, old type: vram
[  226.249533] radeon_copy: result: 0, elapsed 5 usecs
[  226.249568] ttm_bo_move_accel_cleanup: result: 0, elapsed 30 usecs
[  226.249579] radeon_move_blit: new type: tt, old type: vram
[  226.249584] radeon_copy: result: 0, elapsed 5 usecs
[  226.249621] ttm_bo_move_accel_cleanup: result: 0, elapsed 31 usecs
[  226.249631] radeon_move_blit: new type: tt, old type: vram
[  226.249636] radeon_copy: result: 0, elapsed 5 usecs
[  226.249646] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  226.249656] radeon_move_blit: new type: tt, old type: vram
[  226.249662] radeon_copy: result: 0, elapsed 5 usecs
[  226.249686] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.249698] radeon_move_blit: new type: tt, old type: vram
[  226.249704] radeon_copy: result: 0, elapsed 5 usecs
[  226.249728] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249739] radeon_move_blit: new type: tt, old type: vram
[  226.249745] radeon_copy: result: 0, elapsed 5 usecs
[  226.249769] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249780] radeon_move_blit: new type: tt, old type: vram
[  226.249785] radeon_copy: result: 0, elapsed 5 usecs
[  226.249796] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  226.249807] radeon_move_blit: new type: tt, old type: vram
[  226.249812] radeon_copy: result: 0, elapsed 5 usecs
[  226.249836] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249847] radeon_move_blit: new type: tt, old type: vram
[  226.249852] radeon_copy: result: 0, elapsed 5 usecs
[  226.249876] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249886] radeon_move_blit: new type: tt, old type: vram
[  226.249892] radeon_copy: result: 0, elapsed 5 usecs
[  226.249915] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249926] radeon_move_blit: new type: tt, old type: vram
[  226.249931] radeon_copy: result: 0, elapsed 5 usecs
[  226.249955] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  226.249965] radeon_move_blit: new type: tt, old type: vram
[  226.249971] radeon_copy: result: 0, elapsed 5 usecs
[  226.249995] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.250006] radeon_move_blit: new type: tt, old type: vram
[  226.250012] radeon_copy: result: 0, elapsed 5 usecs
[  226.250036] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs
[  226.250052] radeon_move_blit: new type: tt, old type: vram
[  226.250058] radeon_copy: result: 0, elapsed 5 usecs
[  226.250178] ttm_bo_move_accel_cleanup: result: 0, elapsed 113 usecs
[  226.250190] radeon_move_blit: new type: tt, old type: vram
[  226.250196] radeon_copy: result: 0, elapsed 5 usecs
[  226.250275] ttm_bo_move_accel_cleanup: result: 0, elapsed 71 usecs
[  226.250299] radeon_move_blit: new type: tt, old type: vram
[  226.250305] radeon_copy: result: 0, elapsed 6 usecs
[  226.253080] ttm_bo_move_accel_cleanup: result: 0, elapsed 2705 usecs
[  226.253092] radeon_move_blit: new type: tt, old type: vram
[  226.253098] radeon_copy: result: 0, elapsed 5 usecs
[  226.256054] ttm_bo_move_accel_cleanup: result: 0, elapsed 2882 usecs
[  226.256066] radeon_move_blit: new type: tt, old type: vram
[  226.256072] radeon_copy: result: 0, elapsed 5 usecs
[  226.283603] ttm_bo_move_accel_cleanup: result: 0, elapsed 26880 usecs
[  226.283616] radeon_move_blit: new type: tt, old type: vram
[  226.283621] radeon_copy: result: 0, elapsed 5 usecs
[  226.311097] ttm_bo_move_accel_cleanup: result: 0, elapsed 26827 usecs
[  226.311109] radeon_move_blit: new type: tt, old type: vram
[  226.311115] radeon_copy: result: 0, elapsed 5 usecs
[  226.366049] ttm_bo_move_accel_cleanup: result: 0, elapsed 53642 usecs
[  226.366061] radeon_move_blit: new type: tt, old type: vram
[  226.366067] radeon_copy: result: 0, elapsed 5 usecs
[  226.396066] ttm_bo_move_accel_cleanup: result: 0, elapsed 29290 usecs
[  226.396080] radeon_move_blit: new type: tt, old type: vram
[  226.396085] radeon_copy: result: 0, elapsed 5 usecs
[  226.423617] ttm_bo_move_accel_cleanup: result: 0, elapsed 26882 usecs
[  226.423629] radeon_move_blit: new type: tt, old type: vram
[  226.423634] radeon_copy: result: 0, elapsed 5 usecs
[  226.423675] ttm_bo_move_accel_cleanup: result: 0, elapsed 35 usecs
[  226.423686] radeon_move_blit: new type: tt, old type: vram
[  226.423691] radeon_copy: result: 0, elapsed 5 usecs
[  226.423725] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  226.423737] radeon_move_blit: new type: tt, old type: vram
[  226.423743] radeon_copy: result: 0, elapsed 5 usecs
[  226.424053] ttm_bo_move_accel_cleanup: result: 0, elapsed 298 usecs
[  226.425954] radeon_move_blit: new type: tt, old type: vram
[  226.425959] radeon_copy: result: 0, elapsed 6 usecs
[  228.078542] ttm_bo_move_accel_cleanup: result: 0, elapsed 1613845 usecs
[  228.080381] radeon_move_blit: new type: tt, old type: vram
[  228.080387] radeon_copy: result: 0, elapsed 6 usecs
[  228.906023] ttm_bo_move_accel_cleanup: result: 0, elapsed 806280 usecs
[  228.906054] radeon_move_blit: new type: tt, old type: vram
[  228.906059] radeon_copy: result: 0, elapsed 5 usecs
[  229.106037] ttm_bo_move_accel_cleanup: result: 0, elapsed 195285 usecs
[  229.106056] radeon_move_blit: new type: tt, old type: vram
[  229.106062] radeon_copy: result: 0, elapsed 5 usecs
[  229.196080] ttm_bo_move_accel_cleanup: result: 0, elapsed 87903 usecs
[  229.196118] radeon_move_blit: new type: tt, old type: vram
[  229.196124] radeon_copy: result: 0, elapsed 6 usecs
[  229.396100] ttm_bo_move_accel_cleanup: result: 0, elapsed 195284 usecs
[  229.396124] radeon_move_blit: new type: tt, old type: vram
[  229.396130] radeon_copy: result: 0, elapsed 5 usecs
[  229.510015] ttm_bo_move_accel_cleanup: result: 0, elapsed 111211 usecs
[  229.516097] radeon_move_blit: new type: tt, old type: vram
[  229.516104] radeon_copy: result: 0, elapsed 6 usecs
[  234.960990] ttm_bo_move_accel_cleanup: result: 0, elapsed 5317267 usecs
[  234.967296] radeon_move_blit: new type: tt, old type: vram
[  234.967303] radeon_copy: result: 0, elapsed 8 usecs
[  240.333514] ttm_bo_move_accel_cleanup: result: 0, elapsed 5240433 usecs
[  240.335404] radeon_move_blit: new type: tt, old type: vram
[  240.335410] radeon_copy: result: 0, elapsed 6 usecs
[  241.996065] ttm_bo_move_accel_cleanup: result: 0, elapsed 1621728 usecs
[  241.996235] radeon_move_blit: new type: tt, old type: vram
[  241.996241] radeon_copy: result: 0, elapsed 6 usecs
[  243.706028] ttm_bo_move_accel_cleanup: result: 0, elapsed 1669708 usecs
[  243.712517] radeon_move_blit: new type: tt, old type: vram
[  243.712524] radeon_copy: result: 0, elapsed 7 usecs
[  249.306034] ttm_bo_move_accel_cleanup: result: 0, elapsed 5462407 usecs
[  249.306068] radeon_move_blit: new type: tt, old type: vram
[  249.306074] radeon_copy: result: 0, elapsed 6 usecs
[  249.561005] ttm_bo_move_accel_cleanup: result: 0, elapsed 248951 usecs
[  249.561036] radeon_move_blit: new type: tt, old type: vram
[  249.561042] radeon_copy: result: 0, elapsed 5 usecs
[  249.796064] ttm_bo_move_accel_cleanup: result: 0, elapsed 229509 usecs
[  249.802260] radeon_move_blit: new type: tt, old type: vram
[  249.802266] radeon_copy: result: 0, elapsed 6 usecs
[  255.292057] ttm_bo_move_accel_cleanup: result: 0, elapsed 5361118 usecs
[  255.292076] radeon_move_blit: new type: tt, old type: vram
[  255.292082] radeon_copy: result: 0, elapsed 5 usecs
[  255.292099] ttm_bo_move_accel_cleanup: result: 0, elapsed 12 usecs
[  255.292114] radeon_move_blit: new type: tt, old type: vram
[  255.292120] radeon_copy: result: 0, elapsed 5 usecs
[  255.319647] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  255.319659] radeon_move_blit: new type: tt, old type: vram
[  255.319665] radeon_copy: result: 0, elapsed 5 usecs
[  255.319698] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  255.319710] radeon_move_blit: new type: tt, old type: vram
[  255.319715] radeon_copy: result: 0, elapsed 5 usecs
[  255.319749] ttm_bo_move_accel_cleanup: result: 0, elapsed 29 usecs
[  255.319760] radeon_move_blit: new type: tt, old type: vram
[  255.319765] radeon_copy: result: 0, elapsed 5 usecs
[  255.319794] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  255.319804] radeon_move_blit: new type: tt, old type: vram
[  255.319810] radeon_copy: result: 0, elapsed 5 usecs
[  255.319839] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  255.319854] radeon_move_blit: new type: tt, old type: vram
[  255.319859] radeon_copy: result: 0, elapsed 5 usecs
[  255.319890] ttm_bo_move_accel_cleanup: result: 0, elapsed 25 usecs
[  255.319901] radeon_move_blit: new type: tt, old type: vram
[  255.319906] radeon_copy: result: 0, elapsed 4 usecs
[  255.319935] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  255.319945] radeon_move_blit: new type: tt, old type: vram
[  255.319950] radeon_copy: result: 0, elapsed 5 usecs
[  255.319978] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  255.319989] radeon_move_blit: new type: tt, old type: vram
[  255.319995] radeon_copy: result: 0, elapsed 5 usecs
[  255.320022] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  255.320036] radeon_move_blit: new type: tt, old type: vram
[  255.320043] radeon_copy: result: 0, elapsed 6 usecs
[  255.321049] ttm_bo_move_accel_cleanup: result: 0, elapsed 977 usecs
[  255.321059] radeon_move_blit: new type: tt, old type: vram
[  255.321064] radeon_copy: result: 0, elapsed 5 usecs
[  255.321086] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  255.321095] radeon_move_blit: new type: tt, old type: vram
[  255.321101] radeon_copy: result: 0, elapsed 5 usecs
[  255.321121] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  255.321132] radeon_move_blit: new type: tt, old type: vram
[  255.321138] radeon_copy: result: 0, elapsed 5 usecs
[  255.321159] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  255.321189] radeon_move_blit: new type: tt, old type: vram
[  255.321194] radeon_copy: result: 0, elapsed 5 usecs
[  255.451072] ttm_bo_move_accel_cleanup: result: 0, elapsed 126828 usecs
[  255.451083] radeon_move_blit: new type: tt, old type: vram
[  255.451089] radeon_copy: result: 0, elapsed 5 usecs
[  255.478540] ttm_bo_move_accel_cleanup: result: 0, elapsed 26802 usecs
[  255.478550] radeon_move_blit: new type: tt, old type: vram
[  255.478555] radeon_copy: result: 0, elapsed 5 usecs
[  255.478585] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  255.480356] radeon_move_blit: new type: tt, old type: vram
[  255.480361] radeon_copy: result: 0, elapsed 6 usecs
[  255.596065] ttm_bo_move_accel_cleanup: result: 0, elapsed 112986 usecs
[  255.596094] radeon_move_blit: new type: tt, old type: vram
[  255.596100] radeon_copy: result: 0, elapsed 5 usecs
[  255.796089] ttm_bo_move_accel_cleanup: result: 0, elapsed 195297 usecs
[  255.796100] radeon_move_blit: new type: tt, old type: vram
[  255.796105] radeon_copy: result: 0, elapsed 5 usecs
[  255.796127] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  255.796138] radeon_move_blit: new type: tt, old type: vram
[  255.796144] radeon_copy: result: 0, elapsed 5 usecs
[  255.796182] ttm_bo_move_accel_cleanup: result: 0, elapsed 32 usecs
[  255.796193] radeon_move_blit: new type: tt, old type: vram
[  255.796198] radeon_copy: result: 0, elapsed 4 usecs
[  255.800055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3761 usecs
[  255.800066] radeon_move_blit: new type: tt, old type: vram
[  255.800071] radeon_copy: result: 0, elapsed 5 usecs
[  255.800122] ttm_bo_move_accel_cleanup: result: 0, elapsed 45 usecs
[  255.800133] radeon_move_blit: new type: tt, old type: vram
[  255.800139] radeon_copy: result: 0, elapsed 6 usecs
[  255.804053] ttm_bo_move_accel_cleanup: result: 0, elapsed 3817 usecs
[  255.804064] radeon_move_blit: new type: tt, old type: vram
[  255.804070] radeon_copy: result: 0, elapsed 5 usecs
[  255.804121] ttm_bo_move_accel_cleanup: result: 0, elapsed 45 usecs
[  255.804133] radeon_move_blit: new type: tt, old type: vram
[  255.804138] radeon_copy: result: 0, elapsed 5 usecs
[  255.808056] ttm_bo_move_accel_cleanup: result: 0, elapsed 3820 usecs
[  255.808068] radeon_move_blit: new type: tt, old type: vram
[  255.808073] radeon_copy: result: 0, elapsed 5 usecs
[  255.835600] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  255.835612] radeon_move_blit: new type: tt, old type: vram
[  255.835617] radeon_copy: result: 0, elapsed 5 usecs
[  255.863091] ttm_bo_move_accel_cleanup: result: 0, elapsed 26826 usecs
[  255.863103] radeon_move_blit: new type: tt, old type: vram
[  255.863108] radeon_copy: result: 0, elapsed 5 usecs
[  255.890575] ttm_bo_move_accel_cleanup: result: 0, elapsed 26818 usecs
[  255.890585] radeon_move_blit: new type: tt, old type: vram
[  255.890590] radeon_copy: result: 0, elapsed 5 usecs
[  255.890622] ttm_bo_move_accel_cleanup: result: 0, elapsed 27 usecs
[  255.890632] radeon_move_blit: new type: tt, old type: vram
[  255.890638] radeon_copy: result: 0, elapsed 5 usecs
[  255.890671] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  255.890681] radeon_move_blit: new type: tt, old type: vram
[  255.890687] radeon_copy: result: 0, elapsed 5 usecs
[  255.890716] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  255.890839] radeon_move_blit: new type: tt, old type: vram
[  255.890844] radeon_copy: result: 0, elapsed 5 usecs
[  257.051067] ttm_bo_move_accel_cleanup: result: 0, elapsed 1133025 usecs
[  257.051078] radeon_move_blit: new type: tt, old type: vram
[  257.051083] radeon_copy: result: 0, elapsed 5 usecs
[  257.051114] ttm_bo_move_accel_cleanup: result: 0, elapsed 25 usecs
[  257.051124] radeon_move_blit: new type: tt, old type: vram
[  257.051129] radeon_copy: result: 0, elapsed 5 usecs
[  257.051150] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  257.051159] radeon_move_blit: new type: tt, old type: vram
[  257.051164] radeon_copy: result: 0, elapsed 5 usecs
[  257.051185] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  257.051197] radeon_move_blit: new type: tt, old type: vram
[  257.051202] radeon_copy: result: 0, elapsed 5 usecs
[  257.052054] ttm_bo_move_accel_cleanup: result: 0, elapsed 826 usecs
[  257.052066] radeon_move_blit: new type: tt, old type: vram
[  257.052071] radeon_copy: result: 0, elapsed 5 usecs
[  257.056055] ttm_bo_move_accel_cleanup: result: 0, elapsed 3885 usecs
[  257.056067] radeon_move_blit: new type: tt, old type: vram
[  257.056072] radeon_copy: result: 0, elapsed 5 usecs
[  257.083599] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  257.083609] radeon_move_blit: new type: tt, old type: vram
[  257.083614] radeon_copy: result: 0, elapsed 5 usecs
[  257.083643] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  257.083656] radeon_move_blit: new type: tt, old type: vram
[  257.083661] radeon_copy: result: 0, elapsed 5 usecs
[  257.084054] ttm_bo_move_accel_cleanup: result: 0, elapsed 379 usecs
[  257.084066] radeon_move_blit: new type: tt, old type: vram
[  257.084071] radeon_copy: result: 0, elapsed 5 usecs
[  257.088054] ttm_bo_move_accel_cleanup: result: 0, elapsed 3884 usecs
[  257.088066] radeon_move_blit: new type: tt, old type: vram
[  257.088071] radeon_copy: result: 0, elapsed 5 usecs
[  257.115598] ttm_bo_move_accel_cleanup: result: 0, elapsed 26877 usecs
[  257.115609] radeon_move_blit: new type: tt, old type: vram
[  257.115615] radeon_copy: result: 0, elapsed 5 usecs
[  257.143084] ttm_bo_move_accel_cleanup: result: 0, elapsed 26820 usecs
[  257.143095] radeon_move_blit: new type: tt, old type: vram
[  257.143101] radeon_copy: result: 0, elapsed 6 usecs
[  257.170571] ttm_bo_move_accel_cleanup: result: 0, elapsed 26822 usecs
[  257.170582] radeon_move_blit: new type: tt, old type: vram
[  257.170588] radeon_copy: result: 0, elapsed 5 usecs
[  257.196068] ttm_bo_move_accel_cleanup: result: 0, elapsed 24878 usecs
[  257.196080] radeon_move_blit: new type: tt, old type: vram
[  257.196085] radeon_copy: result: 0, elapsed 5 usecs
[  257.196136] ttm_bo_move_accel_cleanup: result: 0, elapsed 44 usecs
[  257.197874] radeon_move_blit: new type: tt, old type: vram
[  257.197879] radeon_copy: result: 0, elapsed 6 usecs
[  257.197927] ttm_bo_move_accel_cleanup: result: 0, elapsed 41 usecs
[  257.197943] radeon_move_blit: new type: tt, old type: vram
[  257.197949] radeon_copy: result: 0, elapsed 5 usecs
[  257.200055] ttm_bo_move_accel_cleanup: result: 0, elapsed 2051 usecs
[  257.200068] radeon_move_blit: new type: tt, old type: vram
[  257.200073] radeon_copy: result: 0, elapsed 5 usecs
[  257.200120] ttm_bo_move_accel_cleanup: result: 0, elapsed 41 usecs
[  257.200130] radeon_move_blit: new type: tt, old type: vram
[  257.200135] radeon_copy: result: 0, elapsed 5 usecs
[  257.200177] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  257.200186] radeon_move_blit: new type: tt, old type: vram
[  257.200192] radeon_copy: result: 0, elapsed 5 usecs
[  257.200221] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  257.200231] radeon_move_blit: new type: tt, old type: vram
[  257.200237] radeon_copy: result: 0, elapsed 5 usecs
[  257.200266] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  257.200275] radeon_move_blit: new type: tt, old type: vram
[  257.200281] radeon_copy: result: 0, elapsed 5 usecs
[  257.200309] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  257.200336] radeon_move_blit: new type: tt, old type: vram
[  257.200341] radeon_copy: result: 0, elapsed 5 usecs
[  257.396064] ttm_bo_move_accel_cleanup: result: 0, elapsed 191130 usecs
[  257.396075] radeon_move_blit: new type: tt, old type: vram
[  257.396081] radeon_copy: result: 0, elapsed 5 usecs
[  257.396123] ttm_bo_move_accel_cleanup: result: 0, elapsed 36 usecs
[  257.396132] radeon_move_blit: new type: tt, old type: vram
[  257.396138] radeon_copy: result: 0, elapsed 5 usecs
[  257.396171] ttm_bo_move_accel_cleanup: result: 0, elapsed 28 usecs
[  257.396181] radeon_move_blit: new type: tt, old type: vram
[  257.396186] radeon_copy: result: 0, elapsed 5 usecs
[  257.396208] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  257.396218] radeon_move_blit: new type: tt, old type: vram
[  257.396223] radeon_copy: result: 0, elapsed 5 usecs
[  257.396252] ttm_bo_move_accel_cleanup: result: 0, elapsed 24 usecs
[  257.396261] radeon_move_blit: new type: tt, old type: vram
[  257.396267] radeon_copy: result: 0, elapsed 5 usecs
[  257.396288] ttm_bo_move_accel_cleanup: result: 0, elapsed 16 usecs
[  257.396298] radeon_move_blit: new type: tt, old type: vram
[  257.396303] radeon_copy: result: 0, elapsed 5 usecs
[  257.396332] ttm_bo_move_accel_cleanup: result: 0, elapsed 23 usecs
[  257.396341] radeon_move_blit: new type: tt, old type: vram
[  257.396347] radeon_copy: result: 0, elapsed 5 usecs
[  257.396367] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  257.396377] radeon_move_blit: new type: tt, old type: vram
[  257.396383] radeon_copy: result: 0, elapsed 5 usecs
[  257.396411] ttm_bo_move_accel_cleanup: result: 0, elapsed 22 usecs
[  257.396419] radeon_move_blit: new type: tt, old type: vram
[  257.396425] radeon_copy: result: 0, elapsed 5 usecs
[  257.396445] ttm_bo_move_accel_cleanup: result: 0, elapsed 15 usecs
[  257.397531] PM: freeze of devices complete after 50901.266 msecs
[  257.398636] PM: late freeze of devices complete after 1.100 msecs
[  257.398705] ACPI: Preparing to enter system sleep state S4
[  257.398909] PM: Saving platform NVS memory
[  257.404716] PM: Saving platform NVS memory
[  257.410415] Disabling non-boot CPUs ...
[  257.420156] Broke affinity for irq 12
[  257.524041] CPU 1 is now offline
[  257.524044] SMP alternatives: switching to UP code
[  257.528345] Extended CMOS year: 2000
[  257.528448] hibernation debug: Waiting for 5 seconds.
[  257.532017] Extended CMOS year: 2000
[  257.532017] Enabling non-boot CPUs ...
[  257.536239] SMP alternatives: switching to SMP code
[  257.539534] Booting Node 0 Processor 1 APIC 0x1
[  257.527447] Switch to broadcast mode on CPU1
[  257.644430] CPU1 is up
[  257.644741] ACPI: Waking up from system sleep state S4
[  257.741605] sata_sil 0000:00:12.0: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
[  257.741828] pata_atiixp 0000:00:14.1: restoring config space at offset 0x1 (was 0x2300001, writing 0x2300005)
[  257.756063] HDA Intel 0000:00:14.2: BAR 0: set to [mem 0x84080000-0x84083fff 64bit] (PCI address [0x84080000-0x84083fff]
[  257.756080] HDA Intel 0000:00:14.2: restoring config space at offset 0xf (was 0x0, writing 0xa)
[  257.756104] HDA Intel 0000:00:14.2: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[  257.756112] HDA Intel 0000:00:14.2: restoring config space at offset 0x1 (was 0x4100000, writing 0x4100002)
[  257.772056] b43-pci-bridge 0000:30:00.0: BAR 0: set to [mem 0xc8000000-0xc8003fff] (PCI address [0xc8000000-0xc8003fff]
[  257.772098] b43-pci-bridge 0000:30:00.0: restoring config space at offset 0x1 (was 0x100003, writing 0x100007)
[  257.788059] tg3 0000:02:01.0: BAR 0: set to [mem 0xd4000000-0xd400ffff] (PCI address [0xd4000000-0xd400ffff]
[  257.804058] ohci1394 0000:02:04.1: BAR 0: set to [mem 0xd4011000-0xd40117ff] (PCI address [0xd4011000-0xd40117ff]
[  257.804066] ohci1394 0000:02:04.1: BAR 1: set to [mem 0xd4014000-0xd4017fff] (PCI address [0xd4014000-0xd4017fff]
[  257.804081] ohci1394 0000:02:04.1: restoring config space at offset 0xf (was 0x4020100, writing 0x402010a)
[  257.804111] ohci1394 0000:02:04.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
[  257.804121] ohci1394 0000:02:04.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[  257.820058] tifm_7xx1 0000:02:04.2: BAR 0: set to [mem 0xd4018000-0xd4018fff] (PCI address [0xd4018000-0xd4018fff]
[  257.820072] tifm_7xx1 0000:02:04.2: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010a)
[  257.820103] tifm_7xx1 0000:02:04.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
[  257.820112] tifm_7xx1 0000:02:04.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[  257.836059] sdhci-pci 0000:02:04.3: BAR 0: set to [mem 0xd4019000-0xd40190ff] (PCI address [0xd4019000-0xd40190ff]
[  257.836073] sdhci-pci 0000:02:04.3: restoring config space at offset 0xf (was 0x40701ff, writing 0x407010a)
[  257.836103] sdhci-pci 0000:02:04.3: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
[  257.836112] sdhci-pci 0000:02:04.3: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[  257.836369] PM: early restore of devices complete after 94.901 msecs
[  258.116099] sata_sil 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  258.116335] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  258.118083] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  258.118263] b43-pci-bridge 0000:30:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  258.118356] tifm_7xx1 0000:02:04.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  258.118379] sdhci-pci 0000:02:04.3: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  258.118421] sd 0:0:0:0: [sda] Starting disk
[  258.129238] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[  258.129750] [drm] radeon: ring at 0x0000000080000000
[  258.129768] [drm] ring test succeeded in 1 usecs
[  258.129780] [drm] ib test succeeded in 0 usecs
[  258.172018] usb usb3: root hub lost power or was reset
[  258.176020] usb usb2: root hub lost power or was reset
[  258.176084] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[  258.176156] usb usb1: root hub lost power or was reset
[  258.285625] ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[  258.285630] ata3.00: ACPI cmd ef/03:22:00:00:00:a0 (SET FEATURES) filtered out
[  258.301585] ata3.00: configured for MWDMA2
[  258.433088] ata2: SATA link down (SStatus 0 SControl 300)
[  258.433149] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  258.457375] ata1.00: configured for UDMA/100
[  258.652049] usb 3-1: reset full speed USB device using ohci_hcd and address 2
[  259.024057] usb 2-2: reset full speed USB device using ohci_hcd and address 2
[  259.232120] btusb 2-2:1.0: no reset_resume for driver btusb?
[  259.232123] btusb 2-2:1.1: no reset_resume for driver btusb?
[  259.624175] PM: restore of devices complete after 1508.162 msecs
[  259.731553] snapshot_ioctl: ioctl '4004330c' is deprecated and will be removed soon, update your suspend-to-disk utilities
[  259.731557] Restarting tasks ... 
[  259.760608] radeon_move_blit: new type: vram, old type: tt
[  259.760619] radeon_copy: result: 0, elapsed 14 usecs
[  259.760635] ttm_bo_move_accel_cleanup: result: 0, elapsed 9 usecs
[  259.760644] radeon_move_blit: new type: vram, old type: tt
[  259.760649] radeon_copy: result: 0, elapsed 5 usecs
[  259.760658] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.760666] radeon_move_blit: new type: vram, old type: tt
[  259.760671] radeon_copy: result: 0, elapsed 5 usecs
[  259.760679] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.760686] radeon_move_blit: new type: vram, old type: tt
[  259.760691] radeon_copy: result: 0, elapsed 4 usecs
[  259.760698] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.760705] radeon_move_blit: new type: vram, old type: tt
[  259.760711] radeon_copy: result: 0, elapsed 5 usecs
[  259.760718] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.760724] radeon_move_blit: new type: vram, old type: tt
[  259.760729] radeon_copy: result: 0, elapsed 5 usecs
[  259.760737] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.760744] radeon_move_blit: new type: vram, old type: tt
[  259.760749] radeon_copy: result: 0, elapsed 5 usecs
[  259.762954] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.762981] radeon_move_blit: new type: vram, old type: tt
[  259.762989] radeon_copy: result: 0, elapsed 9 usecs
[  259.763002] ttm_bo_move_accel_cleanup: result: 0, elapsed 7 usecs
[  259.763011] radeon_move_blit: new type: vram, old type: tt
[  259.763016] radeon_copy: result: 0, elapsed 5 usecs
[  259.763026] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.763034] radeon_move_blit: new type: vram, old type: tt
[  259.763039] radeon_copy: result: 0, elapsed 5 usecs
[  259.763048] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.763056] radeon_move_blit: new type: vram, old type: tt
[  259.763061] radeon_copy: result: 0, elapsed 5 usecs
[  259.763069] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.763077] radeon_move_blit: new type: vram, old type: tt
[  259.763082] radeon_copy: result: 0, elapsed 5 usecs
[  259.763135] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.763143] radeon_move_blit: new type: vram, old type: tt
[  259.763149] radeon_copy: result: 0, elapsed 5 usecs
[  259.763157] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.763164] radeon_move_blit: new type: vram, old type: tt
[  259.763170] radeon_copy: result: 0, elapsed 5 usecs
[  259.763179] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.763188] radeon_move_blit: new type: vram, old type: tt
[  259.763194] radeon_copy: result: 0, elapsed 5 usecs
[  259.763203] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.763211] radeon_move_blit: new type: vram, old type: tt
[  259.763216] radeon_copy: result: 0, elapsed 5 usecs
[  259.763225] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.763234] radeon_move_blit: new type: vram, old type: tt
[  259.763239] radeon_copy: result: 0, elapsed 5 usecs
[  259.763247] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  259.763255] radeon_move_blit: new type: vram, old type: tt
[  259.763261] radeon_copy: result: 0, elapsed 6 usecs
[  259.763270] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.763297] radeon_move_blit: new type: vram, old type: tt
[  259.763303] radeon_copy: result: 0, elapsed 5 usecs
[  259.769865] ttm_bo_move_accel_cleanup: result: 0, elapsed 6399 usecs
[  259.769892] radeon_move_blit: new type: vram, old type: tt
[  259.769900] radeon_copy: result: 0, elapsed 9 usecs
[  259.770083] ttm_bo_move_accel_cleanup: result: 0, elapsed 173 usecs
[  259.779066] radeon_move_blit: new type: vram, old type: tt
[  259.779077] radeon_copy: result: 0, elapsed 15 usecs
[  259.780082] ttm_bo_move_accel_cleanup: result: 0, elapsed 971 usecs
[  259.780170] radeon_move_blit: new type: vram, old type: tt
[  259.780179] radeon_copy: result: 0, elapsed 9 usecs
[  259.780192] ttm_bo_move_accel_cleanup: result: 0, elapsed 8 usecs
[  259.780215] radeon_move_blit: new type: vram, old type: tt
[  259.780221] radeon_copy: result: 0, elapsed 5 usecs
[  259.784064] done.
[  259.786245] ttm_bo_move_accel_cleanup: result: 0, elapsed 5876 usecs
[  259.787064] radeon_move_blit: new type: vram, old type: tt
[  259.787079] radeon_copy: result: 0, elapsed 16 usecs
[  259.787143] ttm_bo_move_accel_cleanup: result: 0, elapsed 54 usecs
[  259.838803] PM: Basic memory bitmaps freed
[  259.838812] video LNXVIDEO:00: Restoring backlight state
[  259.865621] radeon_move_blit: new type: vram, old type: tt
[  259.865659] radeon_copy: result: 0, elapsed 41 usecs
[  259.867472] ttm_bo_move_accel_cleanup: result: 0, elapsed 1751 usecs
[  259.904866] radeon_move_blit: new type: vram, old type: tt
[  259.904908] radeon_copy: result: 0, elapsed 46 usecs
[  259.904937] ttm_bo_move_accel_cleanup: result: 0, elapsed 9 usecs
[  259.904962] radeon_move_blit: new type: vram, old type: tt
[  259.904982] radeon_copy: result: 0, elapsed 19 usecs
[  259.905007] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  259.906446] radeon_move_blit: new type: vram, old type: tt
[  259.906497] radeon_copy: result: 0, elapsed 56 usecs
[  259.915837] ttm_bo_move_accel_cleanup: result: 0, elapsed 9099 usecs
[  259.915945] radeon_move_blit: new type: vram, old type: tt
[  259.915969] radeon_copy: result: 0, elapsed 24 usecs
[  259.920734] ttm_bo_move_accel_cleanup: result: 0, elapsed 4627 usecs
[  259.922621] radeon_move_blit: new type: vram, old type: tt
[  259.922663] radeon_copy: result: 0, elapsed 46 usecs
[  259.922690] ttm_bo_move_accel_cleanup: result: 0, elapsed 7 usecs
[  259.922718] radeon_move_blit: new type: vram, old type: tt
[  259.922739] radeon_copy: result: 0, elapsed 20 usecs
[  259.923836] ttm_bo_move_accel_cleanup: result: 0, elapsed 1051 usecs
[  259.923890] radeon_move_blit: new type: vram, old type: tt
[  259.923913] radeon_copy: result: 0, elapsed 22 usecs
[  259.923939] ttm_bo_move_accel_cleanup: result: 0, elapsed 6 usecs
[  259.923965] radeon_move_blit: new type: vram, old type: tt
[  259.923986] radeon_copy: result: 0, elapsed 20 usecs
[  259.924044] ttm_bo_move_accel_cleanup: result: 0, elapsed 6 usecs
[  259.926508] radeon_move_blit: new type: vram, old type: tt
[  259.926559] radeon_copy: result: 0, elapsed 56 usecs
[  259.944371] ttm_bo_move_accel_cleanup: result: 0, elapsed 17370 usecs
[  259.946170] radeon_move_blit: new type: vram, old type: tt
[  259.946208] radeon_copy: result: 0, elapsed 40 usecs
[  259.959284] ttm_bo_move_accel_cleanup: result: 0, elapsed 12747 usecs
[  259.959724] radeon_move_blit: new type: vram, old type: tt
[  259.959754] radeon_copy: result: 0, elapsed 30 usecs
[  259.959779] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  259.959883] radeon_move_blit: new type: vram, old type: tt
[  259.959909] radeon_copy: result: 0, elapsed 25 usecs
[  259.959934] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.960073] radeon_move_blit: new type: vram, old type: tt
[  259.960099] radeon_copy: result: 0, elapsed 25 usecs
[  259.960124] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.960212] radeon_move_blit: new type: vram, old type: tt
[  259.960237] radeon_copy: result: 0, elapsed 25 usecs
[  259.960262] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  259.960348] radeon_move_blit: new type: vram, old type: tt
[  259.960374] radeon_copy: result: 0, elapsed 25 usecs
[  259.962335] ttm_bo_move_accel_cleanup: result: 0, elapsed 1893 usecs
[  259.962646] radeon_move_blit: new type: vram, old type: tt
[  259.962672] radeon_copy: result: 0, elapsed 27 usecs
[  259.962696] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.962783] radeon_move_blit: new type: vram, old type: tt
[  259.962810] radeon_copy: result: 0, elapsed 26 usecs
[  259.962835] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.962925] radeon_move_blit: new type: vram, old type: tt
[  259.962951] radeon_copy: result: 0, elapsed 25 usecs
[  259.962976] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  259.963348] radeon_move_blit: new type: vram, old type: tt
[  259.963376] radeon_copy: result: 0, elapsed 28 usecs
[  259.963612] ttm_bo_move_accel_cleanup: result: 0, elapsed 211 usecs
[  259.963803] radeon_move_blit: new type: vram, old type: tt
[  259.963830] radeon_copy: result: 0, elapsed 27 usecs
[  259.963944] ttm_bo_move_accel_cleanup: result: 0, elapsed 91 usecs
[  259.964154] radeon_move_blit: new type: vram, old type: tt
[  259.964181] radeon_copy: result: 0, elapsed 26 usecs
[  259.964498] ttm_bo_move_accel_cleanup: result: 0, elapsed 291 usecs
[  259.964636] radeon_move_blit: new type: vram, old type: tt
[  259.964661] radeon_copy: result: 0, elapsed 25 usecs
[  259.964707] ttm_bo_move_accel_cleanup: result: 0, elapsed 25 usecs
[  259.979892] radeon_move_blit: new type: vram, old type: tt
[  259.979931] radeon_copy: result: 0, elapsed 42 usecs
[  259.979960] ttm_bo_move_accel_cleanup: result: 0, elapsed 8 usecs
[  259.980266] radeon_move_blit: new type: vram, old type: tt
[  259.980293] radeon_copy: result: 0, elapsed 27 usecs
[  259.980316] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  260.065886] radeon_move_blit: new type: vram, old type: tt
[  260.065927] radeon_copy: result: 0, elapsed 42 usecs
[  260.066285] ttm_bo_move_accel_cleanup: result: 0, elapsed 330 usecs
[  260.066316] radeon_move_blit: new type: vram, old type: tt
[  260.066337] radeon_copy: result: 0, elapsed 20 usecs
[  260.066364] ttm_bo_move_accel_cleanup: result: 0, elapsed 7 usecs
[  260.066387] radeon_move_blit: new type: vram, old type: tt
[  260.066408] radeon_copy: result: 0, elapsed 20 usecs
[  260.066430] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  260.066454] radeon_move_blit: new type: vram, old type: tt
[  260.066474] radeon_copy: result: 0, elapsed 20 usecs
[  260.066497] ttm_bo_move_accel_cleanup: result: 0, elapsed 3 usecs
[  260.066529] radeon_move_blit: new type: vram, old type: tt
[  260.066551] radeon_copy: result: 0, elapsed 21 usecs
[  260.066667] ttm_bo_move_accel_cleanup: result: 0, elapsed 94 usecs
[  260.066697] radeon_move_blit: new type: vram, old type: tt
[  260.066718] radeon_copy: result: 0, elapsed 21 usecs
[  260.066817] ttm_bo_move_accel_cleanup: result: 0, elapsed 78 usecs
[  260.066847] radeon_move_blit: new type: vram, old type: tt
[  260.066868] radeon_copy: result: 0, elapsed 20 usecs
[  260.066892] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  260.066916] radeon_move_blit: new type: vram, old type: tt
[  260.066937] radeon_copy: result: 0, elapsed 20 usecs
[  260.066960] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  260.066985] radeon_move_blit: new type: vram, old type: tt
[  260.067006] radeon_copy: result: 0, elapsed 20 usecs
[  260.067099] ttm_bo_move_accel_cleanup: result: 0, elapsed 72 usecs
[  260.067127] radeon_move_blit: new type: vram, old type: tt
[  260.067148] radeon_copy: result: 0, elapsed 20 usecs
[  260.067172] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  260.067196] radeon_move_blit: new type: vram, old type: tt
[  260.067217] radeon_copy: result: 0, elapsed 20 usecs
[  260.067315] ttm_bo_move_accel_cleanup: result: 0, elapsed 76 usecs
[  260.067344] radeon_move_blit: new type: vram, old type: tt
[  260.067365] radeon_copy: result: 0, elapsed 20 usecs
[  260.067388] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  260.232266] tg3 0000:02:01.0: wake-up capability disabled by ACPI
[  260.232304] tg3 0000:02:01.0: PME# disabled
[  260.552919] radeon_move_blit: new type: vram, old type: tt
[  260.552958] radeon_copy: result: 0, elapsed 41 usecs
[  260.552988] ttm_bo_move_accel_cleanup: result: 0, elapsed 10 usecs
[  260.553022] radeon_move_blit: new type: vram, old type: tt
[  260.553043] radeon_copy: result: 0, elapsed 20 usecs
[  260.553113] ttm_bo_move_accel_cleanup: result: 0, elapsed 50 usecs
[  260.553141] radeon_move_blit: new type: vram, old type: tt
[  260.553162] radeon_copy: result: 0, elapsed 20 usecs
[  260.553868] ttm_bo_move_accel_cleanup: result: 0, elapsed 667 usecs
[  260.553914] radeon_move_blit: new type: vram, old type: tt
[  260.553936] radeon_copy: result: 0, elapsed 22 usecs
[  260.553961] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  260.553988] radeon_move_blit: new type: vram, old type: tt
[  260.554009] radeon_copy: result: 0, elapsed 20 usecs
[  260.554033] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  260.554870] radeon_move_blit: new type: vram, old type: tt
[  260.554904] radeon_copy: result: 0, elapsed 34 usecs
[  260.554931] ttm_bo_move_accel_cleanup: result: 0, elapsed 7 usecs
[  260.561142] radeon_move_blit: new type: vram, old type: tt
[  260.561182] radeon_copy: result: 0, elapsed 43 usecs
[  260.561303] ttm_bo_move_accel_cleanup: result: 0, elapsed 98 usecs
[  260.561338] radeon_move_blit: new type: vram, old type: tt
[  260.561359] radeon_copy: result: 0, elapsed 21 usecs
[  260.561386] ttm_bo_move_accel_cleanup: result: 0, elapsed 6 usecs
[  260.561411] radeon_move_blit: new type: vram, old type: tt
[  260.561433] radeon_copy: result: 0, elapsed 21 usecs
[  260.561699] ttm_bo_move_accel_cleanup: result: 0, elapsed 240 usecs
[  260.561731] radeon_move_blit: new type: vram, old type: tt
[  260.561753] radeon_copy: result: 0, elapsed 21 usecs
[  260.561873] ttm_bo_move_accel_cleanup: result: 0, elapsed 96 usecs
[  260.561902] radeon_move_blit: new type: vram, old type: tt
[  260.561924] radeon_copy: result: 0, elapsed 21 usecs
[  260.561948] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  260.561975] radeon_move_blit: new type: vram, old type: tt
[  260.561996] radeon_copy: result: 0, elapsed 20 usecs
[  260.562059] ttm_bo_move_accel_cleanup: result: 0, elapsed 42 usecs
[  260.562084] radeon_move_blit: new type: vram, old type: tt
[  260.562105] radeon_copy: result: 0, elapsed 20 usecs
[  260.562177] ttm_bo_move_accel_cleanup: result: 0, elapsed 51 usecs
[  260.562204] radeon_move_blit: new type: vram, old type: tt
[  260.562225] radeon_copy: result: 0, elapsed 20 usecs
[  260.562646] ttm_bo_move_accel_cleanup: result: 0, elapsed 391 usecs
[  260.717053] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[  260.772101] b43-phy0 debug: Chip initialized
[  260.772331] b43-phy0 debug: 32-bit DMA initialized
[  260.772400] b43-phy0 debug: QoS enabled
[  260.796681] b43-phy0 debug: Wireless interface started
[  260.808459] b43-phy0 debug: Adding Interface type 2
[  261.072362] radeon_move_blit: new type: vram, old type: tt
[  261.072403] radeon_copy: result: 0, elapsed 43 usecs
[  261.072435] ttm_bo_move_accel_cleanup: result: 0, elapsed 11 usecs
[  262.036369] radeon_move_blit: new type: vram, old type: tt
[  262.036463] radeon_copy: result: 0, elapsed 97 usecs
[  262.036543] ttm_bo_move_accel_cleanup: result: 0, elapsed 33 usecs
[  262.036613] radeon_move_blit: new type: vram, old type: tt
[  262.036665] radeon_copy: result: 0, elapsed 51 usecs
[  262.036723] ttm_bo_move_accel_cleanup: result: 0, elapsed 9 usecs
[  262.036800] radeon_move_blit: new type: vram, old type: tt
[  262.036856] radeon_copy: result: 0, elapsed 55 usecs
[  262.036913] ttm_bo_move_accel_cleanup: result: 0, elapsed 8 usecs
[  262.963399] tg3 0000:02:01.0: eth2: Link is up at 1000 Mbps, full duplex
[  262.963485] tg3 0000:02:01.0: eth2: Flow control is on for TX and on for RX
[  267.244337] wlan0: deauthenticating from 00:1d:7e:aa:87:ee by local choice (reason=3)
[  267.428210] wlan0: authenticate with 00:1d:7e:aa:87:ee (try 1)
[  267.429380] wlan0: authenticated
[  267.429808] wlan0: associate with 00:1d:7e:aa:87:ee (try 1)
[  267.431257] wlan0: RX AssocResp from 00:1d:7e:aa:87:ee (capab=0x411 status=0 aid=1)
[  267.431267] wlan0: associated
[  267.452237] b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:7e:aa:87:ee
[  267.452343] b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[  268.055109] radeon_move_blit: new type: vram, old type: tt
[  268.055201] radeon_copy: result: 0, elapsed 98 usecs
[  268.055265] ttm_bo_move_accel_cleanup: result: 0, elapsed 17 usecs
[  268.107593] radeon_move_blit: new type: vram, old type: tt
[  268.107681] radeon_copy: result: 0, elapsed 94 usecs
[  268.107745] ttm_bo_move_accel_cleanup: result: 0, elapsed 18 usecs
[  268.593116] radeon_move_blit: new type: vram, old type: tt
[  268.593154] radeon_copy: result: 0, elapsed 41 usecs
[  268.593214] ttm_bo_move_accel_cleanup: result: 0, elapsed 39 usecs
[  268.593240] radeon_move_blit: new type: vram, old type: tt
[  268.593261] radeon_copy: result: 0, elapsed 20 usecs
[  268.593286] ttm_bo_move_accel_cleanup: result: 0, elapsed 5 usecs
[  268.593310] radeon_move_blit: new type: vram, old type: tt
[  268.593331] radeon_copy: result: 0, elapsed 20 usecs
[  268.593354] ttm_bo_move_accel_cleanup: result: 0, elapsed 4 usecs
[  271.278445] radeon_move_blit: new type: vram, old type: tt
[  271.278541] radeon_copy: result: 0, elapsed 103 usecs
[  271.278608] ttm_bo_move_accel_cleanup: result: 0, elapsed 19 usecs

--Boundary-00=_Z88HMEqBdWrtKqn--
