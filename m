Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab2AKWMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:12:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab2AKWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:12:20 -0500
Date: Wed, 11 Jan 2012 14:12:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: lizf@cn.fujitsu.com, penberg@kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
Message-Id: <20120111141219.271d3a97.akpm@linux-foundation.org>
In-Reply-To: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 18:50:36 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> memdup_user() is called when we need to copy data from userspace. This
> means that a user is able to trigger warnings if the kmalloc() inside
> memdup_user() fails.
> 
> For example, this is one caused by writing to much data to ecryptdev:
> 
> [  912.739685] ------------[ cut here ]------------
> [  912.745080] WARNING: at mm/page_alloc.c:2217 __alloc_pages_nodemask+0x22c/0x910()
> [  912.746525] Pid: 19977, comm: trinity Not tainted 3.2.0-next-20120110-sasha #120
> [  912.747915] Call Trace:
> [  912.748415]  [<ffffffff8115ec5c>] ? __alloc_pages_nodemask+0x22c/0x910
> [  912.749651]  [<ffffffff8109a2d5>] warn_slowpath_common+0x75/0xb0
> [  912.750756]  [<ffffffff8109a3d5>] warn_slowpath_null+0x15/0x20
> [  912.751831]  [<ffffffff8115ec5c>] __alloc_pages_nodemask+0x22c/0x910
> [  912.754230]  [<ffffffff81070fd5>] ? pvclock_clocksource_read+0x55/0xd0
> [  912.755484]  [<ffffffff8106ff56>] ? kvm_clock_read+0x46/0x80
> [  912.756565]  [<ffffffff810d1548>] ? sched_clock_cpu+0xc8/0x140
> [  912.757667]  [<ffffffff810cc731>] ? get_parent_ip+0x11/0x50
> [  912.758731]  [<ffffffff810cc731>] ? get_parent_ip+0x11/0x50
> [  912.759890]  [<ffffffff81341a4b>] ? ecryptfs_miscdev_write+0x6b/0x240
> [  912.761119]  [<ffffffff81196c80>] alloc_pages_current+0xa0/0x110
> [  912.762269]  [<ffffffff8115ba1f>] __get_free_pages+0xf/0x40
> [  912.763347]  [<ffffffff811a6082>] __kmalloc_track_caller+0x172/0x190
> [  912.764561]  [<ffffffff8116f0ab>] memdup_user+0x2b/0x90
> [  912.765526]  [<ffffffff81341a4b>] ecryptfs_miscdev_write+0x6b/0x240
> [  912.766669]  [<ffffffff813419e0>] ? ecryptfs_miscdev_open+0x190/0x190
> [  912.767832]  [<ffffffff811ba360>] do_loop_readv_writev+0x50/0x80
> [  912.770735]  [<ffffffff811ba69e>] do_readv_writev+0x1ce/0x1e0
> [  912.773059]  [<ffffffff8251bbbc>] ? __mutex_unlock_slowpath+0x10c/0x200
> [  912.774634]  [<ffffffff810cc731>] ? get_parent_ip+0x11/0x50
> [  912.775699]  [<ffffffff810cc8dd>] ? sub_preempt_count+0x9d/0xd0
> [  912.776827]  [<ffffffff8251f09d>] ? retint_swapgs+0x13/0x1b
> [  912.777887]  [<ffffffff811ba758>] vfs_writev+0x48/0x60
> [  912.779162]  [<ffffffff811ba86f>] sys_writev+0x4f/0xb0
> [  912.780152]  [<ffffffff8251f979>] system_call_fastpath+0x16/0x1b
> [  912.793046] ---[ end trace 50c38c9cdee53379 ]---
> [  912.793906] ecryptfs_miscdev_write: memdup_user returned error [-12]
> 
> Failing memdup_user() shouldn't be generating warnings, instead it should
> be notifying userspace about the error.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  mm/util.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 136ac4f..88bb4d4 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -91,7 +91,7 @@ void *memdup_user(const void __user *src, size_t len)
>  	 * cause pagefault, which makes it pointless to use GFP_NOFS
>  	 * or GFP_ATOMIC.
>  	 */
> -	p = kmalloc_track_caller(len, GFP_KERNEL);
> +	p = kmalloc_track_caller(len, GFP_KERNEL | __GFP_NOWARN);
>  	if (!p)
>  		return ERR_PTR(-ENOMEM);

There's nothing particularly special about memdup_user(): there are
many ways in which userspace can trigger GFP_KERNEL allocations.

The problem here (one which your patch carefully covers up) is that
ecryptfs_miscdev_write() is passing an unchecked userspace-provided
`count' direct into kmalloc().  This is a bit problematic for other
reasons: it gives userspace a way to trigger heavy reclaim activity and
perhaps even to trigger the oom-killer.

A better fix here would be to validate the incoming arg before using
it.  Preferably by running ecryptfs_parse_packet_length() before taking
a copy of the data.  That would require adding a small copy_from_user()
to peek at the message header.
