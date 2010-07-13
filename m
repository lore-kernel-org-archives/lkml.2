Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0GMBLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:11:00 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:34746 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752449Ab0GMBK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:10:59 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278978834.2404.12.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
	 <1278713600.7122.22.camel@localhost.localdomain>
	 <1278716222.2349.20.camel@localhost.localdomain>
	 <1278977858.6489.52.camel@localhost.localdomain>
	 <1278978834.2404.12.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 18:10:26 -0700
Message-ID: <1278983426.6489.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 16:53 -0700, john stultz wrote:
> On Mon, 2010-07-12 at 16:37 -0700, Fernando Lopez-Lezcano wrote:
> > On Fri, 2010-07-09 at 15:57 -0700, john stultz wrote:
> > > So looking over it, I'm not easily seeing what else could be off.
> > > 
> > > So Lets see if we can cut some of the guess work out of this...
> > > 
> > > >  [<c04e08e9>] ? d_materialise_unique+0xbf/0x29e
> > > 
> > > I'm curious exactly where that is in d_materialise_unique. To find out,
> > > can you find the vmlinux image in the base of the directory you built
> > > the kernel you triggered this in?
> > > 
> > > Then run:
> > > # gdb ./vmlinux
> > > 
> > > Once gdb loads:
> > > (gdb) list *0xc04e08e9
> > > 
> > > That should point to exactly where in the function we are trying to
> > > acquire a previously locked lock.
> > 
> > Finally... I did a local build in my desktop machine so I now have
> > access to the full patched/compiled source tree. I confirmed that the
> > patch you sent is there (moving a spin_lock one line down). 
> > 
> > This is from a different kernel (non-PAE) so the exact address is
> > different from the previous report:
> > 
> > (gdb) list *0xc04d82dd
> > 0xc04d82dd is in d_materialise_unique (fs/dcache.c:2100).
> > 2095		spin_lock(&aparent->d_lock);
> > 2096		spin_lock(&dparent->d_lock);
> > 2097		spin_lock(&dentry->d_lock);
> > 2098		spin_lock(&anon->d_lock);
> > 2099	
> > 2100		dentry->d_parent = (aparent == anon) ? dentry : aparent;
> > 2101		list_del(&dentry->d_u.d_child);
> > 2102		if (!IS_ROOT(dentry))
> > 2103			list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
> > 2104		else
> > 
> > See below for the full dump of the BUG through the serial console in
> > this particular occurrence. 
> 
> Huh. I'm still baffled. Since we're blowing out on line 2098, the anon
> pointer points to the alias pointer we passed in to 
> __d_materialise_dentry(). So that means the anon dentry is already
> locked, and we've moved the obviously wrong lock operation down so it
> shouldn't be held.
> 
> Hrm. Ok.. I think the line 2100 above gives us a hint: (aparent == anon)
> So if that were the case, we would have already locked aparent and that
> would explain the blowup.
> 
> How does it do with the following change?

Ok, you are on to something. The machine did not crash hard!
But the serial console printed this:

--------
BUG: unable to handle kernel NULL pointer dereference at 0000008c
IP: [<c045e50a>] rt_spin_lock_fastunlock.clone.2+0x6/0x3e
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_mpu401_uart snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
ohci1394 snd_pcm snd_rawmidi snd_seq_device sky2 snd_timer i2c_i801
asus_atk0110 snd iTCO_wdt iTCO_vendor_support joydev soundcore
snd_page_alloc serio_raw sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 2855, comm: nautilus Not tainted
2.6.33.6-147.rt23.3.fc12.ccrma.i686.rt #3 P5K/EPU/P5K/EPU
EIP: 0060:[<c045e50a>] EFLAGS: 00210246 CPU: 0
EIP is at rt_spin_lock_fastunlock.clone.2+0x6/0x3e
EAX: 00000078 EBX: ef45393c ECX: 00000000 EDX: 00000078
ESI: ef716edc EDI: 00000000 EBP: f1977c8c ESP: f1977c88
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000000
Process nautilus (pid: 2855, ti=f1976000 task=f2347130 task.ti=f1976000)
Stack:
 ef45393c f1977c94 c0781206 f1977cc8 c04d842e 00000000 ef703e54 faadd5bc
<0> f1977cdc 126bc87a ef703ddc 00000000 ef45393c ef716edc ef6f5494
faafdc6c
<0> f1977df8 faad9041 c3604b5c faafdc6c ef452bfc 00007e7f f5eb41e8
00000007
Call Trace:
 [<c0781206>] ? rt_spin_unlock+0x8/0xa
 [<c04d842e>] ? d_materialise_unique+0x210/0x2aa
 [<faadd5bc>] ? nfs_fhget+0x492/0x51d [nfs]
 [<faad9041>] ? nfs_lookup+0x124/0x17d [nfs]
 [<c045e4cb>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c0781206>] ? rt_spin_unlock+0x8/0xa
 [<c04c0a8b>] ? slab_irq_enable+0x4c/0x6d
 [<c045e4cb>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c0781206>] ? rt_spin_unlock+0x8/0xa
 [<c04d86a1>] ? d_alloc+0x14d/0x156
 [<c04d0b6b>] ? do_lookup+0xc7/0x137
 [<c04d253a>] ? link_path_walk+0x367/0x48e
 [<c04d2998>] ? path_walk+0x3a/0x84
 [<c04d204b>] ? path_init+0x6e/0x10f
 [<c04d2b9a>] ? do_path_lookup+0x124/0x186
 [<c04d33e7>] ? user_path_at+0x39/0x5f
 [<c045d24e>] ? do_futex+0x99/0x696
 [<c04cce7b>] ? vfs_fstatat+0x2d/0x54
 [<c04ccee6>] ? vfs_lstat+0x16/0x18
 [<c04ccefc>] ? sys_lstat64+0x14/0x28
 [<c0781296>] ? _mutex_unlock+0x8/0xa
 [<c04d5765>] ? vfs_readdir+0x81/0x92
 [<c04d08d9>] ? path_put+0x15/0x18
 [<c0476d3f>] ? audit_syscall_entry+0x113/0x135
 [<c0476c17>] ? audit_syscall_exit+0xfa/0x10f
 [<c040321f>] ? sysenter_do_call+0x12/0x28
Code: 8d 74 26 00 f6 c4 02 74 19 64 8b 15 7c d4 a3 c0 31 c0 f0 0f b1 53
14 85 c0 74 07 89 d8 e8 73 25 32 00 5b 5d c3 55 89 c2 89 e5 53 <8b> 40
14 64 8b 0d 7c d4 a3 c0 83 e0 fc 39 c1 74 09 83 b9 f8 0c 
EIP: [<c045e50a>] rt_spin_lock_fastunlock.clone.2+0x6/0x3e SS:ESP
0068:f1977c88
CR2: 000000000000008c
---[ end trace ab297a18fc30cdc8 ]---

After that Nautilus is not usable on that autofs mount point (spins
forever). The rest of the system is still running (but I did not try too
many things). 

-- Fernando


> diff --git a/fs/dcache.c b/fs/dcache.c
> index c9d21ae..8d68504 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2099,7 +2099,8 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
>  	aparent = anon->d_parent;
>  
>  	/* XXX: hack */
> -	spin_lock(&aparent->d_lock);
> +	if (aparent != anon)
> +		spin_lock(&aparent->d_lock);
>  	spin_lock(&dparent->d_lock);
>  	spin_lock(&dentry->d_lock);
>  	spin_lock(&anon->d_lock);
> @@ -2121,7 +2122,8 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
>  	spin_unlock(&anon->d_lock);
>  	spin_unlock(&dentry->d_lock);
>  	spin_unlock(&dparent->d_lock);
> -	spin_unlock(&aparent->d_lock);
> +	if (aparent != anon)
> +		spin_unlock(&aparent->d_lock);
>  
>  	anon->d_flags &= ~DCACHE_DISCONNECTED;
>  }
> @@ -2159,8 +2161,8 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
>  			/* Is this an anonymous mountpoint that we could splice
>  			 * into our tree? */
>  			if (IS_ROOT(alias)) {
> -				spin_lock(&alias->d_lock);
>  				__d_materialise_dentry(dentry, alias);
> +				spin_lock(&alias->d_lock);
>  				__d_drop(alias);
>  				goto found;
>  			}
> 


