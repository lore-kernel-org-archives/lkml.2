Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab0FEXOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:14:19 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:33449 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab0FEXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:14:17 -0400
Message-ID: <4C0ADA44.4020406@cesarb.net>
Date: Sat, 05 Jun 2010 20:14:12 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Avi Kivity <avi@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Hugh Dickins <hughd@google.com>
Subject: [PATCH v2 0/3] mm: Swap checksum
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for checksumming the swap pages written to disk, using the
same checksum as btrfs (crc32c). Since the contents of the swap do not
matter after a shutdown, the checksum is kept in memory only.

This protects against silent corruption of the swap caused by hardware
problems, the same way the btrfs checksum protects against silent
corruption of the filesystem. It is useful even with
CONFIG_BLK_DEV_INTEGRITY because it also protects against reads of stale
data.

The checksum is done in the swap layer (instead of in a separate block
device or in the block layer) to allow the checksums to be tracked
together with the rest of swap state (also allowing later for things
like Avi Kivity's suggestions of keeping the checksum in the pte when
possible and converting zeroed pages to a pte_none), to better allow for
different things to be done by the software suspend code (which writes
to the same place but has different needs), to simplify configuration
(no need to edit the fstab), and because it felt the most natural layer
to do it.

Note that this code does not currently checksum the software suspend
image. That will need to be done later.

Lightly tested on a x86 VM.

Changes since -v1:
   Rebase to 2.6.35-rc1 (code moved from swap.c to block_io.c)
   Use bio_data_dir() instead of acessing bi_rw directly
   Use __read_mostly for swapcsum_workqueue
   Include highmem.h instead of pagemap.h

Cesar Eduardo Barros (3):
       mm/swapfile.c: better messages for swap_info_get
       kernel/power/block_io.c: do not use end_swap_bio_read
       mm: Swap checksum

  include/linux/swap.h    |   31 ++++++-
  kernel/power/block_io.c |   22 +++++-
  mm/Kconfig              |   22 +++++
  mm/Makefile             |    1 +
  mm/page_io.c            |   92 +++++++++++++++++--
  mm/swapcsum.c           |   94 ++++++++++++++++++++
  mm/swapfile.c           |  187 +++++++++++++++++++++++++++++++++++++--
  7 files changed, 431 insertions(+), 18 deletions(-)
  create mode 100644 mm/swapcsum.c

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
