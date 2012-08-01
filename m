Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2HAPOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:14:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25950 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2HAPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:14:36 -0400
Date: Wed, 1 Aug 2012 11:05:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: stable@vger.kernel.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] backport "xen: mark local pages as FOREIGN in the
 m2p_override"
Message-ID: <20120801150528.GA31287@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208011401101.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208011401101.4645@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 02:34:08PM +0100, Stefano Stabellini wrote:
> Hello,
> I would like to request a backport of the following upstream Linux
> commit to 3.4, 3.3, 3.2, 3.1, 3.0, 2.6.39 and 2.6.38.
> It fixes a deadlock that happens when a Xen frontend driver connects to
> a Xen backend driver in the same domain. A detailed explanation is
> included in the commit message.
> 
> A simple cherry-pick should work for all the stable versions.

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you!
> 
> Thanks,
> 
> Stefano
> 
> 
> commit b9e0d95c041ca2d7ad297ee37c2e9cfab67a188f
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Wed May 23 18:57:20 2012 +0100
> 
>     xen: mark local pages as FOREIGN in the m2p_override
>     
>     When the frontend and the backend reside on the same domain, even if we
>     add pages to the m2p_override, these pages will never be returned by
>     mfn_to_pfn because the check "get_phys_to_machine(pfn) != mfn" will
>     always fail, so the pfn of the frontend will be returned instead
>     (resulting in a deadlock because the frontend pages are already locked).
>     
>     INFO: task qemu-system-i38:1085 blocked for more than 120 seconds.
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     qemu-system-i38 D ffff8800cfc137c0     0  1085      1 0x00000000
>      ffff8800c47ed898 0000000000000282 ffff8800be4596b0 00000000000137c0
>      ffff8800c47edfd8 ffff8800c47ec010 00000000000137c0 00000000000137c0
>      ffff8800c47edfd8 00000000000137c0 ffffffff82213020 ffff8800be4596b0
>     Call Trace:
>      [<ffffffff81101ee0>] ? __lock_page+0x70/0x70
>      [<ffffffff81a0fdd9>] schedule+0x29/0x70
>      [<ffffffff81a0fe80>] io_schedule+0x60/0x80
>      [<ffffffff81101eee>] sleep_on_page+0xe/0x20
>      [<ffffffff81a0e1ca>] __wait_on_bit_lock+0x5a/0xc0
>      [<ffffffff81101ed7>] __lock_page+0x67/0x70
>      [<ffffffff8106f750>] ? autoremove_wake_function+0x40/0x40
>      [<ffffffff811867e6>] ? bio_add_page+0x36/0x40
>      [<ffffffff8110b692>] set_page_dirty_lock+0x52/0x60
>      [<ffffffff81186021>] bio_set_pages_dirty+0x51/0x70
>      [<ffffffff8118c6b4>] do_blockdev_direct_IO+0xb24/0xeb0
>      [<ffffffff811e71a0>] ? ext3_get_blocks_handle+0xe00/0xe00
>      [<ffffffff8118ca95>] __blockdev_direct_IO+0x55/0x60
>      [<ffffffff811e71a0>] ? ext3_get_blocks_handle+0xe00/0xe00
>      [<ffffffff811e91c8>] ext3_direct_IO+0xf8/0x390
>      [<ffffffff811e71a0>] ? ext3_get_blocks_handle+0xe00/0xe00
>      [<ffffffff81004b60>] ? xen_mc_flush+0xb0/0x1b0
>      [<ffffffff81104027>] generic_file_aio_read+0x737/0x780
>      [<ffffffff813bedeb>] ? gnttab_map_refs+0x15b/0x1e0
>      [<ffffffff811038f0>] ? find_get_pages+0x150/0x150
>      [<ffffffff8119736c>] aio_rw_vect_retry+0x7c/0x1d0
>      [<ffffffff811972f0>] ? lookup_ioctx+0x90/0x90
>      [<ffffffff81198856>] aio_run_iocb+0x66/0x1a0
>      [<ffffffff811998b8>] do_io_submit+0x708/0xb90
>      [<ffffffff81199d50>] sys_io_submit+0x10/0x20
>      [<ffffffff81a18d69>] system_call_fastpath+0x16/0x1b
>     
>     The explanation is in the comment within the code:
>     
>     We need to do this because the pages shared by the frontend
>     (xen-blkfront) can be already locked (lock_page, called by
>     do_read_cache_page); when the userspace backend tries to use them
>     with direct_IO, mfn_to_pfn returns the pfn of the frontend, so
>     do_blockdev_direct_IO is going to try to lock the same pages
>     again resulting in a deadlock.
>     
>     A simplified call graph looks like this:
>     
>     pygrub                          QEMU
>     -----------------------------------------------
>     do_read_cache_page              io_submit
>       |                              |
>     lock_page                       ext3_direct_IO
>                                      |
>                                     bio_add_page
>                                      |
>                                     lock_page
>     
>     Internally the xen-blkback uses m2p_add_override to swizzle (temporarily)
>     a 'struct page' to have a different MFN (so that it can point to another
>     guest). It also can easily find out whether another pfn corresponding
>     to the mfn exists in the m2p, and can set the FOREIGN bit
>     in the p2m, making sure that mfn_to_pfn returns the pfn of the backend.
>     
>     This allows the backend to perform direct_IO on these pages, but as a
>     side effect prevents the frontend from using get_user_pages_fast on
>     them while they are being shared with the backend.
>     
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
