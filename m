Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2HAJLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:11:00 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:42551 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246Ab2HAJK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:10:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <herbert@gondor.hengli.com.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>
CC: <leoli@freescale.com>, <kim.phillips@freescale.com>
Subject: [PATCH v5 0/6] Raid: enable talitos xor offload for improving performance
Date: Wed, 1 Aug 2012 16:46:00 +0800
Message-ID: <1343810760-8035-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following 6 patches enabling fsl-dma and talitos offload raid
operations for improving raid performance and balancing CPU load.

Write performance will be improved by 25-30% tested by iozone.
Write performance is improved about 2% after using spin_lock_bh replace
spin_lock_irqsave.
CPU load will be reduced by 8%.

Changes in v5:
	- add detail description in patch 3/6 about the process of completed
	descriptor, the process is in align with fsl-dma Reference Manual,
	illustrate the potential risk and how to reproduce it;
	- drop the patch 7/7 in v4 according to Timur's comments;

Changes in v4:
	- fix an error in talitos when dest addr is same with src addr, dest
	should be freed only one time if src is same with dest addr;
	- correct coding style in fsl-dma according to Ira's comments;
	- fix a race condition in fsl-dma fsl_tx_status(), remove the interface
	which is used to free descriptors in queue ld_completed, this interface
	has been included in fsldma_cleanup_descriptor(), in v3, there is one
	place missed spin_lock protect;
	- split the original patch 3/4 up to 2 patches 3/7 and 4/7 according to
	Li Yang's comments;
	- fix a warning of unitialized cookie;
	- add memory copy self test in fsl-dma;
	- add more detail description about use spin_lock_bh() to instead of
	spin_lock_irqsave() according to Timur's comments.

Changes in v3:
	- change release process of fsl-dma descriptor for resolve the
	potential race condition;
	- add test result when use spin_lock_bh replace spin_lock_irqsave;
	- modify the benchmark results according to the latest patch.

Changes in v2:
	- rebase onto cryptodev tree;
	- split the patch 3/4 up to 3 independent patches;
	- remove the patch 4/4, the fix is not for cryptodev tree;

Qiang Liu (6):
      Talitos: Support for async_tx XOR offload
      fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
      fsl-dma: change release process of dma descriptor for supporting async_tx
      fsl-dma: move the function ahead of its invoke function
      fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
      fsl-dma: fix a warning of unitialized cookie

 drivers/crypto/Kconfig   |    9 +
 drivers/crypto/talitos.c |  413 ++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos.h |   53 ++++++
 drivers/dma/fsldma.c     |  467 ++++++++++++++++++++++++++--------------------
 drivers/dma/fsldma.h     |    1 +
 5 files changed, 739 insertions(+), 204 deletions(-)

