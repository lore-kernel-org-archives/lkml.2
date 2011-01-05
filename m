Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1AERKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:10:52 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:33872 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751906Ab1AERKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:10:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Kz74hh4VM1kykaMNa.7frbuBX4OUurpOYEa5lXBmRVHMmZA
 C1zVUQfsAxUx43Etgbkr_XvWCLP9MU3DyQebLmdiMPvlda_x4yCFAXzXLs_N
 lrwBiUd8DZ2ZK6dcd0HT8toSLf551L8AG15sFzK5l10GK932iA4DqcHnaPW1
 RmzewFcHzeBNlhejs.4tu4jDUldqvLPPFJXxBH6pCyOVlKqO3wuswyqe8AL5
 0HYbS1YS7bsflENzSI_EYGGUZO6ynKF.udRJpUpgoPF_G0nDOLyvPcMTeSP0
 H7emdHY_xgXmc0ILDJlqNezCoN4BRiNlChCbLG2vesxPCFAk-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 5 Jan 2011 11:10:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Bart Van Assche <bart.vanassche@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <alpine.DEB.2.00.1101050943120.13032@router.home>
Message-ID: <alpine.DEB.2.00.1101051108520.14761@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this solution? In the common case of kernels without hotplug
support there will be no locking at all.


Subject: slub: Avoid use of slub_lock in show_slab_objects()

The purpose of the locking is to prevent removal and additions
of nodes when statistics are gathered for a slab cache. So we
need to avoid racing with memory hotplug functionality.

It is enough to take the memory hotplug locks there instead
of the slub_lock.


Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-01-05 09:55:34.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-01-05 09:56:27.000000000 -0600
@@ -3821,7 +3821,7 @@ static ssize_t show_slab_objects(struct
 		}
 	}

-	down_read(&slub_lock);
+	lock_memory_hotplug();
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -3862,7 +3862,7 @@ static ssize_t show_slab_objects(struct
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
 #endif
-	up_read(&slub_lock);
+	unlock_memory_hotplug();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }

