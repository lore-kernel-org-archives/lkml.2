Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1AJPdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:33:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:58038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1AJPdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:33:00 -0500
Subject: Re: [REPORT] BUG: spinlock recursion on CPU#0, init/1
From: Peter Zijlstra <peterz@infradead.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
References: <a7a9bdaa5936630925fb7ffd1a1795b1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Jan 2011 16:33:29 +0100
Message-ID: <1294673609.12715.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 20:51 +0530, Santosh Shilimkar wrote:
> On latest mainline commit I seeing a regression when rootfs
> is mounted on NFS. Not sure if it's already known regression.
> 
> Anybody is aware of this one ?
> 
> --------------------------------------
> Uncompressing Linux... done, booting the kernel.
> Linux version 2.6.37-03766-g0390214 (a0393909@a0393909-desktop) (gcc
> version 4.4.1 (Sourcery G++ Lite 2010q1-202) ) #44 SMP Mon Jan 10 20:41:27
> IST 2011
> 
> [....]
> 
> VFS: Mounted root (nfs filesystem) on device 0:13.
> Freeing init memory: 296K
> BUG: spinlock recursion on CPU#0, init/1
>  lock: ef5a1e0c, .magic: dead4ead, .owner: init/1, .owner_cpu: 0
> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024ce90>]
> (do_raw_spin_lock+0x48/0x158)
> [<c024ce90>] (do_raw_spin_lock+0x48/0x158) from [<c012f4e0>]
> (nameidata_dentry_drop_rcu+0x84/0x17c)
> [<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
> (d_revalidate+0x30/0x58)
> [<c012f608>] (d_revalidate+0x30/0x58) from [<c0132120>]
> (link_path_walk+0xb44/0xb64)
> [<c0132120>] (link_path_walk+0xb44/0xb64) from [<c0132338>]
> (do_path_lookup+0x44/0xcc)
> [<c0132338>] (do_path_lookup+0x44/0xcc) from [<c0132f08>]
> (do_filp_open+0xc8/0x56c)
> [<c0132f08>] (do_filp_open+0xc8/0x56c) from [<c0124828>]
> (do_sys_open+0x58/0xe4)
> [<c0124828>] (do_sys_open+0x58/0xe4) from [<c005c240>]
> (ret_fast_syscall+0x0/0x3c)
> BUG: spinlock lockup on CPU#0, init/1, ef5a1e0c
> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024cf84>]
> (do_raw_spin_lock+0x13c/0x158)
> [<c024cf84>] (do_raw_spin_lock+0x13c/0x158) from [<c012f4e0>]
> (nameidata_dentry_drop_rcu+0x84/0x17c)
> [<c012f4e0>] (nameidata_dentry_drop_rcu+0x84/0x17c) from [<c012f608>]
> (d_revalidate+0x30/0x58)
> [<c012f608>] (d_revalidate+0x30/0x58) from [<c0132120>]
> (link_path_walk+0xb44/0xb64)
> [<c0132120>] (link_path_walk+0xb44/0xb64) from [<c0132338>]
> (do_path_lookup+0x44/0xcc)
> [<c0132338>] (do_path_lookup+0x44/0xcc) from [<c0132f08>]
> (do_filp_open+0xc8/0x56c)
> [<c0132f08>] (do_filp_open+0xc8/0x56c) from [<c0124828>]
> (do_sys_open+0x58/0xe4)
> [<c0124828>] (do_sys_open+0x58/0xe4) from [<c005c240>]
> (ret_fast_syscall+0x0/0x3c)
> BUG: spinlock lockup on CPU#1, kworker/u:2/499, c05d3c80
> [<c0063290>] (unwind_backtrace+0x0/0xe4) from [<c024cf84>]
> (do_raw_spin_lock+0x13c/0x158)
> [<c024cf84>] (do_raw_spin_lock+0x13c/0x158) from [<c014afac>]
> (exit_fs+0x2c/0x84)
> [<c014afac>] (exit_fs+0x2c/0x84) from [<c0098274>] (do_exit+0x254/0x674)
> [<c0098274>] (do_exit+0x254/0x674) from [<c00b0944>] (kthread+0x88/0x8c)
> [<c00b0944>] (kthread+0x88/0x8c) from [<c005d490>]
> (kernel_thread_exit+0x0/0x8)

Smells like the stuff Nick touched.
