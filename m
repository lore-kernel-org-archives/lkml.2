Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2HGNUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:20:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21153 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2HGNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:20:23 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-ad-502116158148
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Aaro Koskinen'" <aaro.koskinen@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1344171029-24804-1-git-send-email-aaro.koskinen@iki.fi>
In-reply-to: <1344171029-24804-1-git-send-email-aaro.koskinen@iki.fi>
Subject: RE: [PATCH] ARM: dma-mapping: fix incorrect freeing of atomic
 allocations
Date: Tue, 07 Aug 2012 15:20:11 +0200
Organization: SPRC
Message-id: <011c01cd749f$620a80d0$261f8270$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zCOyZVeKQzQh9QU+tgwY7lzU7swBlg3nA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jAV1RMcUAg6m9BhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj8OX6gv3SFa1XFrI0MJ4V72Lk5JAQMJHYsH4CC4QtJnHh3no2
	EFtIYBGjxPdbHl2MXED2LCaJD213WUESbAKGEl1vu9hAEiICbYwSl69OZYTocJFY/G4rWBGn
	gKvE////geIcHMICIRL/NqaChFkEVCXuXD3KBBLmFxCSmDhLASTMC9T56sYnNghbUOLH5Htg
	9zALaEms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERASOJE1d/MEOUiEjcbXjOOoFRaBaSSbOQ
	TJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH8DPpHYyrGiwOMQpwMCrx
	8M5UUQgQYk0sK67MPcQowcGsJMJ7eCdQiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+J91d/IYH0
	xJLU7NTUgtQimCwTB6dUA+OkZ1euT12TPiuOXXtna2/VfqHdxi7Sa3svLI/6dIHr372O6Y9P
	bjqXkdKoGfpQ3yz91ttF4YsNL1nFLdKPTX77oXllt+22Wz4r6i/1d3CeuKkR9rFR1icsMbK5
	M9JdKEwpy/Zskr/DpTSBmvUvzqb/en9GNIQj4emysM3fY8pVrNUDD5ddPKLEUpyRaKjFXFSc
	CAD/U0AsXQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Sunday, August 05, 2012 2:50 PM Aaro Koskinen wrote:

> Commit e9da6e9905e639b0f842a244bc770b48ad0523e9 (ARM: dma-mapping:
> remove custom consistent dma region) changed the way atomic allocations
> are handled. However, arm_dma_free() was not modified accordingly, and
> as a result freeing of atomic allocations does not work correctly when
> CMA is disabled. Memory is leaked and following WARNINGs are seen:
> 
> [   57.698911] ------------[ cut here ]------------
> [   57.753518] WARNING: at arch/arm/mm/dma-mapping.c:263 arm_dma_free+0x88/0xe4()
> [   57.811473] trying to free invalid coherent area: e0848000
> [   57.867398] Modules linked in: sata_mv(-)
> [   57.921373] [<c000d270>] (unwind_backtrace+0x0/0xf0) from [<c0015430>]
> (warn_slowpath_common+0x50/0x68)
> [   58.033924] [<c0015430>] (warn_slowpath_common+0x50/0x68) from [<c00154dc>]
> (warn_slowpath_fmt+0x30/0x40)
> [   58.152024] [<c00154dc>] (warn_slowpath_fmt+0x30/0x40) from [<c000dc18>]
> (arm_dma_free+0x88/0xe4)
> [   58.219592] [<c000dc18>] (arm_dma_free+0x88/0xe4) from [<c008fa30>]
> (dma_pool_destroy+0x100/0x148)
> [   58.345526] [<c008fa30>] (dma_pool_destroy+0x100/0x148) from [<c019a64c>]
> (release_nodes+0x144/0x218)
> [   58.475782] [<c019a64c>] (release_nodes+0x144/0x218) from [<c0197e10>]
> (__device_release_driver+0x60/0xb8)
> [   58.614260] [<c0197e10>] (__device_release_driver+0x60/0xb8) from [<c0198608>]
> (driver_detach+0xd8/0xec)
> [   58.756527] [<c0198608>] (driver_detach+0xd8/0xec) from [<c0197c54>]
> (bus_remove_driver+0x7c/0xc4)
> [   58.901648] [<c0197c54>] (bus_remove_driver+0x7c/0xc4) from [<c004bfac>]
> (sys_delete_module+0x19c/0x220)
> [   59.051447] [<c004bfac>] (sys_delete_module+0x19c/0x220) from [<c0009140>]
> (ret_fast_syscall+0x0/0x2c)
> [   59.207996] ---[ end trace 0745420412c0325a ]---
> [   59.287110] ------------[ cut here ]------------
> [   59.366324] WARNING: at arch/arm/mm/dma-mapping.c:263 arm_dma_free+0x88/0xe4()
> [   59.450511] trying to free invalid coherent area: e0847000
> [   59.534357] Modules linked in: sata_mv(-)
> [   59.616785] [<c000d270>] (unwind_backtrace+0x0/0xf0) from [<c0015430>]
> (warn_slowpath_common+0x50/0x68)
> [   59.790030] [<c0015430>] (warn_slowpath_common+0x50/0x68) from [<c00154dc>]
> (warn_slowpath_fmt+0x30/0x40)
> [   59.972322] [<c00154dc>] (warn_slowpath_fmt+0x30/0x40) from [<c000dc18>]
> (arm_dma_free+0x88/0xe4)
> [   60.070701] [<c000dc18>] (arm_dma_free+0x88/0xe4) from [<c008fa30>]
> (dma_pool_destroy+0x100/0x148)
> [   60.256817] [<c008fa30>] (dma_pool_destroy+0x100/0x148) from [<c019a64c>]
> (release_nodes+0x144/0x218)
> [   60.445201] [<c019a64c>] (release_nodes+0x144/0x218) from [<c0197e10>]
> (__device_release_driver+0x60/0xb8)
> [   60.634148] [<c0197e10>] (__device_release_driver+0x60/0xb8) from [<c0198608>]
> (driver_detach+0xd8/0xec)
> [   60.823623] [<c0198608>] (driver_detach+0xd8/0xec) from [<c0197c54>]
> (bus_remove_driver+0x7c/0xc4)
> [   61.013268] [<c0197c54>] (bus_remove_driver+0x7c/0xc4) from [<c004bfac>]
> (sys_delete_module+0x19c/0x220)
> [   61.203472] [<c004bfac>] (sys_delete_module+0x19c/0x220) from [<c0009140>]
> (ret_fast_syscall+0x0/0x2c)
> [   61.393390] ---[ end trace 0745420412c0325b ]---
> 
> The patch fixes this.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks for spotting this issue. I've applied it to my fixes branch.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


