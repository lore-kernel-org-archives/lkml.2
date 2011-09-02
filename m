Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab1IBLg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 07:36:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11762 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1IBLg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 07:36:56 -0400
X-IronPort-AV: E=Sophos;i="4.68,318,1312171200"; 
   d="scan'208";a="161550794"
Message-ID: <4E60C067.4010600@citrix.com>
Date: Fri, 2 Sep 2011 12:39:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Revert] Re: [PATCH] mm: sync vmalloc address space page tables
 in alloc_vm_area()
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com>	<20110901161134.GA8979@dumpdata.com>	<4E5FED1A.1000300@goop.org> <20110901141754.76cef93b.akpm@linux-foundation.org>
In-Reply-To: <20110901141754.76cef93b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/11 22:17, Andrew Morton wrote:
> On Thu, 01 Sep 2011 13:37:46 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>> On 09/01/2011 09:11 AM, Konrad Rzeszutek Wilk wrote:
>>> On Thu, Sep 01, 2011 at 12:51:03PM +0100, David Vrabel wrote:
>>>> From: David Vrabel <david.vrabel@citrix.com>
>>> Andrew,
>>>
>>> I was wondering if you would be Ok with this patch for 3.1.
>>>
>>> It is a revert (I can prepare a proper revert if you would like
>>> that instead of this patch).
> 
> David's patch looks better than a straight reversion.
> 
> Problem is, I can't find David's original email anywhere.  Someone's
> been playing games with To: headers?

Sorry, I should have Cc'd linux-kernel and others on the original patch.

>From 6844ca07140e08f29454ca7b3fa459571c7ba428 Mon Sep 17 00:00:00 2001
From: David Vrabel <david.vrabel@citrix.com>
Date: Thu, 1 Sep 2011 11:42:50 +0100
Subject: [PATCH] mm: sync vmalloc address space page tables in
alloc_vm_area()

Xen backend drivers (e.g., blkback and netback) would sometimes fail
to map grant pages into the vmalloc address space allocated with
alloc_vm_area().  The GNTTABOP_map_grant_ref would fail because Xen
could not find the page (in the L2 table) containing the PTEs it
needed to update.

(XEN) mm.c:3846:d0 Could not find L1 PTE for address fbb42000

netback and blkback were making the hypercall from a kernel thread
where task->active_mm != &init_mm and alloc_vm_area() was only
updating the page tables for init_mm.  The usual method of deferring
the update to the page tables of other processes (i.e., after taking a
fault) doesn't work as a fault cannot occur during the hypercall.

This would work on some systems depending on what else was using
vmalloc.

Fix this by reverting ef691947d8a3d479e67652312783aedcf629320a
(vmalloc: remove vmalloc_sync_all() from alloc_vm_area()) and add a
comment to explain why it's needed.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/vmalloc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7ef0903..5016f19 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2140,6 +2140,14 @@ struct vm_struct *alloc_vm_area(size_t size)
 		return NULL;
 	}

+	/*
+	 * If the allocated address space is passed to a hypercall
+	 * before being used then we cannot rely on a page fault to
+	 * trigger an update of the page tables.  So sync all the page
+	 * tables here.
+	 */
+	vmalloc_sync_all();
+
 	return area;
 }
 EXPORT_SYMBOL_GPL(alloc_vm_area);
-- 
1.7.2.5

