Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2KOWep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:34:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2KOWeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:34:44 -0500
Date: Thu, 15 Nov 2012 14:34:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: drivres/hv
Message-Id: <20121115143442.fd3672b8.akpm@linux-foundation.org>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E47FEC@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1351894283-12902-1-git-send-email-kys@microsoft.com>
	<20121102233717.GB3239@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930E47FEC@SN2PRD0310MB382.namprd03.prod.outlook.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012 22:22:06 +0000
KY Srinivasan <kys@microsoft.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, November 02, 2012 7:37 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> > Subject: Re: drivres/hv
> > 
> > On Fri, Nov 02, 2012 at 03:11:23PM -0700, K. Y. Srinivasan wrote:
> > >
> > > Greg,
> > >
> > > Recently, I had  re-sent a few patches. You have applied all the patches except
> > the balloon driver
> > > related patches. Should I resend the balloon driver  patches. Let me know.
> > 
> > I can't apply the balloon driver until you get an ack from the
> > maintainers of the code you were exporting the symbols from.
> > 
> > Get that, and then resend them, as they are long gone from my "to-apply"
> > queue.
> 
> Greg,
> 
> Andrew has checked in my patch that exports the necessary function for Hyper-V
> balloon driver:
> 
> commit bb2495a71b8499bdfe207738bc88ffa91ebe0b0a
> Author: K. Y. Srinivasan <kys@microsoft.com>
> Date:   Thu Nov 15 13:37:59 2012 +1100
> 
> I had sent the new balloon driver that used this new function a few days ago. Should I
> resend the balloon driver. Let me know.

I'll send this in to Linus later this week, to make life easier for
everyone.  Or Greg can grab it.


From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: mm: export a function to get vm committed memory

It will be useful to be able to access global memory commitment from
device drivers.  On the Hyper-V platform, the host has a policy engine to
balance the available physical memory amongst all competing virtual
machines hosted on a given node.  This policy engine is driven by a number
of metrics including the memory commitment reported by the guests.  The
balloon driver for Linux on Hyper-V will use this function to retrieve
guest memory commitment.  This function is also used in Xen self
ballooning code.

[akpm@linux-foundation.org: coding-style tweak]
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xen-selfballoon.c |    2 +-
 include/linux/mman.h          |    2 ++
 mm/mmap.c                     |   14 ++++++++++++++
 mm/nommu.c                    |   15 +++++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/xen/xen-selfballoon.c~mm-export-a-function-to-get-vm-committed-memory drivers/xen/xen-selfballoon.c
--- a/drivers/xen/xen-selfballoon.c~mm-export-a-function-to-get-vm-committed-memory
+++ a/drivers/xen/xen-selfballoon.c
@@ -222,7 +222,7 @@ static void selfballoon_process(struct w
 	if (xen_selfballooning_enabled) {
 		cur_pages = totalram_pages;
 		tgt_pages = cur_pages; /* default is no change */
-		goal_pages = percpu_counter_read_positive(&vm_committed_as) +
+		goal_pages = vm_memory_committed() +
 				totalreserve_pages +
 				MB2PAGES(selfballoon_reserved_mb);
 #ifdef CONFIG_FRONTSWAP
diff -puN include/linux/mman.h~mm-export-a-function-to-get-vm-committed-memory include/linux/mman.h
--- a/include/linux/mman.h~mm-export-a-function-to-get-vm-committed-memory
+++ a/include/linux/mman.h
@@ -11,6 +11,8 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern struct percpu_counter vm_committed_as;
 
+unsigned long vm_memory_committed(void);
+
 static inline void vm_acct_memory(long pages)
 {
 	percpu_counter_add(&vm_committed_as, pages);
diff -puN mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory mm/mmap.c
--- a/mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory
+++ a/mm/mmap.c
@@ -89,6 +89,20 @@ int sysctl_max_map_count __read_mostly =
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
 
 /*
+ * The global memory commitment made in the system can be a metric
+ * that can be used to drive ballooning decisions when Linux is hosted
+ * as a guest. On Hyper-V, the host implements a policy engine for dynamically
+ * balancing memory across competing virtual machines that are hosted.
+ * Several metrics drive this policy engine including the guest reported
+ * memory commitment.
+ */
+unsigned long vm_memory_committed(void)
+{
+	return percpu_counter_read_positive(&vm_committed_as);
+}
+EXPORT_SYMBOL_GPL(vm_memory_committed);
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
diff -puN mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory mm/nommu.c
--- a/mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory
+++ a/mm/nommu.c
@@ -66,6 +66,21 @@ int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
 
+/*
+ * The global memory commitment made in the system can be a metric
+ * that can be used to drive ballooning decisions when Linux is hosted
+ * as a guest. On Hyper-V, the host implements a policy engine for dynamically
+ * balancing memory across competing virtual machines that are hosted.
+ * Several metrics drive this policy engine including the guest reported
+ * memory commitment.
+ */
+unsigned long vm_memory_committed(void)
+{
+	return percpu_counter_read_positive(&vm_committed_as);
+}
+
+EXPORT_SYMBOL_GPL(vm_memory_committed);
+
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
 
_


