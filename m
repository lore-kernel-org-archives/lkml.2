Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab1BPAYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:09 -0500
Received: from kroah.org ([198.145.64.141]:49584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1BPAYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:46 2011
Message-Id: <20110216001446.144899533@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [210/272] memory hotplug: one more lock on memory hotplug
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 925268a06dc2b1ff7bfcc37419a6827a0e739639 upstream.

Now, memory_hotplug_(un)lock() is used for add/remove/offline pages
for avoiding races with hibernation. But this should be held in
online_pages(), too. It seems asymmetric.

There are cases where one has to avoid a race with memory hotplug
notifier and his own local code, and hotplug v.s. hotplug.
This will add a generic solution for avoiding races. In other view,
having lock here has no big impacts. online pages is tend to be
done by udev script at el against each memory section one by one.

Then, it's better to have lock here, too.

Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory_hotplug.c            |    4 ++++
 2 files changed, 10 insertions(+)

--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
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
 
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
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


