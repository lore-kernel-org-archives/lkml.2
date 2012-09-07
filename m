Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab2IGOsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:48:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46210 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2IGOsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:48:41 -0400
Date: Fri, 7 Sep 2012 10:37:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
Message-ID: <20120907143751.GB4670@phenom.dumpdata.com>
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <e33a2c0e-3b51-4d89-a2b2-c1ed9c8f862c@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e33a2c0e-3b51-4d89-a2b2-c1ed9c8f862c@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> significant design challenges exist, many of which are already resolved in
> the new codebase ("zcache2").  These design issues include:
.. snip..
> Before other key mm maintainers read and comment on zcache, I think
> it would be most wise to move to a codebase which resolves the known design
> problems or, at least to thoroughly discuss and debunk the design issues
> described above.  OR... it may be possible to identify and pursue some
> compromise plan.  In any case, I believe the promotion proposal is premature.

Thank you for the feedback!

I took your comments and pasted them in this patch.

Seth, Robert, Minchan, Nitin, can you guys provide some comments pls,
so we can put them as a TODO pls or modify the patch below.

Oh, I think I forgot Andrew's comment which was:

 - Explain which workloads this benefits and provide some benchmark data.
   This should help in narrowing down in which case we know zcache works
   well and in which it does not.

My TODO's were:

 - Figure out (this could be - and perhaps should be in frontswap) a
   determination whether this swap is quite fast and the CPU is slow
   (or taxed quite heavily now), so as to not slow the currently executing
   workloads.
 - Work out automatic benchmarks in three categories: database (I am going to use
   swing for that), compile (that one is easy), and firefox tab browsers
   overloading.


>From bd85d5fa0cc231f2779f3209ee62b755caf3aa9b Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 7 Sep 2012 10:21:01 -0400
Subject: [PATCH] zsmalloc/zcache: TODO list.

Adding in comments by Dan.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/TODO   |   21 +++++++++++++++++++++
 drivers/staging/zsmalloc/TODO |   17 +++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/zcache/TODO
 create mode 100644 drivers/staging/zsmalloc/TODO

diff --git a/drivers/staging/zcache/TODO b/drivers/staging/zcache/TODO
new file mode 100644
index 0000000..bf19a01
--- /dev/null
+++ b/drivers/staging/zcache/TODO
@@ -0,0 +1,21 @@
+
+A) Andrea Arcangeli pointed out and, after some deep thinking, I came
+   to agree that zcache _must_ have some "backdoor exit" for frontswap
+   pages [2], else bad things will eventually happen in many workloads.
+   This requires some kind of reaper of frontswap'ed zpages[1] which "evicts"
+   the data to the actual swap disk.  This reaper must ensure it can reclaim
+   _full_ pageframes (not just zpages) or it has little value.  Further the
+   reaper should determine which pageframes to reap based on an LRU-ish
+   (not random) approach.
+
+B) Zcache uses zbud(v1) for cleancache pages and includes a shrinker which
+   reclaims pairs of zpages to release whole pageframes, but there is
+   no attempt to shrink/reclaim cleanache pageframes in LRU order.
+   It would also be nice if single-cleancache-pageframe reclaim could
+   be implemented.
+
+C) Offer a mechanism to select whether zbud or zsmalloc should be used.
+   This should be for either cleancache or frontswap pages. Meaning there
+   are four choices: cleancache and frontswap using zbud; cleancache and
+   frontswap using zsmalloc; cleancache using zsmalloc, frontswap using zbud;
+   cleacache using zbud, and frontswap using zsmalloc.
diff --git a/drivers/staging/zsmalloc/TODO b/drivers/staging/zsmalloc/TODO
new file mode 100644
index 0000000..b1debad
--- /dev/null
+++ b/drivers/staging/zsmalloc/TODO
@@ -0,0 +1,17 @@
+
+A) Zsmalloc has potentially far superior density vs zbud because zsmalloc can
+   pack more zpages into each pageframe and allows for zpages that cross pageframe
+   boundaries.  But, (i) this is very data dependent... the average compression
+   for LZO is about 2x.  The frontswap'ed pages in the kernel compile benchmark
+   compress to about 4x, which is impressive but probably not representative of
+   a wide range of zpages and workloads.  And (ii) there are many historical
+   discussions going back to Knuth and mainframes about tight packing of data...
+   high density has some advantages but also brings many disadvantages related to
+   fragmentation and compaction.  Zbud is much less aggressive (max two zpages
+   per pageframe) but has a similar density on average data, without the
+   disadvantages of high density.
+
+   So zsmalloc may blow zbud away on a kernel compile benchmark but, if both were
+   runners, zsmalloc is a sprinter and zbud is a marathoner.  Perhaps the best
+   solution is to offer both?
+
-- 
1.7.7.6

