Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0JRSpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab0JRSpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:45:04 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101018181916.GB12372@elte.hu>
References: <20101016192027.GA6883@infradead.org>
	 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
	 <20101017004945.GE1614@infradead.org> <20101017054008.GA16383@elte.hu>
	 <20101017184652.GB28060@infradead.org>
	 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
	 <20101018062530.GD8332@bombadil.infradead.org>
	 <1287420534.2530.67.camel@localhost.localdomain>
	 <AANLkTi=h6-qMtk9Kf0TRUfqjuBau+_FhKAMZOd_MZHrn@mail.gmail.com>
	 <1287425596.2530.70.camel@localhost.localdomain>
	 <20101018181916.GB12372@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 14:43:37 -0400
Message-ID: <1287427417.2530.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 20:19 +0200, Ingo Molnar wrote:
> * Eric Paris <eparis@redhat.com> wrote:
> 
> > On Mon, 2010-10-18 at 10:56 -0700, Linus Torvalds wrote:
> > > On Mon, Oct 18, 2010 at 9:48 AM, Eric Paris <eparis@redhat.com> wrote:
> > > >
> > > > 1) IMA uses radix trees which end up wasting 500 bytes per inode because
> > > > the key is too sparse.  I've got a patch which uses an rbtree instead
> > > > I'm testing and will send along shortly.  I found it funny working on
> > > > the patch to see that Documentation/rbtree.txt says "This differs from
> > > > radix trees (which are used to efficiently store sparse arrays and thus
> > > > use long integer indexes to insert/access/delete nodes)"  Which flys in
> > > > the face of this report.
> > > 
> > > Please. Look at the report more carefully.
> > > 
> > > The radix tree memory use is disgusting. Yes. But it is absolutely NOT
> > > sufficient to try to just fix that part. Go back, look at the original
> > > report email, and this line in particular:
> > > 
> > >    2235648 2069791  92%    0.12K  69864       32    279456K iint_cache
> > > 
> > > There's 2.2 million iint_cache allocations too, each 128 bytes in
> > > size. That's still a quarter _gigabyte_ of crap that adds zero value
> > > at all.
> > 
> > That was #2 in my list of things to fix:
> >
> > 2) IMA creates an entire integrity structure for every inode even when most or all 
> > of this structure will not be needed.
> > 
> > I'm stating with #1 since that was 2G of wasted space (thus far my switch to 
> > rbtree seems to be surviving an xfstest) so I expect to send the patch this 
> > afternoon.  #2 should attack the size of the iint_cache entries.  #3 should attack 
> > the scalability.  I'm certainly hoping I didn't miss part of the report....
> 
> I think it would be fair to argue that #2 is the thing that should be fixed first 
> and foremost - before touching any data structure details.
> 
> Because if you fix #2 then all the other items will become no-op to 99.9% of the 
> people who are affected by this bug today.
> 
> It's also probably a much simpler fix for -stable, so should be done first, etc.
> 
> If you do the data structure changes first then #2 will likely not be backportable 
> standalone and #1 will be risky to backport - creating nasty dependencies.

Good point.  I'll keep that in mind and possibly reorder.

-Eric

