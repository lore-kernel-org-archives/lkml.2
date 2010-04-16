Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab0DPDwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:52:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45399 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab0DPDwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:52:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ELhgNy2zHy4sNEcoxvEE6Pne1KuSDH6YDKYaX468sEZB34XhJUZcINuCrwSj5Qnu4
	H/0fAUCCHFT95HlklCQ1w==
MIME-Version: 1.0
In-Reply-To: <4BC7C005.2090100@cn.fujitsu.com>
References: <4BC7C005.2090100@cn.fujitsu.com>
From: Divyesh Shah <dpshah@google.com>
Date: Thu, 15 Apr 2010 20:51:36 -0700
Message-ID: <y2gaf41c7c41004152051w5628eb9fja2159c0eac93cb26@mail.gmail.com>
Subject: Re: lockdep warning on block tree for-2.6.35 branch
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gui,
    Thanks for the report. I can reproduce this and have a patch that
fixes it and makes the warning go away. My understanding of what was
happening is that the stats_lock for the root cfqg was not getting
initialized and hence was missing the static lock_class_key
declaration. This is because we call blkio_group_init() only when
dynamically allocating new cfqg which does not cover the root cfqg.
I'll send out the patch next.

-Divyesh

On Thu, Apr 15, 2010 at 6:40 PM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Hi
>
> I got the following warning when testing.
>
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 3298, comm: find Not tainted 2.6.34-rc4-Vivek-Blkio #48
> Call Trace:
>  [<c04558bf>] __lock_acquire+0x166/0x789
>  [<c0455f76>] lock_acquire+0x94/0xb1
>  [<fa7c06d9>] ? blkiocg_update_io_add_stats+0x21/0xe5 [blk_cgroup]
>  [<c068e1e2>] _raw_spin_lock_irqsave+0x27/0x5a
>  [<fa7c06d9>] ? blkiocg_update_io_add_stats+0x21/0xe5 [blk_cgroup]
>  [<fa7c06d9>] blkiocg_update_io_add_stats+0x21/0xe5 [blk_cgroup]
>  [<fa816886>] cfq_insert_request+0xdc/0x4f2 [cfq_iosched]
>  [<c0451b48>] ? trace_hardirqs_off+0xb/0xd
>  [<c052b7e9>] elv_insert+0xe0/0x174
>  [<c052b90c>] __elv_add_request+0x8f/0x94
>  [<c05314e2>] __make_request+0x357/0x389
>  [<c04d6b44>] ? __find_get_block+0x15d/0x167
>  [<c052faa0>] generic_make_request+0x27f/0x321
>  [<c0491017>] ? mempool_alloc_slab+0xe/0x10
>  [<c0491287>] ? mempool_alloc+0x3c/0xd7
>  [<c0531186>] submit_bio+0x8a/0x8f
>  [<c04da90a>] ? bio_alloc_bioset+0x37/0x96
>  [<c04d656f>] submit_bh+0xf0/0x10f
>  [<c04d7556>] ll_rw_block+0xc0/0xf9
>  [<f86e717c>] ext3_bread+0x34/0x7b [ext3]
>  [<f86ea875>] htree_dirblock_to_tree+0x1f/0x120 [ext3]
>  [<f86ea9f0>] ext3_htree_fill_tree+0x7a/0x1bb [ext3]
>  [<c0453147>] ? mark_held_locks+0x3d/0x58
>  [<c04b29ce>] ? kmem_cache_alloc_notrace+0x86/0xaa
>  [<c0453269>] ? trace_hardirqs_on_caller+0x107/0x12f
>  [<f86e3b53>] ext3_readdir+0x1f9/0x69e [ext3]
>  [<c04c68ec>] ? filldir64+0x0/0xcd
>  [<c068d4fe>] ? mutex_lock_killable_nested+0x2c5/0x2d9
>  [<c0450b5f>] ? debug_mutex_free_waiter+0x45/0x48
>  [<c068d508>] ? mutex_lock_killable_nested+0x2cf/0x2d9
>  [<c04c6ac7>] ? vfs_readdir+0x46/0x94
>  [<c04c6ae9>] vfs_readdir+0x68/0x94
>  [<c04c68ec>] ? filldir64+0x0/0xcd
>  [<c04c6b73>] sys_getdents64+0x5e/0x9f
>  [<c040274c>] sysenter_do_call+0x12/0x32
>
> Thanks,
> Gui
>
>
