Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2HBVVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:21:49 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43603 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2HBVVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:21:48 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Thu, 2 Aug 2012 14:21:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120802212140.GC7916@jtriplet-mobl1>
References: <20120802103244.GA23318@leaf>
 <501A633B.3010509@gmail.com>
 <87txwl1dsq.fsf@xmission.com>
 <501AAC26.6030703@gmail.com>
 <87fw851c3d.fsf@xmission.com>
 <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
 <20120802175904.GB6251@jtriplet-mobl1>
 <CA+55aFwqC9hF++S-VPHJBFRrqfyNvsvqwzP=Vtzkv8qSYVqLxA@mail.gmail.com>
 <20120802202516.GA7916@jtriplet-mobl1>
 <CA+55aFybtRdg=AzcHv3CPm-_wx8LT2_CXaKr4K+i94QSPauZOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFybtRdg=AzcHv3CPm-_wx8LT2_CXaKr4K+i94QSPauZOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 01:32:41PM -0700, Linus Torvalds wrote:
> On Thu, Aug 2, 2012 at 1:25 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > Sorry, I should clarify what I meant: you'll have a total of one extra
> > indirection, not two.
> 
> Yes. But the hash table address generation is noticeably bigger and
> slower due to the non-fixed size too.

If you store the size as a precomputed bitmask, that should simplify the
bucket lookup to just a fetch, mask, and offset.  (You shouldn't ever
need the actual number of buckets or the shift except when resizing, so
the bitmask seems like the optimal thing to store.)  With a fixed table
size, I'd expect to see the same code minus the fetch, with an immediate
in the masking instruction.  Did GCC's generated code have worse
differences than an immediate versus a fetched value?

> In general, you can basically think of a dynamic hash table as always
> having one extra entry in the hash chains. Sure, the base address
> *may* cache well, but on the other hand, a smaller static hash table
> caches better than a big one, so you lose some and you win some.
> According to my numbers, you win a lot more than you lose.

Agreed.

I don't think any of this argues against having a second-level cache,
though, and making that one resizable seems sensible.  So, having a
scalable resizable hash table seems orthogonal to having a small
fixed-size hash table as a first-level cache.  I already agree with you
that the hash table API should not make the latter more complex or
expensive to better suit the former; as far as I can tell, address
generation seems like the only issue there.

> > Does your two-level dcache handle eviction?
> >
> > Mind posting the WIP patches?
> 
> Attached. It's against an older kernel, but I suspect it still applies
> cleanly. The patch is certainly simple, but note the warning (you can
> *run* it, though - the race is almost entirely theoretical, so you can
> get numbers without ever seeing it)
> 
>            Linus


