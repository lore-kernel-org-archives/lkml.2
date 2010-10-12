Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab0JLPEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:04:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55785 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0JLPEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=KzKMkLlTZNw5CZZ0iKl9co407aRAdhKDRZZlqD1LKz54OaXKprbEvo3r5vWv0SNwJ6
         mV9JPtxXpO7peM9bokm9NQqubVyyigLhm2bNAsud/v3z1zcsDZZJiDXZtzBHEofJsivQ
         C/LKs9DIhHwfhfNVE/5kh8iLkOTM4cmj4atwk=
MIME-Version: 1.0
In-Reply-To: <20101011201007.GA29707@redhat.com>
References: <20101011201007.GA29707@redhat.com>
Date: Tue, 12 Oct 2010 08:04:07 -0700
Message-ID: <AANLkTim3aSB6bCDdmX5Ts78cH38U8JQFbhcjY+VGFX9n@mail.gmail.com>
Subject: Re: 2.6.36-rc7: inconsistent lock state: inconsistent
 {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
From: Tom London <selinux@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        selinux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 1:10 PM, Dave Jones <davej@redhat.com> wrote:
> We got this report from a Fedora user (cc'd) today..
>
>        Dave
>
>  > Noticed this when I tried to 'unmount/safely remove' a LUKS encrypted USB hard drive
>  >
>  > =================================
>  > [ 4960.442217] [ INFO: inconsistent lock state ]
>  > [ 4960.442238] 2.6.36-0.35.rc7.git0.fc15.x86_64 #1
>  > [ 4960.442258] ---------------------------------
>  > [ 4960.442278] inconsistent {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
>  > [ 4960.442323] umount/8522 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  > [ 4960.442350]  (iprune_sem){+++++-}, at: [<ffffffff8113ee55>] invalidate_inodes+0x3e/0x12c
>  > [ 4960.442402] {IN-RECLAIM_FS-R} state was registered at:
>  > [ 4960.442427]   [<ffffffff8107f089>] __lock_acquire+0x3f2/0xd79
>  > [ 4960.442464]   [<ffffffff8107feeb>] lock_acquire+0xd2/0xfd
>  > [ 4960.442499]   [<ffffffff8149cfce>] down_read+0x51/0x84
>  > [ 4960.442533]   [<ffffffff8113f197>] shrink_icache_memory+0x4e/0x1ee
>  > [ 4960.442571]   [<ffffffff810ef69d>] shrink_slab+0xe0/0x166
>  > [ 4960.442606]   [<ffffffff810f1b5b>] balance_pgdat+0x257/0x3fe
>  > [ 4960.442641]   [<ffffffff810f1f38>] kswapd+0x236/0x24c
>  > [ 4960.442671]   [<ffffffff8106c61c>] kthread+0x9d/0xa5
>  > [ 4960.442699]   [<ffffffff8100ab64>] kernel_thread_helper+0x4/0x10
>  > [ 4960.442733] irq event stamp: 5383
>  > [ 4960.442747] hardirqs last  enabled at (5383): [<ffffffff8149e5d8>] _raw_spin_unlock_irq+0x30/0x3a
>  > [ 4960.442801] hardirqs last disabled at (5382): [<ffffffff8149ddaa>] _raw_spin_lock_irq+0x21/0x75
>  > [ 4960.442855] softirqs last  enabled at (5358): [<ffffffff81148edd>] bdi_queue_work+0xc1/0xca
>  > [ 4960.442907] softirqs last disabled at (5354): [<ffffffff8149df8d>] _raw_spin_lock_bh+0x1c/0x6e
>  > [ 4960.442959]
>  > [ 4960.442959] other info that might help us debug this:
>  > [ 4960.442991] 3 locks held by umount/8522:
>  > [ 4960.443011]  #0:  (&type->s_umount_key#34){+++++.}, at: [<ffffffff8112dae5>] deactivate_super+0x32/0x3e
>  > [ 4960.443063]  #1:  (iprune_sem){+++++-}, at: [<ffffffff8113ee55>] invalidate_inodes+0x3e/0x12c
>  > [ 4960.443063]  #2:  (&fsnotify_mark_srcu){.+.+.+}, at: [<ffffffff8115896d>] fsnotify+0x7e/0x3d7
>  > [ 4960.443063]
>  > [ 4960.443063] stack backtrace:
>  > [ 4960.443063] Pid: 8522, comm: umount Not tainted 2.6.36-0.35.rc7.git0.fc15.x86_64 #1
>  > [ 4960.443063] Call Trace:
>  > [ 4960.443063]  [<ffffffff8107eaad>] valid_state+0x17c/0x18e
>  > [ 4960.443063]  [<ffffffff8107e3f9>] ? check_usage_backwards+0x0/0x81
>  > [ 4960.443063]  [<ffffffff8107ebdc>] mark_lock+0x11d/0x1d8
>  > [ 4960.443063]  [<ffffffff810801dc>] mark_held_locks+0x50/0x72
>  > [ 4960.443063]  [<ffffffff8108079e>] lockdep_trace_alloc+0xa2/0xc5
>  > [ 4960.443063]  [<ffffffff8111cbe7>] kmem_cache_alloc+0x36/0x159
>  > [ 4960.443063]  [<ffffffff8115968f>] ? fsnotify_create_event+0x3f/0x1bc
>  > [ 4960.444138]  [<ffffffff8115968f>] fsnotify_create_event+0x3f/0x1bc
>  > [ 4960.444138]  [<ffffffff81158817>] send_to_group+0x159/0x1fc
>  > [ 4960.444138]  [<ffffffff8107ff07>] ? lock_acquire+0xee/0xfd
>  > [ 4960.444138]  [<ffffffff8115896d>] ? fsnotify+0x7e/0x3d7
>  > [ 4960.444138]  [<ffffffff81158b68>] fsnotify+0x279/0x3d7
>  > [ 4960.449291]  [<ffffffff81159e81>] fsnotify_unmount_inodes+0xbb/0xfe
>  > [ 4960.449291]  [<ffffffff8113ee69>] invalidate_inodes+0x52/0x12c
>  > [ 4960.449291]  [<ffffffff81154992>] ? __sync_blockdev+0x32/0x34
>  > [ 4960.449291]  [<ffffffff8112cc66>] generic_shutdown_super+0x4c/0xe1
>  > [ 4960.449291]  [<ffffffff8112cd22>] kill_block_super+0x27/0x3f
>  > [ 4960.449291]  [<ffffffff8112cf9d>] deactivate_locked_super+0x26/0x46
>  > [ 4960.449291]  [<ffffffff8112daed>] deactivate_super+0x3a/0x3e
>  > [ 4960.449291]  [<ffffffff81142724>] mntput_no_expire+0xa7/0xd3
>  > [ 4960.449291]  [<ffffffff81143265>] sys_umount+0x2cf/0x301
>  > [ 4960.449291]  [<ffffffff81080309>] ? trace_hardirqs_on_caller+0x10b/0x12f
>  > [ 4960.459556]  [<ffffffff81009cf2>]> system_call_fastpath+0x16/0x1b
>
>

Got this again (stack trace below).  Appears to repeat when I unmount
the LUKS encrypted ext4 FS.



Oct 12 08:02:28 tlondon kernel: [ 7177.418155]
Oct 12 08:02:28 tlondon kernel: [ 7177.418157] =================================
Oct 12 08:02:28 tlondon kernel: [ 7177.418195] [ INFO: inconsistent lock state ]
Oct 12 08:02:28 tlondon kernel: [ 7177.418215]
2.6.36-0.35.rc7.git0.fc15.x86_64 #1
Oct 12 08:02:28 tlondon kernel: [ 7177.418234] ---------------------------------
Oct 12 08:02:28 tlondon kernel: [ 7177.418254] inconsistent
{IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
Oct 12 08:02:28 tlondon kernel: [ 7177.418284] umount/11119
[HC0[0]:SC0[0]:HE1:SE1] takes:
Oct 12 08:02:28 tlondon kernel: [ 7177.418313]  (iprune_sem){+++++-},
at: [<ffffffff8113ee55>] invalidate_inodes+0x3e/0x12c
Oct 12 08:02:28 tlondon kernel: [ 7177.418360] {IN-RECLAIM_FS-R} state
was registered at:
Oct 12 08:02:28 tlondon kernel: [ 7177.418384]   [<ffffffff8107f089>]
__lock_acquire+0x3f2/0xd79
Oct 12 08:02:28 tlondon kernel: [ 7177.418417]   [<ffffffff8107feeb>]
lock_acquire+0xd2/0xfd
Oct 12 08:02:28 tlondon kernel: [ 7177.418446]   [<ffffffff8149cfce>]
down_read+0x51/0x84
Oct 12 08:02:28 tlondon kernel: [ 7177.418474]   [<ffffffff8113f197>]
shrink_icache_memory+0x4e/0x1ee
Oct 12 08:02:28 tlondon kernel: [ 7177.418506]   [<ffffffff810ef69d>]
shrink_slab+0xe0/0x166
Oct 12 08:02:28 tlondon kernel: [ 7177.418536]   [<ffffffff810f1b5b>]
balance_pgdat+0x257/0x3fe
Oct 12 08:02:28 tlondon kernel: [ 7177.418565]   [<ffffffff810f1f38>]
kswapd+0x236/0x24c
Oct 12 08:02:28 tlondon kernel: [ 7177.418593]   [<ffffffff8106c61c>]
kthread+0x9d/0xa5
Oct 12 08:02:28 tlondon kernel: [ 7177.418622]   [<ffffffff8100ab64>]
kernel_thread_helper+0x4/0x10
Oct 12 08:02:28 tlondon kernel: [ 7177.418654] irq event stamp: 44965
Oct 12 08:02:28 tlondon kernel: [ 7177.418670] hardirqs last  enabled
at (44965): [<ffffffff8149e9d0>] restore_args+0x0/0x30
Oct 12 08:02:28 tlondon kernel: [ 7177.418705] hardirqs last disabled
at (44963): [<ffffffff810576ef>] __do_softirq+0x18c/0x1cf
Oct 12 08:02:28 tlondon kernel: [ 7177.418744] softirqs last  enabled
at (44964): [<ffffffff8105771c>] __do_softirq+0x1b9/0x1cf
Oct 12 08:02:28 tlondon kernel: [ 7177.418782] softirqs last disabled
at (44959): [<ffffffff8100ac5c>] call_softirq+0x1c/0x30
Oct 12 08:02:28 tlondon kernel: [ 7177.418820]
Oct 12 08:02:28 tlondon kernel: [ 7177.418820] other info that might
help us debug this:
Oct 12 08:02:28 tlondon kernel: [ 7177.418849] 3 locks held by umount/11119:
Oct 12 08:02:28 tlondon kernel: [ 7177.418865]  #0:
(&type->s_umount_key#34){+++++.}, at: [<ffffffff8112dae5>]
deactivate_super+0x32/0x3e
Oct 12 08:02:28 tlondon kernel: [ 7177.418923]  #1:
(iprune_sem){+++++-}, at: [<ffffffff8113ee55>]
invalidate_inodes+0x3e/0x12c
Oct 12 08:02:28 tlondon kernel: [ 7177.418971]  #2:
(&fsnotify_mark_srcu){.+.+.+}, at: [<ffffffff8115896d>]
fsnotify+0x7e/0x3d7
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]
Oct 12 08:02:28 tlondon kernel: [ 7177.419011] stack backtrace:
Oct 12 08:02:28 tlondon kernel: [ 7177.419011] Pid: 11119, comm:
umount Not tainted 2.6.36-0.35.rc7.git0.fc15.x86_64 #1
Oct 12 08:02:28 tlondon kernel: [ 7177.419011] Call Trace:
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8107eaad>]
valid_state+0x17c/0x18e
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8107e3f9>] ?
check_usage_backwards+0x0/0x81
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8107ebdc>]
mark_lock+0x11d/0x1d8
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff810801dc>]
mark_held_locks+0x50/0x72
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8108079e>]
lockdep_trace_alloc+0xa2/0xc5
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8111cbe7>]
kmem_cache_alloc+0x36/0x159
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8115968f>] ?
fsnotify_create_event+0x3f/0x1bc
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8115968f>]
fsnotify_create_event+0x3f/0x1bc
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81158817>]
send_to_group+0x159/0x1fc
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8107ff07>] ?
lock_acquire+0xee/0xfd
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8115896d>] ?
fsnotify+0x7e/0x3d7
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81158b68>]
fsnotify+0x279/0x3d7
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81159e81>]
fsnotify_unmount_inodes+0xbb/0xfe
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8113ee69>]
invalidate_inodes+0x52/0x12c
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81154992>] ?
__sync_blockdev+0x32/0x34
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8112cc66>]
generic_shutdown_super+0x4c/0xe1
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8112cd22>]
kill_block_super+0x27/0x3f
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8112cf9d>]
deactivate_locked_super+0x26/0x46
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff8112daed>]
deactivate_super+0x3a/0x3e
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81142724>]
mntput_no_expire+0xa7/0xd3
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81143265>]
sys_umount+0x2cf/0x301
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81080309>] ?
trace_hardirqs_on_caller+0x10b/0x12f
Oct 12 08:02:28 tlondon kernel: [ 7177.419011]  [<ffffffff81009cf2>]
system_call_fastpath+0x16/0x1b

tom
-- 
Tom London
