Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2F1Vut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:50:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab2F1Vup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:50:45 -0400
From: Rafael Aquini <aquini@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rafael Aquini <aquini@redhat.com>
Subject: [PATCH v2 0/4] make balloon pages movable by compaction
Date: Thu, 28 Jun 2012 18:49:38 -0300
Message-Id: <cover.1340916058.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset follows the main idea discussed at 2012 LSFMMS section:
"Ballooning for transparent huge pages" -- http://lwn.net/Articles/490114/

to introduce the required changes to the virtio_balloon driver, as well as
changes to the core compaction & migration bits, in order to allow
memory balloon pages become movable within a guest.

Rafael Aquini (4):
  mm: introduce compaction and migration for virtio ballooned pages
  virtio_balloon: handle concurrent accesses to virtio_balloon struct
    elements
  virtio_balloon: introduce migration primitives to balloon pages
  mm: add vm event counters for balloon pages compaction

 drivers/virtio/virtio_balloon.c |  142 +++++++++++++++++++++++++++++++++++----
 include/linux/mm.h              |   16 +++++
 include/linux/virtio_balloon.h  |    6 ++
 include/linux/vm_event_item.h   |    2 +
 mm/compaction.c                 |  111 ++++++++++++++++++++++++------
 mm/migrate.c                    |   32 ++++++++-
 mm/vmstat.c                     |    4 ++
 7 files changed, 280 insertions(+), 33 deletions(-)


V2: address Mel Gorman's review comments

TODO:
- check on naming chages suggested by Konrad (original series discussion)


Preliminary test results:
(2 VCPU 1024mB RAM KVM guest running 3.5.0_rc4+)

* 64mB balloon:
[root@localhost ~]# awk '/compact/ {print}' /proc/vmstat
compact_blocks_moved 0
compact_pages_moved 0
compact_pagemigrate_failed 0
compact_stall 0
compact_fail 0
compact_success 0
compact_balloon_migrated 0
compact_balloon_failed 0
compact_balloon_isolated 0
compact_balloon_freed 0
[root@localhost ~]#
[root@localhost ~]# for i in $(seq 1 4); do echo 1> /proc/sys/vm/compact_memory & done &>/dev/null
[1]   Done                    echo > /proc/sys/vm/compact_memory
[2]   Done                    echo > /proc/sys/vm/compact_memory
[3]-  Done                    echo > /proc/sys/vm/compact_memory
[4]+  Done                    echo > /proc/sys/vm/compact_memory
[root@localhost ~]#
[root@localhost ~]# awk '/compact/ {print}' /proc/vmstat
 compact_blocks_moved 2717
compact_pages_moved 46697
compact_pagemigrate_failed 75
compact_stall 0
compact_fail 0
compact_success 0
compact_balloon_migrated 16384
compact_balloon_failed 0
compact_balloon_isolated 16384
compact_balloon_freed 16384


* 128mB balloon:
[root@localhost ~]# awk '/compact/ {print}' /proc/vmstat
compact_blocks_moved 0
compact_pages_moved 0
compact_pagemigrate_failed 0
compact_stall 0
compact_fail 0
compact_success 0
compact_balloon_migrated 0
compact_balloon_failed 0
compact_balloon_isolated 0
compact_balloon_freed 0
[root@localhost ~]#
[root@localhost ~]# for i in $(seq 1 4); do echo 1> /proc/sys/vm/compact_memory & done &>/dev/null
[1]   Done                    echo > /proc/sys/vm/compact_memory
[2]   Done                    echo > /proc/sys/vm/compact_memory
[3]-  Done                    echo > /proc/sys/vm/compact_memory
[4]+  Done                    echo > /proc/sys/vm/compact_memory
[root@localhost ~]#
[root@localhost ~]# awk '/compact/ {print}' /proc/vmstat
compact_blocks_moved 2598
compact_pages_moved 47660
compact_pagemigrate_failed 103
compact_stall 0
compact_fail 0
compact_success 0
compact_balloon_migrated 26652
compact_balloon_failed 76
compact_balloon_isolated 26728
compact_balloon_freed 26652
-- 
1.7.10.2

