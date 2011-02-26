Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab1BZAXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:23:36 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57713 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab1BZAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:23:34 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 0/8] fsldma: lockup fixes
Date: Fri, 25 Feb 2011 16:23:17 -0800
Message-Id: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Fri, 25 Feb 2011 16:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've been chasing random infrequent controller lockups in the fsldma driver
for a long time. I finally managed to find the problem and fix it. I'm not
quite sure about the exact sequence of events which causes the race
condition, but it is related to using the hardware registers to track the
controller state. See the patch changelogs for more detail.

The problems were quickly found by turning on DMAPOOL_DEBUG inside
mm/dmapool.c. This poisons memory allocated with the dmapool API.

With dmapool poisoning turned on, the dmatest driver would start producing
failures within a few seconds. After this patchset has been applied, I have
run several iterations of the 10 threads per channel, 100000 iterations per
thread test without any problems.

I have made some changes which effect the 85xx/86xx part. I believe that
the changes only effect features which have been unused since the rewrite
in Jan 2010. It would be very good to get a test report from an 85xx/86xx
user.

While making the previous changes, I noticed that the fsldma driver does
not respect the automatic DMA unmapping of src and dst buffers. I have
added support for this feature. This also required a fix to dmatest, which
was sending incorrect flags.

The "support async_tx dependencies" patch could be split apart from the
automatic unmapping patch if it is desirable. They both touch the same
piece of code, so I thought it was ok to combine them. Let me know.

I would really like to see this go into 2.6.39. I think we can get it
reviewed before then. :)

Ira W. Snyder (8):
  fsldma: move related helper functions near each other
  fsldma: use channel name in printk output
  fsldma: improve link descriptor debugging
  fsldma: minor codingstyle and consistency fixes
  fsldma: fix controller lockups
  fsldma: support async_tx dependencies and automatic unmapping
  dmatest: fix automatic buffer unmap type
  fsldma: reduce locking during descriptor cleanup

 drivers/dma/dmatest.c |    7 +-
 drivers/dma/fsldma.c  |  485 +++++++++++++++++++++++++-----------------------
 drivers/dma/fsldma.h  |    6 +-
 3 files changed, 263 insertions(+), 235 deletions(-)

-- 
1.7.3.4

