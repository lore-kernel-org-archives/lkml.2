Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0CZDKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:10:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37948 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0CZDKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:10:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 06/11] Export fragmentation index via /proc/extfrag_index
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100325141142.GS2024@csn.ul.ie>
References: <20100325200919.6C8F.A69D9226@jp.fujitsu.com> <20100325141142.GS2024@csn.ul.ie>
Message-Id: <20100326120844.6C9B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Mar 2010 12:10:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 25, 2010 at 08:20:04PM +0900, KOSAKI Motohiro wrote:
> > > On Thu, Mar 25, 2010 at 11:47:17AM +0900, KOSAKI Motohiro wrote:
> > > > > On Tue, Mar 23, 2010 at 09:22:04AM +0900, KOSAKI Motohiro wrote:
> > > > > > > > > +	/*
> > > > > > > > > +	 * Index is between 0 and 1 so return within 3 decimal places
> > > > > > > > > +	 *
> > > > > > > > > +	 * 0 => allocation would fail due to lack of memory
> > > > > > > > > +	 * 1 => allocation would fail due to fragmentation
> > > > > > > > > +	 */
> > > > > > > > > +	return 1000 - ( (1000+(info->free_pages * 1000 / requested)) / info->free_blocks_total);
> > > > > > > > > +}
> > > > > > > > 
> > > > > > > > Dumb question.
> > > > > > > > your paper (http://portal.acm.org/citation.cfm?id=1375634.1375641) says
> > > > > > > > fragmentation_index = 1 - (TotalFree/SizeRequested)/BlocksFree
> > > > > > > > but your code have extra '1000+'. Why?
> > > > > > > 
> > > > > > > To get an approximation to three decimal places.
> > > > > > 
> > > > > > Do you mean this is poor man's round up logic?
> > > > > 
> > > > > Not exactly.
> > > > > 
> > > > > The intention is to have a value of 968 instead of 0.968231. i.e.
> > > > > instead of a value between 0 and 1, it'll be a value between 0 and 1000
> > > > > that matches the first three digits after the decimal place.
> > > > 
> > > > Let's consider extream case.
> > > > 
> > > > free_pages: 1
> > > > requested: 1
> > > > free_blocks_total: 1
> > > > 
> > > > frag_index = 1000  - ((1000 + 1*1000/1))/1 = -1000
> > > > 
> > > > This is not your intension, I guess. 
> > > 
> > > Why not?
> > > 
> > > See this comment
> > > 
> > > /* Fragmentation index only makes sense when a request would fail */
> > > 
> > > In your example, there is a free page of the requested size so the allocation
> > > would succeed. In this case, fragmentation index does indeed go negative
> > > but the value is not useful.
> > >
> > > > Probably we don't need any round_up/round_down logic. because fragmentation_index
> > > > is only used "if (fragindex >= 0 && fragindex <= 500)" check in try_to_compact_pages().
> > > > +1 or -1 inaccurate can be ignored. iow, I think we can remove '1000+' expression.
> > > > 
> > > 
> > > This isn't about rounding, it's about having a value that normally is
> > > between 0 and 1 expressed as a number between 0 and 1000 because we
> > > can't use double in the kernel.
> > 
> > Sorry, My example was wrong. new example is here.
> > 
> > free_pages: 4
> > requested: 2
> > free_blocks_total: 4
> > 
> > theory: 1 - (TotalFree/SizeRequested)/BlocksFree
> >             = 1 - (4/2)/4 = 0.5
> > 
> > code : 1000 - ((1000 + 4*1000/2))/4 = 1000 - (1000 + 2000)/4 = 1000/4 = 250
> > 
> > I don't think this is three decimal picking up code. This seems might makes
> > lots compaction invocation rather than theory.
> > 
> 
> Ok, I cannot apologise for this enough.
> 
> Since that paper was published, further work showed that the equation could
> be much improved. As part of that, I updated the equation to the following;
> 
> double index = 1    - ( (1    + ((double)info->free_pages        / requested)) / info->free_blocks_total);
> 
> or when approximated to three decimal places
> 
> int index =    1000 - ( (1000 + (        info->free_pages * 1000 / requested)) / info->free_blocks_total);
> 
> Your analysis of the paper is perfect. When slotted into a driver program
> with your example figures, I get the following results
> 
> old equation = 0.500000
> current equation = 0.250000
> integer approximation = 250
> 
> The code as-is is correct and is what I intended. My explanation on the
> other hand sucks and I should have remembered that I updated equation since
> I published that paper 2 years ago.
> 
> Again, I am extremely sorry for misleading you.

No worry at all. it is merely review. I have no objection this equation if it is intentional. :)



