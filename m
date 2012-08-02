Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2HBRcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:32:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52743 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2HBRcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:32:35 -0400
MIME-Version: 1.0
In-Reply-To: <87fw851c3d.fsf@xmission.com>
References: <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com>
 <20120801182112.GC15477@google.com> <50197460.8010906@gmail.com>
 <20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com>
 <20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com>
 <20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com>
 <20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com>
 <87txwl1dsq.fsf@xmission.com> <501AAC26.6030703@gmail.com> <87fw851c3d.fsf@xmission.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Aug 2012 10:32:13 -0700
X-Google-Sender-Auth: 5fzXt7yObuOw3LMQBOrcY2141V8
Message-ID: <CA+55aFw_dwO5ZOuaz9eDxgnTZFDGVZKSLUTm5Fn99faALxxJRQ@mail.gmail.com>
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 9:40 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> For a trivial hash table I don't know if the abstraction is worth it.
> For a hash table that starts off small and grows as big as you need it
> the incent to use a hash table abstraction seems a lot stronger.

I'm not sure growing hash tables are worth it.

In the dcache layer, we have an allocated-at-boot-time sizing thing,
and I have been playing around with a patch that makes the hash table
statically sized (and pretty small). And it actually speeds things up!

A statically allocated hash-table with a fixed size is quite
noticeably faster, because you don't have those extra indirect reads
of the base/size that are in the critical path to the actual lookup.
So for the dentry code I tried a small(ish) direct-mapped fixed-size
"L1 hash" table that then falls back to the old dynamically sized one
when it misses ("main memory"), and it really does seem to work really
well.

The reason it's not committed in my tree is that the filling of the
small L1 hash is racy for me right now (I don't want to take any locks
for filling the small one, and I haven't figured out how to fill it
racelessly without having to add the sequence number to the hash table
itself, which would make it annoyingly bigger).

Anyway, what I really wanted to bring up was the fact that static hash
tables of a fixed size are really quite noticeably faster. So I would
say that Sasha's patch to make *that* case easy actually sounds nice,
rather than making some more complicated case that is fundamentally
slower and more complicated.

                      Linus
