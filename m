Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2A0Rcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:32:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17624 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2A0Rcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:32:54 -0500
MIME-Version: 1.0
Message-ID: <3ac611ee-8830-41bd-8464-6867da701948@default>
Date: Fri, 27 Jan 2012 09:32:39 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>,
        lsf-pc@lists.linux-foundation.org
Subject: RE: [PATCH] mm: implement WasActive page flag (for improving
 cleancache)
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
 <4F218D36.2060308@linux.vnet.ibm.com>
 <9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
 <20120126163150.31a8688f.akpm@linux-foundation.org>
 <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
 <20120126171548.2c85dd44.akpm@linux-foundation.org>
 <7198bfb3-1e32-40d3-8601-d88aed7aabd8@default>
 <1327671787.2977.17.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1327671787.2977.17.camel@dabdike.int.hansenpartnership.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020209.4F22DFB6.0048,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Subject: RE: [PATCH] mm: implement WasActive page flag (for improving cleancache)
> 
> On Thu, 2012-01-26 at 18:43 -0800, Dan Magenheimer wrote:
> > > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > > It really didn't tell us anything, apart from referring to vague
> > > "problems on streaming workloads", which forces everyone to go off and
> > > do an hour or two's kernel archeology, probably in the area of
> > > readahead.
> > >
> > > Just describe the problem!  Why is it slow?  Where's the time being
> > > spent?  How does the proposed fix (which we haven't actually seen)
> > > address the problem?  If you inform us of these things then perhaps
> > > someone will have a useful suggestion.  And as a side-effect, we'll
> > > understand cleancache better.
> >
> > Sorry, I'm often told that my explanations are long-winded so
> > as a result I sometimes err on the side of brevity...
> >
> > The problem is that if a pageframe is used for a page that is
> > very unlikely (or never going) to be used again instead of for
> > a page that IS likely to be used again, it results in more
> > refaults (which means more I/O which means poorer performance).
> > So we want to keep pages that are most likely to be used again.
> > And pages that were active are more likely to be used again than
> > pages that were never active... at least the post-2.6.27 kernel
> > makes that assumption.  A cleancache backend can keep or discard
> > any page it pleases... it makes sense for it to keep pages
> > that were previously active rather than pages that were never
> > active.
> >
> > For zcache, we can store twice as many pages per pageframe.
> > But if we are storing two pages that are very unlikely
> > (or never going) to be used again instead of one page
> > that IS likely to be used again, that's probably still a bad choice.
> > Further, for every page that never gets used again (or gets reclaimed
> > before it can be used again because there's so much data streaming
> > through cleancache), zcache wastes the cpu cost of a page compression.
> > On newer machines, compression is suitably fast that this additional
> > cpu cost is small-ish.  On older machines, it adds up fast and that's
> > what Nebojsa was seeing in https://lkml.org/lkml/2011/8/17/351
> >
> > Page replacement algorithms are all about heuristics and
> > heuristics require information.  The WasActive flag provides
> > information that has proven useful to the kernel (as proven
> > by the 2.6.27 page replacement design rewrite) to cleancache
> > backends (such as zcache).
> 
> So this sounds very similar to the recent discussion which I cc'd to
> this list about readahead:
> 
> http://marc.info/?l=linux-scsi&m=132750980203130
> 
> It sounds like we want to measure something similar (whether a page has
> been touched since it was brought in).  It isn't exactly your WasActive
> flag because we want to know after we bring a page in for readahead was
> it ever actually used, but it's very similar.

Agreed, there is similarity here.
 
> What I was wondering was instead of using a flag, could we make the LRU
> lists do this for us ... something like have a special LRU list for
> pages added to the page cache but never referenced since added?  It
> sounds like you can get your WasActive information from the same type of
> LRU list tricks (assuming we can do them).

Hmmm... I think this would mean more LRU queues but that may be
the right long term answer.  Something like?

	read but not used yet LRU
	readahead but not used yet LRU
	active LRU
	previously active LRU

Naturally, this then complicates the eviction selection process.

> I think the memory pressure eviction heuristic is: referenced but not
> recently used pages first followed by unreferenced and not recently used
> readahead pages.  The key being to keep recently read in readahead pages
> until last because there's a time between doing readahead and getting
> the page accessed and we don't want to trash a recently red in readahead
> page only to have the process touch it and find it has to be read in
> again.

I suspect that any further progress on the page replacement heuristics
is going to require more per-page data to be stored.  Which means
that it probably won't work under the constraints of 32-bit systems.
So it might also make sense to revisit when/whether to allow the
heuristics to be better on a 64-bit system than on a 32-bit.
(Even ARM now has 64-bit processors!)  I put this on my topic list
for LSF/MM, though I have no history of previous discussion so
this may already have previously been decided.
