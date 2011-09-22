Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1IVEqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 00:46:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41745 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804Ab1IVEq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 00:46:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+rovA4tHarXss+E5t5AEctAu0vdwq6LlnpIfjLol
	ax+pHA8suTi5b1
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
In-Reply-To: <1316631037.24750.39.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net>
	 <1316631037.24750.39.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 06:46:22 +0200
Message-ID: <1316666782.6184.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 20:50 +0200, Peter Zijlstra wrote:
> On Wed, 2011-09-21 at 19:01 +0200, Peter Zijlstra wrote:
> > On Wed, 2011-09-21 at 12:17 +0200, Mike Galbraith wrote:
> > > [  144.212272] ------------[ cut here ]------------
> > > [  144.212280] WARNING: at kernel/sched.c:6152 migrate_disable+0x1b6/0x200()
> > > [  144.212282] Hardware name: MS-7502
> > > [  144.212283] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd parport_pc parport nfs_acl auth_rpcgss sunrpc bridge ipv6 stp cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod usbmouse usb_storage usbhid snd_hda_codec_realtek usb_libusual uas sr_mod cdrom hid snd_hda_intel e1000e snd_hda_codec kvm_intel snd_hwdep sg snd_pcm kvm i2c_i801 snd_timer snd firewire_ohci firewire_core soundcore snd_page_alloc crc_itu_t button ext4 mbcache jbd2 crc16 uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
> > > [  144.212317] Pid: 6215, comm: strace Not tainted 3.0.4-rt14 #2052
> > > [  144.212319] Call Trace:
> > > [  144.212323]  [<ffffffff8104662f>] warn_slowpath_common+0x7f/0xc0
> > > [  144.212326]  [<ffffffff8104668a>] warn_slowpath_null+0x1a/0x20
> > > [  144.212328]  [<ffffffff8103f606>] migrate_disable+0x1b6/0x200
> > > [  144.212331]  [<ffffffff8105a2a8>] ptrace_stop+0x128/0x240
> > > [  144.212334]  [<ffffffff81057b9b>] ? recalc_sigpending+0x1b/0x50
> > > [  144.212337]  [<ffffffff8105b6f1>] get_signal_to_deliver+0x211/0x530
> > > [  144.212340]  [<ffffffff81001835>] do_signal+0x75/0x7a0
> > > [  144.212342]  [<ffffffff8105ae68>] ? kill_pid_info+0x58/0x80
> > > [  144.212344]  [<ffffffff8105c34c>] ? sys_kill+0xac/0x1e0
> > > [  144.212347]  [<ffffffff81001fe5>] do_notify_resume+0x65/0x80
> > > [  144.212350]  [<ffffffff8135978b>] int_signal+0x12/0x17
> > > [  144.212352] ---[ end trace 0000000000000002 ]---
> > 
> > 
> > Right, that's because of 
> > 53da1d9456fe7f87a920a78fdbdcf1225d197cb7, I think we simply want a full
> > revert of that for -rt.
> 
> This also made me stare at the trainwreck called wait_task_inactive(),
> how about something like the below, it survives a boot and simple
> strace.

There's a missing hunklet, but...

@@ -8325,9 +8290,7 @@ void __init sched_init(void)
 
 	set_load_weight(&init_task);
 
-#ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
-#endif
 
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);

..perturbation (100% userspace hog) measurement proggy and jitter
measurement proggy pinned to the same cpu makes 100% repeatable boom.

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3
Pid: 6226, comm: pert Not tainted 3.0.4-rt14 #2053
Call Trace:
 <NMI>  [<ffffffff81355f00>] panic+0xa0/0x1a8
 [<ffffffff8108fe47>] watchdog_overflow_callback+0xe7/0xf0
 [<ffffffff810c1c7c>] __perf_event_overflow+0x9c/0x250
 [<ffffffff810c2734>] perf_event_overflow+0x14/0x20
 [<ffffffff81014c7c>] intel_pmu_handle_irq+0x21c/0x440
 [<ffffffff81010fb9>] perf_event_nmi_handler+0x39/0xc0
 [<ffffffff8106f42c>] notifier_call_chain+0x4c/0x70
 [<ffffffff8106fa6a>] __atomic_notifier_call_chain+0x4a/0x70
 [<ffffffff8106faa6>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff8106fc2e>] notify_die+0x2e/0x30
 [<ffffffff81002c8a>] do_nmi+0xaa/0x240
 [<ffffffff813592ea>] nmi+0x1a/0x20
 <<EOE>> <0>Rebooting in 60 seconds..[    0.000000]


