Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1D3UQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:16:05 -0400
Received: from 1wt.eu ([62.212.114.60]:35936 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab1D3UQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:16:03 -0400
Date: Sat, 30 Apr 2011 22:14:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110430201436.GF10529@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430173905.GA25641@tty.gr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Faidon,

On Sat, Apr 30, 2011 at 08:39:05PM +0300, Faidon Liambotis wrote:
> If I may add some, hopefully useful, information to the thread:
> 
> At work we have an HP c7000 blade enclosure. It's populated with 8 ProLiant
> BL460c G1 (Xeon E5405, constant_tsc but not nonstop_tsc) and 4 ProLiant 
> BL460c
> G6 (Xeon E5504, constant_tsc + nonstop_tsc). All were booted at the same day
> with Debian's 2.6.32-23~bpo50+1 kernel, i.e. upstream 2.6.32.21.
> 
> We too experienced problems with just the G6 blades at near 215 days 
> uptime (on the 19th of April), all at the same time. From our 
> investigation, it seems that their cpu_clocks jumped suddenly far in the 
> future and then almost immediately rolled over due to wrapping around 
> 64-bits.
> 
> Although all of their (G6s) clocks wrapped around *at the same time*, only 
> one
> of them actually crashed at the time, with a second one crashing just a few
> days later, on the 28th.
> 
> Three of them had the following on their logs:
> Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers 
> present
> Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - CPU#4 
> stuck for 17163091968s! [kvm:25913]
> [...]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447275]  [<ffffffff81010b42>] ? 
> system_call_fastpath+0x16/0x1b
> Apr 19 10:18:32 hn-05 kernel: [   31.587025] bond0.13: received packet with 
> own address as source address
> (full oops at the end of this mail)
> 
> Note that the 17163091968s time stuck was *the same* (+/- 1s) in *all
> three of them*.
> 
> What's also very strange, although we're not very sure if related, is
> that when we took the first line of the above log entry and substracted
> 17966378.581971 from Apr 18 20:56:07, this resulted in a boot-time that
> differed several hours from the actual boot time (the latter being
> verified both with syslog and /proc/bstat's btime, which were both in
> agreement). This was verified post-mortem too, with the date checked to
> be correct.

Well, your report is by far the most complete of our 3 since you managed
to get this trace of wraping time.

I don't know if it means anything to anyone, but 17163091968 is exactly
0x3FF000000, or 1023*2^24. Too round to be a coincidence. This number
of seconds corresponds to 1000 * 2^32 jiffies at 250 Hz.

> IOW, we have some serious clock drift (calcuated it at runtime to
> ~0.1s/min) on these machines that hasn't been made apparent probably
> since they all run NTP. Moreover, we also saw that drift on other
> machines (1U, different vendor, different data center, E5520 CPUs) but
> not with the G1 blades. Our investigation showed that the drift is there
> constantly (it's not a one-time event) but we're not really sure if it's
> related with the Apr 18th jump event.  Note that the drift is there even
> if we boot with "clocksource=hpet" but disappears when booted with
> "notsc". Also note that we've verified with 2.6.38 and the drift is
> still there.
> 
> Regards,
> Faidon
> 
> 1: The full backtrace is:
> Apr 18 20:56:07 hn-05 kernel: [17966378.581971] tap0: no IPv6 routers 
> present
> Apr 19 06:25:02 hn-05 kernel: imklog 3.18.6, log source = /proc/kmsg 
> started.
> Apr 19 10:15:42 hn-05 kernel: [18446743935.365550] BUG: soft lockup - CPU#4 
> stuck for 17163091968s! [kvm:25913]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447056] Modules linked in: 
> xt_pkttype ext2 tun kvm_intel kvm nf_conntrack_ipv6 ip6table_filter 
> ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_
> defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 8021q 
> garp bridge stp bonding dm_round_robin dm_multipath scsi_dh ipmi_poweroff 
> ipmi_devintf loop snd_pcm snd_ti
> mer snd soundcore bnx2x psmouse snd_page_alloc serio_raw sd_mod crc_t10dif 
> hpilo ipmi_si ipmi_msghandler container evdev crc32c pcspkr shpchp 
> pci_hotplug libcrc32c power_meter mdio
> button processor ext3 jbd mbcache dm_mirror dm_region_hash dm_log 
> dm_snapshot dm_mod usbhid hid cciss ehci_hcd uhci_hcd qla2xxx 
> scsi_transport_fc usbcore nls_base tg3 libphy scsi_
> tgt scsi_mod thermal fan thermal_sys [last unloaded: scsi_wait_scan]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447111] CPU 4:
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447112] Modules linked in: 
> xt_pkttype ext2 tun kvm_intel kvm nf_conntrack_ipv6 ip6table_filter 
> ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_
> defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 8021q 
> garp bridge stp bonding dm_round_robin dm_multipath scsi_dh ipmi_poweroff 
> ipmi_devintf loop snd_pcm snd_timer snd soundcore bnx2x psmouse 
> snd_page_alloc serio_raw sd_mod crc_t10dif hpilo ipmi_si ipmi_msghandler 
> container evdev crc32c pcspkr shpchp pci_hotplug libcrc32c power_meter mdio 
> button processor ext3 jbd mbcache dm_mirror dm_region_hash dm_log 
> dm_snapshot dm_mod usbhid hid cciss ehci_hcd uhci_hcd qla2xxx 
> scsi_transport_fc usbcore nls_base tg3 libphy scsi_tgt scsi_mod thermal fan 
> thermal_sys [last unloaded: scsi_wait_scan]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447154] Pid: 25913, comm: kvm 
> Not tainted 2.6.32-bpo.5-amd64 #1 ProLiant BL460c G6
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447157] RIP: 
> 0010:[<ffffffffa02e209a>]  [<ffffffffa02e209a>] 
> kvm_arch_vcpu_ioctl_run+0x785/0xa44 [kvm]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447177] RSP: 
> 0018:ffff88070065fd38  EFLAGS: 00000202
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447179] RAX: ffff88070065ffd8 
> RBX: ffff8804154ba860 RCX: ffff8804154ba860
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447182] RDX: ffff8804154ba8b9 
> RSI: ffff81004c818b10 RDI: ffff8100291a7d48
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447184] RBP: ffffffff8101166e 
> R08: 0000000000000000 R09: 0000000000000000
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447187] R10: 00007f1b2a2af078 
> R11: ffffffff802f3405 R12: 0000000000000001
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447189] R13: 00000000154ba8b8 
> R14: ffff8804136ac000 R15: ffff8804154bbd48
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447192] FS:  
> 0000000042cbb950(0000) GS:ffff88042e440000(0000) knlGS:0000000000000000
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447195] CS:  0010 DS: 002b ES: 
> 002b CR0: 0000000080050033
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447197] CR2: 0000000000000008 
> CR3: 0000000260c41000 CR4: 00000000000026e0
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447200] DR0: 0000000000000000 
> DR1: 0000000000000000 DR2: 0000000000000000
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447202] DR3: 0000000000000000 
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447205] Call Trace:
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447215]  [<ffffffffa02e2004>] ? 
> kvm_arch_vcpu_ioctl_run+0x6ef/0xa44 [kvm]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447224]  [<ffffffff8100f79c>] ? 
> __switch_to+0x285/0x297
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447231]  [<ffffffffa02d49d1>] ? 
> kvm_vcpu_ioctl+0xf1/0x4e6 [kvm]
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447237]  [<ffffffff810240da>] ? 
> lapic_next_event+0x18/0x1d
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447245]  [<ffffffff8106fb77>] ? 
> tick_dev_program_event+0x2d/0x95
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447251]  [<ffffffff81047e29>] ? 
> finish_task_switch+0x3a/0xaf
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447258]  [<ffffffff810f9f5a>] ? 
> vfs_ioctl+0x21/0x6c
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447261]  [<ffffffff810fa4a8>] ? 
> do_vfs_ioctl+0x48d/0x4cb
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447268]  [<ffffffff81063fcd>] ? 
> sys_timer_settime+0x233/0x283
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447272]  [<ffffffff810fa537>] ? 
> sys_ioctl+0x51/0x70
> Apr 19 10:15:42 hn-05 kernel: [18446743935.447275]  [<ffffffff81010b42>] ? 
> system_call_fastpath+0x16/0x1b
> Apr 19 10:18:32 hn-05 kernel: [   31.587025] bond0.13: received packet with 
> own address as source address

Regards,
Willy

