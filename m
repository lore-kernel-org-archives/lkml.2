Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246Ab0D3T1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:27:01 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:63735 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0D3Qrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rPWnHw8BKw+1U6HbNLgTNsAipvT7QEJ+1Yvy6czCQIjCzKKzeSV+YzNbfiOV8COz9v
         CIeUvpdgOkD0wVXAA4BTc/79DrNvkNGhIKaKiGaZcGOLlT0fEtlXalzhQ8Unlk5X0OKY
         Ccrl2hpJYIAzjsYNep718Hh1PG3GHeCqELpks=
Subject: Re: [RFC PATCH -v3] take all anon_vma locks in anon_vma_lock
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100429081521.GM15815@csn.ul.ie>
References: <1272403852-10479-3-git-send-email-mel@csn.ul.ie>
	 <20100427231007.GA510@random.random> <20100428091555.GB15815@csn.ul.ie>
	 <20100428153525.GR510@random.random> <20100428155558.GI15815@csn.ul.ie>
	 <20100428162305.GX510@random.random>
	 <20100428134719.32e8011b@annuminas.surriel.com>
	 <20100428142510.09984e15@annuminas.surriel.com>
	 <20100428161711.5a815fa8@annuminas.surriel.com>
	 <20100428165734.6541bab3@annuminas.surriel.com>
	 <20100429081521.GM15815@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 17:32:17 +0900
Message-ID: <1272529937.2100.219.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 09:15 +0100, Mel Gorman wrote:
> On Wed, Apr 28, 2010 at 04:57:34PM -0400, Rik van Riel wrote:
> > Take all the locks for all the anon_vmas in anon_vma_lock, this properly
> > excludes migration and the transparent hugepage code from VMA changes done
> > by mmap/munmap/mprotect/expand_stack/etc...
> > 
> 
> In vma_adjust(), what prevents something like rmap_map seeing partial
> updates while the following lines execute?
> 
>         vma->vm_start = start;
>         vma->vm_end = end;
>         vma->vm_pgoff = pgoff;
>         if (adjust_next) {
>                 next->vm_start += adjust_next << PAGE_SHIFT;
>                 next->vm_pgoff += adjust_next;
>         }
> They would appear to happen outside the lock, even with this patch. The
> update happened within the lock in 2.6.33.
> 
> 
> 
This part does it. :)

----
@@ -578,6 +578,7 @@ again:                      remove_next = 1 + (end >
next->vm_end);
                }   
        }   
 
+       anon_vma_lock(vma, &mm->mmap_sem);
        if (root) {
                flush_dcache_mmap_lock(mapping);
                vma_prio_tree_remove(vma, root);
@@ -599,6 +600,7 @@ again:                      remove_next = 1 + (end >
next->vm_end);
                vma_prio_tree_insert(vma, root);
                flush_dcache_mmap_unlock(mapping);
        }   
+       anon_vma_unlock(vma);
---


But we still need patch about shift_arg_pages.



-- 
Kind regards,
Minchan Kim


