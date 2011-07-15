Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1GPBIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 21:08:45 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33946 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1GPBIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 21:08:44 -0400
Date: Fri, 15 Jul 2011 23:10:49 +1000
From: David Gibson <dwg@au1.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Anton Blanchard <anton@samba.org>, mel@csn.ul.ie,
        akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugepage: Allow parallelization of the hugepage
 fault path
Message-ID: <20110715131049.GA4368@yookeroo.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Andi Kleen <andi@firstfloor.org>, Anton Blanchard <anton@samba.org>,
	mel@csn.ul.ie, akpm@linux-foundation.org, hughd@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20110125143226.37532ea2@kryten>
 <20110125143414.1dbb150c@kryten>
 <m2zkkg6kvs.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2zkkg6kvs.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 12:52:38AM -0700, Andi Kleen wrote:
> Anton Blanchard <anton@samba.org> writes:
> 
> 
> > This patch improves the situation by replacing the single mutex with a
> > table of mutexes, selected based on a hash of the address_space and
> > file offset being faulted (or mm and virtual address for MAP_PRIVATE
> > mappings).
> 
> It's unclear to me how this solves the original OOM problem.
> But then you can still have early oom over all the hugepages if they
> happen to hash to different pages, can't you? 

The spurious OOM case only occurs when the two processes or threads
are racing to instantiate the same page (that is the same page within
an address_space for SHARED or the same virtual address for PRIVATE).
In other cases the OOM is correct behaviour (because we really don't
have enough hugepages to satisfy the requests).

Because of the hash's construction, we're guaranteed than in the
spurious OOM case, both processes or threads will use the same mutex.

> I think it would be better to move out the clearing out of the lock,

We really can't.  The lock has to be taken before we grab a page from
the pool, and can't be released until after the page is "committed"
either by updating the address space's radix tree (SHARED) or the page
tables (PRIVATE).  I can't see anyway the clearing can be moved out of
that.

> and possibly take the lock only when the hugepages are about to 
> go OOM.

This is much easier said than done.  

At one stage I did attempt a more theoretically elegant approach which
is to keep a count of the number of "in-flight" hugepages - OOMs
should be retried if it is non-zero.  I believe that approach can
work, but it turns out to be pretty darn hairy to implement.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
