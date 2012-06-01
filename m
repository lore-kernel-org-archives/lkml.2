Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965365Ab2FAQMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:12:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965287Ab2FAQMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:12:13 -0400
Date: Fri, 1 Jun 2012 12:12:05 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120601161205.GA1918@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
References: <20120530163317.GA13189@redhat.com>
 <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
 <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 01:44:44AM -0700, Hugh Dickins wrote:

 > Please give this patch a try (preferably on current git), and let us know.
 > 
 > Thanks,
 > Hugh
 > 
 > --- 3.4.0+/mm/migrate.c	2012-05-27 10:01:43.104049010 -0700
 > +++ linux/mm/migrate.c	2012-06-01 00:10:58.080098749 -0700
 > @@ -436,7 +436,10 @@ void migrate_page_copy(struct page *newp
 >  		 * is actually a signal that all of the page has become dirty.
 >  		 * Whereas only part of our page may be dirty.
 >  		 */
 > -		__set_page_dirty_nobuffers(newpage);
 > +		if (PageSwapBacked(page))
 > +			SetPageDirty(newpage);
 > +		else
 > +			__set_page_dirty_nobuffers(newpage);
 >   	}
 >  
 >  	mlock_migrate_page(newpage, page);
 > --- 3.4.0+/mm/page-writeback.c	2012-05-29 08:09:58.304806782 -0700
 > +++ linux/mm/page-writeback.c	2012-06-01 00:23:43.984116973 -0700
 > @@ -1987,7 +1987,10 @@ int __set_page_dirty_nobuffers(struct pa
 >  		mapping2 = page_mapping(page);
 >  		if (mapping2) { /* Race with truncate? */
 >  			BUG_ON(mapping2 != mapping);
 > -			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 > +			if (WARN_ON(!PagePrivate(page) && !PageUptodate(page)))
 > +				print_symbol(KERN_WARNING
 > +				    "mapping->a_ops->writepage: %s\n",
 > +				    (unsigned long)mapping->a_ops->writepage);
 >  			account_page_dirtied(page, mapping);
 >  			radix_tree_tag_set(&mapping->page_tree,
 >  				page_index(page), PAGECACHE_TAG_DIRTY);

So with this applied, I don't seem to be able to trigger it. It's been running two hours
so far. I'll leave it running, but right now I don't know what to make of this.

	Dave
