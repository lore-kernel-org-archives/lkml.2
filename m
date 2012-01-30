Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2A3WkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:40:24 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41538 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2A3Wjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:39:32 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com, sjenning@linux.vnet.ibm.com,
        chris.mason@oracle.com, dan.magenheimer@oracle.com
Subject: [PATCH V4 0/6] staging: ramster: multi-machine memory capacity management
Date: Mon, 30 Jan 2012 14:39:18 -0800
Message-Id: <1327963158-15860-1-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F271C19.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[And apologies again.  This time it appears to be _really_ fixed. --djm]

[Apologies if you receive this patch sequence as a duplicate from last week.
 Our mail server was having problems and I know some recipients didn't
 receive it. --djm]

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

A git branch containing these patches built on linux-3.2 can be found at:
git://oss.oracle.com/git/djm/tmem.git #ramster-v4
Note that that tree also includes frontswap-v11 and "WasActive" patches

A HOW-TO is available at:
http://oss.oracle.com/projects/tmem/dist/files/RAMster/HOWTO-v4-120126

v3->v4: rebase to 3.2 (including updates in zcache)
v3->v4: fix a couple of bad memory leaks to get cleancache fully working
v3->v4: fix preemption calls to remove dependency on CONFIG_PREEMPT_NONE
v3->v4: various cleanup
v2->v3: documentation and commit message changes required [gregkh]

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>


---

Diffstat:

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/ramster/Kconfig                    |   14 +
 drivers/staging/ramster/Makefile                   |    2 +
 drivers/staging/ramster/TODO                       |    9 +
 drivers/staging/ramster/cluster/Makefile           |    5 +
 drivers/staging/ramster/cluster/heartbeat.c        | 2687 ++++++++++++++++
 drivers/staging/ramster/cluster/heartbeat.h        |   92 +
 drivers/staging/ramster/cluster/masklog.c          |  155 +
 drivers/staging/ramster/cluster/masklog.h          |  219 ++
 drivers/staging/ramster/cluster/netdebug.c         |  579 ++++
 drivers/staging/ramster/cluster/nodemanager.c      |  989 ++++++
 drivers/staging/ramster/cluster/nodemanager.h      |   88 +
 drivers/staging/ramster/cluster/ocfs2_heartbeat.h  |   38 +
 .../staging/ramster/cluster/ocfs2_nodemanager.h    |   45 +
 drivers/staging/ramster/cluster/quorum.c           |  331 ++
 drivers/staging/ramster/cluster/quorum.h           |   36 +
 drivers/staging/ramster/cluster/sys.c              |   82 +
 drivers/staging/ramster/cluster/sys.h              |   33 +
 drivers/staging/ramster/cluster/tcp.c              | 2262 ++++++++++++++
 drivers/staging/ramster/cluster/tcp.h              |  160 +
 drivers/staging/ramster/cluster/tcp_internal.h     |  249 ++
 drivers/staging/ramster/cluster/ver.c              |   42 +
 drivers/staging/ramster/cluster/ver.h              |   31 +
 drivers/staging/ramster/ramster.h                  |  117 +
 drivers/staging/ramster/ramster_o2net.c            |  402 +++
 drivers/staging/ramster/tmem.c                     |  851 +++++
 drivers/staging/ramster/tmem.h                     |  244 ++
 drivers/staging/ramster/zcache-main.c              | 3264 ++++++++++++++++++++
 drivers/staging/ramster/zcache.h                   |   22 +
 30 files changed, 13051 insertions(+), 0 deletions(-)
