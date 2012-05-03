Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2ECOYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:24:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53806 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab2ECOYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:24:00 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCHv2 00/16] [FS, MM, block, MMC]: eMMC High Priority Interrupt Feature
Date: Thu, 3 May 2012 19:52:59 +0530
Message-ID: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
	http://www.jedec.org/sites/default/files/Victor_Tsai.pdf

Acknowledgements:-	
	In no particular order, thanks to Arnd Bergmann and  Saugata Das
from Linaro, Ilan Smith and Alex Lemberg from Sandisk, Luca Porzio from Micron
Technologies, Yejin Moon, Jae Hoon Chung from Samsung and others.

----
v1 -> v2:-
	* Convert threshold for hpi usage to a tuning parameter (sysfs)
	* Add Documentation/ABI for all sysfs entries
	* Add implementation of abort for OMAP controller
	* Rebased to 3.4-rc4 + mmc-next

	This patch series depends on a few other related cleanups
in MMC driver. All the patches and the dependent series can be
pulled from 
	git://github.com/svenkatr/linux.git my/mmc/3.4/foreground-hpiv2

----------------------------------------------------------------
Ilan Smith (3):
      FS: Added demand paging markers to filesystem
      MM: Added page swapping markers to memory management
      block: treat DMPG and SWAPIN requests as special

Venkatraman S (13):
      block: add queue attributes to manage dpmg and swapin requests
      block: add sysfs attributes for runtime control of dpmg and swapin
      block: Documentation: add sysfs ABI for expedite_dmpg and expedite_swapin
      mmc: core: helper function for finding preemptible command
      mmc: core: add preemptibility tracking fields to mmc command
      mmc: core: Add MMC abort interface
      mmc: block: Detect HPI support in card and host controller
      mmc: core: Implement foreground request preemption procedure
      mmc: sysfs: Add sysfs entry for tuning preempt_time_threshold
      mmc: Documentation: Add sysfs ABI for hpi_time_threshold
      mmc: block: Implement HPI invocation and handling logic.
      mmc: Update preempted request with CORRECTLY_PRG_SECTORS_NUM info
      mmc: omap_hsmmc: Implement abort_req host_ops

 Documentation/ABI/testing/sysfs-block       |   12 ++
 Documentation/ABI/testing/sysfs-devices-mmc |   12 ++
 block/blk-core.c                            |   18 +++
 block/blk-sysfs.c                           |   16 +++
 block/elevator.c                            |   14 ++-
 drivers/mmc/card/block.c                    |  143 ++++++++++++++++++++--
 drivers/mmc/card/queue.h                    |    1 +
 drivers/mmc/core/core.c                     |   67 ++++++++++
 drivers/mmc/core/mmc.c                      |   25 ++++
 drivers/mmc/host/omap_hsmmc.c               |   55 ++++++++-
 fs/mpage.c                                  |    2 +
 include/linux/bio.h                         |    8 ++
 include/linux/blk_types.h                   |    4 +
 include/linux/blkdev.h                      |    8 ++
 include/linux/mmc/card.h                    |    1 +
 include/linux/mmc/core.h                    |   19 +++
 include/linux/mmc/host.h                    |    1 +
 include/linux/mmc/mmc.h                     |    4 +
 mm/page_io.c                                |    3 +-
 19 files changed, 395 insertions(+), 18 deletions(-)

-- 
1.7.10.rc2

