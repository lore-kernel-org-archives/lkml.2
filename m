Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1HWRQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:16:10 -0400
Received: from mail.microway.com ([206.173.81.22]:40410 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755319Ab1HWRQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:16:05 -0400
Message-ID: <6ab7a83c84d6398ffc089f925da89658.squirrel@www.microway.com>
In-Reply-To: <201108222313.26769.rjw@sisk.pl>
References: <201108171751.51648.rick@microway.com>
    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>
    <201108222313.26769.rjw@sisk.pl>
Date: Tue, 23 Aug 2011 13:16:03 -0400
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
From: rick@microway.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, "Richard Houghton" <rhoughton@microway.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>
User-Agent: SquirrelMail/1.4.21
X-Priority: 3 (Normal)
Importance: Normal
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hi,
>
> On Monday, August 22, 2011, Rick Warner wrote:
> ...
>> Hi Rafael,
>>
>> Thanks for the off-list help in getting you this info.
>>
>> I had already rebuilt the kernel using the change I mentioned earlier
>> (test on
>> !&g->error_status_address) since the call trace I got.
>>
>> I luckily still had a copy of the kernel and modules I built previously
>> using
>> just your patch, so I undid my change to the ghes.c source, leaving just
>> your
>> patch but not mine so it would match the ghes.ko module I ran on.  This
>> is the
>> output of gdb on that ghes.ko now:
>>
>> (gdb) l *ghes_read_estatus+0x38
>> 0x258 is in ghes_read_estatus (drivers/acpi/apei/ghes.c:296).
>> warning: Source file is more recent than executable.
>> 291             int rc;
>> 292             if (!g)
>> 293                     return -EINVAL;
>> 294
>> 295             rc = acpi_atomic_read(&buf_paddr,
>> &g->error_status_address);
>> 296             if (rc) {
>> 297                     if (!silent && printk_ratelimit())
>> 298                             pr_warning(FW_WARN GHES_PFX
>> 299     "Failed to read error status block address for hardware error
>> source:
>> %d.\n",
>> 300                                        g->header.source_id);
>>
>> The warning about the source being newer is because of the reverted
>> change in
>> the ghes.c source mentioned above.
>
> OK, since &buf_addr cannot be NULL, perhaps ghes is.  Please check if the
> appended patch makes a difference.
>
> Thanks,
> Rafael
>
> ---
>  drivers/acpi/apei/ghes.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> Index: linux/drivers/acpi/apei/ghes.c
> ===================================================================
> --- linux.orig/drivers/acpi/apei/ghes.c
> +++ linux/drivers/acpi/apei/ghes.c
> @@ -393,11 +393,16 @@ static void ghes_copy_tofrom_phys(void *
>
>  static int ghes_read_estatus(struct ghes *ghes, int silent)
>  {
> -	struct acpi_hest_generic *g = ghes->generic;
> +	struct acpi_hest_generic *g;
>  	u64 buf_paddr;
>  	u32 len;
>  	int rc;
>
> +	if (!ghes || !ghes->generic)
> +		return -EINVAL;
> +
> +	g = ghes->generic;
> +
>  	rc = acpi_atomic_read(&buf_paddr, &g->error_status_address);
>  	if (rc) {
>  		if (!silent && printk_ratelimit())
>

Unfortunately it had another panic with this patch in place.  Here is the
latest call trace:

[64614.937968] BUG: unable to handle kernel NULL pointer dereference at   
       (null)
[64614.945851] IP: [<ffffffff812a211d>] acpi_atomic_read+0x8d/0xcb
[64614.951817] PGD 2f8d40067 PUD 2f8cf8067 PMD 0
[64614.956346] Oops: 0000 [#1] PREEMPT SMP
[64614.960344] last sysfs file:
/sys/devices/system/cpu/cpu15/cache/index2/shared_cpu_map
[64614.968265] CPU 14
[64614.970203] Modules linked in: md5 nfsd lockd nfs_acl auth_rpcgss
sunrpc ipt_MASQUERADE iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables af_packet
edd cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq
mperf xfs dm_mod igb joydev sr_mod cdrom pcspkr sg ioatdma button iTCO_wdt
iTCO_vendor_support dca ghes hed i2c_i801 i7core_edac edac_core ext4 jbd2
crc16 raid456 async_raid6_recov async_pq raid6_pq async_xor xor
async_memcpy async_tx raid10 raid1 raid0 fan processor thermal thermal_sys
ata_generic pata_atiixp arcmsr
[64615.024806]
[64615.026305] Pid: 10723, comm: cluster Not tainted
2.6.39.3-microwaycustom #5 Supermicro X8DTH-i/6/iF/6F/X8DTH
[64615.036291] RIP: 0010:[<ffffffff812a211d>]  [<ffffffff812a211d>]
acpi_atomic_read+0x8d/0xcb
[64615.044671] RSP: 0000:ffff88063fcc7da8  EFLAGS: 00010046
[64615.049994] RAX: 0000000000000000 RBX: ffff88063fcc7df0 RCX:
00000000bf7b6000
[64615.057132] RDX: 0000000000000000 RSI: 00000000bf7b6010 RDI:
00000000bf7b5ff0
[64615.064271] RBP: ffff88063fcc7dd8 R08: 00000000bf7b7000 R09:
0000000000000002
[64615.071411] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffc90003044c20
[64615.078549] R13: 0000000000000000 R14: 00000000bf7b5ff0 R15:
0000000000000000
[64615.085688] FS:  0000000000000000(0000) GS:ffff88063fcc0000(0000)
knlGS:0000000000000000
[64615.093771] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[64615.099517] CR2: 0000000000000000 CR3: 00000003015b1000 CR4:
00000000000006e0
[64615.106658] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[64615.113795] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[64615.120928] Process cluster (pid: 10723, threadinfo ffff8802fb3b6000,
task ffff880301534640)
[64615.129361] Stack:
[64615.131386]  0000000000000000 00000000bf7b5ff0 00000000ffffffea
ffff88032b1c3d40
[64615.138871]  0000000000000001 ffffc90003044ca8 ffff88063fcc7e18
ffffffffa01b7245
[64615.146354]  0000000000000000 0000000000000000 ffff88032b1c3d40
0000000000000000
[64615.153840] Call Trace:
[64615.156293]  <NMI>
[64615.158442]  [<ffffffffa01b7245>] ghes_read_estatus+0x55/0x180 [ghes]
[64615.164900]  [<ffffffffa01b760c>] ghes_notify_nmi+0xbc/0x190 [ghes]
[64615.171182]  [<ffffffff8150ddfd>] notifier_call_chain+0x4d/0x70
[64615.177116]  [<ffffffff8150de63>] __atomic_notifier_call_chain+0x43/0x60
[64615.183824]  [<ffffffff8150de91>] atomic_notifier_call_chain+0x11/0x20
[64615.190373]  [<ffffffff8150dece>] notify_die+0x2e/0x30
[64615.195535]  [<ffffffff8150b4f2>] do_nmi+0xa2/0x260
[64615.200430]  [<ffffffff8150b150>] nmi+0x20/0x30
[64615.204981]  [<ffffffff81029f6a>] ? native_write_msr_safe+0xa/0x10
[64615.211170]  <<EOE>>
[64615.213276]  <IRQ>
[64615.215609]  [<ffffffff81011568>] intel_pmu_disable_all+0x38/0xb0
[64615.221710]  [<ffffffff81010efa>] x86_pmu_disable+0x4a/0x50
[64615.227306]  [<ffffffff810ea842>] perf_event_task_tick+0x1a2/0x2a0
[64615.233495]  [<ffffffff81050750>] scheduler_tick+0x1b0/0x290
[64615.239165]  [<ffffffff81066c29>] update_process_times+0x69/0x80
[64615.245193]  [<ffffffff81088098>] tick_sched_timer+0x58/0x150
[64615.250956]  [<ffffffff8107b7ef>] __run_hrtimer+0x6f/0x250
[64615.256459]  [<ffffffff81088040>] ? tick_init_highres+0x20/0x20
[64615.262393]  [<ffffffff8107bf7a>] hrtimer_interrupt+0xda/0x230
[64615.268244]  [<ffffffff8101f5c6>] smp_apic_timer_interrupt+0x66/0xa0
[64615.274622]  [<ffffffff815120f3>] apic_timer_interrupt+0x13/0x20
[64615.280633]  <EOI>
[64615.282570] Code: fc 10 74 1f 77 08 41 80 fc 08 75 49 eb 0e 41 80 fc 20
74 17 41 80 fc 40 75 3b eb 15 8a 00 0f b6 c0 eb 11 66 8b 00 0f b7 c0 eb 09
<8b> 00 89 c0 eb 03 48 8b 00 48 89 03 e8 62 55 e2 ff eb 1d 41 0f
[64615.303108] RIP  [<ffffffff812a211d>] acpi_atomic_read+0x8d/0xcb
[64615.309163]  RSP <ffff88063fcc7da8>
[64615.312668] CR2: 0000000000000000
[64615.316007] ---[ end trace 3ab5dd3ba3391edf ]---
[64615.320637] Kernel panic - not syncing: Fatal exception in interrupt
[64615.326999] Pid: 10723, comm: cluster Tainted: G      D    
2.6.39.3-microwaycustom #5
[64615.334914] Call Trace:
[64615.337371]  <NMI>  [<ffffffff815071ee>] panic+0x9b/0x1b0
[64615.342837]  [<ffffffff8150bb4a>] oops_end+0xea/0xf0
[64615.347828]  [<ffffffff81031dc3>] no_context+0xf3/0x260
[64615.353081]  [<ffffffff81032055>] __bad_area_nosemaphore+0x125/0x1e0
[64615.359456]  [<ffffffff8103211e>] bad_area_nosemaphore+0xe/0x10
[64615.365389]  [<ffffffff8150dd10>] do_page_fault+0x500/0x5a0
[64615.370985]  [<ffffffff810eb839>] ? __perf_event_overflow+0x99/0x210
[64615.377357]  [<ffffffff8150ae95>] page_fault+0x25/0x30
[64615.382516]  [<ffffffff812a211d>] ? acpi_atomic_read+0x8d/0xcb
[64615.388365]  [<ffffffff812a20f0>] ? acpi_atomic_read+0x60/0xcb
[64615.394224]  [<ffffffffa01b7245>] ghes_read_estatus+0x55/0x180 [ghes]
[64615.400685]  [<ffffffffa01b760c>] ghes_notify_nmi+0xbc/0x190 [ghes]
[64615.406959]  [<ffffffff8150ddfd>] notifier_call_chain+0x4d/0x70
[64615.412887]  [<ffffffff8150de63>] __atomic_notifier_call_chain+0x43/0x60
[64615.419594]  [<ffffffff8150de91>] atomic_notifier_call_chain+0x11/0x20
[64615.426138]  [<ffffffff8150dece>] notify_die+0x2e/0x30
[64615.431292]  [<ffffffff8150b4f2>] do_nmi+0xa2/0x260
[64615.436180]  [<ffffffff8150b150>] nmi+0x20/0x30
[64615.440730]  [<ffffffff81029f6a>] ? native_write_msr_safe+0xa/0x10
[64615.446911]  <<EOE>>  <IRQ>  [<ffffffff81011568>]
intel_pmu_disable_all+0x38/0xb0
[64615.454467]  [<ffffffff81010efa>] x86_pmu_disable+0x4a/0x50
[64615.460050]  [<ffffffff810ea842>] perf_event_task_tick+0x1a2/0x2a0
[64615.466233]  [<ffffffff81050750>] scheduler_tick+0x1b0/0x290
[64615.471908]  [<ffffffff81066c29>] update_process_times+0x69/0x80
[64615.477933]  [<ffffffff81088098>] tick_sched_timer+0x58/0x150
[64615.483691]  [<ffffffff8107b7ef>] __run_hrtimer+0x6f/0x250
[64615.489202]  [<ffffffff81088040>] ? tick_init_highres+0x20/0x20
[64615.495138]  [<ffffffff8107bf7a>] hrtimer_interrupt+0xda/0x230
[64615.500989]  [<ffffffff8101f5c6>] smp_apic_timer_interrupt+0x66/0xa0
[64615.507362]  [<ffffffff815120f3>] apic_timer_interrupt+0x13/0x20
[64615.513375]  <EOI>

What should I try next?

Thanks,
Rick

