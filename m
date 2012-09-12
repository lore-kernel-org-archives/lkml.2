Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2ILDhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:37:19 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55202 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2ILDhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:37:16 -0400
Message-ID: <50500360.5020700@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 11:37:04 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 09/12] thp: introduce khugepaged_prealloc_page and khugepaged_alloc_page
References: <5028E12C.70101@linux.vnet.ibm.com> <5028E20C.3080607@linux.vnet.ibm.com> <alpine.LSU.2.00.1209111807030.21798@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1209111807030.21798@eggly.anvils>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091203-5564-0000-0000-0000046C9DB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:03 AM, Hugh Dickins wrote:

> What brought me to look at it was hitting "BUG at mm/huge_memory.c:1842!"
> running tmpfs kbuild swapping load (with memcg's memory.limit_in_bytes
> forcing out to swap), while I happened to have CONFIG_NUMA=y.
> 
> That's the VM_BUG_ON(*hpage) on entry to khugepaged_alloc_page().

> 
> So maybe 9/12 is just obscuring what was already a BUG, either earlier
> in your series or elsewhere in mmotm (I've never seen it on 3.6-rc or
> earlier releases, nor without CONFIG_NUMA).  I've not spent any time
> looking for it, maybe it's obvious - can you spot and fix it?

Hugh,

I think i have already found the reason, if i am correct, the bug was existing
before my patch.

Could you please try below patch? And, could please allow me to fix the bug first,
then post another patch to improve the things you dislike?


Subject: [PATCH] thp: fix forgetting to reset the page alloc indicator

If NUMA is enabled, the indicator is not reset if the previous page
request is failed, then it will trigger the BUG_ON in khugepaged_alloc_page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e366ca5..66d2bc6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1825,6 +1825,7 @@ static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
 			return false;

 		*wait = false;
+		*hpage = NULL;
 		khugepaged_alloc_sleep();
 	} else if (*hpage) {
 		put_page(*hpage);
-- 
1.7.7.6

