Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab2IFUih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:38:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48724 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2IFUif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:38:35 -0400
MIME-Version: 1.0
Message-ID: <e33a2c0e-3b51-4d89-a2b2-c1ed9c8f862c@default>
Date: Thu, 6 Sep 2012 13:37:41 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [RFC] mm: add support for zsmalloc and zcache
References: <<1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to this RFC for zcache promotion, I've been asked to summarize
the concerns and objections which led me to NACK the previous zcache
promotion request.  While I see great potential in zcache, I think some
significant design challenges exist, many of which are already resolved in
the new codebase ("zcache2").  These design issues include:

A) Andrea Arcangeli pointed out and, after some deep thinking, I came
   to agree that zcache _must_ have some "backdoor exit" for frontswap
   pages [2], else bad things will eventually happen in many workloads.
   This requires some kind of reaper of frontswap'ed zpages[1] which "evicts"
   the data to the actual swap disk.  This reaper must ensure it can reclaim
   _full_ pageframes (not just zpages) or it has little value.  Further the
   reaper should determine which pageframes to reap based on an LRU-ish
   (not random) approach.

B) Zsmalloc has potentially far superior density vs zbud because zsmalloc can
   pack more zpages into each pageframe and allows for zpages that cross pageframe
   boundaries.  But, (i) this is very data dependent... the average compression
   for LZO is about 2x.  The frontswap'ed pages in the kernel compile benchmark
   compress to about 4x, which is impressive but probably not representative of
   a wide range of zpages and workloads.  And (ii) there are many historical
   discussions going back to Knuth and mainframes about tight packing of data...
   high density has some advantages but also brings many disadvantages related to
   fragmentation and compaction.  Zbud is much less aggressive (max two zpages
   per pageframe) but has a similar density on average data, without the
   disadvantages of high density.

   So zsmalloc may blow zbud away on a kernel compile benchmark but, if both were
   runners, zsmalloc is a sprinter and zbud is a marathoner.  Perhaps the best
   solution is to offer both?

   Further, back to (A), reaping is much easier with zbud because (i) zsmalloc
   is currently unable to deal with pointers to zpages from tmem data structures
   which may be dereferenced concurrently, (ii) because there may be many more such
   pointers, and (iii) because zpages stored by zsmalloc may cross pageframe boundaries.
   The locking issues that arise with zsmalloc for reaping even a single pageframe
   are complex; though they might eventually be solved with zsmalloc, this is
   likely a very big project.

C) Zcache uses zbud(v1) for cleancache pages and includes a shrinker which
   reclaims pairs of zpages to release whole pageframes, but there is
   no attempt to shrink/reclaim cleanache pageframes in LRU order.
   It would also be nice if single-cleancache-pageframe reclaim could
   be implemented.

D) Ramster is built on top of zcache, but required a handful of changes
   (on the order of 100 lines).  Due to various circumstances, ramster was
   submitted as a fork of zcache with the intent to unfork as soon as
   possible.  The proposal to promote the older zcache perpetuates that fork,
   requiring fixes in multiple places, whereas the new codebase supports
   ramster and provides clearly defined boundaries between the two.

The new codebase (zcache) just submitted as part of drivers/staging/ramster
resolves these problems (though (A) is admittedly still a work in progress).
Before other key mm maintainers read and comment on zcache, I think
it would be most wise to move to a codebase which resolves the known design
problems or, at least to thoroughly discuss and debunk the design issues
described above.  OR... it may be possible to identify and pursue some
compromise plan.  In any case, I believe the promotion proposal is premature.

Unfortunately, I will again be away from email for a few days, but
will be happy to respond after I return if clarification or more detailed
discussion is needed.

Dan

Footnotes:
[1] zpage is shorthand for a compressed PAGE_SIZE-sized page.
[2] frontswap, since it uses the tmem architecture, has always had a "frontdoor
    bouncer"... any frontswap page can be rejected by zcache for any reason,
    such as if there is no non-emergency pageframes available or if any individual
    page (or long sequence of pages) compresses poorly
