Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab0EEBOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 21:14:40 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35405 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760250Ab0EEBOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 21:14:39 -0400
Subject: Re: [RT] 2.6.33.3-rt19: WARNING: at fs/namespace.c:648
 commit_tree+0xf1/0x10b()
From: john stultz <johnstul@us.ibm.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100504140443.GF4309@uudg.org>
References: <20100504140443.GF4309@uudg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 18:14:19 -0700
Message-ID: <1273022060.3112.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 11:04 -0300, Luis Claudio R. Goncalves wrote:
> John,
> 
> As the backtrace seems to be closely related to what has been discussed on
> the thread "2.6.33.3-rt16: WARNING: at fs/namespace.c:1197", I copied the
> same people on this message.
> 
> As a side note, this time I just see the warning, there is no system freeze
> involved.
> 
> 
> ------------[ cut here ]------------
> WARNING: at fs/namespace.c:648 commit_tree+0xf1/0x10b()
> Hardware name: KQ260AA-AC4 a6540br
> Modules linked in: nls_utf8 udf vfat fat usb_storage fuse i915 drm_kms_helper drm video output ipt_MASQUERADE iptable_nat nf_nat bridge stp llc sunrpc ipv6 xt_physdev ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel kvm uinput tuner_simple tuner_types wm8775 tda9887 tda8290 snd_hda_codec_realtek tuner snd_hda_intel cx25840 snd_hda_codec ivtv snd_hwdep snd_seq i2c_algo_bit cx2341x v4l2_common videodev snd_seq_device v4l1_compat snd_pcm v4l2_compat_ioctl32 snd_timer ir_common snd ir_core sg r8169 tveeprom soundcore sr_mod i2c_i801 mii iTCO_wdt snd_page_alloc intel_agp firewire_ohci serio_raw cdrom i2c_core iTCO_vendor_support firewire_core pcspkr crc_itu_t button ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> Pid: 14002, comm: fusermount Not tainted 2.6.33.3-rt19 #32
> Call Trace:
> [<ffffffff81040e67>] warn_slowpath_common+0x7c/0x94
> [<ffffffff81040e93>] warn_slowpath_null+0x14/0x16
> [<ffffffff81115811>] commit_tree+0xf1/0x10b
> [<ffffffff8111661d>] attach_recursive_mnt+0xf2/0x188
> [<ffffffff811167b3>] graft_tree+0x100/0x102
> [<ffffffff8111765b>] do_mount+0x386/0x7ae
> [<ffffffff810d55f2>] ? strndup_user+0x5d/0x85
> [<ffffffff81117b0b>] sys_mount+0x88/0xc2
> [<ffffffff81002d32>] system_call_fastpath+0x16/0x1b

Yea. Looks like the fuse mounts are more interesting here and are
tripping up the MNT_MOUNTED logic.

I have a patch that will likely resolve this, but I don't think its
right, because all the MNT_MOUNTED corner cases are starting to pile up
and I suspect a deeper fix is needed.


Nick, maybe you can help here?

Trivial cases:
MNT_MOUNTED gets set by:
	attach_mnt
	commit_tree

MNT_MOUNTED gets unset by:
	detach_mnt
	unmount_tree

So there's a nice symmetry there.

We also clear MNT_MOUNTED in clone_mnt(), since we're creating a
unmounted copy that we will latter call attach_mnt() upon.


Now, here's where things get messy:
copy_tree():
	In your patches, we didn't set MNT_MOUNTED on the first clone on the
root of the mnt to be copied. This caused problems with new namespaces
since after it is copied, we don't call attach_mnt or commit_tree. So
when the namespace is removed, and we call unmount_tree, and hit a
WARN_ON. Similarly, if we bombed out in copy_tree due to a ENOMEM, we
call umount_tree on the mnt and will hit the WARN_ON as well. The same
issue hits us with collect_mounts and drop_collected_mounts, where we
copy_tree() and then unmount_tree() and hit the WARN_ON.

This seemed broken, so I set MNT_MOUNTED on the root cloned mnt in
copy_tree and it resolved the above asymmetries. 

However, do_loopback is more complicated, since it calls either
copy_tree or clone_mnt  (depending on the recursive flag) and then
grafts that mnt which calls commit_tree()/attach_mnt(). 

Leaving clone_mnt(), the mnt is not set as MNT_MOUNTED, but now with my
change to copy_tree(), it sets the root as MNT_MOUNTED. This then causes
a WARN_ON in the commit_tree() called by graft_tree().

The hacky fix below simply clears the recently set MNT_MOUNTED flag
after copy_tree() returns,  before calling graft_tree().

Now, I'm not very clear on the mnt rules here, so I'm probably wrong.
And it just seems so hacky there probably should be a better fix.

Ideas:
o Maybe the callers of copy_tree() should be setting the MNT_MOUNTED
flag? (and the ENOMEM case there would still need to be cleaned up). 

o Should we only call unmount_tree on the first sub mnt, instead of on
the non MNT_MOUNTED mnt?

o Or maybe the WARN_ONs are just overly cautious, and we should be cool
calling unmount on mnts not marked MNT_MOUNTED?

Do you have any thoughts here? 

thanks
-john

Hacky fix for MNT_MOUNTED WARNON. 

Clear MNT_MOUNTED after copy_tree, but before calling graft_tree.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/fs/namespace.c b/fs/namespace.c
index 35c56c2..150fdf4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1670,9 +1670,13 @@ static int do_loopback(struct path *path, char *old_name,
 		goto out;
 
 	err = -ENOMEM;
-	if (recurse)
+	if (recurse) {
 		mnt = copy_tree(old_path.mnt, old_path.dentry, 0);
-	else
+		/* Annoying. Since we graft the rootfs, we need to unmark
+		 * it as mounted. */
+		WARN_ON(!(mnt->mnt_flags & MNT_MOUNTED));
+		mnt->mnt_flags &= ~MNT_MOUNTED;
+	} else
 		mnt = clone_mnt(old_path.mnt, old_path.dentry, 0);
 
 	if (!mnt)


