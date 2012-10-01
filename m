Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2JAJKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:10:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab2JAJKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:10:04 -0400
Date: Mon, 1 Oct 2012 11:10:01 +0200
From: Jan Kara <jack@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Jan Kara <jack@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
Message-ID: <20121001091001.GA22800@quack.suse.cz>
References: <50531629.9020107@ahsoftware.de>
 <20120925110206.GD28937@mwanda>
 <50643C4A.9010202@ahsoftware.de>
 <20120927151232.GA12210@quack.suse.cz>
 <506474E8.3030300@ahsoftware.de>
 <20120927200342.GB12553@quack.suse.cz>
 <506746EF.5070000@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506746EF.5070000@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 29-09-12 21:07:27, Alexander Holler wrote:
> Am 27.09.2012 22:03, schrieb Jan Kara:
> >On Thu 27-09-12 17:46:48, Alexander Holler wrote:
> >>Hello,
> >>
> >>Am 27.09.2012 17:12, schrieb Jan Kara:
> >>>   Just some thoughts about your oops:
> >>>The assertion which fails is:
> >>>BUG_ON(!list_empty(&bh->b_assoc_buffers));
> >>>
> >>>Now b_assoc_buffers isn't used very much. In particular ext4 which you seem
> >>>to be using doesn't use this list at all (except when mounted in nojournal
> >>>mode but that doesn't seem to be your case). That would point rather
> >>>strongly at a memory corruption issue.
> >>>
> >>>So if you can reproduce the oops, it might be interesting to print
> >>>bh->b_assoc_buffers.next and &bh->b_assoc_buffers.next if the list is found
> >>>to be non-empty.
> >>
> >>Hmm, a loose pointer would explain it all too. Especially the cases
> >>when I just have seen wrong content in the archive without having
> >>any oops. I try to reproduce it with
> >>
> >>pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
> >>&bh->b_assoc_buffers.next);
> >>after the BUG_ON().
> >   It should have been:
> >	if (!list_empty(&bh->b_assoc_buffers))
> >		pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next,
> >			&bh->b_assoc_buffers.next);
> >   *before* BUG_ON().
> >
> >   What you saw in the logs were just pointers showing the list is empty
> >(naturally as otherwise we'd see the BUG_ON trigger).
> 
> Yes, I've already wondered what you want to read in the output. ;)
> 
> Btw. I've just had that bug while doing sha1sum /dev/sr0, where sr0
> is a dvd-writer attached to a sata-port. No USB involved. Before the
> sha1sum I did an mbuffer < /dev/sr0 | bzip2smp >foo.iso.bz2. But
> that needed only a few minutes (8GB) and I haven't had any throttle
> events or similiar, so Idon't think the cpu (or whatever) got hot.
> 
> ---------
> Sep 29 20:38:20 krabat kernel: [ 1652.879952] ------------[ cut here
> ]------------
> Sep 29 20:38:20 krabat kernel: [ 1652.879956] kernel BUG at
> fs/buffer.c:3199!
> Sep 29 20:38:20 krabat kernel: [ 1652.879957] invalid opcode: 0000 [#1] SMP
> Sep 29 20:38:20 krabat kernel: [ 1652.879959] CPU 2
> Sep 29 20:38:20 krabat kernel: [ 1652.879960] Modules linked in: nfs
> rfcomm fuse hidp ebtable_nat ebtables ipt_MASQUERADE xt_CHECKSUM
> iptable_mangle iptable_nat nf_nat bridge stp llc it87 hwmon_vid
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
> ip6_tables xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack iptable_filter btusb bluetooth rfkill joydev
> hid_logitech ff_memless usbhid pata_jmicron binfmt_misc usb_storage
> uas virtio_blk virtio_net virtio_balloon virtio_pci virtio_ring
> virtio vhost_net tun macvtap macvlan snd_hda_codec_hdmi
> snd_hda_codec_realtek coretemp kvm_intel snd_hda_intel snd_hda_codec
> kvm snd_hwdep uhci_hcd uinput snd_seq crc32c_intel snd_seq_device
> sr_mod snd_pcm xhci_hcd cdrom i7core_edac microcode ehci_hcd
> snd_page_alloc dm_mod edac_core fglrx(PO) r8169 snd_timer lpc_ich
> mii snd jmicron mfd_core soundcore agpgart usbcore usb_common nfsd
> nfs_acl auth_rpcgss lockd sunrpc ipv6 [last unloaded:
> scsi_wait_scan]
> Sep 29 20:38:20 krabat kernel: [ 1652.879992]
> Sep 29 20:38:20 krabat kernel: [ 1652.879993] Pid: 4670, comm:
> sha1sum Tainted: P           O 3.5.4-00009-gfa43f23-dirty #228
  BTW, fglrx moodule taints the kernel because it is a proprietary driver.
Can you reproduce the issue without this module loaded?

								Honza

