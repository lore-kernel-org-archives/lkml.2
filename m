Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1GQOtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 10:49:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:54648 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1GQOtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 10:49:13 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E22E4AC.7040600@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins>  <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop> <1310900561.13765.22.camel@twins>
	 <4E22E4AC.7040600@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 00:48:37 +1000
Message-ID: <1310914117.25044.216.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-17 at 21:33 +0800, Shan Hai wrote:
> 
> On ARM you could not protect pages from supervisor-mode writes,
> isn't it?  That means, all writable user pages are writable for
> supervisor too, but its not hold for at least x86 and powerpc,
> x86 and powerpc can be configured to protect pages from
> supervisor-mode writes.

That doesn't sound right... how would put_user() work properly then ? A
cursory glance at the ARM code doesn't show it doing anything "special",
just stores ... but I might have missing something.

> Think about the following situation,
> a page fault occurs on the kernel trying to write to a writable shared
> user page which is read only to the kernel, the following conditions
> hold,
> - the page is *present*, because its a shared page
> - the page is *writable*, because demand paging sets up the pte for
>      the current process to so
> 
> The follow_page() called in the __get_user_page() returns non NULL
> to its caller on the above mentioned *present* and *writable* page,
> so the gup(.write=1) has no chance to set pte dirty by calling 
> handle_mm_fault,
> the follow_page() has no knowledge of supervisor-mode write protected
> pages,
> that's the culprit in the bug discussed here. 

Right, the problem is with writable pages that have "lost" (or never had
but usually it's lost, due to swapping for example) their dirty bit, or
any page that has lost young.

>From what I can tell, we need to either fix those bits from the caller
of gup (futex code), which sound nasty, or more easily fix those from
gup itself, possibly under control of flags in the "write" argument to 
avoid breaking code relying on the existing behaviour, expecially vs.
dirty.

Cheers,
Ben.


