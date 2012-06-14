Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2FNNpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:45:07 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:48503 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2FNNpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:45:05 -0400
X-IronPort-AV: E=Sophos;i="4.75,770,1330905600"; 
   d="scan'208";a="13023184"
Date: Thu, 14 Jun 2012 14:44:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xen: mark local pages as FOREIGN in the
 m2p_override
In-Reply-To: <20120613193926.GA21706@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1206141223240.14957@kaball.uk.xensource.com>
References: <1337795840-10061-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120613193926.GA21706@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Konrad Rzeszutek Wilk wrote:
> On Wed, May 23, 2012 at 06:57:20PM +0100, Stefano Stabellini wrote:
> > When the frontend and the backend reside on the same domain, even if we
> > add pages to the m2p_override, these pages will never be returned by
> > mfn_to_pfn because the check "get_phys_to_machine(pfn) != mfn" will
> > always fail, so the pfn of the frontend will be returned instead
> > (resulting in a deadlock because the frontend pages are already locked).
> 
> If I recall you were suppose to attach the stack trace here
> and also explain a bit about how the lock happens (like a call-tree).

This is the stack trace:

[ 7440.396076] INFO: task qemu-system-i38:1085 blocked for more than 120 seconds.
[ 7440.396089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7440.396096] qemu-system-i38 D ffff8800cfc137c0     0  1085      1 0x00000000
[ 7440.396105]  ffff8800c47ed898 0000000000000282 ffff8800be4596b0 00000000000137c0
[ 7440.396115]  ffff8800c47edfd8 ffff8800c47ec010 00000000000137c0 00000000000137c0
[ 7440.396124]  ffff8800c47edfd8 00000000000137c0 ffffffff82213020 ffff8800be4596b0
[ 7440.396134] Call Trace:
[ 7440.396146]  [<ffffffff81101ee0>] ? __lock_page+0x70/0x70
[ 7440.396155]  [<ffffffff81a0fdd9>] schedule+0x29/0x70
[ 7440.396160]  [<ffffffff81a0fe80>] io_schedule+0x60/0x80
[ 7440.396166]  [<ffffffff81101eee>] sleep_on_page+0xe/0x20
[ 7440.396172]  [<ffffffff81a0e1ca>] __wait_on_bit_lock+0x5a/0xc0
[ 7440.396179]  [<ffffffff81101ed7>] __lock_page+0x67/0x70
[ 7440.396207]  [<ffffffff8106f750>] ? autoremove_wake_function+0x40/0x40
[ 7440.396215]  [<ffffffff811867e6>] ? bio_add_page+0x36/0x40
[ 7440.396222]  [<ffffffff8110b692>] set_page_dirty_lock+0x52/0x60
[ 7440.396228]  [<ffffffff81186021>] bio_set_pages_dirty+0x51/0x70
[ 7440.396235]  [<ffffffff8118c6b4>] do_blockdev_direct_IO+0xb24/0xeb0
[ 7440.396244]  [<ffffffff811e71a0>] ? ext3_get_blocks_handle+0xe00/0xe00
[ 7440.396251]  [<ffffffff8118ca95>] __blockdev_direct_IO+0x55/0x60
[ 7440.396258]  [<ffffffff811e71a0>] ? ext3_get_blocks_handle+0xe00/0xe00
[ 7440.396265]  [<ffffffff811e91c8>] ext3_direct_IO+0xf8/0x390
[ 7440.396271]  [<ffffffff811e71a0>] ? ext3_get_blocks_handle+0xe00/0xe00
[ 7440.396278]  [<ffffffff81004b60>] ? xen_mc_flush+0xb0/0x1b0
[ 7440.396285]  [<ffffffff81104027>] generic_file_aio_read+0x737/0x780
[ 7440.396293]  [<ffffffff813bedeb>] ? gnttab_map_refs+0x15b/0x1e0
[ 7440.396300]  [<ffffffff811038f0>] ? find_get_pages+0x150/0x150
[ 7440.396308]  [<ffffffff8119736c>] aio_rw_vect_retry+0x7c/0x1d0
[ 7440.396315]  [<ffffffff811972f0>] ? lookup_ioctx+0x90/0x90
[ 7440.396320]  [<ffffffff81198856>] aio_run_iocb+0x66/0x1a0
[ 7440.396326]  [<ffffffff811998b8>] do_io_submit+0x708/0xb90
[ 7440.396333]  [<ffffffff81199d50>] sys_io_submit+0x10/0x20
[ 7440.396340]  [<ffffffff81a18d69>] system_call_fastpath+0x16/0x1b



The explanation is in the comment within the code:

+        * We need to do this because the pages shared by the frontend
+        * (xen-blkfront) can be already locked (lock_page, called by
+        * do_read_cache_page); when the userspace backend tries to use them
+        * with direct_IO, mfn_to_pfn returns the pfn of the frontend, so
+        * do_blockdev_direct_IO is going to try to lock the same pages
+        * again resulting in a deadlock.


A simplified call graph looks like this:

pygrub                          QEMU
-----------------------------------------------
do_read_cache_page              io_submit
  |                              |
lock_page                       ext3_direct_IO
                                 |
                                bio_add_page
                                 |
                                lock_page



