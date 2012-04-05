Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DEPJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:09:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43153 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2DEPJM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 5 Apr 2012 11:09:12 -0400
Message-Id: <4F7DD1EF020000780007CC05@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 05 Apr 2012 16:10:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/gnttab: add deferred freeing logic
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than just leaking pages that can't be freed at the point where
access permission for the backend domain gets revoked, put them on a
list and run a timer to (infrequently) retry freeing them. (This can
particularly happen when unloading a frontend driver when devices are
still present, and the backend still has them in non-closed state or
hasn't finished closing them yet.)

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/grant-table.c |  106 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 96 insertions(+), 10 deletions(-)

--- 3.4-rc1/drivers/xen/grant-table.c
+++ 3.4-rc1-xen-gnttab-deferred-end-access/drivers/xen/grant-table.c
@@ -426,10 +426,8 @@ static int gnttab_end_foreign_access_ref
 	nflags = *pflags;
 	do {
 		flags = nflags;
-		if (flags & (GTF_reading|GTF_writing)) {
-			printk(KERN_ALERT "WARNING: g.e. still in use!\n");
+		if (flags & (GTF_reading|GTF_writing))
 			return 0;
-		}
 	} while ((nflags = sync_cmpxchg(pflags, flags, 0)) != flags);
 
 	return 1;
@@ -458,12 +456,103 @@ static int gnttab_end_foreign_access_ref
 	return 1;
 }
 
-int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+static inline int _gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
 {
 	return gnttab_interface->end_foreign_access_ref(ref, readonly);
 }
+
+int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+{
+	if (_gnttab_end_foreign_access_ref(ref, readonly))
+		return 1;
+	pr_warn("WARNING: g.e. %#x still in use!\n", ref);
+	return 0;
+}
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_access_ref);
 
+struct deferred_entry {
+	struct list_head list;
+	grant_ref_t ref;
+	bool ro;
+	uint16_t warn_delay;
+	struct page *page;
+};
+static LIST_HEAD(deferred_list);
+static void gnttab_handle_deferred(unsigned long);
+static DEFINE_TIMER(deferred_timer, gnttab_handle_deferred, 0, 0);
+
+static void gnttab_handle_deferred(unsigned long unused)
+{
+	unsigned int nr = 10;
+	struct deferred_entry *first = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gnttab_list_lock, flags);
+	while (nr--) {
+		struct deferred_entry *entry
+			= list_first_entry(&deferred_list,
+					   struct deferred_entry, list);
+
+		if (entry == first)
+			break;
+		list_del(&entry->list);
+		spin_unlock_irqrestore(&gnttab_list_lock, flags);
+		if (_gnttab_end_foreign_access_ref(entry->ref, entry->ro)) {
+			put_free_entry(entry->ref);
+			if (entry->page) {
+				pr_debug("freeing g.e. %#x (pfn %#lx)\n",
+					 entry->ref, page_to_pfn(entry->page));
+				__free_page(entry->page);
+			} else
+				pr_info("freeing g.e. %#x\n", entry->ref);
+			kfree(entry);
+			entry = NULL;
+		} else {
+			if (!--entry->warn_delay)
+				pr_info("g.e. %#x still pending\n",
+					entry->ref);
+			if (!first)
+				first = entry;
+		}
+		spin_lock_irqsave(&gnttab_list_lock, flags);
+		if (entry)
+			list_add_tail(&entry->list, &deferred_list);
+		else if (list_empty(&deferred_list))
+			break;
+	}
+	if (!list_empty(&deferred_list) && !timer_pending(&deferred_timer)) {
+		deferred_timer.expires = jiffies + HZ;
+		add_timer(&deferred_timer);
+	}
+	spin_unlock_irqrestore(&gnttab_list_lock, flags);
+}
+
+static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
+				struct page *page)
+{
+	struct deferred_entry *entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+	const char *what = KERN_WARNING "leaking";
+
+	if (entry) {
+		unsigned long flags;
+
+		entry->ref = ref;
+		entry->ro = readonly;
+		entry->page = page;
+		entry->warn_delay = 60;
+		spin_lock_irqsave(&gnttab_list_lock, flags);
+		list_add_tail(&entry->list, &deferred_list);
+		if (!timer_pending(&deferred_timer)) {
+			deferred_timer.expires = jiffies + HZ;
+			add_timer(&deferred_timer);
+		}
+		spin_unlock_irqrestore(&gnttab_list_lock, flags);
+		what = KERN_DEBUG "deferring";
+	}
+	printk("%s g.e. %#x (pfn %#lx)\n",
+	       what, ref, page ? page_to_pfn(page) : -1);
+}
+
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
 			       unsigned long page)
 {
@@ -471,12 +560,9 @@ void gnttab_end_foreign_access(grant_ref
 		put_free_entry(ref);
 		if (page != 0)
 			free_page(page);
-	} else {
-		/* XXX This needs to be fixed so that the ref and page are
-		   placed on a list to be freed up later. */
-		printk(KERN_WARNING
-		       "WARNING: leaking g.e. and page still in use!\n");
-	}
+	} else
+		gnttab_add_deferred(ref, readonly,
+				    page ? virt_to_page(page) : NULL);
 }
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_access);
 


