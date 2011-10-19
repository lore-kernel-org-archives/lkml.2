Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1JSAZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:25:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:20235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1JSAZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:25:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,368,1315206000"; 
   d="scan'208";a="63951576"
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: munlock use mapcount to avoid terrible overhead
References: <alpine.LSU.2.00.1110181700400.3361@sister.anvils>
Date: Tue, 18 Oct 2011 17:25:48 -0700
In-Reply-To: <alpine.LSU.2.00.1110181700400.3361@sister.anvils> (Hugh
	Dickins's message of "Tue, 18 Oct 2011 17:02:56 -0700 (PDT)")
Message-ID: <m262jlzv1v.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hughd@google.com> writes:

> A process spent 30 minutes exiting, just munlocking the pages of a large
> anonymous area that had been alternately mprotected into page-sized vmas:
> for every single page there's an anon_vma walk through all the other
> little vmas to find the right one.

We had the same problem recently after a mmap+touch workload: in this
case it was hugepaged walking all these anon_vmas and the list was over
100k long. 

Had some data on this at plumbers:
http://halobates.de/plumbers-fork-locks_v2.pdf

> A general fix to that would be a lot more complicated (use prio_tree on
> anon_vma?), but there's one very simple thing we can do to speed up the
> common case: if a page to be munlocked is mapped only once, then it is
> our vma that it is mapped into, and there's no need whatever to walk
> through all the others.

I think we need a generic fix, this problem does not only happen
in munmap. 


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
