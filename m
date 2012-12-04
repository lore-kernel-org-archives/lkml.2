Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab2LDKdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:33:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2LDKdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:33:11 -0500
Message-ID: <50BDD163.4040302@canonical.com>
Date: Tue, 04 Dec 2012 11:33:07 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com> <50615268.1040805@canonical.com> <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com> <506173A6.2050705@canonical.com> <87ipb2pemt.fsf@xmission.com> <50618F96.1020204@canonical.com> <87sja6nxvt.fsf@xmission.com> <20121129200612.GP4939@ZenIV.linux.org.uk>
In-Reply-To: <20121129200612.GP4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 29-11-12 21:06, Al Viro schreef:
> On Tue, Sep 25, 2012 at 04:29:58AM -0700, Eric W. Biederman wrote:
>> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>>
>>>> Could you try the following patch?  This should report what directories
>>>> cannot be renamed because one of them is a mount point and it gives some
>>>> real insight into what is going on.
>>> ls /
>>> __d_unalias: /dev -> /dev
>>> __d_unalias: /proc -> /proc
>>> __d_unalias: /sys -> /sys
>> Ok.  That is what I thought was going on.  For some reason nfs is
>> attempting to recreate an existing dentry.
>>
>> Does this fix the nfs problem for you?
>>
>> Eric
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 8086636..6390f0f 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -2404,6 +2404,9 @@ out_unalias:
>>  	if (likely(!d_mountpoint(alias))) {
>>  		__d_move(alias, dentry);
>>  		ret = alias;
>> +	} else if ((alias->d_parent == dentry->d_parent) &&
>> +		   !dentry_cmp(alias, dentry->d_name.name, dentry->d_name.len))
>> +		ret = alias;
>>  	}
> The interesting question is why the hell had it decided that preexisting
> dentry was not good enough for it?  Note that we have arrived to nfs_lookup()
> after we'd decided *not* to use the damn alias.  The trace posted upthread
> went __lookup_hash() -> lookup_real().  It means that lookup_dcache()
> has not produced this one.  And no, even if ->d_revalidate() decided it
> was no good, the logics in d_invalidate() would've said "busy" and we'd
> gone with that dentry anyway.  So it means that d_lookup() has not
> found it at all.
>
> IOW, something out there is blindly unhashing mountpoint dentries; that's
> where the real root of the problem seems to be.  Could you slap
> WARN_ON(d_mountpoint(dentry)) in __d_drop() and see what it catches?
>
Sorry for replying so late, I thought I wasn't hitting the bug any more, I was wrong..

------------[ cut here ]------------
WARNING: at fs/dcache.c:452 d_drop+0x58/0x60()
Hardware name: Aspire M3985
Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq kvm_intel kvm snd_timer snd_seq_device radeon snd usb_storage parport_pc ttm soundcore drm_kms_helper snd_page_alloc ppdev drm parport mei agpgart netconsole configfs nfsd
Pid: 1497, comm: ls Not tainted 3.7.0-rc4-patser+ #517
Call Trace:
 [<ffffffff8104cd8f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104cdea>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81187be8>] d_drop+0x58/0x60
 [<ffffffff81256881>] nfs_readdir_page_filler+0x271/0x460
 [<ffffffff81257e59>] nfs_readdir_xdr_to_array+0x1f9/0x2e0
 [<ffffffff81257f66>] nfs_readdir_filler+0x26/0x90
 [<ffffffff81119e15>] ? add_to_page_cache_lru+0x35/0x50
 [<ffffffff8111a622>] do_read_cache_page+0x82/0x1a0
 [<ffffffff81257f40>] ? nfs_readdir_xdr_to_array+0x2e0/0x2e0
 [<ffffffff81183d40>] ? sys_ioctl+0xb0/0xb0
 [<ffffffff8111a78c>] read_cache_page_async+0x1c/0x20
 [<ffffffff8111a79e>] read_cache_page+0xe/0x20
 [<ffffffff81258327>] nfs_readdir+0x137/0x510
 [<ffffffff811840e1>] ? vfs_readdir+0x81/0xf0
 [<ffffffff8126dfe0>] ? nfs3_xdr_dec_getattr3res+0x80/0x80
 [<ffffffff81183d40>] ? sys_ioctl+0xb0/0xb0
 [<ffffffff81184118>] vfs_readdir+0xb8/0xf0
 [<ffffffff8118426e>] sys_getdents+0x8e/0x120
 [<ffffffff81753394>] tracesys+0xdd/0xe2
---[ end trace 61d6a607ecd4e587 ]---
------------[ cut here ]------------

