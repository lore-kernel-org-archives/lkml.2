Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2A0CoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:44:09 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37754 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2A0CoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:44:07 -0500
MIME-Version: 1.0
Message-ID: <7198bfb3-1e32-40d3-8601-d88aed7aabd8@default>
Date: Thu, 26 Jan 2012 18:43:55 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH] mm: implement WasActive page flag (for improving
 cleancache)
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
 <4F218D36.2060308@linux.vnet.ibm.com>
 <9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
 <20120126163150.31a8688f.akpm@linux-foundation.org>
 <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
 <20120126171548.2c85dd44.akpm@linux-foundation.org>
In-Reply-To: <20120126171548.2c85dd44.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F220F68.0083,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)
> 
> On Thu, 26 Jan 2012 16:56:34 -0800 (PST)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > > I'll find the place to add the call to ClearPageWasActive() for v2.
> > >
> > > AFAICT this patch consumes our second-last page flag, or close to it.
> > > We'll all be breaking out in hysterics when the final one is gone.
> >
> > I'd be OK with only using this on 64-bit systems, though there
> > are ARM folks playing with zcache that might disagree.
> 
> 64-bit only is pretty lame and will reduce the appeal of cleancache and
> will increase the maintenance burden by causing different behavior on
> different CPU types.  Most Linux machines are 32-bit!  (My cheerily
> unsubstantiated assertion of the day).

Three years ago, I would have agreed.  I suspect the tipping point
has been crossed, especially if one is counting only servers (not
smartphones) though my opinion is also unsubstantiated.

But...

> >  Am I
> > correct in assuming that your "second-last page flag" concern
> > applies only to 32-bit systems?
> 
> Sort-of.  Usually a flag which is 64-bit-only causes the above issues.

Agreed so a non-page-flag approach or overloading a page flag would
be better (though I'd still settle for 64-bit-only if it's the
only option).

Maybe the Active page bit could be overloaded with some minor
rewriting?  IOW, perhaps the Active bit could be ignored when
the page is moved to the inactive LRU?  (Confusing I know, but I am
just brainstorming...)

> > I can see that may not be sufficient, so let me expand on it.
> >
> > First, just as page replacement worked prior to the active/inactive
> > redesign at 2.6.27, cleancache works without the WasActive page flag.
> > However, just as pre-2.6.27 page replacement had problems on
> > streaming workloads, so does cleancache.  The WasActive page flag
> > is an attempt to pass the same active/inactive info gathered by
> > the post-2.6.27 kernel into cleancache, with the same objectives and
> > presumably the same result: improving the "quality" of pages preserved
> > in memory thus reducing refaults.
> >
> > Is that clearer?  If so, I'll do better on the description at v2.
> 
> It really didn't tell us anything, apart from referring to vague
> "problems on streaming workloads", which forces everyone to go off and
> do an hour or two's kernel archeology, probably in the area of
> readahead.
> 
> Just describe the problem!  Why is it slow?  Where's the time being
> spent?  How does the proposed fix (which we haven't actually seen)
> address the problem?  If you inform us of these things then perhaps
> someone will have a useful suggestion.  And as a side-effect, we'll
> understand cleancache better.

Sorry, I'm often told that my explanations are long-winded so
as a result I sometimes err on the side of brevity...

The problem is that if a pageframe is used for a page that is
very unlikely (or never going) to be used again instead of for
a page that IS likely to be used again, it results in more
refaults (which means more I/O which means poorer performance).
So we want to keep pages that are most likely to be used again.
And pages that were active are more likely to be used again than
pages that were never active... at least the post-2.6.27 kernel
makes that assumption.  A cleancache backend can keep or discard
any page it pleases... it makes sense for it to keep pages
that were previously active rather than pages that were never
active.

For zcache, we can store twice as many pages per pageframe.
But if we are storing two pages that are very unlikely
(or never going) to be used again instead of one page
that IS likely to be used again, that's probably still a bad choice.
Further, for every page that never gets used again (or gets reclaimed
before it can be used again because there's so much data streaming
through cleancache), zcache wastes the cpu cost of a page compression.
On newer machines, compression is suitably fast that this additional
cpu cost is small-ish.  On older machines, it adds up fast and that's
what Nebojsa was seeing in https://lkml.org/lkml/2011/8/17/351 

Page replacement algorithms are all about heuristics and
heuristics require information.  The WasActive flag provides
information that has proven useful to the kernel (as proven
by the 2.6.27 page replacement design rewrite) to cleancache
backends (such as zcache).

> How does the proposed fix (which we haven't actually seen)
> address the problem?

Not sure I understand... The patch as posted is the entire proposed
fix (except for the missing page bit clearing as Dave pointed out),
including for one cleancache backend (zcache).  RAMster can also
use WasActive.  It's not clear yet whether Xen tmem (or a future
KVM implementation) needs to.

Thanks again for the great feedback... after being buried in
tmem for so long, it's difficult to see another's perspective.

Dan
