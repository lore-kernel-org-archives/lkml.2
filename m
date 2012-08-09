Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2HIRDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:03:14 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48209 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2HIRDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:03:11 -0400
Date: Thu, 9 Aug 2012 10:03:07 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: qiang.liu@freescale.com
Cc: linux-crypto@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, herbert@gondor.hengli.com.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, dan.j.williams@gmail.com
Subject: Re: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
Message-ID: <20120809170307.GG14264@ovro.caltech.edu>
References: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Thu, 09 Aug 2012 10:03:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:19:35PM +0800, qiang.liu@freescale.com wrote:
> Hi all,
> 
> The following 8 patches enabling fsl-dma and talitos offload raid
> operations for improving raid performance and balancing CPU load.
> 
> These patches include talitos, fsl-dma and carma module (caram uses
> some features of fsl-dma).
> 
> Write performance will be improved by 25-30% tested by iozone.
> Write performance is improved about 2% after using spin_lock_bh replace
> spin_lock_irqsave.
> CPU load will be reduced by 8%.
> 
> "fwiw, I gave v5 a test-drive, setting up a RAID5 array on ramdisks
> [1], and this patchseries, along with FSL_DMA && NET_DMA set seems
> to be holding water, so this series gets my:"
> 
> Tested-by: Kim Phillips <kim.phillips@freescale.com>
> 

The fsldma parts of the series all look great to me.

Thanks,
Ira

> [1] mdadm --create --verbose --force /dev/md0 --level=raid5 --raid-devices=4 \
> 	/dev/ram[0123]
> 
> Changes in v7:
> 	- add test result which is provided by Kim Phillips;
> 	- correct one coding style issue in patch 5/8;
> 	- add comments by Arnd Bergmann in patch 6/8;
> 
> Changes in v6:
> 	- swap the order of original patch 3/6 and 4/6;
> 	- merge Ira's patch to reduce the size of original patch;
> 	- merge Ira's patch of carma in 8/8;
> 	- update documents and descriptions according to Ira's advice;
> 
> Changes in v5:
> 	- add detail description in patch 3/6 about the process of completed
> 	descriptor, the process is in align with fsl-dma Reference Manual,
> 	illustrate the potential risk and how to reproduce it;
> 	- drop the patch 7/7 in v4 according to Timur's comments;
> 
> Changes in v4:
> 	- fix an error in talitos when dest addr is same with src addr, dest
> 	should be freed only one time if src is same with dest addr;
> 	- correct coding style in fsl-dma according to Ira's comments;
> 	- fix a race condition in fsl-dma fsl_tx_status(), remove the interface
> 	which is used to free descriptors in queue ld_completed, this interface
> 	has been included in fsldma_cleanup_descriptor(), in v3, there is one
> 	place missed spin_lock protect;
> 	- split the original patch 3/4 up to 2 patches 3/7 and 4/7 according to
> 	Li Yang's comments;
> 	- fix a warning of unitialized cookie;
> 	- add memory copy self test in fsl-dma;
> 	- add more detail description about use spin_lock_bh() to instead of
> 	spin_lock_irqsave() according to Timur's comments.
> 
> Changes in v3:
> 	- change release process of fsl-dma descriptor for resolve the
> 	potential race condition;
> 	- add test result when use spin_lock_bh replace spin_lock_irqsave;
> 	- modify the benchmark results according to the latest patch.
> 
> Changes in v2:
> 	- rebase onto cryptodev tree;
> 	- split the patch 3/4 up to 3 independent patches;
> 	- remove the patch 4/4, the fix is not for cryptodev tree;
> 
> Qiang Liu (8):
>       Talitos: Support for async_tx XOR offload
>       fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
>       fsl-dma: add fsl_dma_free_descriptor() to reduce code duplication
>       fsl-dma: move functions to avoid forward declarations
>       fsl-dma: change release process of dma descriptor for supporting async_tx
>       fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
>       fsl-dma: fix a warning of unitialized cookie
>       carma: remove unnecessary DMA_INTERRUPT capability
> 
>  drivers/crypto/Kconfig                  |    9 +
>  drivers/crypto/talitos.c                |  413 ++++++++++++++++++++++++++
>  drivers/crypto/talitos.h                |   53 ++++
>  drivers/dma/fsldma.c                    |  488 +++++++++++++++++--------------
>  drivers/dma/fsldma.h                    |   17 +-
>  drivers/misc/carma/carma-fpga-program.c |    1 -
>  drivers/misc/carma/carma-fpga.c         |    2 +-
>  7 files changed, 761 insertions(+), 222 deletions(-)
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
