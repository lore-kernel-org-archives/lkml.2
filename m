Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab0IXXNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:13:54 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44952 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0IXXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:13:53 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH RFCv2 0/2] dma: add support for sg-to-sg transfers
Date: Fri, 24 Sep 2010 16:13:50 -0700
Message-Id: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 16:13:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for scatterlist to scatterlist transfers to the
generic DMAEngine API. I have hidden it behind a configuration option to
allow specific drivers that need this functionality to enable it.

This series is intended to lay the groundwork for further changes to the
series titled "CARMA Board Support". That series will be updated when I
have time and hardware to test with.

This series has not been runtime tested yet. I am posting it only to
gain comments before I spend the effort to update the driver that
depends on this.

To help reviewers, I'd like to comment on the architecture of
dma_async_memcpy_sg_to_sg(). It explicitly avoids using descriptor
chaining due to the way that feature interacts with the fsldma
controller's external start feature. To use the external start feature
properly, the in-memory descriptor chain must not be fragmented into
multiple smaller chains. This is what is achieved by submitting all
descriptors without using chaining.

An alternative implementation would create a device_prep_sg_to_sg()
function, and use that to allocate all descriptors in one shot. That
implementation would be safer against allocation failures than this one.

I would recommend against committing this until I've tested it on real
hardware.

Ira W. Snyder (2):
  dmaengine: add support for scatterlist to scatterlist transfers
  fsldma: use generic support for scatterlist to scatterlist transfers

 arch/powerpc/include/asm/fsldma.h |  115 ++------------------
 drivers/dma/Kconfig               |    4 +
 drivers/dma/dmaengine.c           |  119 ++++++++++++++++++++
 drivers/dma/fsldma.c              |  219 +++++++------------------------------
 include/linux/dmaengine.h         |   10 ++
 5 files changed, 181 insertions(+), 286 deletions(-)

