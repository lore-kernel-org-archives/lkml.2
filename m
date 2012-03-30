Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929Ab2C3OLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:11:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35274
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760911Ab2C3OLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:11:06 -0400
Date: Fri, 30 Mar 2012 10:10:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/13] XFS: Fix lock ASSERT on UP
Message-ID: <20120330141058.GA19986@infradead.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
 <1332895637-32572-6-git-send-email-andi@firstfloor.org>
 <20120329232114.GA26342@infradead.org>
 <20120329235201.GF17822@one.firstfloor.org>
 <20120330041348.GF18323@dastard>
 <20120330140457.GH17822@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330140457.GH17822@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 04:04:57PM +0200, Andi Kleen wrote:
> It's really interesting how much you guys argue for your buggy construct
> which you clearly never tested on a UP build...


spin_is_locked always return 0 on UP builds, and given that XFS only
has !spin_is_locked asserts things will work just fine on UP builds
(not the !CONFIG_SMP and !CONFIG_XFS_DEBUG would be a common
combination).

In fact if you check the archives the one use of assert_spin_locked was
added exactly because some still tripped over the spin_is_locked
behaviour on UP relatively soon.

> Not sure if that is a hot path, but on highly contended locks every cache line
> fetch is quite expensive on larger systems.

It's not an overly contended lock.

> also I doubt the thing really catches bugs, and if it did you would be 
> probably better off with a sparse notation or so.

This one probably doesn't - the first occurance is just after a blocking
allocation, and the second one just before taking the lock.  So they
probably could as well just be removed.

The point that still stands is that lockdep_assert_held isn't actually
a useful replacement.
