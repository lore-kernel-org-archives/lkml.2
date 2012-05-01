Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2EAUXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 16:23:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35873 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2EAUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 16:23:01 -0400
Date: Tue, 1 May 2012 13:22:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@gmail.com>
cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@gmail.com, Neil Brown <neilb@suse.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] vmalloc: add warning in __vmalloc
In-Reply-To: <CAPa8GCBN6U_GRaG=GYFByNB4REcVA-yy+kKMMbrGaDKULUXW9w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205011310180.7742@chino.kir.corp.google.com>
References: <1335516144-3486-1-git-send-email-minchan@kernel.org> <alpine.DEB.2.00.1204270323000.11866@chino.kir.corp.google.com> <CAPa8GCBN6U_GRaG=GYFByNB4REcVA-yy+kKMMbrGaDKULUXW9w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1914011446-1335903093=:7742"
Content-ID: <alpine.DEB.2.00.1205011314360.7742@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1914011446-1335903093=:7742
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1205011314361.7742@chino.kir.corp.google.com>

On Tue, 1 May 2012, Nick Piggin wrote:

> > I disagree with this approach since it's going to violently spam an
> > innocent kernel user's log with no ratelimiting and for a situation that
> > actually may not be problematic.
> 
> With WARN_ON_ONCE, it should be good.
> 

To catch a single instance of this per-boot, sure.  I've never seen us add 
WARN_ON_ONCE()'s where we have concrete examples of kernel code that will 
trigger it, though.  Not sure why spamming the kernel log and getting 
users to think something is wrong and report the bug when it's possible to 
audit the code and make a report to the subsystem maintainer.  Perhaps 
adding WARN_ON_ONCE()'s is just easier and then walk away from it?

> > Passing any of these bits (the difference between GFP_KERNEL and
> > GFP_ATOMIC) only means anything when we're going to do reclaim.  And I'm
> > suspecting we would have seen problems with this already since
> > pte_alloc_kernel() does __GFP_REPEAT on most architectures meaning that it
> > will loop infinitely in the page allocator until at least one page is
> > freed (since its an order-0 allocation) which would hardly ever happen if
> > __GFP_FS or __GFP_IO actually meant something in this context.
> >
> > In other words, we would already have seen these deadlocks and it would
> > have been diagnosed as a vmalloc(GFP_ATOMIC) problem.  Where are those bug
> > reports?
> 
> That's not sound logic to disprove a bug.
> 
> I think simply most callers are permissive and don't mask out flags.
> But for example a filesystem holding an fs lock and then doing
> vmalloc(GFP_NOFS) can certainly deadlock.
> 

I'm not disproving a bug, I'm asking for an example of how this problem 
has caused pain before and it has been the result of calling 
vmalloc(GFP_NOFS).  I agree we should certainly fix those callers, but it 
seems like adding the WARN_ON_ONCE()'s is certainly going to cause pain in 
tons of bug reports where there's no actual problem that couldn't have 
been found by auditing the code.
--397155492-1914011446-1335903093=:7742--
