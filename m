Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1IAPS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:18:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:57404 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab1IAPS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:18:57 -0400
MIME-Version: 1.0
Message-ID: <36dad993-ea60-43f4-89f0-77831befd483@default>
Date: Thu, 1 Sep 2011 08:17:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, ngupta@vflare.org,
        cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH 0/3] staging: zcache: xcfmalloc support
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default
 4E5EB066.6020007@linux.vnet.ibm.com>
In-Reply-To: <4E5EB066.6020007@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4E5FA24B.003C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do you have any data comparing xcfmalloc vs xvmalloc for
> > compression ratio and/or performance (cycles to compress
> > or decompress different pages) on a wide(r) range of data?
> > Assuming xcfmalloc isn't "always better", maybe it would
> > be best to allow the algorithm to be selectable?  (And
> > then we would also need to decide the default.)
> >
> 
> I can get you some results comparing the two tomorrow.
> 
> You have to make the distinction between the
> "compression ratio" and the "effective compression".
> The compression ratio is the same since the compression
> algorithm, LZO, was changed.  The effective compression,

changed -> NOT changed, correct? LZO is used in both?
I had forgotten that, so the only issue might be the
overhead.

> the ratio of stored compressed pages to allocator pool
> pages, is different between the two, especially for
> allocation sets > PAGE_SIZE/2.
 
> What the numbers will tell you is that for allocations sets
> < PAGE_SIZE/2 xcfmalloc is a little worse (~2% greater
> overhead).  But for allocation sets > PAGE_SIZE/2,
> xcfmalloc has up to a 50% advantage over xvmalloc.
> 
> As far as performance numbers, all I can see is that
> the throughput is the same between the two.  I'm not
> sure how to get, for example, and cycles delta
> between the two.

IIRC, xvmalloc has O(1) overhead regardless of the number
of chunks of data stored.  Some algorithms are O(N) or
even O(N**2), i.e. might walk a potentially increasingly
very long list of allocations/descriptors
to find a slot, which would not be acceptable for
zcache as, for a large data set, the overhead might
be much worse than the cycles-to-compress.  Which is
xcfmalloc, O(1) or O(N) or O(N**2)?

(Also, since I think interrupts are still disabled,
reading the tsc before/after should be safe to
get the cycles delta.)

> I would be difficult to make it selectable because the
> function signatures (and some concepts) aren't the same.
> You can see the changes that were required in the patch
> 2/3.

Then I definitely would like to see some review
and discussion from Nitin.  Clearly xcfmalloc is better
for poorly-compressible data; I would like to be confident
that it is not "worse" for another large common set of
data.

An even better implementation could be if both are
active and the selection is made at runtime depending
on the compressibility of the data, i.e. poorly-compressible
data gets stored in xcfmalloc and other data in xvmalloc?
Probably not worth the effort, but food for thought.

Thanks,
Dan
