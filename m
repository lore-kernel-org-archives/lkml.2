Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0IYNIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 09:08:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64435 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab0IYNIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 09:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c+RLtn1EHz5HfD7riER5+nvQqd/XunB/5YfxrhVEyiZqcQvQH3ZmKAQKgm567JFuis
         USWWlu8LiL2xaCmYNnuQQa4SrOUiHom8W3YgMZF+zcR1v0L09PTtTV9MG9Z4Ql46AIYy
         1R846rYLawkPC6Ugx65wBSxPO0RAWzON3WSD0=
MIME-Version: 1.0
In-Reply-To: <20100920191355.GA28443@infradead.org>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
	<20100917005227.GJ24409@dastard>
	<20100920191355.GA28443@infradead.org>
Date: Sat, 25 Sep 2010 15:08:11 +0200
Message-ID: <AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>
Subject: Re: -mm: xfs lockdep warning
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Yang Ruirui <ruirui.r.yang@tieto.com>,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Tejun Heo, because I'm partly blaming his workqueues]

On Mon, Sep 20, 2010 at 9:13 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Sep 17, 2010 at 10:52:27AM +1000, Dave Chinner wrote:
>> Christoph, this implies an inode that has been marked for reclaim
>> that has not passed through xfs_fs_evict_inode() after being
>> initialised. If it went through the eviction process, the iolock
>> would have been re-initialised to a different context. Can you think
>> of any path that can get here without going through ->evict? I can't
>> off the top of my head...
>
> I think this could happen if the init_inode_always during
> re-initialization of an inode in reclaim fails in iget.  I have a patch
> to add that I'll run through xfsqa.  It should only happen very rarely.

I had the same lockdep report in mainline 2.6.36-rc5, when I enabled
lockdep to try to debug a hang under high load and some memory
pressure.
Do you have a patch I could try to get rid of this lockdep report to
see, if there is another one lurking behind it?

As for the hang: Today I wanted to install updates on my gentoo system
and that included an update of koffice. Because I allow emerge
(gentoos package manager) to process 4 packages in parallel and
specify -j5 for each of the compiles the result was, that emerge
decided to build 4 koffice programs in parallel which resulted in a
load ~18 on my 4 core system. With all these gcc running and the
compiles happening on a tmpfs this also resulted in some memory
pressure. (But not in a swap storm)

The first time I got this hang, I was not able to capture useful
informations, the second time it happened I got a report from the hung
task timeout:
3 processes where blocked in:
[ 1203.056532]  [<ffffffff810801c0>] ? sync_page+0x0/0x50
[ 1203.061836]  [<ffffffff8156078d>] ? io_schedule+0x3d/0x60
[ 1203.067390]  [<ffffffff810801fd>] ? sync_page+0x3d/0x50
probably because of these:
[ 1202.872424] INFO: task plasma-desktop:3169 blocked for more than 120 seconds.
[ 1202.879883] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1202.888118]  ffff88011ef860b0 0000000000000086 000000011ef860b0
ffff880114faff48
[ 1202.895936]  ffff8800071cf1c0 0000000000012780 ffff880114faffd8
0000000000012780
[ 1202.903777]  ffff880114faffd8 ffff88011ef86310 ffff880114faffd8
ffff88011ef86308
[ 1202.911586] Call Trace:
[ 1202.914140]  [<ffffffff815612c1>] ? __mutex_lock_slowpath+0xe1/0x160
[ 1202.920693]  [<ffffffff810d1e57>] ? __d_lookup+0x97/0x120
[ 1202.926272]  [<ffffffff81560d8a>] ? mutex_lock+0x1a/0x40
[ 1202.931783]  [<ffffffff810c9dbf>] ? do_lookup+0x10f/0x190
[ 1202.937426]  [<ffffffff810c7e24>] ? acl_permission_check+0x54/0xb0
[ 1202.943898]  [<ffffffff810ca8d9>] ? link_path_walk+0x4c9/0x9a0
[ 1202.950028]  [<ffffffff810d65f4>] ? mnt_want_write+0x34/0x70
[ 1202.955947]  [<ffffffff810caecf>] ? path_walk+0x5f/0xe0
[ 1202.961416]  [<ffffffff810caf9b>] ? do_path_lookup+0x4b/0x50
[ 1202.967325]  [<ffffffff810cbc35>] ? user_path_at+0x55/0xb0
[ 1202.973020]  [<ffffffff8102e860>] ? __dequeue_entity+0x40/0x50
[ 1202.979054]  [<ffffffff8107bcf4>] ? perf_event_task_sched_out+0x44/0x260
[ 1202.985995]  [<ffffffff810c2e46>] ? vfs_fstatat+0x36/0x80
[ 1202.991600]  [<ffffffff815602ac>] ? schedule+0x24c/0x6f0
[ 1202.997157]  [<ffffffff810c2f8f>] ? sys_newstat+0x1f/0x50
[ 1203.002784]  [<ffffffff81003035>] ? device_not_available+0x15/0x20
[ 1203.009204]  [<ffffffff8100246b>] ? system_call_fastpath+0x16/0x1b

[ 1202.400046] INFO: task kworker/u:8:845 blocked for more than 120 seconds.
[ 1202.407128] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1202.415372]  ffff88007ffa8b60 0000000000000046 ffff88007f74fe98
0000000000000000
[ 1202.423229]  ffff8800071cf770 0000000000012780 ffff8800070e9fd8
0000000000012780
[ 1202.431054]  ffff8800070e9fd8 ffff88007ffa8dc0 ffff8800070e9fd8
ffff88007ffa8db8
[ 1202.438898] Call Trace:
[ 1202.441495]  [<ffffffff814361ed>] ? md_write_start+0x9d/0x190
[ 1202.447536]  [<ffffffff81052e70>] ? autoremove_wake_function+0x0/0x30
[ 1202.454311]  [<ffffffff810925ca>] ? zone_nr_free_pages+0x9a/0xb0
[ 1202.460639]  [<ffffffff8142c423>] ? make_request+0x23/0x800
[ 1202.466496]  [<ffffffff811d90ea>] ? blkcipher_walk_done+0x8a/0x230
[ 1202.472990]  [<ffffffff811df4c4>] ? crypto_cbc_encrypt+0xe4/0x180
[ 1202.479327]  [<ffffffff8102a150>] ? twofish_encrypt+0x0/0x10
[ 1202.485276]  [<ffffffff81431ac3>] ? md_make_request+0xc3/0x220
[ 1202.491412]  [<ffffffff811eafca>] ? generic_make_request+0x18a/0x330
[ 1202.498096]  [<ffffffff814484fc>] ? crypt_convert+0x25c/0x310
[ 1202.504090]  [<ffffffff81448881>] ? kcryptd_crypt+0x2d1/0x3f0
[ 1202.510031]  [<ffffffff814485b0>] ? kcryptd_crypt+0x0/0x3f0
[ 1202.516081]  [<ffffffff8104d2eb>] ? process_one_work+0xfb/0x370
[ 1202.522123]  [<ffffffff8104ee4c>] ? worker_thread+0x16c/0x360
[ 1202.527935]  [<ffffffff8104ece0>] ? worker_thread+0x0/0x360
[ 1202.533541]  [<ffffffff8104ece0>] ? worker_thread+0x0/0x360
[ 1202.539131]  [<ffffffff810529e6>] ? kthread+0x96/0xa0
[ 1202.544245]  [<ffffffff81003194>] ? kernel_thread_helper+0x4/0x10
[ 1202.550363]  [<ffffffff81052950>] ? kthread+0x0/0xa0
[ 1202.555346]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10

After that I enabled lockdep and retried the same update: This time no
hang, only the same lockdep report that Yang Ruirui had.

So I'm currently at a loss how I should continue from here. The XFS
false positive drowns any other lockdep problems, but XFS had some
hang problems with the new workqueues. (Personally I had no other hang
with earlier 2.6.36-rcs)
As seen in the call trace from the kworker, there are more workqueues
involved, thats why I added Tejun to the CC. My root filesystem is XFS
on dm-crypt on a md/raid1, so it might have been something there.

If you need more information, just ask, I will try to provide it.

Torsten
