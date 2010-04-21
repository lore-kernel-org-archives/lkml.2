Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0DUUxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:53:16 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47565 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab0DUUxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:53:14 -0400
Date: Wed, 21 Apr 2010 22:53:05 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Dan Carpenter <error27@gmail.com>,
       Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] ksm: check for ERR_PTR from follow_page()
Message-ID: <20100421205305.GO20640@cmpxchg.org>
References: <20100421102759.GA29647@bicker> <4BCF18A8.8080809@redhat.com> <20100421174615.GO32034@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421174615.GO32034@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 07:46:15PM +0200, Andrea Arcangeli wrote:
> On Wed, Apr 21, 2010 at 11:24:24AM -0400, Rik van Riel wrote:
> > On 04/21/2010 06:27 AM, Dan Carpenter wrote:
> > > The follow_page() function can potentially return -EFAULT so I added
> > > checks for this.
> > >
> > > Also I silenced an uninitialized variable warning on my version of gcc
> > > (version 4.3.2).
> > >
> > > Signed-off-by: Dan Carpenter<error27@gmail.com>
> > 
> > Acked-by: Rik van Riel <riel@redhat.com>
> 
>   	    	while (!(page = follow_page(vma, start, foll_flags)))
>   	    	{
> 
> gup only checks for null, so when exactly is follow_page going to
> return -EFAULT? It's not immediately clear.

Check below that loop.  If it returns non-null, the first check is
whether it IS_ERR().

How about the below?

	Hannes

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: document follow_page()

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memory.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 833952d..119b7cc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1227,8 +1227,17 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
-/*
- * Do a quick page-table lookup for a single page.
+/**
+ * follow_page - look up a page descriptor from a user-virtual address
+ * @vma: vm_area_struct mapping @address
+ * @address: virtual address to look up
+ * @flags: flags modifying lookup behaviour
+ *
+ * @flags can have FOLL_ flags set, defined in <linux/mm.h>
+ *
+ * Returns the mapped (struct page *), %NULL if no mapping exists, or
+ * an error pointer if there is a mapping to something not represented
+ * by a page descriptor (see also vm_normal_page()).
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
-- 
1.7.0.2
