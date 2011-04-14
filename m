Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1DNVx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:53:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53142 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1DNVxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:53:55 -0400
Date: Thu, 14 Apr 2011 22:53:27 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: raz ben yehuda <raziebe@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org
Subject: Re: 2.6.38 page_test regression
Message-ID: <20110414215327.GI11871@csn.ul.ie>
References: <1302692638.15225.14.camel@raz.scalemp.com>
 <20110413125146.GR29444@random.random>
 <1302703579.17536.1.camel@raz.scalemp.com>
 <20110413172127.GB5734@random.random>
 <1302781754.5098.13.camel@raz.scalemp.com>
 <20110414150925.GD15707@random.random>
 <1302811643.10051.8.camel@raz.scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1302811643.10051.8.camel@raz.scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:07:23PM +0300, raz ben yehuda wrote:
> bah. Mel is correct. I did mean page_test  ( in my defense it is in the
> msg ).
> Here some more information:
> 1. I manage to lower the regression to 2 sha1's:
>     	32dba98e085f8b2b4345887df9abf5e0e93bfc12 to
> 71e3aac0724ffe8918992d76acfe3aad7d8724a5. 
> 	though I had to remark wait_split_huge_page for the sake of
> compilation. up to 32dba98e085f8b2b4345887df9abf5e0e93bfc12 there is no
> regression.
> 
> 2. I booted 2.6.37-rc5 you gave me. same regression is there. 

Extremely long shot - try this patch.

diff --git a/mm/memory.c b/mm/memory.c
index c50a195..a39baaf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3317,7 +3317,7 @@ int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * run pte_offset_map on the pmd, if an huge pmd could
 	 * materialize from under us from a different thread.
 	 */
-	if (unlikely(__pte_alloc(mm, vma, pmd, address)))
+	if (unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, vma, pmd, address))
 		return VM_FAULT_OOM;
 	/* if an huge pmd materialized from under us just retry later */
 	if (unlikely(pmd_trans_huge(*pmd)))
