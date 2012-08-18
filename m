Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2HREH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 00:07:57 -0400
Received: from evergreen.ssec.wisc.edu ([128.104.108.253]:47506 "EHLO
	evergreen.ssec.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2HREHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 00:07:48 -0400
Date: Fri, 17 Aug 2012 23:07:47 -0500
From: Daniel Forrest <dan.forrest@ssec.wisc.edu>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Repeated fork() causes SLAB to grow without bound
Message-ID: <20120818040747.GA22793@evergreen.ssec.wisc.edu>
Reply-To: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	linux-mm <linux-mm@kvack.org>
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu> <502D42E5.7090403@redhat.com> <20120818000312.GA4262@evergreen.ssec.wisc.edu> <502F100A.1080401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502F100A.1080401@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:46:18PM -0400, Rik van Riel wrote:

> On 08/17/2012 08:03 PM, Daniel Forrest wrote:
> 
> >Based on your comments, I came up with the following patch.  It boots
> >and the anon_vma/anon_vma_chain SLAB usage is stable, but I don't know
> >if I've overlooked something.  I'm not a kernel hacker.
> 
> The patch looks reasonable to me.  There is one spot left
> for optimization, which I have pointed out below.
> 
> Of course, that leaves the big question: do we want the
> overhead of having the atomic addition and decrement for
> every anonymous memory page, or is it easier to fix this
> issue in userspace?
> 
> Given that malicious userspace could potentially run the
> system out of memory, without needing special privileges,
> and the OOM killer may not be able to reclaim it due to
> internal slab fragmentation, I guess this issue could be
> classified as a low impact denial of service vulnerability.
> 
> Furthermore, there is already a fair amount of bookkeeping
> being done in the rmap code, so this patch is not likely
> to add a whole lot - some testing might be useful, though.
> 
> >@@ -262,7 +264,10 @@ int anon_vma_clone(struct vm_area_struct
> >  		}
> >  		anon_vma = pavc->anon_vma;
> >  		root = lock_anon_vma_root(root, anon_vma);
> >-		anon_vma_chain_link(dst, avc, anon_vma);
> >+		if (!atomic_read(&anon_vma->pagecount))
> >+			anon_vma_chain_free(avc);
> >+		else
> >+			anon_vma_chain_link(dst, avc, anon_vma);
> >  	}
> >  	unlock_anon_vma_root(root);
> >  	return 0;
> 
> In this function, you can do the test before the code block
> where we try to allocate an anon_vma chain.
> 
> In other words:
> 
> 	list_for_each_entry_reverse(.....
> 	struct anon_vma *anon_vma;
> 
> +	if (!atomic_read(&anon_vma->pagecount))
> +		continue;
> +
> 	avc = anon_vma_chain_alloc(...
> 	if (unlikely(!avc)) {
> 
> The rest looks good.

I was being careful since I wasn't certain about the locking.  Does
the test need to be protected by "lock_anon_vma_root"?  That's why I
chose the overhead of the possible wasted "anon_vma_chain_alloc".

-- 
Daniel K. Forrest		Space Science and
dan.forrest@ssec.wisc.edu	Engineering Center
(608) 890 - 0558		University of Wisconsin, Madison
