Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0CXAg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:36:26 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36089 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753012Ab0CXAgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:36:24 -0400
Message-Id: <20100324003621.266604595@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 23 Mar 2010 19:36:10 -0500
From: holt@sgi.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Rafael Wysocki <rjw@novell.com>
Subject: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
References: <20100324003608.811051277@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=memtype_rwlock_V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert the memtype_lock from a spin_lock to an rw_lock.  The first
version of my patch had this and it did improve performance for fault
in times.  The atomic page flags patch (first in the series) improves
things much greater for ram pages.  This patch is to help the other pages.

To: Ingo Molnar <mingo@redhat.com>
To: H. Peter Anvin <hpa@zytor.com>
To: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org

---

 arch/x86/mm/pat.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-next/arch/x86/mm/pat.c
===================================================================
--- linux-next.orig/arch/x86/mm/pat.c	2010-03-15 08:13:47.262469632 -0500
+++ linux-next/arch/x86/mm/pat.c	2010-03-15 08:13:47.294446141 -0500
@@ -130,7 +130,7 @@ void pat_init(void)
 
 #undef PAT
 
-static DEFINE_SPINLOCK(memtype_lock);	/* protects memtype accesses */
+static DEFINE_RWLOCK(memtype_lock);	/* protects memtype accesses */
 
 /*
  * Does intersection of PAT memory type and MTRR memory type and returns
@@ -310,7 +310,7 @@ int reserve_memtype(u64 start, u64 end, 
 	new->end	= end;
 	new->type	= actual_type;
 
-	spin_lock(&memtype_lock);
+	write_lock(&memtype_lock);
 
 	err = rbt_memtype_check_insert(new, new_type);
 	if (err) {
@@ -318,12 +318,12 @@ int reserve_memtype(u64 start, u64 end, 
 		       "track %s, req %s\n",
 		       start, end, cattr_name(new->type), cattr_name(req_type));
 		kfree(new);
-		spin_unlock(&memtype_lock);
+		write_unlock(&memtype_lock);
 
 		return err;
 	}
 
-	spin_unlock(&memtype_lock);
+	write_unlock(&memtype_lock);
 
 	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
 		start, end, cattr_name(new->type), cattr_name(req_type),
@@ -354,9 +354,9 @@ int free_memtype(u64 start, u64 end)
 		return -EINVAL;
 	}
 
-	spin_lock(&memtype_lock);
+	write_lock(&memtype_lock);
 	err = rbt_memtype_erase(start, end);
-	spin_unlock(&memtype_lock);
+	write_unlock(&memtype_lock);
 
 	if (err) {
 		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
@@ -400,7 +400,7 @@ static unsigned long lookup_memtype(u64 
 		return rettype;
 	}
 
-	spin_lock(&memtype_lock);
+	read_lock(&memtype_lock);
 
 	entry = rbt_memtype_lookup(paddr);
 	if (entry != NULL)
@@ -408,7 +408,7 @@ static unsigned long lookup_memtype(u64 
 	else
 		rettype = _PAGE_CACHE_UC_MINUS;
 
-	spin_unlock(&memtype_lock);
+	read_unlock(&memtype_lock);
 	return rettype;
 }
 
@@ -748,9 +748,9 @@ static struct memtype *memtype_get_idx(l
 	if (!print_entry)
 		return NULL;
 
-	spin_lock(&memtype_lock);
+	read_lock(&memtype_lock);
 	ret = rbt_memtype_copy_nth_element(print_entry, pos);
-	spin_unlock(&memtype_lock);
+	read_unlock(&memtype_lock);
 
 	if (!ret) {
 		return print_entry;

