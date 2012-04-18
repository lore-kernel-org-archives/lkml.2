Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab2DRGZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:25:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56851 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2DRGZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:25:54 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 00/11] [FS, MM, block, MMC]: eMMC High Priority Interrupt Feature
Date: Wed, 18 Apr 2012 11:55:21 +0530
Message-ID: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is still work in progress. Posting for early review and suggestions)

Standard eMMC (Embedded MultiMedia Card) specification expects to execute
one request at a time. If some requests are more important than others, they
can't be aborted while the flash procedure is in progress.

New versions of the eMMC standard (4.41 and above) specfies a feature 
called High Priority Interrupt (HPI). This enables an ongoing transaction
to be aborted using a special command (HPI command) so that the card is ready
to receive new commands immediately. Then the new request can be submitted
to the card, and optionally the interrupted command can be resumed again.

Some restrictions exist on when and how the command can be used. For example,
only write and write-like commands (ERASE) can be preempted, and the urgent
request must be a read.

In order to support this in software,
a) At the top level, some policy decisions have to be made on what is
worth preempting for.
	This implementation uses the demand paging requests and swap
read requests as potential reads worth preempting an ongoing long write.
	This is expected to provide improved responsiveness for smarphones
with multitasking capabilities - example would be launch a email application
while a video capture session (which causes long writes) is ongoing.
b) At the block handler, the higher priority request should be queued
  ahead of the pending requests in the elevator
c) At the MMC block and core level, transactions have to executed to 
enforce the rules of the MMC spec and make a reasonable tradeoff if the
ongoing command is really worth preempting. (For example, is it too close
to completing already ?).
	The current implementation uses a fixed time logic. If 10ms has
already elapsed since the first request was submitted, then a new high
priority request would not cause a HPI, as it is expected that the first
request would finish soon. Further work is needed to dynamically tune
this value (maybe through sysfs) or automatically determine based on
average write times of previous requests.
d) At the lowest level (MMC host controllers), support interface to 
provide a transition path for ongoing transactions to be aborted and the
controller to be ready to receive next command.

	More information about this feature can be found at
Jedec Specification:-
	http://www.jedec.org/standards-documents/docs/jesd84-a441
Presentation on eMMC4.41 features:-
	http://www.jedec.org/sites/.default/files/Victor_Tsai.pdf

Still TODO:-
	* Provide sysfs entry for tuning the threshold time for preemption
	* Implement resuming of the preempted request by checking
	  CORRECTLY_PROGRAMMED_SECTORS_NUM field.
	* Provide implementation of abort_req for omap_hsmmc_driver
		(This is almost done, needs a few tests)

Acknowledgements:-	
	In no particular order, thanks to Arnd Bergmann and  Saugata Das
from Linaro, Ilan Smith and Alex Lemberg from Sandisk, Luca Porzio from Micron
devices, Yejin Moon, Jae Hoon Chung from Samsung and others.

----
	This patch series depends on a few other related cleanups
in MMC driver. All the patches and the dependent series can be
pulled from 
	git://github.com/svenkatr/linux.git my/mmc/3.4/foreground-hpiv1

Ilan Smith (3):
  fs: Add demand paging markers to filesystem
  mm: Add page swapping markers to memory management
  block: Expedite DMPG and SWAPIN requests ahead of the queue

Venkatraman S (8):
  block: Add queue attributes to manage dpmg and swapin requests
  mmc: Add BKOPS field offsets
  mmc: core: Helper function for finding preemptible command
  mmc: core: add preemptibility tracking fields to mmc command
  mmc: core: Add MMC abort interface
  mmc: block: Detect HPI support in card and host controller
  mmc: core: Utility function for mmc preemption sequence
  mmc: block: Implement HPI invocation and handling for foreground
    requests

 block/blk-core.c          |   18 ++++++
 block/blk-sysfs.c         |   16 ++++++
 drivers/mmc/card/block.c  |  138 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/mmc/card/queue.h  |    1 +
 drivers/mmc/core/core.c   |   28 +++++++++
 fs/mpage.c                |    2 +
 include/linux/bio.h       |    8 +++
 include/linux/blk_types.h |    4 ++
 include/linux/blkdev.h    |    8 +++
 include/linux/mmc/core.h  |   19 +++++++
 include/linux/mmc/host.h  |    1 +
 include/linux/mmc/mmc.h   |    2 +
 mm/page_io.c              |    3 +-
 13 files changed, 233 insertions(+), 15 deletions(-)

-- 
1.7.10.rc2

