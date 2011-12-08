Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1LHMm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:42:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1LHMm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:42:56 -0500
Date: Thu, 8 Dec 2011 13:42:17 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of
 vma_merge succeeding in copy_vma
Message-ID: <20111208124217.GD15343@redhat.com>
References: <alpine.LSU.2.00.1111041856530.22199@sister.anvils>
 <1320512782-12209-1-git-send-email-aarcange@redhat.com>
 <alpine.DEB.2.00.1112071924400.636@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112071924400.636@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 07:24:59PM -0800, David Rientjes wrote:
> On Sat, 5 Nov 2011, Andrea Arcangeli wrote:
> 
> > migrate was doing a rmap_walk with speculative lock-less access on
> > pagetables. That could lead it to not serialize properly against
> > mremap PT locks. But a second problem remains in the order of vmas in
> > the same_anon_vma list used by the rmap_walk.
> > 
> > If vma_merge would succeed in copy_vma, the src vma could be placed
> > after the dst vma in the same_anon_vma list. That could still lead
> > migrate to miss some pte.
> > 
> > This patch adds a anon_vma_moveto_tail() function to force the dst vma
> > at the end of the list before mremap starts to solve the problem.
> > 
> > If the mremap is very large and there are a lots of parents or childs
> > sharing the anon_vma root lock, this should still scale better than
> > taking the anon_vma root lock around every pte copy practically for
> > the whole duration of mremap.
> > 
> > Update: Hugh noticed special care is needed in the error path where
> > move_page_tables goes in the reverse direction, a second
> > anon_vma_moveto_tail() call is needed in the error path.
> > 
> 
> Is this still needed?  It's missing in linux-next.

Yes it's needed, either this or the anon_vma lock around
move_page_tables. Then we also need the i_mmap_mutex around fork or a
triple loop in vmtruncate (then we could remove i_mmap_mutex in
mremap).
