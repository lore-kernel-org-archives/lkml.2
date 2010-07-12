Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0GLXiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:38:18 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:51645 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232Ab0GLXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:38:16 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278716222.2349.20.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
	 <1278713600.7122.22.camel@localhost.localdomain>
	 <1278716222.2349.20.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 16:37:38 -0700
Message-ID: <1278977858.6489.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:57 -0700, john stultz wrote:
> On Fri, 2010-07-09 at 15:13 -0700, Fernando Lopez-Lezcano wrote:
> > On Fri, 2010-07-09 at 12:54 -0700, john stultz wrote:
> > > On Fri, 2010-07-09 at 12:02 -0700, Fernando Lopez-Lezcano wrote:
> > > > Ok, I got one! (had to go buy a null modem cable, I thought I had one
> > > > but it has disappeared since the last time I did this :-)
> > > 
> > > Great! Sorry to make you go shopping! But this points out the problem
> > > nicely.
> > 
> > No problem at all, I was sure I had one... anyway, I still need it :-<
> > 
> > > > Find it below... it keeps spewing stuff every once in a while. Hopefully
> > > > this will be enough. No response from the network or the keyboard or
> > > > mouse at this point, reset is the only way out. 
> > > > 
> > > > I can retest if somebody comes up with a patch...
> > 
> > Sorry, it looks like the patch patched correctly and this is the new
> > kernel, but I still get a hang as before. 
> 
> So looking over it, I'm not easily seeing what else could be off.
> 
> So Lets see if we can cut some of the guess work out of this...
> 
> >  [<c04e08e9>] ? d_materialise_unique+0xbf/0x29e
> 
> I'm curious exactly where that is in d_materialise_unique. To find out,
> can you find the vmlinux image in the base of the directory you built
> the kernel you triggered this in?
> 
> Then run:
> # gdb ./vmlinux
> 
> Once gdb loads:
> (gdb) list *0xc04e08e9
> 
> That should point to exactly where in the function we are trying to
> acquire a previously locked lock.

Finally... I did a local build in my desktop machine so I now have
access to the full patched/compiled source tree. I confirmed that the
patch you sent is there (moving a spin_lock one line down). 

This is from a different kernel (non-PAE) so the exact address is
different from the previous report:

(gdb) list *0xc04d82dd
0xc04d82dd is in d_materialise_unique (fs/dcache.c:2100).
2095		spin_lock(&aparent->d_lock);
2096		spin_lock(&dparent->d_lock);
2097		spin_lock(&dentry->d_lock);
2098		spin_lock(&anon->d_lock);
2099	
2100		dentry->d_parent = (aparent == anon) ? dentry : aparent;
2101		list_del(&dentry->d_u.d_child);
2102		if (!IS_ROOT(dentry))
2103			list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
2104		else

See below for the full dump of the BUG through the serial console in
this particular occurrence. 

Let me know if there is anything else I could do. 
-- Fernando



------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:808!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs
file: /sys/devices/pci0000:00/0000:00:1c.5/0000:02:00.0/net/eth0/statistics/collisions
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 2832, comm: nautilus Not tainted
2.6.33.6-147.rt23.3.fc12.ccrma.i686.rt #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0780ab7>] EFLAGS: 00010046 CPU: 0
EIP is at rt_spin_lock_slowlock+0x43/0x1bb
EAX: f21522b0 EBX: f022f7a4 ECX: f022f7a4 EDX: f21522b0
ESI: efcf9f1c EDI: f022fd3c EBP: f23b7d14 ESP: f23b7cbc
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000001
Process nautilus (pid: 2832, ti=f23b6000 task=f21522b0 task.ti=f23b6000)
Stack:
 00000000 00000001 00000000 f23b7cd8 00000292 efcab7ac 00000000 f23b7d1c
<0> fab0f5e6 00000246 f022f7a4 f022f79c 00000000 f23b7cfc c045e4cb
efcab7ac
<0> 00000000 c0781206 00000246 f022f7a4 efcf9f1c f022fd3c f23b7d20
c045e501
Call Trace:
 [<fab0f5e6>] ? nfs_refresh_inode_locked+0x79c/0xa1e [nfs]
 [<c045e4cb>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c0781206>] ? rt_spin_unlock+0x8/0xa
 [<c045e501>] ? rt_spin_lock_fastlock.clone.1+0x5c/0x5f
 [<c07811f2>] ? rt_spin_lock+0x8/0xa
 [<c04d82dd>] ? d_materialise_unique+0xbf/0x29e
 [<fab0c5a0>] ? nfs_do_filldir+0x27b/0x3a9 [nfs]
 [<c04d5490>] ? filldir64+0x0/0xcb
 [<fab0cd57>] ? nfs_readdir+0x689/0x707 [nfs]
 [<c04d5490>] ? filldir64+0x0/0xcb
 [<c0424e61>] ? enqueue_task+0x70/0x80
 [<fab1d0de>] ? nfs3_decode_dirent+0x0/0x10e [nfs]
 [<c045d24e>] ? do_futex+0x99/0x696
 [<c0780e85>] ? rt_mutex_lock_killable+0x28/0x2c
 [<c04d574a>] ? vfs_readdir+0x66/0x92
 [<c04d5490>] ? filldir64+0x0/0xcb
 [<c04d57d9>] ? sys_getdents64+0x63/0xa5
 [<c0476d3f>] ? audit_syscall_entry+0x113/0x135
 [<c040321f>] ? sysenter_do_call+0x12/0x28
Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89 43 04 89 43 08 8d 43 0c 89 43
0c 89 43 10 8b 43 14 64 8b 15 7c d4 a3 c0 83 e0 fc 39 c2 75 04 <0f> 0b
eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff 02 b8 04 00 00 
EIP: [<c0780ab7>] rt_spin_lock_slowlock+0x43/0x1bb SS:ESP 0068:f23b7cbc
---[ end trace 21aa2c1d673e60c7 ]---
note: nautilus[2832] exited with preempt_count 1
BUG: soft lockup - CPU#2 stuck for 61s! [gvfs-gdu-volume:2718]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 2718, comm: gvfs-gdu-volume Tainted: G      D
2.6.33.6-147.rt23.3.fc12.ccrma.i686.rt #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c045ec5a>] EFLAGS: 00200202 CPU: 2
EIP is at smp_call_function_many+0x16b/0x175
EAX: 00200296 EBX: c360353c ECX: 00000004 EDX: 00000020
ESI: 00000002 EDI: c3603554 EBP: f18c7c90 ESP: f18c7c78
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gvfs-gdu-volume (pid: 2718, ti=f18c6000 task=f214f0b0
task.ti=f18c6000)
Stack:
 014ad48f 00000000 c0423a7a f18c6000 c0423a7a 00000224 f18c7ca0 c045ec8a
<0> 00000001 00000000 f18c7cb4 c043d731 00000246 00000020 00000224
f18c7cbc
<0> c04239e8 f18c7d58 c04ad6ad 00000000 00000021 00000225 00000226
00000227
Call Trace:
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c045ec8a>] ? smp_call_function+0x26/0x43
 [<c043d731>] ? on_each_cpu+0x1b/0x4c
 [<c04239e8>] ? flush_tlb_all+0x14/0x16
 [<c04ad6ad>] ? pkmap_get_free+0x146/0x188
 [<c04ad702>] ? pkmap_insert+0x13/0x108
 [<c04ad823>] ? kmap_high+0x2c/0x33
 [<c0424605>] ? kmap+0x4b/0x5a
 [<c041fa66>] ? kmap_atomic_func+0x16/0x18
 [<c04b0a25>] ? handle_mm_fault+0xb4/0x7d1
 [<c056e902>] ? avc_has_perm+0x3c/0x46
 [<c0783ccb>] ? do_page_fault+0x29d/0x2b3
 [<c0783a2e>] ? do_page_fault+0x0/0x2b3
 [<c0781db7>] ? error_code+0x73/0x78
 [<c049bacb>] ? file_read_actor+0x28/0xda
 [<c049d3ca>] ? generic_file_aio_read+0x340/0x519
 [<c04c9896>] ? do_sync_read+0x87/0xc2
 [<c0569a84>] ? security_file_permission+0xf/0x11
 [<c04c9969>] ? rw_verify_area+0x98/0xbb
 [<c04c980f>] ? do_sync_read+0x0/0xc2
 [<c04c9eb8>] ? vfs_read+0x7d/0xdc
 [<c04d08d9>] ? path_put+0x15/0x18
 [<c04c9fab>] ? sys_read+0x3b/0x5d
 [<c040321f>] ? sysenter_do_call+0x12/0x28
Code: c0 89 c2 b8 88 61 94 c0 89 59 04 e8 f7 27 32 00 0f ae f0 89 f6 89
f8 ff 15 e8 4c 97 c0 80 7d eb 00 75 04 eb 08 f3 90 f6 43 10 01 <75> f8
8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 e3 81 e3 00 e0 ff 
Call Trace:
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c045ec8a>] smp_call_function+0x26/0x43
 [<c043d731>] on_each_cpu+0x1b/0x4c
 [<c04239e8>] flush_tlb_all+0x14/0x16
 [<c04ad6ad>] pkmap_get_free+0x146/0x188
 [<c04ad702>] pkmap_insert+0x13/0x108
 [<c04ad823>] kmap_high+0x2c/0x33
 [<c0424605>] kmap+0x4b/0x5a
 [<c041fa66>] kmap_atomic_func+0x16/0x18
 [<c04b0a25>] handle_mm_fault+0xb4/0x7d1
 [<c056e902>] ? avc_has_perm+0x3c/0x46
 [<c0783ccb>] do_page_fault+0x29d/0x2b3
 [<c0783a2e>] ? do_page_fault+0x0/0x2b3
 [<c0781db7>] error_code+0x73/0x78
 [<c049bacb>] ? file_read_actor+0x28/0xda
 [<c049d3ca>] generic_file_aio_read+0x340/0x519
 [<c04c9896>] do_sync_read+0x87/0xc2
 [<c0569a84>] ? security_file_permission+0xf/0x11
 [<c04c9969>] ? rw_verify_area+0x98/0xbb
 [<c04c980f>] ? do_sync_read+0x0/0xc2
 [<c04c9eb8>] vfs_read+0x7d/0xdc
 [<c04d08d9>] ? path_put+0x15/0x18
 [<c04c9fab>] sys_read+0x3b/0x5d
 [<c040321f>] sysenter_do_call+0x12/0x28
BUG: soft lockup - CPU#3 stuck for 61s! [gnome-keyring-d:2595]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 2595, comm: gnome-keyring-d Tainted: G      D
2.6.33.6-147.rt23.3.fc12.ccrma.i686.rt #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c045ec56>] EFLAGS: 00200202 CPU: 3
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200282 EBX: c370353c ECX: 00000004 EDX: 00000020
ESI: 00000003 EDI: c3703554 EBP: f23e5e34 ESP: f23e5e1c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gnome-keyring-d (pid: 2595, ti=f23e4000 task=f2240d30
task.ti=f23e4000)
Stack:
 014ad48f 00000000 c0423a7a f23e4000 c0423a7a 00000246 f23e5e44 c045ec8a
<0> 00000001 00000000 f23e5e58 c043d731 00000267 00000020 00000246
f23e5e60
<0> c04239e8 f23e5efc c04ad6ad 00000021 00000020 00000247 00000248
00000249
Call Trace:
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c045ec8a>] ? smp_call_function+0x26/0x43
 [<c043d731>] ? on_each_cpu+0x1b/0x4c
 [<c04239e8>] ? flush_tlb_all+0x14/0x16
 [<c04ad6ad>] ? pkmap_get_free+0x146/0x188
 [<c04ad702>] ? pkmap_insert+0x13/0x108
 [<c04ad823>] ? kmap_high+0x2c/0x33
 [<c0424605>] ? kmap+0x4b/0x5a
 [<c041fa66>] ? kmap_atomic_func+0x16/0x18
 [<c04b0a25>] ? handle_mm_fault+0xb4/0x7d1
 [<c044e9f9>] ? autoremove_wake_function+0x0/0x2f
 [<c0783ccb>] ? do_page_fault+0x29d/0x2b3
 [<c0783a2e>] ? do_page_fault+0x0/0x2b3
 [<c0781db7>] ? error_code+0x73/0x78
Code: 1d 80 61 94 c0 89 c2 b8 88 61 94 c0 89 59 04 e8 f7 27 32 00 0f ae
f0 89 f6 89 f8 ff 15 e8 4c 97 c0 80 7d eb 00 75 04 eb 08 f3 90 <f6> 43
10 01 75 f8 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 e3 81 
Call Trace:
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c045ec8a>] smp_call_function+0x26/0x43
 [<c043d731>] on_each_cpu+0x1b/0x4c
 [<c04239e8>] flush_tlb_all+0x14/0x16
 [<c04ad6ad>] pkmap_get_free+0x146/0x188
 [<c04ad702>] pkmap_insert+0x13/0x108
 [<c04ad823>] kmap_high+0x2c/0x33
 [<c0424605>] kmap+0x4b/0x5a
 [<c041fa66>] kmap_atomic_func+0x16/0x18
 [<c04b0a25>] handle_mm_fault+0xb4/0x7d1
 [<c044e9f9>] ? autoremove_wake_function+0x0/0x2f
 [<c0783ccb>] do_page_fault+0x29d/0x2b3
 [<c0783a2e>] ? do_page_fault+0x0/0x2b3
 [<c0781db7>] error_code+0x73/0x78
BUG: soft lockup - CPU#0 stuck for 61s! [rsyslogd:1287]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_seq_dummy snd_cs8427 snd_ac97_codec iTCO_wdt snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
iTCO_vendor_support ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi
snd_seq_device snd_timer i2c_i801 snd ohci1394 snd_page_alloc soundcore
asus_atk0110 joydev sky2 serio_raw sata_sil24 radeon ttm drm_kms_helper
drm i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 1287, comm: rsyslogd Tainted: G      D
2.6.33.6-147.rt23.3.fc12.ccrma.i686.rt #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c045ec56>] EFLAGS: 00000202 CPU: 0
EIP is at smp_call_function_many+0x167/0x175
EAX: 00000292 EBX: c340353c ECX: 00000004 EDX: 00000020
ESI: 00000000 EDI: c3403554 EBP: f4203cd0 ESP: f4203cb8
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process rsyslogd (pid: 1287, ti=f4202000 task=f5ebc170 task.ti=f4202000)
Stack:
 014ad48f 00000000 c0423a7a f4202000 c0423a7a 00000267 f4203ce0 c045ec8a
<0> 00000001 00000000 f4203cf4 c043d731 00000288 00000020 00000267
f4203cfc
<0> c04239e8 f4203d98 c04ad6ad 00000020 00000020 00000268 00000269
0000026a
Call Trace:
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c045ec8a>] ? smp_call_function+0x26/0x43
 [<c043d731>] ? on_each_cpu+0x1b/0x4c
 [<c04239e8>] ? flush_tlb_all+0x14/0x16
 [<c04ad6ad>] ? pkmap_get_free+0x146/0x188
 [<c04ad702>] ? pkmap_insert+0x13/0x108
 [<c04ad823>] ? kmap_high+0x2c/0x33
 [<c0424605>] ? kmap+0x4b/0x5a
 [<c049b6ee>] ? iov_iter_copy_from_user_atomic+0x1d/0x63
 [<c049b80d>] ? generic_file_buffered_write+0xd9/0x1b3
 [<c049c861>] ? __generic_file_aio_write+0x256/0x287
 [<c049c8ef>] ? generic_file_aio_write+0x5d/0xa4
 [<c04c97d4>] ? do_sync_write+0x87/0xc2
 [<c0432002>] ? pick_next_task_fair+0xb3/0xbb
 [<c0569a84>] ? security_file_permission+0xf/0x11
 [<c04c9969>] ? rw_verify_area+0x98/0xbb
 [<c04c974d>] ? do_sync_write+0x0/0xc2
 [<c04c9d26>] ? vfs_write+0x80/0xdf
 [<c04c9e19>] ? sys_write+0x3b/0x5d
 [<c040321f>] ? sysenter_do_call+0x12/0x28
Code: 1d 80 61 94 c0 89 c2 b8 88 61 94 c0 89 59 04 e8 f7 27 32 00 0f ae
f0 89 f6 89 f8 ff 15 e8 4c 97 c0 80 7d eb 00 75 04 eb 08 f3 90 <f6> 43
10 01 75 f8 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 e3 81 
Call Trace:
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c0423a7a>] ? do_flush_tlb_all+0x0/0x37
 [<c045ec8a>] smp_call_function+0x26/0x43
 [<c043d731>] on_each_cpu+0x1b/0x4c
 [<c04239e8>] flush_tlb_all+0x14/0x16
 [<c04ad6ad>] pkmap_get_free+0x146/0x188
 [<c04ad702>] pkmap_insert+0x13/0x108
 [<c04ad823>] kmap_high+0x2c/0x33
 [<c0424605>] kmap+0x4b/0x5a
 [<c049b6ee>] iov_iter_copy_from_user_atomic+0x1d/0x63
 [<c049b80d>] generic_file_buffered_write+0xd9/0x1b3
 [<c049c861>] __generic_file_aio_write+0x256/0x287
 [<c049c8ef>] generic_file_aio_write+0x5d/0xa4
 [<c04c97d4>] do_sync_write+0x87/0xc2
 [<c0432002>] ? pick_next_task_fair+0xb3/0xbb
 [<c0569a84>] ? security_file_permission+0xf/0x11
 [<c04c9969>] ? rw_verify_area+0x98/0xbb
 [<c04c974d>] ? do_sync_write+0x0/0xc2
 [<c04c9d26>] vfs_write+0x80/0xdf
 [<c04c9e19>] sys_write+0x3b/0x5d
 [<c040321f>] sysenter_do_call+0x12/0x28


