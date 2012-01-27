Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2A0A4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:56:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24624 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2A0A4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:56:45 -0500
MIME-Version: 1.0
Message-ID: <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
Date: Thu, 26 Jan 2012 16:56:34 -0800 (PST)
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
In-Reply-To: <20120126163150.31a8688f.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F21F63E.00C9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)

Thanks for the reply!
 
> On Thu, 26 Jan 2012 13:28:02 -0800 (PST)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > I do think it also needs to get cleared on the way in to the page
> > > allocator.  Otherwise:
> > >
> > > 	PageSetWasActive(page);
> > > 	free_page(page);
> > > 	...
> > > 	another_user_page = get_free_page()
> > > 	// now cleancache sees the active bit for the prev user
> > >
> > > Or am I missing somewhere it gets cleared non-explicitly somewhere?
> >
> > True, it is not getting cleared and it should be, good catch!
> 
> It should be added to PAGE_FLAGS_CHECK_AT_FREE.

I was thinking of clearing it in free_pages_prepare() before the
call to free_pages_check().  Does that make sense?  If so, then
it could also be added to PAGE_FLAGS_CHECK_AT_FREE, though it might
be a bit redundant.

> > I'll find the place to add the call to ClearPageWasActive() for v2.
> 
> AFAICT this patch consumes our second-last page flag, or close to it.
> We'll all be breaking out in hysterics when the final one is gone.

I'd be OK with only using this on 64-bit systems, though there
are ARM folks playing with zcache that might disagree.  Am I
correct in assuming that your "second-last page flag" concern
applies only to 32-bit systems?

> This does appear to be a make or break thing for cleancache - if we
> can't fix https://lkml.org/lkml/2012/1/22/61 then cleancache is pretty
> much a dead duck.

Hmmm... is that URL correct?  If so, there is some subtlety in
that thread that I am missing as I don't understand the relationship
to cleancache at all?

> But I'm going to ask for great effort to avoid
> consuming another page flag.  Either fix cleancache via other means or,
> much less desirably, find an existing page flag and overload it.

Cleancache isn't broken.  The fix is not a requirement for other
cleancache users (Xen and RAMster), though it is definitely useful.
It's not a _requirement_ for zcache either but definitely helps on
certain workloads and systems, see below.

> And I'm afraid that neither I nor other MM developers are likely to
> help you with "fix cleancache via other means" because we weren't
> provided with any description of what the problem is within cleancache,
> nor how it will be fixed.  All we are given is the assertion "cleancache
> needs this".

The patch comment says:

The patch resolves issues reported with cleancache which occur
especially during streaming workloads on older processors,
see https://lkml.org/lkml/2011/8/17/351

I can see that may not be sufficient, so let me expand on it.

First, just as page replacement worked prior to the active/inactive
redesign at 2.6.27, cleancache works without the WasActive page flag.
However, just as pre-2.6.27 page replacement had problems on
streaming workloads, so does cleancache.  The WasActive page flag
is an attempt to pass the same active/inactive info gathered by
the post-2.6.27 kernel into cleancache, with the same objectives and
presumably the same result: improving the "quality" of pages preserved
in memory thus reducing refaults.

Is that clearer?  If so, I'll do better on the description at v2.

Thanks,
Dan
