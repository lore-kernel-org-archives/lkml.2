Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1AKHuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 02:50:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53003 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1AKHuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 02:50:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 11 Jan 2011 16:44:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] one more lock on memory hotplug (Re: [PATCH] slub: Fix
 sysfs circular locking dependency
Message-Id: <20110111164401.3b1e5d8a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D2BFAA9.2050200@kernel.org>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101050943120.13032@router.home>
	<alpine.DEB.2.00.1101051108520.14761@router.home>
	<AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
	<AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
	<AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
	<alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101061107500.8655@router.home>
	<20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1101070922100.3014@router.home>
	<alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
	<AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com>
	<1294475323.5248.74.camel@jaguar>
	<alpine.DEB.2.00.1101101014470.12243@router.home>
	<alpine.DEB.2.00.1101101230190.11969@chino.kir.corp.google.com>
	<4D2BFAA9.2050200@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 08:37:29 +0200
Pekka Enberg <penberg@kernel.org> wrote:

> On 1/10/11 10:30 PM, David Rientjes wrote:
> > On Mon, 10 Jan 2011, Christoph Lameter wrote:
> >
> >> New patch that just covers the slub changes.
> >>
> >> Subject: slub: Avoid use of slub_lock in show_slab_objects()
> >>
> >> The purpose of the locking is to prevent removal and additions
> >> of nodes when statistics are gathered for a slab cache. So we
> >> need to avoid racing with memory hotplug functionality.
> >>
> >> It is enough to take the memory hotplug locks there instead
> >> of the slub_lock.
> >>
> >> online_pages() currently does not acquire the memory_hotplug
> >> lock. Another patch will be submitted by the memory hotplug
> >> authors to take the memory hotplug lock and describe the
> >> uses of the memory hotplug lock to protect against
> >> adding and removal of nodes from non hotplug data structures.
> >>
> >> Signed-off-by: Christoph Lameter<cl@linux.com>
> > Acked-by: David Rientjes<rientjes@google.com>
> 
> Is this safe to be applied without the other hotplug parts?
> 
> 

How about this ? 
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, memory_hotplug_(un)lock() is used for add/remove/offline pages
for avoiding races with hibernation. But this should be held in
online_pages(), too. It seems asymmetric.

There are cases where one has to avoid a race with memory hotplug
notifier and his own local code, and hotplug v.s. hotplug.
This will add a generic solution for avoiding races. In other view,
having lock here has no big impacts. online pages is tend to be
done by udev script at el against each memory section one by one.

Then, it's better to have lock here, too.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory_hotplug.c            |    4 ++++
 2 files changed, 10 insertions(+)

Index: linux-2.6.37.org/include/linux/memory_hotplug.h
===================================================================
--- linux-2.6.37.org.orig/include/linux/memory_hotplug.h
+++ linux-2.6.37.org/include/linux/memory_hotplug.h
@@ -161,6 +161,12 @@ extern void register_page_bootmem_info_n
 extern void put_page_bootmem(struct page *page);
 #endif
 
+/*
+ * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug
+ * notifier will be called under this. 2) offline/online/add/remove memory
+ * will not run simultaneously.
+ */
+
 void lock_memory_hotplug(void);
 void unlock_memory_hotplug(void);
 
Index: linux-2.6.37.org/mm/memory_hotplug.c
===================================================================
--- linux-2.6.37.org.orig/mm/memory_hotplug.c
+++ linux-2.6.37.org/mm/memory_hotplug.c
@@ -407,6 +407,7 @@ int online_pages(unsigned long pfn, unsi
 	int ret;
 	struct memory_notify arg;
 
+	lock_memory_hotplug();
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
 	arg.status_change_nid = -1;
@@ -419,6 +420,7 @@ int online_pages(unsigned long pfn, unsi
 	ret = notifier_to_errno(ret);
 	if (ret) {
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
+		unlock_memory_hotplug();
 		return ret;
 	}
 	/*
@@ -443,6 +445,7 @@ int online_pages(unsigned long pfn, unsi
 		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
 			nr_pages, pfn);
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
+		unlock_memory_hotplug();
 		return ret;
 	}
 
@@ -467,6 +470,7 @@ int online_pages(unsigned long pfn, unsi
 
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);
+	unlock_memory_hotplug();
 
 	return 0;
 }

