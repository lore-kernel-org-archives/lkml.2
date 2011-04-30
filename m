Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1D3WsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:48:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:5209 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810Ab1D3WsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:48:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,294,1301900400"; 
   d="scan'208";a="636288881"
Message-Id: <20110430223605.034517922@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 01 May 2011 06:36:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/3] sync livelock fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

I wrote a simple script to test sync livelock and this patchset is working as
expected:

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


