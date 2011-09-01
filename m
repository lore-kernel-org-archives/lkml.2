Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab1IAXo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 19:44:28 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42155 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab1IAXo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 19:44:27 -0400
Subject: Re: [PATCH 0/3] staging: zcache: xcfmalloc support
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, ngupta@vflare.org, cascardo@holoscopio.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
In-Reply-To: <4E6000C4.7030007@linux.vnet.ibm.com>
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default 4E5EB066.6020007@linux.vnet.ibm.com>
	 <36dad993-ea60-43f4-89f0-77831befd483@default>
	 <4E5FB3CF.3020703@linux.vnet.ibm.com> <1314896087.13161.30.camel@nimitz>
	 <4E6000C4.7030007@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 16:44:23 -0700
Message-ID: <1314920663.6393.18.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 17:01 -0500, Seth Jennings wrote:
> I was seeing n as the number of allocations.  Since 
> XCF_MAX_BLOCKS_PER_ALLOC and XCF_NUM_FREELISTS are constant (i.e.
> not increasing with the number of allocations) wouldn't it be
> O(1)?

It's the difference between your implementation and the _algorithm_
you've chosen.  If someone doubled XCF_MAX_BLOCKS_PER_ALLOC and
XCF_NUM_FREELISTS, you'd see the time quadruple, not stay constant.
That's a property of the _algorithm_.

> > xcfmalloc's big compromise is that it doesn't do any searching or
> > fitting.  It might needlessly split larger blocks when two small ones
> > would have worked, for instance.
> 
> Splitting a larger block is the last option.  I might not
> be understanding you correctly, but find_remove_block() does try to
> find the optimal block to use, which is "searching and fitting" in my
> mind.

I don't want to split hairs on the wording.  It's obvious, though, that
xcfmalloc does not find _optimal_ fits.  It also doesn't use the
smallest-possible blocks to fit the alloction.  Consider if you wanted a
1000 byte allocation (with 10 100-byte buckets and no metadata for
simplicity), and had 4 blocks:

        900
        500,500,500

I think it would split a 500 into 100,400, and leave the 400:
        
        500,500
        400

It took the largest (most valuable) block, and split a 500 block when it
didn't have to.  The reason it doesn't do this is that it doesn't
_search_.  It just indexes and guesses.  That's *fast*, but it errs on
the side of speed rather than being optimal.  That's OK, we do it all
the time, but it *is* a compromise.  We should at least be thinking of
the cases when this doesn't perform well.

-- Dave

