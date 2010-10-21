Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0JUDrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:47:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757390Ab0JUDrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:47:07 -0400
Date: Wed, 20 Oct 2010 20:46:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: mmotm 2010-10-20-15-01 uploaded
Message-Id: <20101020204649.46361931.akpm@linux-foundation.org>
In-Reply-To: <4CBFB06B.3020305@cn.fujitsu.com>
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
	<4CBFAB7B.7080306@cn.fujitsu.com>
	<4CBFB06B.3020305@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 11:15:55 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Li Zefan wrote:
> > akpm@linux-foundation.org wrote:
> >> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to
> >>
> >>    http://userweb.kernel.org/~akpm/mmotm/
> >>
> >> and will soon be available at
> >>
> >>    git://zen-kernel.org/kernel/mmotm.git
> >>
> >> It contains the following patches against 2.6.36-rc8:
> >>
> > 
> > Got this:
> > 
> > arch/x86/pci/xen.c: In function 'pci_xen_init':
> > arch/x86/pci/xen.c:138: error: 'isapnp_disable' undeclared (first use in this function)
> > arch/x86/pci/xen.c:138: error: (Each undeclared identifier is reported only once
> > arch/x86/pci/xen.c:138: error: for each function it appears in.)
> > 
> > # quilt patches arch/x86/pci/xen.c
> > linux-next.patch
> 
> I just commented out isapnp_disable, and after boot I saw this warning:
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/highmem_32.c:82 __kunmap_atomic+0x80/0xd4()

		WARN_ON_ONCE(idx !=
			((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));

> Hardware name: ASPIRE AG1720
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.36-rc8-mm1+ #1
> Call Trace:
>  [<c0440982>] warn_slowpath_common+0x6a/0x7f
>  [<c042e6c5>] ? __kunmap_atomic+0x80/0xd4
>  [<c04409ab>] warn_slowpath_null+0x14/0x18
>  [<c042e6c5>] __kunmap_atomic+0x80/0xd4
>  [<c04f2d1f>] zero_user_segments+0x5e/0x64
>  [<c04f2e58>] simple_write_begin+0x5e/0x6c
>  [<c04a6518>] generic_file_buffered_write+0xc0/0x1c5
>  [<c0444f41>] ? current_fs_time+0x1b/0x1e
>  [<c04a7745>] __generic_file_aio_write+0x25e/0x28f
>  [<c04a77d8>] generic_file_aio_write+0x62/0xaa
>  [<c04db6df>] do_sync_write+0x8f/0xca
>  [<c075fc8f>] ? _raw_write_unlock_irqrestore+0x41/0x4d
>  [<c074aedd>] ? kmemleak_alloc+0x59/0x78
>  [<c09874f3>] ? do_name+0x10e/0x26b
>  [<c04db650>] ? do_sync_write+0x0/0xca
>  [<c04dbc44>] vfs_write+0x85/0xe3
>  [<c04dbd40>] sys_write+0x40/0x62
>  [<c098722b>] do_copy+0x24/0xbe
>  [<c09870d4>] flush_buffer+0x6a/0x8a
>  [<c09a84b1>] gunzip+0x267/0x2e6
>  [<c0592458>] ? nofill+0x0/0x8
>  [<c09a824a>] ? gunzip+0x0/0x2e6
>  [<c0987b7f>] unpack_to_rootfs+0x1e0/0x2ee
>  [<c098706a>] ? flush_buffer+0x0/0x8a
>  [<c0986e93>] ? error+0x0/0x13
>  [<c0987cd9>] populate_rootfs+0x4c/0x200
>  [<c05a944e>] ? pci_get_subsys+0x4d/0x59
>  [<c075da14>] ? printk+0x14/0x18
>  [<c09aa16f>] ? pci_apply_final_quirks+0xc9/0xe6
>  [<c0403080>] do_one_initcall+0x76/0x126
>  [<c0987c8d>] ? populate_rootfs+0x0/0x200
>  [<c098539e>] kernel_init+0x126/0x1a2
>  [<c0985278>] ? kernel_init+0x0/0x1a2
>  [<c0409942>] kernel_thread_helper+0x6/0x10

It would have been clearer to do

	WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx))

but I don't see what's gone wrong here.  Peter?


