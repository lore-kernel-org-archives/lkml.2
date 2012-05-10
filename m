Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2EJQEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab2EJQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:04:47 -0400
Date: Thu, 10 May 2012 12:04:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linus-nfs@vger.kernel.org, bfields@fieldses.org,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: nfs triggering Root dentry has weird name <>
Message-ID: <20120510160437.GA11707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linus-nfs@vger.kernel.org, bfields@fieldses.org,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been getting reports of this message for a while in Fedora
(Since circa 3.1).  There are two different flavours.
One from readlink..

:WARNING: at fs/dcache.c:2460 prepend_path+0x11b/0x131()
:Hardware name: System Product Name
:Root dentry has weird name <>
:Modules linked in: ppdev parport_pc lp parport fuse nfs fscache auth_rpcgss nfs_acl via drm lockd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack_netbios_ns nf_conntrack_broadcast ip6table_filter nf_conntrack_tftp ip6_tables nf_conntrack snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device joydev snd_pcm via_rhine snd_timer snd mii soundcore snd_page_alloc shpchp asus_atk0110 i2c_viapro i2c_core microcode sunrpc xfs pata_acpi ata_generic pata_via sata_via [last unloaded: scsi_wait_scan]
:Pid: 6635, comm: abrt-hook-ccpp Not tainted 3.1.0-7.fc16.x86_64 #1
:Call Trace:
: [<ffffffff81057a4e>] warn_slowpath_common+0x83/0x9b
: [<ffffffff81057b09>] warn_slowpath_fmt+0x46/0x48
: [<ffffffff81139190>] prepend_path+0x11b/0x131
: [<ffffffff81139216>] path_with_deleted+0x70/0x79
: [<ffffffff8113a40d>] d_path+0xa1/0xc6
: [<ffffffff81175f03>] proc_pid_readlink+0x71/0xcf
: [<ffffffff8112cd36>] sys_readlinkat+0x73/0x95
: [<ffffffff8112cd73>] sys_readlink+0x1b/0x1d
: [<ffffffff814bc482>] system_call_fastpath+0x16/0x1b

and one from getcwd...

WARNING: at fs/dcache.c:2458 prepend_path+0x18c/0x1a0()
Hardware name: P5KC
Root dentry has weird name <>
Modules linked in: vfat fat snd_usb_audio snd_usbmidi_lib snd_rawmidi nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack tcp_lp binfmt_misc ppdev parport_pc lp parport fcoe libfcoe libfc scsi_transport_fc scsi_tgt 8021q garp stp llc nfs lockd auth_rpcgss nfs_acl des_generic md4 nls_utf8 cifs fscache ip6t_REJECT fuse snd_hda_codec_hdmi microcode iTCO_wdt iTCO_vendor_support serio_raw snd_hda_codec_realtek i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep asus_atk0110 snd_seq snd_seq_device snd_pcm atl1 mii snd_timer snd soundcore snd_page_alloc uinput sunrpc firewire_ohci firewire_core pata_acpi ata_generic usb_storage crc_itu_t pata_jmicron radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: nf_conntrack]
 Pid: 18100, comm: view Tainted: G        W  3.1.9-1.fc16.x86_64 #1
Call Trace:
 [<ffffffff8106b7ef>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106b8e6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff811875bc>] prepend_path+0x18c/0x1a0
 [<ffffffff8118a7d7>] sys_getcwd+0xf7/0x1e0
 [<ffffffff815dd1c2>] system_call_fastpath+0x16/0x1b


The common thing seems to be NFS.
I added a patch to print out vfsmnt->mnt_sb->s_type->name, and sure enough
every report since has shown nfs in there.

Despite how commonly we've had it reported, it seems to be very hard to reproduce.
I managed to hit it once myself, but haven't seen it in a month or so since.

Original reports at:
https://bugzilla.redhat.com/show_bug.cgi?id=766277
https://bugzilla.redhat.com/show_bug.cgi?id=787171

	Dave

