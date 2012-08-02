Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2HBR7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:59:13 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42083 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2HBR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:59:11 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 173.246.103.110
Date: Thu, 2 Aug 2012 10:59:04 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <levinsasha928@gmail.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120802175904.GB6251@jtriplet-mobl1>
References: <20120801202432.GE15477@google.com>
 <5019B0B4.1090102@gmail.com>
 <20120801224556.GF15477@google.com>
 <501A4FC1.8040907@gmail.com>
 <20120802103244.GA23318@leaf>
 <501A633B.3010509@gmail.com>
 <87txwl1dsq.fsf@xmission.com>
 <501AAC26.6030703@gmail.com>
 <87fw851c3d.fsf@xmission.com>
 <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 10:32:13AM -0700, Linus Torvalds wrote:
> On Thu, Aug 2, 2012 at 9:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > For a trivial hash table I don't know if the abstraction is worth it.
> > For a hash table that starts off small and grows as big as you need it
> > the incent to use a hash table abstraction seems a lot stronger.
> 
> I'm not sure growing hash tables are worth it.
> 
> In the dcache layer, we have an allocated-at-boot-time sizing thing,
> and I have been playing around with a patch that makes the hash table
> statically sized (and pretty small). And it actually speeds things up!
>
> A statically allocated hash-table with a fixed size is quite
> noticeably faster, because you don't have those extra indirect reads
> of the base/size that are in the critical path to the actual lookup.
> So for the dentry code I tried a small(ish) direct-mapped fixed-size
> "L1 hash" table that then falls back to the old dynamically sized one
> when it misses ("main memory"), and it really does seem to work really
> well.

You shouldn't have any extra indirection for the base, if it lives
immediately after the size.  You should only have a single extra
indirection for the size, and in a workload that uses that hash table
heavily, I'd hope that cache line sticks around.

Also, if you want to use a fixed-size "L1" hash table to reduce
indirections, you might as well use a non-chaining hash table to
eliminate another few indirections.

> The reason it's not committed in my tree is that the filling of the
> small L1 hash is racy for me right now (I don't want to take any locks
> for filling the small one, and I haven't figured out how to fill it
> racelessly without having to add the sequence number to the hash table
> itself, which would make it annoyingly bigger).

I'd be interested to see the performance numbers for an L1 hash that
doesn't cheat by skipping synchronization. :)  If you benchmarked an L1
hash with no synchronization against the existing dcache with its pile
of synchronization, that would make a large difference in performance,
but not necessarily because of a single extra indirection.

> Anyway, what I really wanted to bring up was the fact that static hash
> tables of a fixed size are really quite noticeably faster. So I would
> say that Sasha's patch to make *that* case easy actually sounds nice,
> rather than making some more complicated case that is fundamentally
> slower and more complicated.

The current approach that Sasha and I have iterated on should make the
fixed-size case equally easy and efficient, while also making the
resizable case possible.  Any particular reason not to use that
approach?

- Josh Triplett
