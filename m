Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab2AOP3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 10:29:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35463 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2AOP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:29:37 -0500
Date: Sun, 15 Jan 2012 20:58:06 +0530
From: Rabin Vincent <rabin@rab.in>
To: fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Crash in writeback:single_inode tracepoint after card removal
Message-ID: <20120115152806.GA32106@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm testing SD card removal, and with tracing enabled I'm seeing a crash
in the writeback:single_inode event sometimes when a umount is done
after a card is removed with pending io.  When the problem occurs,
writeback is begin attempted with the default_backing_dev_info.  The
block bdi which was handling this device has been unregistered and it's
bdi->dev is NULL.  However it is still referenced by
inode->i_mapping->backing_dev_info, and the trace point does the
following, leading to the oops:

	TP_fast_assign(
		strncpy(__entry->name,
		dev_name(inode->i_mapping->backing_dev_info->dev),
		32);

   umount-33      0.... 10973110us : writeback_inodes_sb <-__sync_filesystem
   umount-33      0.... 10973248us : writeback_inodes_sb_nr <-__sync_filesystem
   umount-33      0.... 10973289us : bdi_queue_work <-writeback_inodes_sb_nr
   umount-33      0...1 10973336us : writeback_queue: bdi default: sb_dev 179:0 nr_pages=2153 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
 bdi-defa-14      1.... 10974021us : wb_do_writeback <-bdi_forker_thread
 bdi-defa-14      1...1 10974041us : writeback_exec: bdi default: sb_dev 179:0 nr_pages=2153 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
 bdi-defa-14      1.... 10974053us : wb_writeback <-wb_do_writeback
 bdi-defa-14      1...2 10974059us : writeback_start: bdi default: sb_dev 179:0 nr_pages=2153 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
 bdi-defa-14      1...2 10974093us : writeback_queue_io: bdi default: older=4294939114 age=0 enqueue=2 reason=sync
 bdi-defa-14      1...1 10974101us : writeback_sb_inodes <-wb_writeback
 bdi-defa-14      1...2 10974166us : writeback_single_inode <-writeback_sb_inodes

 Unable to handle kernel NULL pointer dereference at virtual address 0000002c
 pgd = c0004000
 [0000002c] *pgd=00000000
 Internal error: Oops: 17 [#1] PREEMPT SMP
 PC is at ftrace_raw_event_writeback_single_inode_template+0x60/0xe4
 LR is at ftrace_raw_event_writeback_single_inode_template+0x50/0xe4

The full trace+log is attached.  My kernel (current linus) has a delay
inserted in __mark_inode_dirty, to easily trigger the condition:

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f855916..424a655 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1057,6 +1057,7 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
  * page->mapping->host, so the page-dirtying time is recorded in the internal
  * blockdev inode.
  */
+#include <linux/delay.h>
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
@@ -1131,6 +1132,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 					wakeup_bdi = true;
 			}
 
+			trace_printk("bdi %s\n", bdi->name);
+
 			spin_unlock(&inode->i_lock);
 			spin_lock(&bdi->wb.list_lock);
 			inode->dirtied_when = jiffies;
@@ -1139,6 +1142,14 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 
 			if (wakeup_bdi)
 				bdi_wakeup_thread_delayed(bdi);
+
+			if (!strcmp(bdi->name, "block")) {
+				printk("waiting 6s, remove card\n");
+				trace_printk("waiting 6s, remove card\n");
+				msleep(6000);
+				printk("done waiting\n");
+				trace_printk("done waiting\n");
+			}
 			return;
 		}
 	}


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=wblog

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0
[    0.000000] Linux version 3.2.0+ (rabin@debian) (gcc version 4.6.0 (crosstool-NG-hg_default@2404_8988576c491a) ) #581 SMP PREEMPT Sun Jan 15 20:32:25 IST 2012
[    0.000000] CPU: ARMv7 Processor [410fc090] revision 0 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: ARM-RealView PBX
[    0.000000] Ignoring unrecognised tag 0x00000000
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] On node 0 totalpages: 32768
[    0.000000]   DMA zone: 288 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 32480 pages, LIFO batch:7
[    0.000000] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
[    0.000000] PERCPU: Embedded 6 pages/cpu @c07e2000 s9216 r0 d15360 u32768
[    0.000000] pcpu-alloc: s9216 r0 d15360 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32480
[    0.000000] Kernel command line: earlyprintk console=ttyAMA0 mem=128M debug ftrace=function ftrace_filter=writeback*,__writeback*,bdi*,__bdi*,wb_*,bdev_*,blkdev*,__blkdev*,__mark_inode_dirty trace_event=writeback:*,block:* ftrace_dump_on_oops
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Memory: 128MB = 128MB total
[    0.000000] Memory: 120040k/120040k available, 11032k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc8800000 - 0xff000000   ( 872 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .text : 0xc0008000 - 0xc02efd84   (2976 kB)
[    0.000000]       .init : 0xc02f0000 - 0xc031d400   ( 181 kB)
[    0.000000]       .data : 0xc031e000 - 0xc033f664   ( 134 kB)
[    0.000000]        .bss : 0xc033f688 - 0xc05a08a4   (2437 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:128
[    0.000000] Console: colour dummy device 80x30
[    0.000000] ODEBUG: 4 of 4 active objects replaced
[    0.047375] Calibrating delay loop... 407.96 BogoMIPS (lpj=2039808)
[    0.233334] pid_max: default: 32768 minimum: 301
[    0.234544] Mount-cache hash table entries: 512
[    0.242147] CPU: Testing write buffer coherency: ok
[    0.243896] ftrace: allocating 10192 entries in 20 pages
[    0.522900] smp_twd: clock not found: -2
[    0.523026] Calibrating local timer... 99.42MHz.
[    0.574060] hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 1 counters available
[    0.574529] Setting up static identity map for 0x24c448 - 0x24c47c
[    0.683217] CPU1: Booted secondary processor
[    0.842929] Brought up 2 CPUs
[    0.843025] SMP: Total of 2 processors activated (417.68 BogoMIPS).
[    0.852260] CPU1: Unknown IPI message 0x1
[    0.853812] devtmpfs: initialized
[    0.865446] NET: Registered protocol family 16
[    0.869459] L2x0 series cache controller enabled
[    0.869514] l2x0: 8 ways, CACHE_ID 0x00000000, AUX_CTRL 0x02520000, Cache size: 131072 B
[    0.882582] hw-breakpoint: Debug register access (0xee113e93) caused undefined instruction on CPU 1
[    0.882691] hw-breakpoint: Debug register access (0xee013e90) caused undefined instruction on CPU 1
[    0.882733] hw-breakpoint: Debug register access (0xee003e17) caused undefined instruction on CPU 1
[    0.882811] hw-breakpoint: Debug register access (0xee004e52) caused undefined instruction on CPU 1
[    0.883015] hw-breakpoint: Debug register access (0xee113e93) caused undefined instruction on CPU 0
[    0.883056] hw-breakpoint: Debug register access (0xee013e90) caused undefined instruction on CPU 0
[    0.883091] hw-breakpoint: Debug register access (0xee003e17) caused undefined instruction on CPU 0
[    0.883127] hw-breakpoint: Debug register access (0xee004e52) caused undefined instruction on CPU 0
[    0.892233] Serial: AMBA PL011 UART driver
[    0.894094] dev:uart0: ttyAMA0 at MMIO 0x10009000 (irq = 44) is a PL011 rev1
[    0.899958] console [ttyAMA0] enabled
[    0.902168] dev:uart1: ttyAMA1 at MMIO 0x1000a000 (irq = 45) is a PL011 rev1
[    0.902886] dev:uart2: ttyAMA2 at MMIO 0x1000b000 (irq = 46) is a PL011 rev1
[    0.903533] fpga:uart3: ttyAMA3 at MMIO 0x1000c000 (irq = 47) is a PL011 rev1
[    0.913054] bio: create slab <bio-0> at 0
[    0.914982] gpiochip_add: registered GPIOs 0 to 7 on device: dev:gpio0
[    0.915231] gpiochip_add: registered GPIOs 8 to 15 on device: dev:gpio1
[    0.915381] gpiochip_add: registered GPIOs 16 to 23 on device: dev:gpio2
[    0.923388] Switching to clocksource timer3
[    1.001105] NET: Registered protocol family 2
[    1.004715] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    1.007580] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    1.008064] TCP bind hash table entries: 4096 (order: 3, 49152 bytes)
[    1.008457] TCP: Hash tables configured (established 4096 bind 4096)
[    1.008661] TCP reno registered
[    1.008804] UDP hash table entries: 128 (order: 0, 4096 bytes)
[    1.009157] UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
[    1.016558] RPC: Registered named UNIX socket transport module.
[    1.016766] RPC: Registered udp transport module.
[    1.016867] RPC: Registered tcp transport module.
[    1.016949] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.020608] Unpacking initramfs...
[    1.117631] Freeing initrd memory: 3884K
[    1.120691] Starting tracer 'function'
[    1.199635] msgmni has been set to 242
[    1.200068] io scheduler noop registered
[    1.200173] io scheduler deadline registered
[    1.200449] io scheduler cfq registered (default)
[    1.214682] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.217998] smsc911x: Driver version 2008-10-21
[    1.222149] smsc911x-mdio: probed
[    1.222670] smsc911x smsc911x.0: eth0: attached PHY driver [SMSC LAN911x Internal PHY] (mii_bus:phy_addr=smsc911x-0:01, irq=-1)
[    1.224060] smsc911x smsc911x.0: eth0: MAC Address: 52:54:00:12:34:56
[    1.228176] rtc-pl031 dev:rtc: rtc core: registered pl031 as rtc0
[    1.230003] mmci-pl18x fpga:mmc0: mmc0: PL181 manf 41 rev0 at 0x10005000 irq 49,50 (pio)
[    1.232066] TCP cubic registered
[    1.232278] NET: Registered protocol family 17
[    1.233432] VFP support v0.3: implementor 41 architecture 3 part 40 variant 0 rev 0
[    1.294911] rtc-pl031 dev:rtc: setting system clock to 2012-01-15 15:03:25 UTC (1326639805)
[    1.311049] Freeing init memory: 180K
[    1.548813] mmc0: new SD card at address 4567
[    1.575092] mmcblk0: mmc0:4567 QEMU! 128 MiB 
# [    1.809385]  mmcblk0:

# 
# 
# 
# 
# 
# 
# 
# 
# echo 0 > /debug/tracing/trace
# 
# 
# mount /dev/mmcblk0 /tmp/; echo h > /tmp/filez; umount /tmp
[   12.202065] waiting 6s, remove card
QEMU 0.15.50 monitor - type 'help' for more information
(qemu) eject sd0
(qemu)
[   14.814775] mmc0: card 4567 removed
[   18.203991] done waiting
[   18.211605] FAT-fs (mmcblk0): FAT read failed (blocknr 4)
[   18.229107] Unable to handle kernel NULL pointer dereference at virtual address 0000002c
[   18.229332] pgd = c0004000
[   18.229401] [0000002c] *pgd=00000000
[   18.229681] Internal error: Oops: 17 [#1] PREEMPT SMP
[   18.229951] Dumping ftrace buffer:
[   18.230280] ---------------------------------
[   18.232265]       sh-29      0....  740us : __mark_inode_dirty <-simple_setattr
[   18.232486]       sh-29      0.... 1797014us : __mark_inode_dirty <-file_update_time
[   18.232674]       sh-29      0.... 1797928us : __mark_inode_dirty <-touch_atime
[   18.232868]    mount-30      1.... 1802611us : __mark_inode_dirty <-touch_atime
[   18.233062]    mount-30      0.... 1803542us : __mark_inode_dirty <-touch_atime
[   18.233259]    mount-30      0.... 1810404us : blkdev_get_by_path <-mount_bdev
[   18.233454]    mount-30      0.... 1810603us : bdev_alloc_inode <-alloc_inode
[   18.233657]    mount-30      0...1 1810650us : bdev_set <-iget5_locked
[   18.234280]    mount-30      0.... 1810851us : blkdev_get <-blkdev_get_by_path
[   18.234479]    mount-30      0.... 1811041us : __blkdev_get <-blkdev_get
[   18.234669]    mount-30      0.... 1811402us : bdev_inode_switch_bdi <-__blkdev_get
[   18.234881]    mount-30      0.... 1811430us : bdi_lock_two <-bdev_inode_switch_bdi
[   18.235086]    mount-30      0.... 1811636us : bdev_read_only <-blkdev_get_by_path
[   18.235393]    mount-30      0...1 1813654us : block_bio_queue: 179,0 R 2 + 2 [mount]
[   18.235642]    mount-30      0...1 1815011us : block_getrq: 179,0 R 2 + 2 [mount]
[   18.235915]    mount-30      0d..2 1815683us : block_rq_insert: 179,0 R 0 () 2 + 2 [mount]
[   18.236115]  mmcqd/0-28      0d..2 1817346us : block_rq_issue: 179,0 R 0 () 2 + 2 [mmcqd/0]
[   18.236413]  mmcqd/0-28      0d..2 1817941us : block_rq_complete: 179,0 R () 2 + 2 [0]
[   18.236609]    mount-30      0.... 1818561us : blkdev_put <-deactivate_locked_super
[   18.236796]    mount-30      0.... 1818629us : __blkdev_put <-deactivate_locked_super
[   18.236985]    mount-30      0.... 1819514us : blkdev_releasepage <-try_to_release_page
[   18.237173]    mount-30      0.... 1819644us : bdev_inode_switch_bdi <-__blkdev_put
[   18.237360]    mount-30      0.... 1819651us : bdi_lock_two <-bdev_inode_switch_bdi
[   18.237564]   <idle>-0       0.Ns2 3739530us : bdi_arm_supers_timer <-run_timer_softirq
[   18.237756]    mount-30      1.... 3791485us : blkdev_get_by_path <-mount_bdev
[   18.237935]    mount-30      1.... 3791649us : blkdev_get <-blkdev_get_by_path
[   18.238109]    mount-30      1.... 3791772us : __blkdev_get <-blkdev_get
[   18.238267]    mount-30      1.... 3791802us : bdev_inode_switch_bdi <-__blkdev_get
[   18.238438]    mount-30      1.... 3791807us : bdi_lock_two <-bdev_inode_switch_bdi
[   18.238606]    mount-30      1.... 3791904us : bdev_read_only <-blkdev_get_by_path
[   18.238776]    mount-30      1...1 3793477us : block_bio_queue: 179,0 R 0 + 1 [mount]
[   18.238949]    mount-30      1...1 3793649us : block_getrq: 179,0 R 0 + 1 [mount]
[   18.239119]    mount-30      1d..2 3793680us : block_rq_insert: 179,0 R 0 () 0 + 1 [mount]
[   18.239302]  mmcqd/0-28      0d..2 3794515us : block_rq_issue: 179,0 R 0 () 0 + 1 [mmcqd/0]
[   18.239484]  mmcqd/0-28      0d..2 3795002us : block_rq_complete: 179,0 R () 0 + 1 [0]
[   18.239658]    mount-30      1...1 3796587us : block_bio_queue: 179,0 R 516 + 1 [mount]
[   18.239834]    mount-30      1...1 3796635us : block_getrq: 179,0 R 516 + 1 [mount]
[   18.240008]    mount-30      1d..2 3796656us : block_rq_insert: 179,0 R 0 () 516 + 1 [mount]
[   18.240200]  mmcqd/0-28      0d..2 3796985us : block_rq_issue: 179,0 R 0 () 516 + 1 [mmcqd/0]
[   18.240385]  mmcqd/0-28      0d..2 3797376us : block_rq_complete: 179,0 R () 516 + 1 [0]
[   18.240560]    mount-30      1...1 3797954us : block_bio_queue: 179,0 R 517 + 1 [mount]
[   18.240734]    mount-30      1...1 3797997us : block_getrq: 179,0 R 517 + 1 [mount]
[   18.240905]    mount-30      1d..2 3798021us : block_rq_insert: 179,0 R 0 () 517 + 1 [mount]
[   18.241090]  mmcqd/0-28      0d..2 3798253us : block_rq_issue: 179,0 R 0 () 517 + 1 [mmcqd/0]
[   18.241270]  mmcqd/0-28      0d..2 3798629us : block_rq_complete: 179,0 R () 517 + 1 [0]
[   18.241444]    mount-30      1...1 3799036us : block_bio_queue: 179,0 R 518 + 1 [mount]
[   18.241616]    mount-30      1...1 3799077us : block_getrq: 179,0 R 518 + 1 [mount]
[   18.241791]    mount-30      1d..2 3799097us : block_rq_insert: 179,0 R 0 () 518 + 1 [mount]
[   18.241976]  mmcqd/0-28      0d..2 3799433us : block_rq_issue: 179,0 R 0 () 518 + 1 [mmcqd/0]
[   18.242161]  mmcqd/0-28      0d..2 3799801us : block_rq_complete: 179,0 R () 518 + 1 [0]
[   18.242338]    mount-30      1...1 3800207us : block_bio_queue: 179,0 R 519 + 1 [mount]
[   18.242516]    mount-30      1...1 3800248us : block_getrq: 179,0 R 519 + 1 [mount]
[   18.242691]    mount-30      1d..2 3800269us : block_rq_insert: 179,0 R 0 () 519 + 1 [mount]
[   18.242879]  mmcqd/0-28      0d..2 3800473us : block_rq_issue: 179,0 R 0 () 519 + 1 [mmcqd/0]
[   18.243066]  mmcqd/0-28      0d..2 3800844us : block_rq_complete: 179,0 R () 519 + 1 [0]
[   18.243244]    mount-30      1...1 3801297us : block_bio_queue: 179,0 R 520 + 1 [mount]
[   18.243423]    mount-30      1...1 3801340us : block_getrq: 179,0 R 520 + 1 [mount]
[   18.243600]    mount-30      1d..2 3801360us : block_rq_insert: 179,0 R 0 () 520 + 1 [mount]
[   18.244216]  mmcqd/0-28      0d..2 3801584us : block_rq_issue: 179,0 R 0 () 520 + 1 [mmcqd/0]
[   18.244418]  mmcqd/0-28      0d..2 3801954us : block_rq_complete: 179,0 R () 520 + 1 [0]
[   18.244600]    mount-30      1...1 3802353us : block_bio_queue: 179,0 R 521 + 1 [mount]
[   18.244781]    mount-30      1...1 3802394us : block_getrq: 179,0 R 521 + 1 [mount]
[   18.244957]    mount-30      1d..2 3802414us : block_rq_insert: 179,0 R 0 () 521 + 1 [mount]
[   18.245145]  mmcqd/0-28      0d..2 3802616us : block_rq_issue: 179,0 R 0 () 521 + 1 [mmcqd/0]
[   18.245331]  mmcqd/0-28      0d..2 3802981us : block_rq_complete: 179,0 R () 521 + 1 [0]
[   18.245511]    mount-30      1...1 3803381us : block_bio_queue: 179,0 R 522 + 1 [mount]
[   18.245691]    mount-30      1...1 3803421us : block_getrq: 179,0 R 522 + 1 [mount]
[   18.245869]    mount-30      1d..2 3803442us : block_rq_insert: 179,0 R 0 () 522 + 1 [mount]
[   18.246056]  mmcqd/0-28      0d..2 3803644us : block_rq_issue: 179,0 R 0 () 522 + 1 [mmcqd/0]
[   18.246245]  mmcqd/0-28      0d..2 3804017us : block_rq_complete: 179,0 R () 522 + 1 [0]
[   18.246425]    mount-30      1...1 3804434us : block_bio_queue: 179,0 R 523 + 1 [mount]
[   18.246604]    mount-30      1...1 3804476us : block_getrq: 179,0 R 523 + 1 [mount]
[   18.246783]    mount-30      1d..2 3804495us : block_rq_insert: 179,0 R 0 () 523 + 1 [mount]
[   18.246971]  mmcqd/0-28      0d..2 3804706us : block_rq_issue: 179,0 R 0 () 523 + 1 [mmcqd/0]
[   18.247157]  mmcqd/0-28      0d..2 3805073us : block_rq_complete: 179,0 R () 523 + 1 [0]
[   18.247337]    mount-30      1...1 3805471us : block_bio_queue: 179,0 R 524 + 1 [mount]
[   18.247515]    mount-30      1...1 3805512us : block_getrq: 179,0 R 524 + 1 [mount]
[   18.247689]    mount-30      1d..2 3805532us : block_rq_insert: 179,0 R 0 () 524 + 1 [mount]
[   18.247876]  mmcqd/0-28      0d..2 3805731us : block_rq_issue: 179,0 R 0 () 524 + 1 [mmcqd/0]
[   18.248064]  mmcqd/0-28      0d..2 3806094us : block_rq_complete: 179,0 R () 524 + 1 [0]
[   18.248248]    mount-30      1...1 3806492us : block_bio_queue: 179,0 R 525 + 1 [mount]
[   18.248430]    mount-30      1...1 3806533us : block_getrq: 179,0 R 525 + 1 [mount]
[   18.248605]    mount-30      1d..2 3806553us : block_rq_insert: 179,0 R 0 () 525 + 1 [mount]
[   18.248794]  mmcqd/0-28      0d..2 3806753us : block_rq_issue: 179,0 R 0 () 525 + 1 [mmcqd/0]
[   18.248982]  mmcqd/0-28      0d..2 3807116us : block_rq_complete: 179,0 R () 525 + 1 [0]
[   18.249164]    mount-30      1...1 3807521us : block_bio_queue: 179,0 R 526 + 1 [mount]
[   18.249345]    mount-30      1...1 3807564us : block_getrq: 179,0 R 526 + 1 [mount]
[   18.249525]    mount-30      1d..2 3807585us : block_rq_insert: 179,0 R 0 () 526 + 1 [mount]
[   18.249711]  mmcqd/0-28      0d..2 3807823us : block_rq_issue: 179,0 R 0 () 526 + 1 [mmcqd/0]
[   18.249898]  mmcqd/0-28      0d..2 3808163us : block_rq_complete: 179,0 R () 526 + 1 [0]
[   18.250078]    mount-30      1...1 3808562us : block_bio_queue: 179,0 R 527 + 1 [mount]
[   18.250256]    mount-30      1...1 3808603us : block_getrq: 179,0 R 527 + 1 [mount]
[   18.250434]    mount-30      1d..2 3808624us : block_rq_insert: 179,0 R 0 () 527 + 1 [mount]
[   18.250622]  mmcqd/0-28      0d..2 3808825us : block_rq_issue: 179,0 R 0 () 527 + 1 [mmcqd/0]
[   18.250807]  mmcqd/0-28      0d..2 3809193us : block_rq_complete: 179,0 R () 527 + 1 [0]
[   18.250988]    mount-30      1...1 3809709us : block_bio_queue: 179,0 R 528 + 1 [mount]
[   18.251167]    mount-30      1...1 3809847us : block_getrq: 179,0 R 528 + 1 [mount]
[   18.251345]    mount-30      1d..2 3809868us : block_rq_insert: 179,0 R 0 () 528 + 1 [mount]
[   18.251530]  mmcqd/0-28      0d..2 3810091us : block_rq_issue: 179,0 R 0 () 528 + 1 [mmcqd/0]
[   18.251717]  mmcqd/0-28      0d..2 3810463us : block_rq_complete: 179,0 R () 528 + 1 [0]
[   18.251897]    mount-30      1...1 3810862us : block_bio_queue: 179,0 R 529 + 1 [mount]
[   18.252075]    mount-30      1...1 3810903us : block_getrq: 179,0 R 529 + 1 [mount]
[   18.252256]    mount-30      1d..2 3810922us : block_rq_insert: 179,0 R 0 () 529 + 1 [mount]
[   18.252443]  mmcqd/0-28      0d..2 3811123us : block_rq_issue: 179,0 R 0 () 529 + 1 [mmcqd/0]
[   18.252631]  mmcqd/0-28      0d..2 3811490us : block_rq_complete: 179,0 R () 529 + 1 [0]
[   18.252808]    mount-30      1...1 3811910us : block_bio_queue: 179,0 R 530 + 1 [mount]
[   18.252987]    mount-30      1...1 3811952us : block_getrq: 179,0 R 530 + 1 [mount]
[   18.253164]    mount-30      1d..2 3811972us : block_rq_insert: 179,0 R 0 () 530 + 1 [mount]
[   18.253354]  mmcqd/0-28      0d..2 3812181us : block_rq_issue: 179,0 R 0 () 530 + 1 [mmcqd/0]
[   18.253542]  mmcqd/0-28      0d..2 3812547us : block_rq_complete: 179,0 R () 530 + 1 [0]
[   18.254086]    mount-30      1...1 3812945us : block_bio_queue: 179,0 R 531 + 1 [mount]
[   18.254309]    mount-30      1...1 3812985us : block_getrq: 179,0 R 531 + 1 [mount]
[   18.254493]    mount-30      1d..2 3813005us : block_rq_insert: 179,0 R 0 () 531 + 1 [mount]
[   18.254683]  mmcqd/0-28      0d..2 3813210us : block_rq_issue: 179,0 R 0 () 531 + 1 [mmcqd/0]
[   18.254875]  mmcqd/0-28      0d..2 3813576us : block_rq_complete: 179,0 R () 531 + 1 [0]
[   18.255059]    mount-30      1...1 3813973us : block_bio_queue: 179,0 R 532 + 1 [mount]
[   18.255241]    mount-30      1...1 3814014us : block_getrq: 179,0 R 532 + 1 [mount]
[   18.255420]    mount-30      1d..2 3814034us : block_rq_insert: 179,0 R 0 () 532 + 1 [mount]
[   18.255609]  mmcqd/0-28      0d..2 3814252us : block_rq_issue: 179,0 R 0 () 532 + 1 [mmcqd/0]
[   18.255804]  mmcqd/0-28      0d..2 3814620us : block_rq_complete: 179,0 R () 532 + 1 [0]
[   18.255988]    mount-30      1...1 3815017us : block_bio_queue: 179,0 R 533 + 1 [mount]
[   18.256170]    mount-30      1...1 3815057us : block_getrq: 179,0 R 533 + 1 [mount]
[   18.256358]    mount-30      1d..2 3815077us : block_rq_insert: 179,0 R 0 () 533 + 1 [mount]
[   18.256545]  mmcqd/0-28      0d..2 3815292us : block_rq_issue: 179,0 R 0 () 533 + 1 [mmcqd/0]
[   18.256730]  mmcqd/0-28      0d..2 3815668us : block_rq_complete: 179,0 R () 533 + 1 [0]
[   18.256910]    mount-30      1...1 3816063us : block_bio_queue: 179,0 R 534 + 1 [mount]
[   18.257090]    mount-30      1...1 3816108us : block_getrq: 179,0 R 534 + 1 [mount]
[   18.257264]    mount-30      1d..2 3816128us : block_rq_insert: 179,0 R 0 () 534 + 1 [mount]
[   18.257450]  mmcqd/0-28      0d..2 3816337us : block_rq_issue: 179,0 R 0 () 534 + 1 [mmcqd/0]
[   18.257635]  mmcqd/0-28      0d..2 3816713us : block_rq_complete: 179,0 R () 534 + 1 [0]
[   18.257812]    mount-30      1...1 3817087us : block_bio_queue: 179,0 R 535 + 1 [mount]
[   18.257990]    mount-30      1...1 3817128us : block_getrq: 179,0 R 535 + 1 [mount]
[   18.258167]    mount-30      1d..2 3817148us : block_rq_insert: 179,0 R 0 () 535 + 1 [mount]
[   18.258353]  mmcqd/0-28      0d..2 3817357us : block_rq_issue: 179,0 R 0 () 535 + 1 [mmcqd/0]
[   18.258538]  mmcqd/0-28      0d..2 3817722us : block_rq_complete: 179,0 R () 535 + 1 [0]
[   18.258716]    mount-30      1...1 3818156us : block_bio_queue: 179,0 R 536 + 1 [mount]
[   18.258897]    mount-30      1...1 3818197us : block_getrq: 179,0 R 536 + 1 [mount]
[   18.259076]    mount-30      1d..2 3818217us : block_rq_insert: 179,0 R 0 () 536 + 1 [mount]
[   18.259264]  mmcqd/0-28      0d..2 3818443us : block_rq_issue: 179,0 R 0 () 536 + 1 [mmcqd/0]
[   18.259454]  mmcqd/0-28      0d..2 3818816us : block_rq_complete: 179,0 R () 536 + 1 [0]
[   18.259635]    mount-30      1...1 3819198us : block_bio_queue: 179,0 R 537 + 1 [mount]
[   18.259812]    mount-30      1...1 3819434us : block_getrq: 179,0 R 537 + 1 [mount]
[   18.259989]    mount-30      1d..2 3819459us : block_rq_insert: 179,0 R 0 () 537 + 1 [mount]
[   18.260287]  mmcqd/0-28      0d..2 3819691us : block_rq_issue: 179,0 R 0 () 537 + 1 [mmcqd/0]
[   18.260476]  mmcqd/0-28      0d..2 3820092us : block_rq_complete: 179,0 R () 537 + 1 [0]
[   18.260656]    mount-30      1...1 3820513us : block_bio_queue: 179,0 R 538 + 1 [mount]
[   18.260832]    mount-30      1...1 3820556us : block_getrq: 179,0 R 538 + 1 [mount]
[   18.261009]    mount-30      1d..2 3820576us : block_rq_insert: 179,0 R 0 () 538 + 1 [mount]
[   18.261197]  mmcqd/0-28      0d..2 3820804us : block_rq_issue: 179,0 R 0 () 538 + 1 [mmcqd/0]
[   18.261386]  mmcqd/0-28      0d..2 3821170us : block_rq_complete: 179,0 R () 538 + 1 [0]
[   18.261565]    mount-30      1...1 3821546us : block_bio_queue: 179,0 R 539 + 1 [mount]
[   18.261746]    mount-30      1...1 3821586us : block_getrq: 179,0 R 539 + 1 [mount]
[   18.261925]    mount-30      1d..2 3821606us : block_rq_insert: 179,0 R 0 () 539 + 1 [mount]
[   18.262111]  mmcqd/0-28      0d..2 3821812us : block_rq_issue: 179,0 R 0 () 539 + 1 [mmcqd/0]
[   18.262296]  mmcqd/0-28      0d..2 3822177us : block_rq_complete: 179,0 R () 539 + 1 [0]
[   18.262474]    mount-30      1...1 3822571us : block_bio_queue: 179,0 R 540 + 1 [mount]
[   18.262654]    mount-30      1...1 3822625us : block_getrq: 179,0 R 540 + 1 [mount]
[   18.262829]    mount-30      1d..2 3822650us : block_rq_insert: 179,0 R 0 () 540 + 1 [mount]
[   18.263015]  mmcqd/0-28      0d..2 3822873us : block_rq_issue: 179,0 R 0 () 540 + 1 [mmcqd/0]
[   18.263198]  mmcqd/0-28      0d..2 3823224us : block_rq_complete: 179,0 R () 540 + 1 [0]
[   18.263377]    mount-30      1...1 3823611us : block_bio_queue: 179,0 R 541 + 1 [mount]
[   18.263554]    mount-30      1...1 3823652us : block_getrq: 179,0 R 541 + 1 [mount]
[   18.264142]    mount-30      1d..2 3823672us : block_rq_insert: 179,0 R 0 () 541 + 1 [mount]
[   18.264393]  mmcqd/0-28      0d..2 3823917us : block_rq_issue: 179,0 R 0 () 541 + 1 [mmcqd/0]
[   18.264585]  mmcqd/0-28      0d..2 3824288us : block_rq_complete: 179,0 R () 541 + 1 [0]
[   18.264773]    mount-30      1...1 3824650us : block_bio_queue: 179,0 R 542 + 1 [mount]
[   18.264960]    mount-30      1...1 3824693us : block_getrq: 179,0 R 542 + 1 [mount]
[   18.265142]    mount-30      1d..2 3824714us : block_rq_insert: 179,0 R 0 () 542 + 1 [mount]
[   18.265335]  mmcqd/0-28      0d..2 3824921us : block_rq_issue: 179,0 R 0 () 542 + 1 [mmcqd/0]
[   18.265523]  mmcqd/0-28      0d..2 3825288us : block_rq_complete: 179,0 R () 542 + 1 [0]
[   18.265706]    mount-30      1...1 3825667us : block_bio_queue: 179,0 R 543 + 1 [mount]
[   18.265889]    mount-30      1...1 3825707us : block_getrq: 179,0 R 543 + 1 [mount]
[   18.266069]    mount-30      1d..2 3825728us : block_rq_insert: 179,0 R 0 () 543 + 1 [mount]
[   18.266259]  mmcqd/0-28      0d..2 3825935us : block_rq_issue: 179,0 R 0 () 543 + 1 [mmcqd/0]
[   18.266450]  mmcqd/0-28      0d..2 3826300us : block_rq_complete: 179,0 R () 543 + 1 [0]
[   18.266633]    mount-30      1...1 3826725us : block_bio_queue: 179,0 R 544 + 1 [mount]
[   18.266815]    mount-30      1...1 3826767us : block_getrq: 179,0 R 544 + 1 [mount]
[   18.266991]    mount-30      1d..2 3826788us : block_rq_insert: 179,0 R 0 () 544 + 1 [mount]
[   18.267179]  mmcqd/0-28      0d..2 3827014us : block_rq_issue: 179,0 R 0 () 544 + 1 [mmcqd/0]
[   18.267374]  mmcqd/0-28      0d..2 3827392us : block_rq_complete: 179,0 R () 544 + 1 [0]
[   18.267559]    mount-30      1...1 3827785us : block_bio_queue: 179,0 R 545 + 1 [mount]
[   18.267736]    mount-30      1...1 3827827us : block_getrq: 179,0 R 545 + 1 [mount]
[   18.267911]    mount-30      1d..2 3827848us : block_rq_insert: 179,0 R 0 () 545 + 1 [mount]
[   18.268094]  mmcqd/0-28      0d..2 3828082us : block_rq_issue: 179,0 R 0 () 545 + 1 [mmcqd/0]
[   18.268282]  mmcqd/0-28      0d..2 3828429us : block_rq_complete: 179,0 R () 545 + 1 [0]
[   18.268455]    mount-30      1...1 3828804us : block_bio_queue: 179,0 R 546 + 1 [mount]
[   18.268633]    mount-30      1...1 3828845us : block_getrq: 179,0 R 546 + 1 [mount]
[   18.268810]    mount-30      1d..2 3828866us : block_rq_insert: 179,0 R 0 () 546 + 1 [mount]
[   18.268998]  mmcqd/0-28      0d..2 3829074us : block_rq_issue: 179,0 R 0 () 546 + 1 [mmcqd/0]
[   18.269185]  mmcqd/0-28      0d..2 3829559us : block_rq_complete: 179,0 R () 546 + 1 [0]
[   18.269364]    mount-30      1...1 3829953us : block_bio_queue: 179,0 R 547 + 1 [mount]
[   18.269542]    mount-30      1...1 3829997us : block_getrq: 179,0 R 547 + 1 [mount]
[   18.269719]    mount-30      1d..2 3830019us : block_rq_insert: 179,0 R 0 () 547 + 1 [mount]
[   18.269909]  mmcqd/0-28      0d..2 3830229us : block_rq_issue: 179,0 R 0 () 547 + 1 [mmcqd/0]
[   18.270098]  mmcqd/0-28      0d..2 3830600us : block_rq_complete: 179,0 R () 547 + 1 [0]
[   18.270296]       sh-29      0.... 3837243us : __mark_inode_dirty <-mark_buffer_dirty_inode
[   18.270817]       sh-29      0...1 3837313us : __mark_inode_dirty: bdi block
[   18.270991]       sh-29      0.... 3837332us : bdi_wakeup_thread_delayed <-__mark_inode_dirty
[   18.271177]       sh-29      0.... 3838574us : __mark_inode_dirty: waiting 6s, remove card
[   18.271366] kworker/-5       0...2 6451843us : bdev_test <-find_inode
[   18.271524] kworker/-5       0.... 6452071us : writeback_inodes_sb <-__sync_filesystem
[   18.271701] kworker/-5       0.... 6452208us : writeback_inodes_sb_nr <-__sync_filesystem
[   18.271883] kworker/-5       0.... 6452245us : bdi_queue_work <-writeback_inodes_sb_nr
[   18.272224] kworker/-5       0...1 6452294us : writeback_queue: bdi 179:0: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.272506] kworker/-5       0..s2 6452424us : writeback_nothread: bdi 179:0: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.272778] flush-17-32      1.... 6453532us : bdi_writeback_thread <-kthread
[   18.272992] flush-17-32      1...1 6453625us : writeback_thread_start: bdi 179:0
[   18.273163] flush-17-32      1.... 6453745us : wb_do_writeback <-bdi_writeback_thread
[   18.273348] flush-17-32      1...1 6453809us : writeback_exec: bdi 179:0: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.273613] flush-17-32      1.... 6453851us : wb_writeback <-wb_do_writeback
[   18.274213] flush-17-32      1...2 6453917us : writeback_start: bdi 179:0: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.274616] flush-17-32      1...2 6454091us : writeback_queue_io: bdi 179:0: older=4294938773 age=0 enqueue=1 reason=sync
[   18.274853] flush-17-32      1...1 6454205us : writeback_sb_inodes <-wb_writeback
[   18.275039] flush-17-32      1...2 6454326us : writeback_written: bdi 179:0: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.275318] flush-17-32      1...1 6454367us : __bdi_update_bandwidth <-wb_writeback
[   18.275494] flush-17-32      1.... 6454520us : wb_writeback <-wb_do_writeback
[   18.275678] flush-17-32      1...2 6454548us : writeback_start: bdi 179:0: sb_dev 0:0 nr_pages=2148 sync_mode=0 kupdate=1 range_cyclic=1 background=0 reason=periodic
[   18.275955] flush-17-32      1...2 6454554us : writeback_queue_io: bdi 179:0: older=4294935773 age=30000 enqueue=0 reason=periodic
[   18.276184] flush-17-32      1...1 6454575us : __writeback_inodes_wb <-wb_writeback
[   18.276387] flush-17-32      1...2 6454604us : writeback_written: bdi 179:0: sb_dev 0:0 nr_pages=2148 sync_mode=0 kupdate=1 range_cyclic=1 background=0 reason=periodic
[   18.276658] flush-17-32      1...1 6454609us : __bdi_update_bandwidth <-wb_writeback
[   18.276918] flush-17-32      1...1 6454790us : global_dirty_state: dirty=1 writeback=0 unstable=0 bg_thresh=2904 thresh=5809 limit=0 dirtied=1 written=0
[   18.277174] flush-17-32      1.... 6454898us : bdi_dirty_limit <-over_bground_thresh
[   18.277397] flush-17-32      1...1 6455096us : writeback_pages_written: 0
[   18.277633] kworker/-5       0...1 6455964us : wbc_writepage: bdi 179:0: towrt=2147483647 skip=0 mode=0 kupd=0 bgrd=0 reclm=0 cyclic=0 start=0x0 end=0xffffffff
[   18.277900] kworker/-5       0.... 6456077us : blkdev_writepage <-__writepage
[   18.278071] kworker/-5       0...1 6456639us : block_bio_queue: 179,0 W 516 + 1 [kworker/u:0]
[   18.278258] kworker/-5       0...1 6456785us : block_getrq: 179,0 W 516 + 1 [kworker/u:0]
[   18.278485] kworker/-5       0...1 6456849us : block_plug: [kworker/u:0]
[   18.278653] kworker/-5       0d..2 6457078us : block_rq_insert: 179,0 W 0 () 516 + 1 [kworker/u:0]
[   18.278890] kworker/-5       0d..2 6457208us : block_unplug: [kworker/u:0] 1
[   18.279051] kworker/-5       0.... 6457386us : bdi_queue_work <-sync_inodes_sb
[   18.279233] kworker/-5       0...1 6457393us : writeback_queue: bdi 179:0: sb_dev 179:0 nr_pages=2147483647 sync_mode=1 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.279509]  mmcqd/0-28      0d..2 6457553us : block_rq_issue: 179,0 W 0 () 516 + 1 [mmcqd/0]
[   18.279701]  mmcqd/0-28      0d..2 6457607us : block_rq_complete: 179,0 W () 516 + 1 [0]
[   18.279881] flush-17-32      1.... 6458325us : wb_do_writeback <-bdi_writeback_thread
[   18.280073] flush-17-32      1...1 6458342us : writeback_exec: bdi 179:0: sb_dev 179:0 nr_pages=2147483647 sync_mode=1 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.280356] flush-17-32      1.... 6458352us : wb_writeback <-wb_do_writeback
[   18.280536] flush-17-32      1...2 6458356us : writeback_start: bdi 179:0: sb_dev 179:0 nr_pages=2147483647 sync_mode=1 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.280817] flush-17-32      1...2 6458364us : writeback_queue_io: bdi 179:0: older=4294938773 age=0 enqueue=1 reason=sync
[   18.281037] flush-17-32      1...1 6458371us : writeback_sb_inodes <-wb_writeback
[   18.281222] flush-17-32      1...2 6458377us : writeback_written: bdi 179:0: sb_dev 179:0 nr_pages=2147483647 sync_mode=1 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.281503] flush-17-32      1...1 6458383us : __bdi_update_bandwidth <-wb_writeback
[   18.281689] flush-17-32      1...1 6458426us : global_dirty_state: dirty=1 writeback=0 unstable=0 bg_thresh=2904 thresh=5809 limit=0 dirtied=1 written=0
[   18.281944] flush-17-32      1.... 6458433us : bdi_dirty_limit <-over_bground_thresh
[   18.282114] flush-17-32      1...1 6458442us : writeback_pages_written: 0
[   18.282278] kworker/-5       0.... 6460418us : blkdev_releasepage <-try_to_release_page
[   18.282457] kworker/-5       0.... 6460738us : blkdev_releasepage <-try_to_release_page
[   18.282635] kworker/-5       0.... 6460848us : blkdev_releasepage <-try_to_release_page
[   18.282813] kworker/-5       0.... 6460875us : blkdev_releasepage <-try_to_release_page
[   18.282991] kworker/-5       0.... 6460897us : blkdev_releasepage <-try_to_release_page
[   18.283171] kworker/-5       0.... 6460920us : blkdev_releasepage <-try_to_release_page
[   18.283352] kworker/-5       0.... 6461258us : bdi_unregister <-del_gendisk
[   18.283519] kworker/-5       0.... 6461287us : bdi_set_min_ratio <-bdi_unregister
[   18.283686] kworker/-5       0...1 6461352us : writeback_bdi_unregister: bdi 179:0
[   18.284286] flush-17-32      1...1 6462190us : writeback_thread_stop: bdi 179:0
[   18.284478] kdevtmpf-11      0.... 6464246us : __mark_inode_dirty <-simple_setattr
[   18.284657]   <idle>-0       0.Ns2 9739458us : bdi_arm_supers_timer <-run_timer_softirq
[   18.284843]       sh-29      0.... 9839656us : __mark_inode_dirty: done waiting
[   18.285013]       sh-29      0.... 9839892us : __mark_inode_dirty <-vfat_add_entry
[   18.285186]       sh-29      0...1 9839941us : __mark_inode_dirty: bdi default
[   18.285356]       sh-29      0.... 9839957us : bdi_wakeup_thread_delayed <-__mark_inode_dirty
[   18.285540]       sh-29      0.... 9841517us : __mark_inode_dirty <-file_update_time
[   18.285714]       sh-29      0...1 9841557us : __mark_inode_dirty: bdi default
[   18.285886]       sh-29      0...1 9842797us : block_bio_queue: 179,0 R 4 + 1 [sh]
[   18.286063]       sh-29      0...1 9842938us : block_getrq: 179,0 R 4 + 1 [sh]
[   18.286226]       sh-29      0...1 9843010us : block_plug: [sh]
[   18.286383]       sh-29      0d..2 9843385us : block_rq_insert: 179,0 R 0 () 4 + 1 [sh]
[   18.286566]       sh-29      0d..2 9844551us : block_rq_issue: 179,0 R 0 () 4 + 1 [sh]
[   18.286749]       sh-29      0d..2 9844836us : block_rq_complete: 179,0 R () 4 + 1 [0]
[   18.286921]       sh-29      0dN.2 9846849us : block_unplug: [sh] 1
[   18.287074]       sh-29      0.... 9848591us : __mark_inode_dirty <-touch_atime
[   18.287269]   umount-33      1.... 9850941us : __mark_inode_dirty <-touch_atime
[   18.287434]   umount-33      1.... 9851236us : __mark_inode_dirty <-touch_atime
[   18.287599]   umount-33      1.... 9863971us : writeback_inodes_sb <-__sync_filesystem
[   18.287774]   umount-33      1.... 9863994us : writeback_inodes_sb_nr <-__sync_filesystem
[   18.287951]   umount-33      1.... 9864001us : bdi_queue_work <-writeback_inodes_sb_nr
[   18.288147]   umount-33      1...1 9864006us : writeback_queue: bdi default: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.288428] bdi-defa-14      1.... 9864154us : wb_do_writeback <-bdi_forker_thread
[   18.288608] bdi-defa-14      1...1 9864162us : writeback_exec: bdi default: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.288870] bdi-defa-14      1.... 9864168us : wb_writeback <-wb_do_writeback
[   18.289045] bdi-defa-14      1...2 9864172us : writeback_start: bdi default: sb_dev 179:0 nr_pages=2148 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
[   18.289318] bdi-defa-14      1...2 9864202us : writeback_queue_io: bdi default: older=4294939114 age=0 enqueue=2 reason=sync
[   18.289534] bdi-defa-14      1...1 9864210us : writeback_sb_inodes <-wb_writeback
[   18.289701] bdi-defa-14      1...2 9864265us : writeback_single_inode <-writeback_sb_inodes
[   18.289860] ---------------------------------
[   18.290122] CPU: 1    Not tainted  (3.2.0+ #581)
[   18.290360] PC is at ftrace_raw_event_writeback_single_inode_template+0x60/0xe4
[   18.290501] LR is at ftrace_raw_event_writeback_single_inode_template+0x50/0xe4
[   18.290653] pc : [<c00dce78>]    lr : [<c00dce68>]    psr: 00000013
[   18.290670] sp : c7b61e38  ip : c7b61e20  fp : c7b61ea8
[   18.290856] r10: c75062c8  r9 : 00000003  r8 : a0000013
[   18.290966] r7 : 7fffffff  r6 : c0331450  r5 : c7b26e00  r4 : c7506200
[   18.291089] r3 : 00000000  r2 : 00000020  r1 : 00000000  r0 : c7b26e04
[   18.291265] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   18.291422] Control: 10c53c7d  Table: 06d7406a  DAC: 00000015
[   18.291560] Process bdi-default (pid: 14, stack limit = 0xc7b602f0)
[   18.291724] Stack: (0xc7b61e38 to 0xc7b62000)
[   18.291900] 1e20:                                                       00000003 c00de248
[   18.292083] 1e40: c6d3fed0 c7803580 7fffffff c7506200 00000000 c7b61ea8 c7b7a2d0 c7506240
[   18.292267] 1e60: c0330958 c75062c8 7fffffff c00de0ac c7506200 00000183 c7b61ea8 c6d3fed0
[   18.292442] 1e80: c0330910 7fffffff 00000000 c7506284 c7506240 c7506200 c0567b90 c00de248
[   18.292609] 1ea0: ffff91ea c6d6c000 00000000 7fffffff 00000000 00000000 00000000 00000000
[   18.292785] 1ec0: ffffffff 7fffffff 00000004 00000000 c0330948 c7b60000 c0330910 c6d3fed0
[   18.292957] 1ee0: c0320080 c7b7a010 00000000 c0330838 c0330958 c00de75c 00000001 c6d3fed0
[   18.293129] 1f00: a0000013 c7b26ce0 ffff91ea 00000864 00000001 ffff91ea c6d3fed0 c6d3fed0
[   18.293304] 1f20: c0330910 c7b60000 c7b79fd0 c0330838 00000000 00000000 c033f220 c00df8bc
[   18.293462] 1f40: c05406e0 c016b080 000005c5 c002ae84 c0330930 c7b61f7c c05406e0 c002ae84
[   18.293619] 1f60: c0330924 c0330910 c05406e0 c0330998 c0330910 c7b60000 c03307f8 00000000
[   18.294142] 1f80: c0330998 c0330940 c6d441c8 c00a1748 c6d1f860 00000000 00000000 00000001
[   18.294321] 1fa0: c7b61fc4 c7843f48 c0330910 c00a16c0 00000013 00000000 00000000 00000000
[   18.294488] 1fc0: 00000000 c003a97c c000e0a8 00000000 c0330910 00000000 00000000 00000000
[   18.294657] 1fe0: c7b61fe0 c7b61fe0 c7843f48 c003a8f4 c000e0a8 c000e0a8 00000000 00000000
[   18.295425] [<c00dce78>] (ftrace_raw_event_writeback_single_inode_template+0x60/0xe4) from [<c00de0ac>] (writeback_single_inode+0x38c/0x3d4)
[   18.295728] [<c00de0ac>] (writeback_single_inode+0x38c/0x3d4) from [<c00de248>] (writeback_sb_inodes+0x154/0x20c)
[   18.295934] [<c00de248>] (writeback_sb_inodes+0x154/0x20c) from [<c00de75c>] (wb_writeback+0x18c/0x304)
[   18.296132] [<c00de75c>] (wb_writeback+0x18c/0x304) from [<c00df8bc>] (wb_do_writeback+0xc0/0x218)
[   18.296350] [<c00df8bc>] (wb_do_writeback+0xc0/0x218) from [<c00a1748>] (bdi_forker_thread+0x88/0x3d0)
[   18.296518] [<c00a1748>] (bdi_forker_thread+0x88/0x3d0) from [<c003a97c>] (kthread+0x88/0x94)
[   18.296708] [<c003a97c>] (kthread+0x88/0x94) from [<c000e0a8>] (kernel_thread_exit+0x0/0x8)
[   18.297010] Code: e5943018 e3a02020 e5933054 e5933138 (e593102c) 
[   18.297629] ---[ end trace 256a9335cc76a49b ]---
[   18.297860] note: bdi-default[14] exited with preempt_count 4


QEMU: Terminated


--BXVAT5kNtrzKuDFl--
