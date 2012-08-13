Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2HMUWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:22:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab2HMUWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:22:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 35/82] block: uninitialized ioc->nr_tasks triggers WARN_ON
Date: Mon, 13 Aug 2012 13:19:11 -0700
Message-Id: <20120813201749.507154525@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit 4638a83e8615de9c16c39dfed234951d0f468cf1 upstream.

Hi,

I'm using the old-fashioned 'dump' backup tool, and I noticed that it spews the
below warning as of 3.5-rc1 and later (3.4 is fine):

[   10.886893] ------------[ cut here ]------------
[   10.886904] WARNING: at include/linux/iocontext.h:140 copy_process+0x1488/0x1560()
[   10.886905] Hardware name: Bochs
[   10.886906] Modules linked in:
[   10.886908] Pid: 2430, comm: dump Not tainted 3.5.0-rc7+ #27
[   10.886908] Call Trace:
[   10.886911]  [<ffffffff8107ce8a>] warn_slowpath_common+0x7a/0xb0
[   10.886912]  [<ffffffff8107ced5>] warn_slowpath_null+0x15/0x20
[   10.886913]  [<ffffffff8107c088>] copy_process+0x1488/0x1560
[   10.886914]  [<ffffffff8107c244>] do_fork+0xb4/0x340
[   10.886918]  [<ffffffff8108effa>] ? recalc_sigpending+0x1a/0x50
[   10.886919]  [<ffffffff8108f6b2>] ? __set_task_blocked+0x32/0x80
[   10.886920]  [<ffffffff81091afa>] ? __set_current_blocked+0x3a/0x60
[   10.886923]  [<ffffffff81051db3>] sys_clone+0x23/0x30
[   10.886925]  [<ffffffff8179bd73>] stub_clone+0x13/0x20
[   10.886927]  [<ffffffff8179baa2>] ? system_call_fastpath+0x16/0x1b
[   10.886928] ---[ end trace 32a14af7ee6a590b ]---

Reproducing is easy, I can hit it on a KVM system with a very basic
config (x86_64 make defconfig + enable the drivers needed). To hit it,
just install dump (on debian/ubuntu, not sure what the package might be
called on Fedora), and:

dump -o -f /tmp/foo /

You'll see the warning in dmesg once it forks off the I/O process and
starts dumping filesystem contents.

I bisected it down to the following commit:

commit f6e8d01bee036460e03bd4f6a79d014f98ba712e
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Mar 5 13:15:26 2012 -0800

    block: add io_context->active_ref

    Currently ioc->nr_tasks is used to decide two things - whether an ioc
    is done issuing IOs and whether it's shared by multiple tasks.  This
    patch separate out the first into ioc->active_ref, which is acquired
    and released using {get|put}_io_context_active() respectively.

    This will be used to associate bio's with a given task.  This patch
    doesn't introduce any visible behavior change.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: Vivek Goyal <vgoyal@redhat.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

It seems like the init of ioc->nr_tasks was removed in that patch,
so it starts out at 0 instead of 1.

Tejun, is the right thing here to add back the init, or should something else
be done?

The below patch removes the warning, but I haven't done any more extensive
testing on it.

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-ioc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -244,6 +244,7 @@ int create_task_io_context(struct task_s
 
 	/* initialize */
 	atomic_long_set(&ioc->refcount, 1);
+	atomic_set(&ioc->nr_tasks, 1);
 	atomic_set(&ioc->active_ref, 1);
 	spin_lock_init(&ioc->lock);
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);


