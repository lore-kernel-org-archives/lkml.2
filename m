Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1AJQPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:15:21 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:42371 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751193Ab1AJQPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:15:19 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xnSSCpUVM1mTyR5mYqZIrBf8IQmSA195vIV9htWq_fYu7mv
 K4JXF2NG0tiaqS8dJw314SON6uoPVG2_vHw9uWjV94V5boe9t8SbOf1014ik
 Mq9_3ajkN8f0eq4A5FMviys.ND1lHJIGB8_dadxxllZoohlcpIg_OgivjogA
 VyoXc6bQY1K1p50RmRllRcdiKG8ovrrzhorjJ0n68iXWzyCbwoVMZUat69M9
 CW5KM00hKvBgwqQmE0paWe.n1_vn2nXTKT2J9RqX_lJkEYGXmjiLCZX4Mp0p
 u7VkrThJx3E.oqo7IYvWrzShPM3MYZu95eEahoJqaUXzdoCc-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 10 Jan 2011 10:15:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Bart Van Assche <bvanassche@acm.org>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <1294475323.5248.74.camel@jaguar>
Message-ID: <alpine.DEB.2.00.1101101014470.12243@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>  <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>  <alpine.DEB.2.00.1101050943120.13032@router.home>  <alpine.DEB.2.00.1101051108520.14761@router.home> 
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>  <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>  <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>  <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
  <alpine.DEB.2.00.1101061107500.8655@router.home>  <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.DEB.2.00.1101070922100.3014@router.home>  <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>  <AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com>
 <1294475323.5248.74.camel@jaguar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New patch that just covers the slub changes.

Subject: slub: Avoid use of slub_lock in show_slab_objects()

The purpose of the locking is to prevent removal and additions
of nodes when statistics are gathered for a slab cache. So we
need to avoid racing with memory hotplug functionality.

It is enough to take the memory hotplug locks there instead
of the slub_lock.

online_pages() currently does not acquire the memory_hotplug
lock. Another patch will be submitted by the memory hotplug
authors to take the memory hotplug lock and describe the
uses of the memory hotplug lock to protect against
adding and removal of nodes from non hotplug data structures.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/memory_hotplug.c |   17 +++++++++++------
 mm/slub.c           |    4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-01-10 09:02:08.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-01-10 10:10:46.000000000 -0600
@@ -3781,7 +3781,7 @@ static ssize_t show_slab_objects(struct
 		}
 	}

-	down_read(&slub_lock);
+	lock_memory_hotplug();
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -3822,7 +3822,7 @@ static ssize_t show_slab_objects(struct
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
 #endif
-	up_read(&slub_lock);
+	unlock_memory_hotplug();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }

