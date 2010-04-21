Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0DVAE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:04:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33312 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0DVAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:04:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 22 Apr 2010 08:59:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
 PageSwapCache pages
Message-Id: <20100422085943.3d908a4b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1004210927550.4959@router.home>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>
	<1271797276-31358-5-git-send-email-mel@csn.ul.ie>
	<alpine.DEB.2.00.1004210927550.4959@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 09:30:20 -0500 (CDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 20 Apr 2010, Mel Gorman wrote:
> 
> > @@ -520,10 +521,12 @@ static int move_to_new_page(struct page *newpage, struct page *page)
> >  	else
> >  		rc = fallback_migrate_page(mapping, newpage, page);
> >
> > -	if (!rc)
> > -		remove_migration_ptes(page, newpage);
> > -	else
> > +	if (rc) {
> >  		newpage->mapping = NULL;
> > +	} else {
> > +		if (remap_swapcache)
> > +			remove_migration_ptes(page, newpage);
> > +	}
> 
> You are going to keep the migration ptes after the page has been unlocked?
> Or is remap_swapcache true if its not a swapcache page?
> 
> Maybe you meant
> 
> if (!remap_swapcache)
> 

Ah....Can I confirm my understanding ?

remap_swapcache == true only when
  The old page was ANON && it is not mapped. && it is SwapCache.

We do above check under lock_page(). So, this SwapCache is never mapped until
we release lock_page() on the old page. So, we don't use migration_pte in
this case because try_to_unmap() do nothing and don't need to call
remove_migration_pte().

If migration_pte is used somewhere...I think it's bug.

-Kame



> ?
> 
> >  	unlock_page(newpage);
> >
> 
> >
> >  skip_unmap:
> >  	if (!page_mapped(page))
> > -		rc = move_to_new_page(newpage, page);
> > +		rc = move_to_new_page(newpage, page, remap_swapcache);
> >
> > -	if (rc)
> > +	if (rc && remap_swapcache)
> >  		remove_migration_ptes(page, page);
> >  rcu_unlock:
> >
> 
> Looks like you meant !remap_swapcache
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

