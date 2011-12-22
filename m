Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1LVPup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:50:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37284 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1LVPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:50:43 -0500
Date: Thu, 22 Dec 2011 07:50:30 -0800
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com, dan.magenheimer@oracle.com
Subject: [PATCH V2 0/6] drivers/staging: ramster: multi-machine memory
	capacity management
Message-ID: <20111222155029.GA21377@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EF351CB.00E3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V2 0/6] drivers/staging: ramster: multi-machine memory capacity management

HIGH LEVEL OVERVIEW

RAMster implements peer-to-peer transcendent memory, allowing a "cluster" of
kernels to dynamically pool their RAM so that a RAM-hungry workload on one
machine can temporarily and transparently utilize RAM on another machine which
is presumably idle or running a non-RAM-hungry workload.  Other than the
already-merged cleancache patchset and the not-yet-merged frontswap patchset,
no core kernel changes are currently required.

(Note that, unlike previous public descriptions of RAMster, this implementation
does NOT require synchronous "gets" or core networking changes.)

RAMster combines the clustering and messaging foundation of the ocfs2
filesystem implementation with the in-kernel compression implementation
of zcache, and adds code to glue them together.  When a page is "put"
to RAMster, it is compressed and stored locally.  Periodically, a thread
will "remotify" these pages by sending them via messages to a remote machine.
When the page is later needed as indicated by a page fault, a "get" is issued.
If the data is local, it is uncompressed and the fault is resolved.  If the
data is remote, a message is sent to fetch the data and the faulting thread
sleeps; when the data arrives, the thread awakens, the data is decompressed
and the fault is resolved.

The mechanism works today for a two-node cluster.  Some simple policy
is in place that will need to be refined over time.  Larger clusters
and fault-resistant protocols can also be added over time.

A git branch containing these patches can be found at:
git://oss.oracle.com/git/djm/tmem.git #ramster-v2
Note that that tree also includes frontswap-v11.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

---

Diffstat:
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/ramster/Kconfig                    |   14 +
 drivers/staging/ramster/Makefile                   |    2 +
 drivers/staging/ramster/cluster/Makefile           |    5 +
 drivers/staging/ramster/cluster/heartbeat.c        | 2636 ++++++++++++++++
 drivers/staging/ramster/cluster/heartbeat.h        |   92 +
 drivers/staging/ramster/cluster/masklog.c          |  155 +
 drivers/staging/ramster/cluster/masklog.h          |  219 ++
 drivers/staging/ramster/cluster/netdebug.c         |  543 ++++
 drivers/staging/ramster/cluster/nodemanager.c      |  989 ++++++
 drivers/staging/ramster/cluster/nodemanager.h      |   88 +
 drivers/staging/ramster/cluster/ocfs2_heartbeat.h  |   38 +
 .../staging/ramster/cluster/ocfs2_nodemanager.h    |   45 +
 drivers/staging/ramster/cluster/quorum.c           |  331 ++
 drivers/staging/ramster/cluster/quorum.h           |   36 +
 drivers/staging/ramster/cluster/sys.c              |   82 +
 drivers/staging/ramster/cluster/sys.h              |   33 +
 drivers/staging/ramster/cluster/tcp.c              | 2255 +++++++++++++
 drivers/staging/ramster/cluster/tcp.h              |  156 +
 drivers/staging/ramster/cluster/tcp_internal.h     |  249 ++
 drivers/staging/ramster/cluster/ver.c              |   42 +
 drivers/staging/ramster/cluster/ver.h              |   31 +
 drivers/staging/ramster/ramster.h                  |  117 +
 drivers/staging/ramster/ramster_o2net.c            |  419 +++
 drivers/staging/ramster/tmem.c                     |  853 +++++
 drivers/staging/ramster/tmem.h                     |  244 ++
 drivers/staging/ramster/zcache-main.c              | 3318 ++++++++++++++++++++
 drivers/staging/ramster/zcache.h                   |   22 +
 29 files changed, 13017 insertions(+), 0 deletions(-)
