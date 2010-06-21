Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0FUI5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 04:57:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:60546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0FUI5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 04:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="578264921"
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com>	<1274253276.5605.10124.camel@twins>
	 <20100520184213.GB21030@kroah.com>	<20100520201418.GB11470@elte.hu>
	 <20100520231229.GB8335@kroah.com>	<1274429038.1674.1684.camel@laptop>
	 <20100521094053.GA4658@elte.hu>
	 <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Jun 2010 16:55:09 +0800
Message-Id: <1277110509.18390.28.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Ingo Molnar <mingo@elte.hu>
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2010-05-20 at 16:12 -0700, Greg KH wrote:
> 
> > > How deep in the device tree are you really going to be
> > > caring about?  It sounds like the large majority of
> > > events are only going to be coming from the "system"
> > > type objects (cpu, nodes, memory, etc.) and very few
> > > would be from things that we consider a 'struct
> > > device' today (like a pci, usb, scsi, or input, etc.)
> >
> > The general noise I hear from the hardware people is
> > that we'll see more and more device-level stuff - bus
> > bridges/controller and actual devices (GPUs, NICs etc.)
> > will be wanting to export performance metrics.
> 
> There's (much) more:
> 
>  - laptops want to provide power level/usage metrics,
> 
>  - we could express a lot of special, lower level
>   (transport specific) disk IO stats via events as well -
>   without having to push those stats to a higher level
>   (where it might not make sense). Currently such kinds
>   of stats/metrics are very device/subsystem specific
>   way, if they are provided at all.
> 
> Also, we already have quite a few per device tracepoints
> upstream. Here are a few examples:
> 
>  - GPU tracepoints (trace_i915_gem_request_submit(), etc.)
>  - WIFI tracepoints (trace_iwlwifi_dev_ioread32(), etc.)
>  - block tracepoints (trace_block_bio_complete())
> 
> So these would be attached to:
> 
>  # GEM events of drm/card0:
>  /sys/devices/pci0000:00/0000:00:02.0/drm/card0/events/i915_gem_request_submit/
> 
>  # Wifi-ioread events of wlan0:
>  /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ioread32/
> 
>  # whole sdb disk events:
>  /sys/block/sdb/events/block_bio_complete/
> 
>  # sdb1 partition events:
>  /sys/block/sdb/sdb1/events/block_bio_complete/
> 
> And we also have 'software nodes' in /sys that have events
> upstream here and today. For example for SLAB we already
> have kmalloc/kfree tracepoints (trace_kmalloc() and
> trace_kfree()):
> 
>  # all kmalloc events:
>  /sys/kernel/slab/events/
> 
>  # kmalloc events for sighand_cache:
>  /sys/kernel/slab/sighand_cache/events/kmalloc/
> 
>  # kfree events for sighand_cache:
>  /sys/kernel/slab/sighand_cache/events/kfree/
> 
> In general the set of events we have upstream is growing
> along an exponential curve (there's over a hundred now,
> via tracepoints).
> 
> They are either logically attached to the hardware
> topology of the system (as in the first set of examples
> above), or ae attached to the software/subsystem object
> topology of the kernel (some examples of which are
> described in the second set of examples above).
> 
> Sometimes there are aliasing/filtering relationship
> between events, which is expressed very well via the
> hierarchy and granularity of /sysfs.
> 
> New events would go into that topology there in a natural
> way.
> 
> For example general hugepage tracepoints (should we
> introduce any) would go into the existing hugepage node:
> 
>  /sys/kernel/mm/hugepages/events/...
> 
> All in one, all these existing and future events, both of
> hardware and software type, are literally begging to be
> attached to nodes in /sys :-)

(sorry for late response...)

There are so many events via tracepoints, how about below sysfs point
for each events?

1. kvm events
/sys/devices/system/kvm/kvm0/events/kvm_set_irq/
...
/sys/devices/system/kvm/kvm0/events/kvm_emulate_insn/

2. kvm_mmu events
/sys/devices/system/kvm/kvm0/events/kvm_mmu_pagetable_walk/
...
/sys/devices/system/kvm/kvm0/events/kvm_mmu_zap_page/

3. raw_syscalls events
/sys/kernel/events/sys_enter/
/sys/kernel/events/sys_exit/

4. mce events
/sys/devices/system/machinecheck/machinecheck0/mce_record/
...
/sys/devices/system/machinecheck/machinecheckN/mce_record/

5. sched events
/sys/kernel/events/sched_kthread_stop/
...
/sys/kernel/events/sched_stat_runtime/

6. irq events
/sys/kernel/events/irq_handler_entry/
...
/sys/kernel/events/softirq_exit/

7. timer events
/sys/kernel/events/timer_init/
...
/sys/kernel/events/itimer_expire/

8. signal events
/sys/kernel/events/signal_generate/
...
/sys/kernel/events/signal_lose_info/

9. workqueue events
/sys/kernel/events/workqueue_insertion/
...
/sys/kernel/events/workqueue_destruction/

10. lock events
/sys/kernel/events/lock_acquire/
...
/sys/kernel/events/lock_acquired/

11. module events
/sys/module/events/module_load/
...
/sys/module/events/module_request/

12. power events
/sys/power/events/power_start/
...
/sys/power/events/power_end/

13. kmem events
/sys/kernel/mm/events/kmalloc/
...
/sys/kernel/mm/events/mm_page_alloc_extfrag/

14. ext4 events
/sys/fs/events/ext4_free_inode/
...
/sys/fs/events/ext4_mb_buddy_bitmap_load/

15. jbd2 events
/sys/fs/events/jbd2_checkpoint/
...
/sys/fs/events/jbd2_cleanup_journal_tail/

16. xfs events
/sys/fs/events/xfs_attr_list_sf/
...
/sys/fs/events/xfs_log_recover_inode_skip/

17. gfs2 events
/sys/fs/events/gfs2_glock_state_change/
...
/sys/fs/events/gfs2_block_alloc/

18. block events
/sys/block/sda/events/block_rq_abort/
...
/sys/block/sdb/events/block_rq_remap/

19. bkl events
/sys/kernel/events/lock_kernel/
...
/sys/kernel/events/unlock_kernel/

20. scsi events
/sys/bus/scsi/devices/0:0:0:0/events/scsi_dispatch_cmd_start/
...
/sys/bus/scsi/devices/0:0:0:0/events/scsi_eh_wakeup/

21. iwlwifi_io events
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ioread32/
...
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/events/iwlwifi_dev_ucode_event/

22. iwm events
<where should iwm events be in sysfs?>

23. skb events
/sys/class/net/events/kfree_skb/
/sys/class/net/events/skb_copy_datagram_iovec/

24. napi events
/sys/class/net/events/napi/

25. mac80211 events
/sys/class/net/events/drv_start/
...
/sys/class/net/events/stop_queue







