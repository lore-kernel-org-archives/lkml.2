Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2HOPYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:24:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34478 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2HOPYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:24:23 -0400
MIME-Version: 1.0
Message-ID: <de4d2944-7b3e-4005-8a96-d5a18fa6740d@default>
Date: Wed, 15 Aug 2012 08:23:33 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: RE: [PATCH 0/7] zram/zsmalloc promotion
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
 <20120814023530.GA9787@kroah.com> <5029E3EF.9080301@vflare.org>
 <502A8D4D.3080101@linux.vnet.ibm.com>
In-Reply-To: <502A8D4D.3080101@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On a second thought, I think zsmalloc should stay in drivers/block/zram
> > since zram is now the only user of zsmalloc since zcache and ramster are
> > moving to another allocator.
> 
> The removal of zsmalloc from zcache has not been agreed upon
> yet.
> 
> Dan _suggested_ removing zsmalloc as the persistent
> allocator for zcache in favor of zbud to solve "flaws" in
> zcache.

(Correction: Dan has _coded_, _tested_ and _published_ _working_
code that removes zsmalloc ;-)

> However, zbud has large deficiencies.
> 
> A zero-filled 4k page will compress with LZO to 103 bytes.
> zbud can only store two compressed pages in each memory pool
> page, resulting in 95% fragmentation (i.e. 95% of the memory
> pool page goes unused).  While this might not be a typical
> case, it is the worst case and absolutely does happen.
> 
> zbud's design also effectively limits the useful page
> compression to 50%. If pages are compressed beyond that, the
> added space savings is lost in memory pool fragmentation.
> For example, if two pages compress to 30% of their original
> size, those two pages take up 60% of the zbud memory pool
> page, and 40% is lost to fragmentation because zbud can't
> store anything in the remaining space.
> 
> To say it another way, for every two page cache pages that
> cleancache stores in zcache, zbud _must_ allocate a memory
> pool page, regardless of how well those pages compress.
> This reduces the efficiency of the page cache reclaim
> mechanism by half.

All very true, but these are not zbud deficiencies.
They are design choices to ensure predictability so that
pageframes can be reclaimed when the cache gets full.
NOT zpages but complete pageframes, since this is what
the rest of the kernel uses.  And zbud handles LRU
ordering also.

Basic computer science principles tell us that maximizing
storage density (as zsmalloc does) has major negative
consequences especially when random fragments are freed,
as is true for the random frontswap access patterns.  You
don't get higher density without much higher complexity.
This is a fundamental design tradeoff for zcache.
 
> I have posted some work (zsmalloc shrinker interface, user
> registered alloc/free functions for the zsmalloc memory
> pool) that begins to make zsmalloc a suitable replacement
> for zbud, but that work was put on hold until the path out
> of staging was established.
>
> I'm hoping to continue this work once the code is in
> mainline.  While zbud has deficiencies, it doesn't prevent
> zcache from having value as I have already demonstrated.
> However, replacing zsmalloc with zbud would step backward
> for the reasons mentioned above.

Please do continue this work.  But there was no indication
that you had even begun to think through all the consequences
of concurrent access or LRU pageframe reclaim.  I did think
through them and concluded that the issues were far more complex
with zsmalloc than zbud (and would be happy to explain further).
So I solved the issues with zbud and got both parts of zcache
(frontswap and cleancache) working fully with zbud.

In other words, IMHO the existing zsmalloc will need to evolve
a great deal to work with the complete needs of zcache.  If
you can get both maximal density AND concurrency AND LRU
pageframe reclaim all working with zsmalloc, and fully test
it (with zcache) and publish it, I would support moving to
this "new" zsmalloc instantly.

> I do not support the removal of zsmalloc from zcache.  As
> such, I think the zsmalloc code should remain independent.

Zcache must move forward to meet the needs of a broader set
of workloads and distros and users, not just the limited
toy benchmarking you have provided.  Zsmalloc has not yet
proven capable of meeting those needs.  It may be capable
in the future but it cannot meet them now.

Dan

P.S. I think zsmalloc IS a good match for zram so I do not
object to the promotion of zsmalloc as part of promoting zram.
Would be happy to explain technical details further if this
surprises anyone.
