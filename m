Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0EJRLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:11:47 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:33246 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755812Ab0EJRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:11:44 -0400
Subject: Re: 2.6.33.3-rt19 kernel BUG's
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1273279153.2776.7.camel@localhost.localdomain>
References: <1273197218.6768.10.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1005071240350.3401@localhost.localdomain>
	 <1273275821.2776.3.camel@localhost.localdomain>
	 <1273276725.17045.4.camel@localhost.localdomain>
	 <1273279153.2776.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 10 May 2010 10:11:05 -0700
Message-Id: <1273511465.21774.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 17:39 -0700, john stultz wrote:
> On Fri, 2010-05-07 at 23:58 +0000, Fernando Lopez-Lezcano wrote:
> > On Fri, 2010-05-07 at 16:43 -0700, john stultz wrote:
> > > On Fri, 2010-05-07 at 12:41 +0200, Thomas Gleixner wrote:
> > > > On Thu, 6 May 2010, Fernando Lopez-Lezcano wrote:
> > > > 
> > > > CC'ed John and Nick
> > > > 
> > > > > See below... just trying to boot (quad core desktop machine).
> > > 
> > > Ok. Got this to reproduce. Will hopefully have a fix for your soon.
> > > 
> > > Thanks for the bug report!
> > 
> > Thanks for looking at it! It had been a while since I had problems with
> > rt so I could not understand why I could not login :-) 
> 
> Bah! I should have caught this faster. I kept thinking it had to be some
> missed unlock of the sbi->fs_lock, but it ends up its just the
> autofs4_lock.
> 
> Apparently the conversion from using the dcache_lock -> autofs4_lock
> forgot that this function already grabs the autofs_lock for a small
> moment, so we end up grabbing the lock, then a moment later grab it
> again. Splat.
> 
> This patch should resolve it.

I'm still having problems when trying to use autofs, even with your
previous patch:

May 10 10:03:38 cmn3 kernel: ------------[ cut here ]------------
May 10 10:03:38 cmn3 kernel: kernel BUG at kernel/rtmutex.c:808!
May 10 10:03:38 cmn3 kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
May 10 10:03:38 cmn3 kernel: last sysfs
file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
May 10 10:03:38 cmn3 kernel: Modules linked in: autofs4 xt_time
xt_connlimit xt_realm iptable_raw xt_comment xt_policy ipt_ULOG
ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn
ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac
xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp
xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat
iptable_mangle nfnetlink coretemp hwmon_vid nfs lockd fscache nfs_acl
auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_mul
May 10 10:03:38 cmn3 kernel: tipath uinput snd_hda_codec_realtek
snd_ice1712 snd_ice17xx_ak4xxx snd_hda_intel snd_ak4xxx_adda
snd_hda_codec snd_cs8427 snd_ac97_codec snd_hwdep snd_seq snd_pcm
ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi snd_seq_device joydev
snd_timer snd asus_atk0110 iTCO_wdt sata_sil24 ohci1394 soundcore
i2c_i801 sky2 serio_raw snd_page_alloc iTCO_vendor_support ata_generic
pata_acpi radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
unloaded: microcode]
May 10 10:03:38 cmn3 kernel:
May 10 10:03:38 cmn3 kernel: Pid: 4245, comm: ls Not tainted
2.6.33.3-85.rt19.1.fc11.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
May 10 10:03:38 cmn3 kernel: EIP: 0060:[<c079201b>] EFLAGS: 00210046
CPU: 2
May 10 10:03:38 cmn3 kernel: EIP is at rt_spin_lock_slowlock+0x43/0x1bb
May 10 10:03:38 cmn3 kernel: EAX: f28a04f0 EBX: fba41f00 ECX: fba41f00
EDX: f28a04f0
May 10 10:03:38 cmn3 kernel: ESI: f01e01d0 EDI: f4a4bbc0 EBP: f02fddc4
ESP: f02fdd6c
May 10 10:03:38 cmn3 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS:
0068 preempt:00000001
May 10 10:03:38 cmn3 kernel: Process ls (pid: 4245, ti=f02fc000
task=f28a04f0 task.ti=f02fc000)
May 10 10:03:38 cmn3 kernel: Stack:
May 10 10:03:38 cmn3 kernel: f217dd90 00000001 00000000 00000000
00200296 00000000 00000000 00000000
May 10 10:03:38 cmn3 kernel: <0> 00000000 00000000 00000000 00000000
00200246 f01e01d0 f01e0180 f4a4bbc0
May 10 10:03:38 cmn3 kernel: <0> 00000000 c0464f73 00200246 fba41f00
f01e01d0 f4a4bbc0 f02fddd0 c0464fa9
May 10 10:03:38 cmn3 kernel: Call Trace:
May 10 10:03:38 cmn3 kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May 10 10:03:38 cmn3 kernel: [<c0464fa9>] ?
rt_spin_lock_fastlock.clone.1+0x5c/0x5f
May 10 10:03:38 cmn3 kernel: [<c0792752>] ? rt_spin_lock+0x8/0xa
May 10 10:03:38 cmn3 kernel: [<fba3ea5c>] ? autofs4_follow_link
+0xac/0x176 [autofs4]
May 10 10:03:38 cmn3 kernel: [<c04e5819>] ? mntput+0x19/0x1b
May 10 10:03:38 cmn3 kernel: [<c04d9522>] ? do_follow_link+0xbd/0x25f
May 10 10:03:38 cmn3 kernel: [<c04d98fb>] ? link_path_walk+0x237/0x4fc
May 10 10:03:38 cmn3 kernel: [<c04d9cc7>] ? path_walk+0x3a/0x84
May 10 10:03:38 cmn3 kernel: [<c04db08b>] ? path_init+0x6e/0x10c
May 10 10:03:38 cmn3 kernel: [<c04db24d>] ? do_path_lookup+0x124/0x186
May 10 10:03:38 cmn3 kernel: [<c04dc3ae>] ? user_path_at+0x39/0x5f
May 10 10:03:38 cmn3 kernel: [<c04d8d99>] ? page_put_link+0x0/0x1b
May 10 10:03:38 cmn3 kernel: [<c04d8db1>] ? page_put_link+0x18/0x1b
May 10 10:03:38 cmn3 kernel: [<c04d9e09>] ? generic_readlink+0x64/0x6e
May 10 10:03:38 cmn3 kernel: [<c04d5663>] ? vfs_fstatat+0x2d/0x54
May 10 10:03:38 cmn3 kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May 10 10:03:38 cmn3 kernel: [<c04d575b>] ? vfs_stat+0x13/0x15
May 10 10:03:38 cmn3 kernel: [<c04d5771>] ? sys_stat64+0x14/0x28
May 10 10:03:38 cmn3 kernel: [<c04e5819>] ? mntput+0x19/0x1b
May 10 10:03:38 cmn3 kernel: [<c04d904d>] ? path_put+0x15/0x18
May 10 10:03:38 cmn3 kernel: [<c047de61>] ? audit_syscall_entry
+0x113/0x135
May 10 10:03:38 cmn3 kernel: [<c047dd39>] ? audit_syscall_exit
+0xfa/0x10f
May 10 10:03:38 cmn3 kernel: [<c040895f>] ? sysenter_do_call+0x12/0x28
May 10 10:03:38 cmn3 kernel: Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89
43 04 89 43 08 8d 43 0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5 c0
83 e0 fc 39 c2 75 04 <0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff
02 b8 04 00 00 
May 10 10:03:38 cmn3 kernel: EIP: [<c079201b>] rt_spin_lock_slowlock
+0x43/0x1bb SS:ESP 0068:f02fdd6c
May 10 10:03:38 cmn3 kernel: ---[ end trace 6995ddbbd57ded08 ]---

-- Fernando


