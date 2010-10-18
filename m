Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab0JRR51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:57:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755214Ab0JRR50 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <1287420534.2530.67.camel@localhost.localdomain>
References: <20101016065206.GO4681@dastard> <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com> <20101017004945.GE1614@infradead.org>
 <20101017054008.GA16383@elte.hu> <20101017184652.GB28060@infradead.org>
 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org> <20101018062530.GD8332@bombadil.infradead.org>
 <1287420534.2530.67.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Oct 2010 10:56:18 -0700
Message-ID: <AANLkTi=h6-qMtk9Kf0TRUfqjuBau+_FhKAMZOd_MZHrn@mail.gmail.com>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
To: Eric Paris <eparis@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 9:48 AM, Eric Paris <eparis@redhat.com> wrote:
>
> 1) IMA uses radix trees which end up wasting 500 bytes per inode because
> the key is too sparse.  I've got a patch which uses an rbtree instead
> I'm testing and will send along shortly.  I found it funny working on
> the patch to see that Documentation/rbtree.txt says "This differs from
> radix trees (which are used to efficiently store sparse arrays and thus
> use long integer indexes to insert/access/delete nodes)"  Which flys in
> the face of this report.

Please. Look at the report more carefully.

The radix tree memory use is disgusting. Yes. But it is absolutely NOT
sufficient to try to just fix that part. Go back, look at the original
report email, and this line in particular:

   2235648 2069791  92%    0.12K  69864       32    279456K iint_cache

There's 2.2 million iint_cache allocations too, each 128 bytes in
size. That's still a quarter _gigabyte_ of crap that adds zero value
at all.

Sure, memory is cheap, and this is on a machine with a lot of memory.
But it has lots of memory because it wants to cache a lot of files,
but because it wants to waste it on useless crap.

And yes, the radix tree usage is even worse, because radix trees are
useful for densely clustered indexing, not sparse ones. But even if
you were to get the indexing cost down to _zero_, it would still be
unacceptable to waste memory like this for absolutely ZERO GAIN.

The IMA code clearly needs fixing at a much more fundamental level
than just the indexing.

                                             Linus
