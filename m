Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab1EBDca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 23:32:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:7696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab1EBDcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 23:32:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,300,1301900400"; 
   d="scan'208";a="740965806"
Message-Id: <20110502031750.135798606@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 11:17:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/3] sync livelock fixes v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

changes from v1:
- retain tagged sync behavior for all WB_SYNC_ALL callers (Dave Chinner)
- rename wbc.for_sync to wbc.tagged_sync
- remove the changes to trace events

The below sync livelock test script is working fine after this patchset:

        sync time: 2
        Dirty:             26492 kB
        Writeback:         30260 kB
        NFS_Unstable:          0 kB
        WritebackTmp:          0 kB
        sync NOT livelocked

In particular patch 2 fixes the sync livelock problem introduced by patch
"writeback: try more writeback as long as something was written".

Thanks,
Fengguang
---

#!/bin/sh

umount /dev/sda7
# mkfs.xfs -f /dev/sda7
mkfs.ext4 /dev/sda7
mount /dev/sda7 /fs

echo $((50<<20)) > /proc/sys/vm/dirty_bytes

pid=
for i in `seq 10`
do     
        dd if=/dev/zero of=/fs/zero-$i bs=1M count=1000 &
        pid="$pid $!"
done

sleep 1

tic=$(date +'%s')
sync
tac=$(date +'%s')

echo
echo sync time: $((tac-tic))
egrep '(Dirty|Writeback|NFS_Unstable)' /proc/meminfo

pidof dd > /dev/null && { kill -9 $pid; echo sync NOT livelocked; }



