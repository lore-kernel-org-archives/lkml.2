Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2HFPCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:02:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42858 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab2HFPCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:02:08 -0400
Date: Mon, 6 Aug 2012 10:31:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Regression in xen-netfront on v3.6 (git commit
 c48a11c7ad2623b99bbd6859b0b4234e7f11176f, netvm: propagate page->pfmemalloc
 to skb)
Message-ID: <20120806143158.GB2487@phenom.dumpdata.com>
References: <20120801190227.GA13272@phenom.dumpdata.com>
 <20120803120414.GA10670@andromeda.dapyr.net>
 <20120804110355.GA17640@andromeda.dapyr.net>
 <20120804133105.GE29814@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120804133105.GE29814@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 02:31:05PM +0100, Mel Gorman wrote:
> On Sat, Aug 04, 2012 at 07:03:55AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, Aug 03, 2012 at 08:04:14AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Wed, Aug 01, 2012 at 03:02:27PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > So I hadn't done a git bisection yet. But if I choose git commit:
> > > > 4b24ff71108164e047cf2c95990b77651163e315
> > > >     Merge tag 'for-v3.6' of git://git.infradead.org/battery-2.6
> > > > 
> > > >     Pull battery updates from Anton Vorontsov:
> > > > 
> > > > 
> > > > everything works nicely. Anything past that, so these merges:
> > > > 
> > > > konrad@phenom:~/ssd/linux$ git log --oneline --merges 4b24ff71108164e047cf2c95990b77651163e315..linus/master
> > > > 2d53492 Merge tag 'irqdomain-for-linus' of git://git.secretlab.ca/git/linux-2.6
> > > ===> ac694db Merge branch 'akpm' (Andrew's patch-bomb)
> > > 
> > > Somewhere in there is the culprit. Hadn't done yet the full bisection
> > > (was just checking out in each merge to see when it stopped working)
> > 
> > Mel, your:
> > commit c48a11c7ad2623b99bbd6859b0b4234e7f11176f
> > Author: Mel Gorman <mgorman@suse.de>
> > Date:   Tue Jul 31 16:44:23 2012 -0700
> > 
> >     netvm: propagate page->pfmemalloc to skb
> > 
> > is the culprit per git bisect. Any ideas - do the drivers need to do
> > some extra processing? Here is the git bisect log
> > 
> 
> The problem appears to be at drivers/net/xen-netfront.c#973 where it
> calls __skb_fill_page_desc(skb, 0, NULL, 0, 0) . The driver does not
> have to do extra processing as such but I did not expect NULL to be
> passed in like this. Can you check if this fixes the bug please?

That does it!
.. snip..
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  include/linux/skbuff.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7632c87..8857669 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1256,7 +1256,7 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
>  	 * do not lose pfmemalloc information as the pages would not be
>  	 * allocated using __GFP_MEMALLOC.
>  	 */
> -	if (page->pfmemalloc && !page->mapping)
> +	if (page && page->pfmemalloc && !page->mapping)
>  		skb->pfmemalloc	= true;
>  	frag->page.p		  = page;
>  	frag->page_offset	  = off;
