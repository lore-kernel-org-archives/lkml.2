Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0DGIoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:44:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0DGIoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:44:09 -0400
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
References: <4BBB475A.7070002@redhat.com>
	 <1270568096.1814.145.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
	 <1270571019.1814.163.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
	 <1270572327.1711.3.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
	 <4BBB69A9.5090906@redhat.com>
	 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
	 <20100406120315.53ad7390.akpm@linux-foundation.org>
	 <20100406194238.GB20357@a1.tnic>
	 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Apr 2010 10:41:55 +0200
Message-ID: <1270629715.5109.556.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 13:02 -0700, Linus Torvalds wrote:
>  - Related to the above: perhaps the RCU freeing isn't working, or 
>    slub/slab/slob ends up reusing the allocations for something else than 
>    anonvma's, so together with the race _and_ an unlucky re-use, you get 
>    some odd crud.
> 
>    I haven't looked at the kernel config files: do they perhaps share the 
>    same (odd?) SLUB/SLAB/SLOB config? 

Right, so anon_vma uses SLAB_DESTROY_BY_RCU and as the huge comment in
rmap.c explains, that doesn't mean the objects themself get RCU grace
period delays in freeing, only the SLAB that backs these objects does.

So the moment you do kmem_cache_free() on the anon_vma it can be re-used
for another allocation. The only guarantee given by RCU is that the
backing storage doesn't go away and hence you can 'safely' deref
pointers, you still very much have to revalidate you got the object you
were looking for.
