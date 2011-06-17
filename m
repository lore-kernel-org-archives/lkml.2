Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab1FQWUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:20:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14786 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab1FQWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=R0ia8FoV7+o23vLhCKkeza/he3x0BAw/ytdhjxY3l5cRjO1hDg6wQgeatzDzxwtfGD
         rOJg6c74knBSg4/awQbg==
Date: Fri, 17 Jun 2011 15:20:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
In-Reply-To: <BANLkTimStT22tA2YkeuYBzarnnWTnMjiKQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1106171509100.20144@sister.anvils>
References: <1308097798.17300.142.camel@schen9-DESK> <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK> <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com> <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com> <1308255972.17300.450.camel@schen9-DESK> <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com> <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com> <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com>
 <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com> <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com> <1308310080.2355.19.camel@twins> <BANLkTim2bmPfeRT1tS7hx2Z85QHjPHwU3Q@mail.gmail.com> <alpine.LSU.2.00.1106171040460.7018@sister.anvils>
 <BANLkTim3vo0vpovV=5sU=GLxkotheB=Ryg@mail.gmail.com> <1308334688.12801.19.camel@laptop> <1308335557.12801.24.camel@laptop> <BANLkTimStT22tA2YkeuYBzarnnWTnMjiKQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Linus Torvalds wrote:
> On Fri, Jun 17, 2011 at 11:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > something like so I guess, completely untested etc..
> 
> Having gone over it a bit more, I actually think I prefer to just
> special-case the allocation instead.
> 
> We already have to drop the anon_vma lock for the "out of memory"
> case, and a slight re-organization of clone_anon_vma() makes it easy
> to just first try a NOIO allocation with the lock still held, and then
> if that fails do the "drop lock, retry, and hard-fail" case.
> 
> IOW, something like the attached (on top of the patches already posted
> except for your memory reclaim thing)
> 
> Hugh, does this fix the lockdep issue?

Yes, that fixed the lockdep issue, and ran nicely under load for an hour.

I agree that it's better to do this GFP_NOWAIT and fallback,
than trylock the anon_vma.

And I'm happy that you've still got that WARN_ON_ONCE(root) in: I do not
have a fluid mental model of the anon_vma_chains, get lost there; and
though it's obvious that we must have the same anon_vma->root going
down the same_anon_vma list, I could not put my finger on a killer
demonstration for why the same has to be true of the same_vma list.

But I've not seen your WARN_ON_ONCE fire, and it's hard to imagine
how there could be more than one root in the whole bundle of lists.

Hugh
