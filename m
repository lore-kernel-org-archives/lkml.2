Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab1EaIRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:17:19 -0400
Received: from forward3.mail.yandex.net ([77.88.46.8]:47811 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab1EaIRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:17:15 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 04:17:14 EDT
X-Yandex-Spam: 1
From: Dmitry Dmitriev <dimondmm@yandex.ru>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: PROBLEM: Corrupting d_count of target dentry, when rename directory to the directory which is mount point, or when rename directory which is mount point to the existing directory.
MIME-Version: 1.0
Message-Id: <254871306829495@web62.yandex.ru>
Date: Tue, 31 May 2011 12:11:34 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Type: multipart/mixed;
	boundary="----==--bound.25488.web62.yandex.ru"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


------==--bound.25488.web62.yandex.ru
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r

Hello!

When rename directory to the directory which is mount point( or rename directory which is mount point to the existing directory ), the target directory dentry d_count become corrupted. This problem occur on 2.6.35 kernel. In this case next call to the dget function report BUG( see below ).

The problem in vfs_rename_dir function( fs/namei.c module ):
2577 ššššššštarget = new_dentry->d_inode;
2578 šššššššif (target)
2579 šššššššššššššššmutex_lock(&target->i_mutex);
2580 šššššššif (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
2581 šššššššššššššššerror = -EBUSY;
2582 šššššššelse {
2583 šššššššššššššššif (target)
2584 šššššššššššššššššššššššdentry_unhash(new_dentry);
2585 šššššššššššššššerror = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
2586 ššššššš}
2587 šššššššif (target) {
2588 šššššššššššššššif (!error) {
2589 ššššššššššššššššššššššštarget->i_flags |= S_DEAD;
2590 šššššššššššššššššššššššdont_mount(new_dentry);
2591 ššššššššššššššš}
2592 šššššššššššššššmutex_unlock(&target->i_mutex);
2593 šššššššššššššššif (d_unhashed(new_dentry))
2594 šššššššššššššššššššššššd_rehash(new_dentry);
2595 šššššššššššššššdput(new_dentry);
2596 ššššššš}

When new_dentry exist, i.e. 'target' is not NULL, and a mount point( or old dentry is a mount point ), then function set 'error' variable to -EBUSY( line 2581 ). After that function will call dput function for new_dentry( line 2595 ) without corresponding dget. In this case d_count of dentry become corrupted. In case when old dentry and new dentry are not mount points, dget for new dentry is called in dentry_unhash function.

Therefore if old dentry or new dentry are mount points, then after execution of vfs_rename_dir function, new dentry will have a corrupted d_count and next call to the dget function can cause a BUG on line 338:
š335static inline struct dentry *dget(struct dentry *dentry)
š336{
š337 šššššššif (dentry) {
š338 šššššššššššššššBUG_ON(!atomic_read(&dentry->d_count));
š339 šššššššššššššššatomic_inc(&dentry->d_count);
š340 ššššššš}
š341 šššššššreturn dentry;
š342}

Script reproducing this problem on 2.6.35 kernel is attached.
BUG report is below:
[š 679.726754] ------------[ cut here ]------------
[š 679.726758] kernel BUG at /build/buildd/linux-2.6.35/include/linux/dcache.h:338!
[š 679.726760] invalid opcode: 0000 [#1] SMP 
[š 679.726763] last sysfs file: /sys/devices/virtual/block/loop1/queue/hw_sector_size
[š 679.726764] Modules linked in: nls_iso8859_1 vfat fat nls_cp437 cifs sha1_generic arc4 ppp_mppe ppp_async crc_ccitt binfmt_misc kvm_intel kvm parport_pc ppdev nfs lockd fscache nfs_acl auth_rpcgss sunrpc i915 drm_kms_helper drm snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device joydev asus_atk0110 snd intel_agp psmouse soundcore i2c_algo_bit snd_page_alloc serio_raw video output agpgart lp parport hid_a4tech usbhid hid r8169 ahci libahci mii
[š 679.726793] 
[š 679.726795] Pid: 2463, comm: rmdir Not tainted 2.6.35-23-generic #41-Ubuntu P7H55D-M PRO/System Product Name
[š 679.726798] EIP: 0060:[<c0221d8d>] EFLAGS: 00210246 CPU: 1
[š 679.726803] EIP is at dentry_unhash+0x7d/0x90
[š 679.726805] EAX: 00000000 EBX: ee540bb0 ECX: c02a43e0 EDX: 00000000
[š 679.726806] ESI: f2f9e0a0 EDI: ee540bb0 EBP: ef10df1c ESP: ef10df14
[š 679.726808]š DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[š 679.726810] Process rmdir (pid: 2463, ti=ef10c000 task=f037d8d0 task.ti=ef10c000)
[š 679.726811] Stack:
[š 679.726812]š fffffff0 f2f9e0a0 ef10df30 c0223126 ef10df3c ee540bb0 00000000 ef10dfa4
[š 679.726816] <0> c0224d2d ef10df94 f6bcde00 f2f4ed48 00271d65 00000003 f0187002 00000000
[š 679.726820] <0> 00000004 00000000 00000000 00000000 00800004 00000071 00000001 f2874d80
[š 679.726824] Call Trace:
[š 679.726828]š [<c0223126>] ? vfs_rmdir+0x66/0xe0
[š 679.726831]š [<c0224d2d>] ? do_rmdir+0xdd/0xf0
[š 679.726835]š [<c0216d1c>] ? filp_close+0x4c/0x80
[š 679.726837]š [<c0224d95>] ? sys_rmdir+0x15/0x20
[š 679.726841]š [<c05c99f4>] ? syscall_call+0x7/0xb
[š 679.726842] Code: 8d b6 00 00 00 00 8b 43 04 a8 10 75 dc 83 c8 10 8b 53 18 89 43 04 8b 43 14 85 c0 89 02 74 03 89 50 04 c7 43 18 00 02 20 00 eb be <0f> 0b eb fe eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 
[š 679.726864] EIP: [<c0221d8d>] dentry_unhash+0x7d/0x90 SS:ESP 0068:ef10df14
[š 679.726868] ---[ end trace a1a44cd5949fd802 ]---


Regards,
Dmitry
------==--bound.25488.web62.yandex.ru
Content-Disposition: attachment;
	filename="bug.sh"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream;
	name="bug.sh"

IyEvYmluL3NoCgpJTUFHRV9GSUxFPS4vaW1hZ2VfZmlsZQpNTlRfRElSPS4vbW50Ck9MRF9ESVI9
Li9vbGQKCmRkIGlmPS9kZXYvemVybyBvZj0kSU1BR0VfRklMRSBicz00MDk2IGNvdW50PTQwOTYg
Mj4gL2Rldi9udWxsCmxvc2V0dXAgL2Rldi9sb29wMSAkSU1BR0VfRklMRQpta2Rvc2ZzIC1GIDMy
IC9kZXYvbG9vcDEgPiAvZGV2L251bGwKCm1rZGlyICRNTlRfRElSCm1vdW50IC9kZXYvbG9vcDEg
JE1OVF9ESVIKCm1rZGlyICRPTERfRElSCgojIHJlbmFtZSAkT0xEX0RJUiB0byB0aGUgJE1OVF9E
SVIgd2hlbiAkTU5UX0RJUiBpcyBhIG1vdW50IHBvaW50Cm12ICRPTERfRElSICRNTlRfRElSIC1U
Cgp1bW91bnQgJE1OVF9ESVIKCiMgbm93IHdpbGwgZ290IEJVRwpybWRpciAkTU5UX0RJUgoKCg==
------==--bound.25488.web62.yandex.ru--
