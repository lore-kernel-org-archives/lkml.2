Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1AGPWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:22:51 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43355 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753861Ab1AGPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:22:50 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: c8L6L64VM1lD.fl.6zVhW5E6DjCS64O.VtgRge1F57B6Zfd
 FAjrEwMtT9OE88v1AhXfD4Ep0_OU.1pffStLVV9Bn09Z9_gYAW7cDnACDsJs
 k1ic5sY9Foqw0zAa1toT8lgP0I2VLwmPSHjS54ns28gprA.IGExYpO3JlFhC
 .qBZ.gSgc0RBL9pU_sbcsxV2ztglw811RXZQkKSg5qfISMCSzpTBJa1Pl953
 KnaqS7TrZUFXWrKz9BE9BH4RwG.x0ZKYDYvPBxTvgTyMvv0LNTbj0AvzwfiR
 GLCvuhWYFultZ6te3gj4Vf4o3Hrc3IAjo2XawNiFpdzIpFDM-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 7 Jan 2011 09:22:46 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1101070922100.3014@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com> <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101061107500.8655@router.home> <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, KAMEZAWA Hiroyuki wrote:

> But, nice catch. I think MEM_GOING_ONLINE, MEM_ONLINE should be done under
> lock_memory_hotplug. So, could you update your patch and modify online_pages() ?
>
> IIUC, online_pages() is an user interface function and there will be no downside
> to insert lock there. online_pages() should be serialized.

Subject: slub: Avoid use of slub_lock in show_slab_objects()

The purpose of the locking is to prevent removal and additions
of nodes when statistics are gathered for a slab cache. So we
need to avoid racing with memory hotplug functionality.

It is enough to take the memory hotplug locks there instead
of the slub_lock.

online_pages() does not acquire the memory_hotplug lock. So
add the missing locking there.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/memory_hotplug.c |   17 +++++++++++------
 mm/slub.c           |    4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-01-07 09:17:35.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-01-07 09:17:38.000000000 -0600
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
Index: linux-2.6/mm/memory_hotplug.c
===================================================================
--- linux-2.6.orig/mm/memory_hotplug.c	2011-01-07 09:17:59.000000000 -0600
+++ linux-2.6/mm/memory_hotplug.c	2011-01-07 09:20:07.000000000 -0600
@@ -415,12 +415,12 @@ int online_pages(unsigned long pfn, unsi
 	if (node_present_pages(nid) == 0)
 		arg.status_change_nid = nid;

+	lock_memory_hotplug();
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
-	if (ret) {
-		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		return ret;
-	}
+	if (ret)
+		goto cancel;
+
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
 	 * The section can't be removed here because of the
@@ -442,8 +442,7 @@ int online_pages(unsigned long pfn, unsi
 		mutex_unlock(&zonelists_mutex);
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
 			nr_pages, pfn);
-		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		return ret;
+		goto cancel;
 	}

 	zone->present_pages += onlined_pages;
@@ -468,7 +467,13 @@ int online_pages(unsigned long pfn, unsi
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);

+	unlock_memory_hotplug();
 	return 0;
+
+cancel:
+	memory_notify(MEM_CANCEL_ONLINE, &arg);
+	unlock_memory_hotplug();
+	return ret;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */

