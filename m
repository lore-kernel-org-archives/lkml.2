Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0GBOBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab0GBOBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:01:09 -0400
Message-ID: <4C2DF0CB.8060906@gmail.com>
Date: Fri, 02 Jul 2010 15:59:39 +0200
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
References: <20100702093451.GA3973@swordfish.minsk.epam.com> <20100702131248.GA5324@nowhere>
In-Reply-To: <20100702131248.GA5324@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Jul 02, 2010 at 12:34:51PM +0300, Sergey Senozhatsky wrote:
>   
>> Hello,
>>
>> I searched lkml and found the following report (titled reiserfs locking):
>> http://lkml.org/lkml/2010/4/15/389  (Fri, 16 Apr 2010)
>>
>> I can see this backtrace while configuring emacs:
>>
>> [ 6136.579013] 
>> [ 6136.579015] =======================================================
>> [ 6136.579021] [ INFO: possible circular locking dependency detected ]
>> [ 6136.579025] 2.6.35-rc3-dbg-git3-00350-g94d119f #61
>> [ 6136.579027] -------------------------------------------------------
>> [ 6136.579031] conftest/13950 is trying to acquire lock:
>> [ 6136.579034]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<c10f1cf6>] reiserfs_file_release+0x11d/0x344
>> [ 6136.579050] 
>> [ 6136.579051] but task is already holding lock:
>> [ 6136.579054]  (&mm->mmap_sem){++++++}, at: [<c1091b87>] sys_munmap+0x26/0x42
>> [ 6136.579064] 
>> [ 6136.579065] which lock already depends on the new lock.
>> [ 6136.579066] 
>> [ 6136.579069] 
>> [ 6136.579070] the existing dependency chain (in reverse order) is:
>> [ 6136.579073] 
>> [ 6136.579074] -> #1 (&mm->mmap_sem){++++++}:
>> [ 6136.579081]        [<c104f53a>] lock_acquire+0x59/0x70
>> [ 6136.579089]        [<c108cf78>] might_fault+0x53/0x70
>> [ 6136.579094]        [<c11853b8>] copy_to_user+0x30/0x48
>> [ 6136.579101]        [<c10afaf9>] filldir64+0x95/0xc9
>> [ 6136.579106]        [<c10f2504>] reiserfs_readdir_dentry+0x35d/0x4d9
>> [ 6136.579112]        [<c10f2692>] reiserfs_readdir+0x12/0x17
>> [ 6136.579117]        [<c10afd17>] vfs_readdir+0x6d/0x92
>> [ 6136.579122]        [<c10afe91>] sys_getdents64+0x63/0xa2
>> [ 6136.579127]        [<c10027d3>] sysenter_do_call+0x12/0x32
>> [ 6136.579134] 
>> [ 6136.579135] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
>> [ 6136.579142]        [<c104ef30>] __lock_acquire+0x96d/0xbe1
>> [ 6136.579148]        [<c104f53a>] lock_acquire+0x59/0x70
>> [ 6136.579153]        [<c12c5614>] __mutex_lock_common+0x39/0x36b
>> [ 6136.579160]        [<c12c5980>] mutex_lock_nested+0x12/0x15
>> [ 6136.579165]        [<c10f1cf6>] reiserfs_file_release+0x11d/0x344
>> [ 6136.579171]        [<c10a580d>] fput+0xe0/0x16a
>> [ 6136.579177]        [<c1090ca6>] remove_vma+0x28/0x47
>> [ 6136.579182]        [<c1091a68>] do_munmap+0x1e8/0x200
>> [ 6136.579188]        [<c1091b93>] sys_munmap+0x32/0x42
>> [ 6136.579193]        [<c10027d3>] sysenter_do_call+0x12/0x32
>> [ 6136.579198] 
>> [ 6136.579199] other info that might help us debug this:
>> [ 6136.579200] 
>> [ 6136.579204] 1 lock held by conftest/13950:
>> [ 6136.579207]  #0:  (&mm->mmap_sem){++++++}, at: [<c1091b87>] sys_munmap+0x26/0x42
>> [ 6136.579216] 
>> [ 6136.579217] stack backtrace:
>> [ 6136.579221] Pid: 13950, comm: conftest Not tainted 2.6.35-rc3-dbg-git3-00350-g94d119f #61
>> [ 6136.579225] Call Trace:
>> [ 6136.579230]  [<c12c4893>] ? printk+0xf/0x11
>> [ 6136.579235]  [<c104dbdd>] print_circular_bug+0x8a/0x96
>> [ 6136.579241]  [<c104ef30>] __lock_acquire+0x96d/0xbe1
>> [ 6136.579247]  [<c104e436>] ? mark_lock+0x26/0x1b3
>> [ 6136.579254]  [<c104f53a>] lock_acquire+0x59/0x70
>> [ 6136.579259]  [<c10f1cf6>] ? reiserfs_file_release+0x11d/0x344
>> [ 6136.579265]  [<c12c5614>] __mutex_lock_common+0x39/0x36b
>> [ 6136.579270]  [<c10f1cf6>] ? reiserfs_file_release+0x11d/0x344
>> [ 6136.579276]  [<c1084375>] ? release_pages+0x55/0x116
>> [ 6136.579282]  [<c12c5980>] mutex_lock_nested+0x12/0x15
>> [ 6136.579287]  [<c10f1cf6>] ? reiserfs_file_release+0x11d/0x344
>> [ 6136.579293]  [<c10f1cf6>] reiserfs_file_release+0x11d/0x344
>> [ 6136.579299]  [<c10a57bd>] ? fput+0x90/0x16a
>> [ 6136.579304]  [<c10a580d>] fput+0xe0/0x16a
>> [ 6136.579309]  [<c1090ca6>] remove_vma+0x28/0x47
>> [ 6136.579314]  [<c1091819>] ? arch_unmap_area_topdown+0x0/0x18
>> [ 6136.579319]  [<c1091a68>] do_munmap+0x1e8/0x200
>> [ 6136.579325]  [<c1091b93>] sys_munmap+0x32/0x42
>> [ 6136.579330]  [<c10027d3>] sysenter_do_call+0x12/0x32
>>
>>     
>
>
>
> Right.
>
>
> The problem is:
>
> vfs_readdir() {						do_munmap() {
> 	mutex_lock(inode);					read or write(don't know)_lock(mm->mmap_sem)
> 	reiserfs_readdir() {					reiserfs_file_release() {
> 		read_lock(mm->mmap_sem)					mutex_lock(inode);
> 	}							}
> }							}
>
>
>
> I don't think the deadlock can really happen, as we can't release the directory while
> we are reading it. Plus I guess we can't mmap a directory (someone correct me if
> I'm wrong).
>
> But still the warning is annoying. I suspect this was there for a while.
> There are other known "inversions that can't happen" in reiserfs, one is
> on the xattrs code (reiserfs/xattr.c:xattr_unlink()) which warning you
> can trigger under testing pressure.
>
> But this one looks easy to trigger, although I've never seen it, but I'll
> try your testcase.
>
> Anyway, we can't change the readdir path. mutex -> mm->mmap_sem is the correct
> ordering, we need to call copy_to_user there anyway.
>
> So the challenge is to look at this mutex_lock(&inode->i_mutex) in
> reiserfs_file_release(). I really don't know what it is protecting.
>
> Is there someone who could give me a hint here?
>   

I guess this protects file's data during so-called tail conversions.
This is a comment in indirect2direct():

// we are protected by i_mutex. The tail can not disapper, not
// append can be done either
// we are in truncate or packing tail in file_release


Edward.
>  
>   
>> As well as this:
>>
>> [  202.300464] REISERFS error (device sda9): vs-2100 add_save_link:
>> search_by_key ([-1 7812832 0x1 IND]) returned 1
>> [  202.300473] REISERFS (device sda9): Remounting filesystem read-only
>> [  202.301603] ------------[ cut here ]------------
>> [  202.301615] WARNING: at fs/reiserfs/journal.c:3436
>> journal_end+0x5b/0xaf()
>> [  202.301619] Hardware name: F3JC                
>> [  202.301622] Modules linked in: snd_seq_dummy snd_seq_oss
>> snd_seq_midi_event snd_seq snd_seq_device snd_hda_codec_si3054
>> snd_hda_codec_realtek snd_hwdep snd_pcm_oss snd_mixer_oss asus_laptop
>> sparse_keymap sdhci_pci sdhci snd_hda_intel mmc_core led_class snd_hda_codec
>> rng_core snd_pcm snd_timer snd_page_alloc snd i2c_i801 soundcore psmouse sg
>> evdev serio_raw r8169 mii usbhid hid uhci_hcd ehci_hcd sr_mod usbcore cdrom
>> sd_mod ata_piix
>> [  202.301689] Pid: 5055, comm: a.out Not tainted
>> 2.6.35-rc3-dbg-git6-00502-g94feaba-dirty #65
>> [  202.301693] Call Trace:
>> [  202.301701]  [<c102e3a2>] warn_slowpath_common+0x65/0x7a
>> [  202.301707]  [<c1102d95>] ? journal_end+0x5b/0xaf
>> [  202.301712]  [<c102e3c6>] warn_slowpath_null+0xf/0x13
>> [  202.301718]  [<c1102d95>] journal_end+0x5b/0xaf
>> [  202.301725]  [<c10eebaa>] reiserfs_truncate_file+0x19f/0x233
>> [  202.301733]  [<c10f1ba1>] reiserfs_vfs_truncate_file+0xd/0xf
>> [  202.301738]  [<c1084883>] vmtruncate+0x23/0x29
>> [  202.301745]  [<c10b4ad4>] inode_setattr+0x47/0x68
>> [  202.301751]  [<c10f1b3f>] reiserfs_setattr+0x242/0x297
>> [  202.301758]  [<c12c5d05>] ? down_write+0x22/0x2a
>> [  202.301764]  [<c10b4d6f>] notify_change+0x15c/0x26b
>> [  202.301770]  [<c10a35c7>] do_truncate+0x64/0x7d
>> [  202.301776]  [<c12c69b0>] ? _raw_spin_unlock+0x33/0x3f
>> [  202.301783]  [<c10ad892>] do_last+0x450/0x459
>> [  202.301789]  [<c10ada5b>] do_filp_open+0x1c0/0x41a
>> [  202.301798]  [<c1029081>] ? get_parent_ip+0xb/0x31
>> [  202.301804]  [<c1029123>] ? sub_preempt_count+0x7c/0x89
>> [  202.301810]  [<c10b5746>] ? alloc_fd+0xb4/0xbf
>> [  202.301816]  [<c10a3f46>] do_sys_open+0x48/0xdf
>> [  202.301821]  [<c10a3ffb>] sys_open+0x1e/0x26
>> [  202.301827]  [<c10027d3>] sysenter_do_call+0x12/0x32
>> [  202.301833] ---[ end trace c4e3312bdadd2dc5 ]---
>>     
>
>
>
> Ah that's wicked. I'll try your testcase for that too.
>
> Thanks a lot for providing these!
>
> --
> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

