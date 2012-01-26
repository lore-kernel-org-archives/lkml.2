Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2AZV2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:28:19 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17541 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2AZV2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:28:17 -0500
MIME-Version: 1.0
Message-ID: <9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
Date: Thu, 26 Jan 2012 13:28:02 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>
Subject: RE: [PATCH] mm: implement WasActive page flag (for improving
 cleancache)
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
 <4F218D36.2060308@linux.vnet.ibm.com>
In-Reply-To: <4F218D36.2060308@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F21C55E.0059,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
> Subject: Re: [PATCH] mm: implement WasActive page flag (for improving cleancache)

Thanks for the review Dave!
 
> On 01/25/2012 01:58 PM, Dan Magenheimer wrote:
> > (Feedback welcome if there is a different/better way to do this
> > without using a page flag!)
> >
> > Since about 2.6.27, the page replacement algorithm maintains
> > an "active" bit to help decide which pages are most eligible
> > to reclaim, see http://linux-mm.org/PageReplacementDesign
> >
> > This "active' information is also useful to cleancache but is lost
> > by the time that cleancache has the opportunity to preserve the
> > pageful of data.  This patch adds a new page flag "WasActive" to
> > retain the state.  The flag may possibly be useful elsewhere.
> 
> I guess cleancache itself is clearing the bit, right?  I didn't see any
> clearing going on in the patch.

No, there are no changes in cleancache.c so it isn't clearing
the bit.

> I do think it also needs to get cleared on the way in to the page
> allocator.  Otherwise:
> 
> 	PageSetWasActive(page);
> 	free_page(page);
> 	...
> 	another_user_page = get_free_page()
> 	// now cleancache sees the active bit for the prev user
> 
> Or am I missing somewhere it gets cleared non-explicitly somewhere?

True, it is not getting cleared and it should be, good catch!

I'll find the place to add the call to ClearPageWasActive() for v2.

Thanks,
Dan

