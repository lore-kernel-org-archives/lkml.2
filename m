Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2IQUmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:42:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17321 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2IQUms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:42:48 -0400
MIME-Version: 1.0
Message-ID: <e5d08804-a542-4778-a103-b14b553b0747@default>
Date: Mon, 17 Sep 2012 13:42:30 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <e33a2c0e-3b51-4d89-a2b2-c1ed9c8f862c@default>
 <20120907143751.GB4670@phenom.dumpdata.com> <504C1100.2050300@vflare.org>
In-Reply-To: <504C1100.2050300@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nitin Gupta [mailto:ngupta@vflare.org]
> Subject: Re: [RFC] mm: add support for zsmalloc and zcache
> 
> The problem is that zbud performs well only when a (compressed) page is
> either PAGE_SIZE/2 - e or PAGE_SIZE - e, where e is small. So, even if
> the average compression ratio is 2x (which is hard to believe), a
> majority of sizes can actually end up in PAGE_SIZE/2 + e bucket and zbud
> will still give bad performance.  For instance, consider these histograms:

Whoa whoa whoa.  This is very wrong.  Zbud handles compressed pages
of any range that fits in a pageframe (same, almost, as zsmalloc).
Unless there is some horrible bug you found...

Zbud _does_ require the _distribution_ of zsize to be roughly
centered around PAGE_SIZE/2 (or less).  Is that what you meant?
If so, the following numbers you posted don't make sense to me.
Could you be more explicit on what the numbers mean?

Also, as you know, unlike zram, the architecture of tmem/frontswap
allows zcache to reject any page, so if the distribution of zsize
exceeds PAGE_SIZE/2, some pages can be rejected (and thus passed
through to swap).  This safety valve already exists in zcache (and zcache2)
to avoid situations where zpages would otherwise significantly
exceed half of total pageframes allocated.  IMHO this is a
better policy than accepting a large number of poorly-compressed pages,
i.e. if every data page compresses down from 4096 bytes to 4032
bytes, zsmalloc stores them all (thus using very nearly one pageframe
per zpage), whereas zbud avoids the anomalous page sequence altogether.
 
> # Created tar of /usr/lib (2GB) on a fairly loaded Linux system and
> compressed page-by-page using LZO:
> 
> # first two fields: bin start, end.  Third field: compressed size
> 32 286 7644
> :
> 3842 4096 3482
> 
> The only (approx) sweetspots for zbud are 1810-2064 and 3842-4096 which
> covers only a small fraction of pages.
> 
> # same page-by-page compression for 220MB ISO from project Gutenberg:
> 32 286 70
> :
> 3842 4096 804
> 
> Again very few pages in zbud favoring bins.
> 
> So, we really need zsmalloc style allocator which handles sizes all over
> the spectrum. But yes, compaction remains far easier to implement on zbud.

So it remains to be seen if a third choice exists (which might be either
an enhanced zbud or an enhanced zsmalloc), right?

Dan
