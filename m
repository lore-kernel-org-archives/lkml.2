Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2IYLD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:03:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39252 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYLDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:03:54 -0400
Message-ID: <50618F96.1020204@canonical.com>
Date: Tue, 25 Sep 2012 13:03:50 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com> <50615268.1040805@canonical.com> <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com> <506173A6.2050705@canonical.com> <87ipb2pemt.fsf@xmission.com>
In-Reply-To: <87ipb2pemt.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-09-12 12:42, Eric W. Biederman schreef:
> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>
>> Hey,
>>
>> Op 25-09-12 09:05, Eric W. Biederman schreef:
>>> Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>>>
>>>> Hey,
>>>>
>>>> Op 25-09-12 05:39, Eric W. Biederman schreef:
>>>>> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>>>>>
>>>>>> This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.
>>>>>>
>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>>
>>>>>> My thread about the regression seemed to have been ignored, so I can
>>>> only
>>>>>> conclude nobody objects against a full revert of this patch.
>>>>>>
>>>>>> My testcase is simply booting through netboot with / and ~/nfs as
>>>> separate
>>>>>> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a
>>>> gnome-terminal
>>>>>> window, then I get:
>>>>> Do I read your description correctly:  Without using a bind mount you
>>>>> have the same nfs filesystem mounted on / and on ~/nfs?
>>>>>
>>>>> Something is definitely off with your configuration but if to work
>>>> you
>>>>> need to move mount points around then that something seems much
>>>> deeper
>>>>> than the __d_unalias change.
>>>>>
>>>>> What filesystems do you have mounted where?
>>>>>
>>>> / is a nfs filesystem, ~/nfs is a different nfs filesystem.
>>> Are both filesystems on the same server?
>>>
>>> Are the two filesystems distinct filesystem on the server?
>>>
>>> Unless there is duplication of something somewhere the d_unalias code should not trigger.
>> They're both on the same physical filesystem on the server, but unique exports:
>> /home/mlankhorst/nfs *(no_subtree_check,insecure,rw,all_squash,anonuid=1000,anongid=1000)
>> /home/mlankhorst/kvm/quantal-amd64 *(no_subtree_check,insecure,rw,no_root_squash)
> Modern NFS does some interesting things with disconnected roots and the
> like.  I don't think it should be connecting those two filesytems
> together because there are no overlapping directories.
>
> I really don't get why using one filesystem causes confusion in the other.
>
>> Rootfs is mounted by the kernel itself, I used a custom init script to mount /lib/modules
>> early on:
>>
>> mount -t nfs -o nolock,vers=3 192.168.1.128:/home/mlankhorst/nfs /home/mlankhorst/nfs &&
>> mkdir -p /lib/modules/$(uname -r)/kernel &&
>> mount --bind /home/mlankhorst/nfs/linux /lib/modules/$(uname -r)/kernel &&
>> ([ -f /lib/modules/$(uname -r)/modules.symbols ] || depmod)
>>
>> exec /sbin/init
> Could you try the following patch?  This should report what directories
> cannot be renamed because one of them is a mount point and it gives some
> real insight into what is going on.

ls /
__d_unalias: /dev -> /dev
__d_unalias: /proc -> /proc
__d_unalias: /sys -> /sys

Backtrace with WARN_ON_ONCE on the if check, unsurprisingly __d_unalias was inlined:
WARNING: at fs/dcache.c:2407 d_materialise_unique+0x3ee/0x490()
Hardware name: 1215N
Modules linked in: snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq parport_pc snd_timer snd_seq_device arc4 nouveau ppdev snd eeepc_wmi parport ath9k asus_wmi ttm mac80211 mxm_wmi i915 ath9k_common ath9k_hw drm_kms_helper drm ath soundcore cfg80211 snd_page_alloc video nfsd
Pid: 1452, comm: ls Not tainted 3.6.0-rc4-patser+ #175
Call Trace:
 [<ffffffff8104907a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810490c5>] warn_slowpath_null+0x15/0x20
 [<ffffffff8117d52e>] d_materialise_unique+0x3ee/0x490
 [<ffffffff812477cb>] ? nfs_fhget+0x4db/0x5a0
 [<ffffffff81242b00>] nfs_lookup+0x130/0x190
 [<ffffffff8116ff68>] lookup_real+0x18/0x50
 [<ffffffff811704e3>] __lookup_hash+0x33/0x40
 [<ffffffff81708153>] lookup_slow+0x44/0xa8
 [<ffffffff81172806>] path_lookupat+0x236/0x7e0
 [<ffffffff81170702>] ? getname_flags+0x32/0x100
 [<ffffffff8115870c>] ? kmem_cache_alloc+0xdc/0x260
 [<ffffffff81170702>] ? getname_flags+0x32/0x100
 [<ffffffff81172ddc>] do_path_lookup+0x2c/0xc0
 [<ffffffff81175a14>] user_path_at_empty+0x54/0xa0
 [<ffffffff81076f0d>] ? lg_local_unlock+0x3d/0x70
 [<ffffffff8116a1a1>] ? cp_new_stat+0x111/0x130
 [<ffffffff81175a6c>] user_path_at+0xc/0x10
 [<ffffffff8116a3b5>] vfs_fstatat+0x35/0x60
 [<ffffffff8116a3f9>] vfs_lstat+0x19/0x20
 [<ffffffff8116a555>] sys_newlstat+0x15/0x30
 [<ffffffff813924ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff817191a2>] system_call_fastpath+0x16/0x1b

~Maarten

