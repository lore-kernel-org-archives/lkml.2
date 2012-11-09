Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2KIOzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:55:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24520 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2KIOzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:55:43 -0500
Date: Fri, 9 Nov 2012 09:55:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.8
Message-ID: <20121109145529.GB23023@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8

which has a new feature of the blk[back|front] driver - it is called 'feature-persistent'.
Roger and Oliver patch says:
"  This patch implements persistent grants for the xen-blk{front,back}
    mechanism. The effect of this change is to reduce the number of unmap
    operations performed, since they cause a (costly) TLB shootdown. This
    allows the I/O performance to scale better when a large number of VMs
    are performing I/O.
    
    Previously, the blkfront driver was supplied a bvec[] from the request
    queue. This was granted to dom0; dom0 performed the I/O and wrote
    directly into the grant-mapped memory and unmapped it; blkfront then
    removed foreign access for that grant. The cost of unmapping scales
    badly with the number of CPUs in Dom0. An experiment showed that when
    Dom0 has 24 VCPUs, and guests are performing parallel I/O to a
    ramdisk, the IPIs from performing unmap's is a bottleneck at 5 guests
    (at which point 650,000 IOPS are being performed in total). If more
    than 5 guests are used, the performance declines. By 10 guests, only
    400,000 IOPS are being performed.
    
    This patch improves performance by only unmapping when the connection
    between blkfront and back is broken.
"

Note: You might get a conflict in the common.h file. It should
be fairly easy to fix it - it should end up looking as this:

160         /* Cached size parameter. */
161         sector_t                size;
162         unsigned int            flush_support:1;
163         unsigned int            discard_secure:1;
164         unsigned int            feature_gnt_persistent:1;
165         unsigned int            overflow_max_grants:1;
166 };

Thanks!

 drivers/block/xen-blkback/blkback.c |  295 ++++++++++++++++++++++++++++++++---
 drivers/block/xen-blkback/common.h  |   17 ++
 drivers/block/xen-blkback/xenbus.c  |   23 +++-
 drivers/block/xen-blkfront.c        |  198 ++++++++++++++++++++----
 4 files changed, 478 insertions(+), 55 deletions(-)

Roger Pau Monne (2):
      xen/blkback: Persistent grant maps for xen blk drivers
      xen/blkback: persistent-grants fixes

