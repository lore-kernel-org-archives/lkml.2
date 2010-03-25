Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab0CYCrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 22:47:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46350 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0CYCrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 22:47:21 -0400
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
In-Reply-To: <20100323120329.GE9590@csn.ul.ie>
References: <20100323050910.A473.A69D9226@jp.fujitsu.com> <20100323120329.GE9590@csn.ul.ie>
Message-Id: <20100325102342.945A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 11:47:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Mar 23, 2010 at 09:22:04AM +0900, KOSAKI Motohiro wrote:
> > > > > +	/*
> > > > > +	 * Index is between 0 and 1 so return within 3 decimal places
> > > > > +	 *
> > > > > +	 * 0 => allocation would fail due to lack of memory
> > > > > +	 * 1 => allocation would fail due to fragmentation
> > > > > +	 */
> > > > > +	return 1000 - ( (1000+(info->free_pages * 1000 / requested)) / info->free_blocks_total);
> > > > > +}
> > > > 
> > > > Dumb question.
> > > > your paper (http://portal.acm.org/citation.cfm?id=1375634.1375641) says
> > > > fragmentation_index = 1 - (TotalFree/SizeRequested)/BlocksFree
> > > > but your code have extra '1000+'. Why?
> > > 
> > > To get an approximation to three decimal places.
> > 
> > Do you mean this is poor man's round up logic?
> 
> Not exactly.
> 
> The intention is to have a value of 968 instead of 0.968231. i.e.
> instead of a value between 0 and 1, it'll be a value between 0 and 1000
> that matches the first three digits after the decimal place.

Let's consider extream case.

free_pages: 1
requested: 1
free_blocks_total: 1

frag_index = 1000  - ((1000 + 1*1000/1))/1 = -1000

This is not your intension, I guess. 
Probably we don't need any round_up/round_down logic. because fragmentation_index
is only used "if (fragindex >= 0 && fragindex <= 500)" check in try_to_compact_pages().
+1 or -1 inaccurate can be ignored. iow, I think we can remove '1000+' expression.


> > Why don't you use DIV_ROUND_UP? likes following,
> > 
> > return 1000 - (DIV_ROUND_UP(info->free_pages * 1000 / requested) /  info->free_blocks_total);
> > 
> 
> Because it's not doing the same thing unless I missed something.



