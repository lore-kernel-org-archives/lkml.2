Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab2FBLgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 07:36:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36258 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab2FBLgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 07:36:38 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <02bf01cd3efd$c4980ec0$4dc82c40$%szyprowski@samsung.com>
References: <20120531004446.GA401@localhost.localdomain>
	<02bf01cd3efd$c4980ec0$4dc82c40$%szyprowski@samsung.com>
Date: Sat, 2 Jun 2012 07:36:36 -0400
X-Google-Sender-Auth: qGntV3g-ApQbLTznK33uAmFprGQ
Message-ID: <CAPbh3ru1U9BgBfFEnJWHTYwjrLCANVrPXD8uxbBoq49LqDi8gA@mail.gmail.com>
Subject: Re: Bug in BUG: Bad page state in process work_for_cpu pfn:cf800
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, kyungmin.park@samsung.com,
        arnd@arndb.de, tony.luck@intel.com, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 3:19 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hi Konrad,
>
> On Thursday, May 31, 2012 2:45 AM Konrad Rzeszutek Wilk wrote:
>
>> About two-three days ago I started getting this on one of the AMD
>> machines I run nighly bootup test (full bootup log attached):
>> [Note: This is baremetal]
>>
>> ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
>> BUG: Bad page state in process work_for_cpu  pfn:cf800
>> page:ffffea0002d64000 count:-1 mapcount:0 ing:          (null) index:0x0
>> page flags: 0x100000000000000()
>> Modules linked in:
>> Pid: 1207, comm: work_for_cpu Not tainted 3.4.0upstream-09208-gaf56e0a #1
>> Call Trace:
>>  [<ffffffff81103eb7>] ? dump_page+0x97/0xf0
>>  [<ffffffff811050bd>] bad_page+0xad/0x100
>>  [<ffffffff811067a2>] get_page_from_freelist+0x712/0x850
>>  [<ffffffff812916d8>] ? __const_udelay+0x28/0x30
>>  [<ffffffff81107a82>] __alloc_pages_nodemask+0x162/0x900
>>  [<ffffffff810a2975>] ? dequeue_task_fair+0xa5/0x330
>>  [<ffffffff810367e2>] ? __switch_to+0x152/0x440
>>  [<ffffffff8107ee37>] ? lock_timer_base+0x37/0x70
>>  [<ffffffff8103c7ff>] dma_generic_alloc_coherent+0x10f/0x170
>>  [<ffffffff81062e7e>] gart_alloc_coherent+0xee/0x120
>>  [<ffffffff81137542>] dma_pool_alloc+0x102/0x2e0
>>  [<ffffffff8109f240>] ? try_to_wake_up+0x310/0x310
>>  [<ffffffff813f3dc7>] ehci_qh_alloc+0x47/0xf0
>>  [<ffffffff813f81e7>] ehci_pci_setup+0x367/0xea0
>>  [<ffffffff81389213>] ? device_pm_init+0x43/0x80
>>  [<ffffffff813d3065>] ? usb_alloc_dev+0x2d5/0x330
>>  [<ffffffff81002030>] ? do_one_initcall+0x30/0x170
>>  [<ffffffff813db6a9>] usb_add_hcd+0x1e9/0x7a0
>>  [<ffffffff813ea0fa>] usb_hcd_pci_probe+0x1ba/0x3a0
>>  [<ffffffff81088890>] ? cwq_dec_nr_in_flight+0x90/0x90
>>  [<ffffffff812ad3f2>] local_pci_probe+0x12/0x20
>>  [<ffffffff810888a3>] do_work_for_cpu+0x13/0x30
>>  [<ffffffff810906e6>] kthread+0x96/0xa0
>>  [<ffffffff815b61e4>] kernel_thread_helper+0x4/0x10
>>  [<ffffffff81090650>] ? kthread_freezable_should_stop+0x70/0x70
>>  [<ffffffff815b61e0>] ? gs_change+0x13/0x13
>> Disabling lock debugging due to kernel taint
>> BUG: Bad page state in process work_for_cpu  pfn:cf801
>>
>> I haven't actually run a git bisection, but the last git commit
>> that does something in the gart code looks to be this one:
>>
>> commit baa676fcf8d555269bd0a5a2496782beee55824d
>> Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> Date:   Tue Mar 27 14:28:18 2012 +0200
>>
>>     X86 & IA64: adapt for dma_map_ops changes
>>
>> hence CC-ing on this e-email.
>
> I hardly see how this commit can cause such issue. It was a pure code refactoring (attributes
> parameter has been added to alloc/free functions) without any change in actual code flow. Maybe
> something has been changed in core mm code or elsewhere in the driver? 'Bad page state' sounds
> rather bad and might be cause by some trashing in completely unrelated code...

Doing a git bisection points it to this one:
is the first bad commit
commit 0a2b9a6ea93650b8a00f9fd5ee8fdd25671e2df6
Author: Marek Szyprowski <m.szyprowski@samsung.com>
Date:   Thu Dec 29 13:09:51 2011 +0100

    X86: integrate CMA with DMA-mapping subsystem

    This patch adds support for CMA to dma-mapping subsystem for x86
    architecture that uses common pci-dma/pci-nommu implementation. This
    allows to test CMA on KVM/QEMU and a lot of common x86 boxes.

    Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    CC: Michal Nazarewicz <mina86@mina86.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>

:040000 040000 be152c4e3a5641fbd6dfc2f8faf3e634f47bd94e
4e5424f0b11ff1fead974e6c4ea7341b046cc960 M      arch


[konrad@build linux]$ git bisect log
git bisect start
# good: [b5f4035adfffbcc6b478de5b8c44b618b3124aff] Merge tag
'stable/for-linus-3.5-rc0-tag' of
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect good b5f4035adfffbcc6b478de5b8c44b618b3124aff
# bad: [da89fb165e5e51a2ec1ff8a0ff6bc052d1068184] Merge tag
'tag-for-linus-3.5' of
git://git.linaro.org/people/sumitsemwal/linux-dma-buf
git bisect bad da89fb165e5e51a2ec1ff8a0ff6bc052d1068184
# good: [ece78b7df734726e790dcab207f463401ff80440] Merge branch
'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect good ece78b7df734726e790dcab207f463401ff80440
# good: [58823de9d2f1265030d0d06cb03cc2a551994398] Merge tag
'hda-switcheroo' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 58823de9d2f1265030d0d06cb03cc2a551994398
# bad: [0f51596bd39a5c928307ffcffc9ba07f90f42a8b] Merge branch
'for-next-arm-dma' into for-linus
git bisect bad 0f51596bd39a5c928307ffcffc9ba07f90f42a8b
# bad: [0a2b9a6ea93650b8a00f9fd5ee8fdd25671e2df6] X86: integrate CMA
with DMA-mapping subsystem
git bisect bad 0a2b9a6ea93650b8a00f9fd5ee8fdd25671e2df6
# good: [6d4a49160de2c684fb59fa627bce80e200224331] mm: page_alloc:
change fallbacks array handling
git bisect good 6d4a49160de2c684fb59fa627bce80e200224331
# good: [cfd3da1e49bb95c355c01c0f502d657deb3d34a4] mm: Serialize
access to min_free_kbytes
git bisect good cfd3da1e49bb95c355c01c0f502d657deb3d34a4
# good: [49f223a9cd96c7293d7258ff88c2bdf83065f69c] mm: trigger page
reclaim in alloc_contig_range() to stabilise watermarks
git bisect good 49f223a9cd96c7293d7258ff88c2bdf83065f69c
# good: [c64be2bb1c6eb43c838b2c6d57b074078be208dd] drivers: add
Contiguous Memory Allocator
git bisect good c64be2bb1c6eb43c838b2c6d57b074078be208dd

>
>> Was wondering if other people had seen something similar to this?
>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
>
>
>
