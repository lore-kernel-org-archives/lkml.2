Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184Ab1IOVnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:43:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935098Ab1IOVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:43:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=qNEBgv3jaLBbCcBXIG3+usjimT4YAQTHuxgQhxSDYHJw9tOtEdhSe7L6m/FsPYL6+
	yfoT7Gnw5gwyZspgtwlZg==
Date: Thu, 15 Sep 2011 14:42:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Tino Keitel <tino.keitel@tikei.de>
cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: echo 3 > /proc/.../drop_caches goes mad with 3.1-rc6, maybe
 fsnotify related
In-Reply-To: <20110915200514.GA30223@mac.home>
Message-ID: <alpine.LSU.2.00.1109151432330.10523@sister.anvils>
References: <20110915200514.GA30223@mac.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Tino Keitel wrote:
> 
> "echo 3 > /proc/sys/vm/drop_caches" does not return here, and in the
> kernel log I see the log entries below. In fact, the computer becomes
> partly unusable regarding disk access, and I have to reboot.
> 
> I currently use 3.1-rc6, but it also happened with older 3.1-rc
> kernels.
> 
> As fsnotify is showing up in the trace: I have an inotify_wait always
> running which triggers a mail queue run if something happens in my mail
> queue directory.
> 
> INFO: rcu_sched_state detected stall on CPU 1 (t=18000 jiffies)
> INFO: rcu_sched_state detected stall on CPU 1 (t=72030 jiffies)
> INFO: rcu_sched_state detected stall on CPU 1 (t=126060 jiffies)
> INFO: rcu_sched_state detected stall on CPU 1 (t=180090 jiffies)
> INFO: rcu_sched_state detected stall on CPU 1 (t=234120 jiffies)
> INFO: rcu_sched_state detected stall on CPU 1 (t=288150 jiffies)
> INFO: task fsnotify_mark:491 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> fsnotify_mark   D ffff88021fb10700     0   491      2 0x00000000
>  ffff88021eac20d0 0000000000000046 ffff880200000000 ffff88021e8be0d0
>  ffff880216497fd8 ffff880216497fd8 ffff880216497fd8 ffff88021eac20d0
>  ffff880216497e4c 0000000181037707 0000000200000086 ffffffff819577b0
> Call Trace:
>  [<ffffffff814de368>] ? __mutex_lock_slowpath+0xc8/0x140
>  [<ffffffff8108ae20>] ? synchronize_rcu_bh+0x60/0x60
>  [<ffffffff814de013>] ? mutex_lock+0x23/0x40
>  [<ffffffff8106468c>] ? __synchronize_srcu+0x2c/0xc0
>  [<ffffffff81103583>] ? fsnotify_mark_destroy+0x83/0x160
>  [<ffffffff8105fca0>] ? add_wait_queue+0x60/0x60
>  [<ffffffff81103500>] ? fsnotify_put_mark+0x20/0x20
>  [<ffffffff8105f53e>] ? kthread+0x7e/0x90
>  [<ffffffff814e0b74>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff8105f4c0>] ? kthread_worker_fn+0x180/0x180
>  [<ffffffff814e0b70>] ? gs_change+0xb/0xb
> INFO: task inotifywait:25496 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> inotifywait     D ffff88021fa10700     0 25496   2060 0x00000000
>  ffff88006ef46650 0000000000000046 ffff880200000000 ffffffff81826020
>  ffff88011355bfd8 ffff88011355bfd8 ffff88011355bfd8 ffff88006ef46650
>  000000000c800000 0000000100000000 0000000000000002 ffff88011355bd88
> Call Trace:
>  [<ffffffff814ddc55>] ? schedule_timeout+0x1c5/0x240
>  [<ffffffff814d89dd>] ? cache_alloc_refill+0x84/0x4c5
>  [<ffffffff8124e997>] ? idr_remove+0x127/0x1c0
>  [<ffffffff814dd61b>] ? wait_for_common+0xcb/0x160
>  [<ffffffff8103ef00>] ? try_to_wake_up+0x270/0x270
>  [<ffffffff8108ae20>] ? synchronize_rcu_bh+0x60/0x60
>  [<ffffffff8108ae6d>] ? synchronize_sched+0x4d/0x60
>  [<ffffffff8105ca60>] ? find_ge_pid+0x40/0x40
>  [<ffffffff810646c3>] ? __synchronize_srcu+0x63/0xc0
>  [<ffffffff81102e41>] ? fsnotify_put_group+0x21/0x40
>  [<ffffffff81104838>] ? inotify_release+0x18/0x20
>  [<ffffffff810d096a>] ? fput+0xea/0x240
>  [<ffffffff810cd1ef>] ? filp_close+0x5f/0x90
>  [<ffffffff81047116>] ? put_files_struct+0x76/0xe0

Although these stacktraces don't implicate find_get_pages() at all,
please try Shaohua's fix below (see thread: [BUG] infinite loop in
find_get_pages()), which Linus put in his tree yesterday.

Hugh

Subject: mm: account skipped entries to avoid looping in find_get_pages

The found entries by find_get_pages() could be all swap entries. In
this case we skip the entries, but make sure the skipped entries are
accounted, so we don't keep looping.
Using nr_found > nr_skip to simplify code as suggested by Eric.

Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/filemap.c b/mm/filemap.c
index 645a080..7771871 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -827,13 +827,14 @@ unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 {
 	unsigned int i;
 	unsigned int ret;
-	unsigned int nr_found;
+	unsigned int nr_found, nr_skip;
 
 	rcu_read_lock();
 restart:
 	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
 				(void ***)pages, NULL, start, nr_pages);
 	ret = 0;
+	nr_skip = 0;
 	for (i = 0; i < nr_found; i++) {
 		struct page *page;
 repeat:
@@ -856,6 +857,7 @@ repeat:
 			 * here as an exceptional entry: so skip over it -
 			 * we only reach this from invalidate_mapping_pages().
 			 */
+			nr_skip++;
 			continue;
 		}
 
@@ -876,7 +878,7 @@ repeat:
 	 * If all entries were removed before we could secure them,
 	 * try again, because callers stop trying once 0 is returned.
 	 */
-	if (unlikely(!ret && nr_found))
+	if (unlikely(!ret && nr_found > nr_skip))
 		goto restart;
 	rcu_read_unlock();
 	return ret;
