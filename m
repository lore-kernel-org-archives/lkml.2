Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2LUCwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:52:06 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36773 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2LUCu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:50:57 -0500
Date: Thu, 20 Dec 2012 21:49:57 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] mm: vmscan: clean up get_scan_count()
Message-ID: <20121221024957.GE7147@cmpxchg.org>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
 <1355767957-4913-6-git-send-email-hannes@cmpxchg.org>
 <20121219160805.658f724f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219160805.658f724f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 04:08:05PM -0800, Andrew Morton wrote:
> On Mon, 17 Dec 2012 13:12:35 -0500
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Reclaim pressure balance between anon and file pages is calculated
> > through a tuple of numerators and a shared denominator.
> > 
> > Exceptional cases that want to force-scan anon or file pages configure
> > the numerators and denominator such that one list is preferred, which
> > is not necessarily the most obvious way:
> > 
> >     fraction[0] = 1;
> >     fraction[1] = 0;
> >     denominator = 1;
> >     goto out;
> > 
> > Make this easier by making the force-scan cases explicit and use the
> > fractionals only in case they are calculated from reclaim history.
> > 
> > And bring the variable declarations/definitions in order.
> > 
> > ...
> >
> > +	u64 fraction[2], uninitialized_var(denominator);
> 
> Using uninitialized_var() puts Linus into rant mode.  Unkindly, IMO:
> uninitialized_var() is documentarily useful and reduces bloat.  There is
> a move afoot to replace it with
> 
> 	int foo = 0;	/* gcc */
> 
> To avoid getting ranted at we can do
> 
> --- a/mm/vmscan.c~mm-vmscan-clean-up-get_scan_count-fix
> +++ a/mm/vmscan.c
> @@ -1658,7 +1658,8 @@ static void get_scan_count(struct lruvec
>  			   unsigned long *nr)
>  {
>  	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
> -	u64 fraction[2], uninitialized_var(denominator);
> +	u64 fraction[2];
> +	u64 denominator = 0;
>  	struct zone *zone = lruvec_zone(lruvec);
>  	unsigned long anon_prio, file_prio;
>  	enum scan_balance scan_balance;

Makes sense, I guess, but then you have to delete this line from the
changelog:

"And bring the variable declarations/definitions in order."

Or change it to "partial" order or something... :-)

