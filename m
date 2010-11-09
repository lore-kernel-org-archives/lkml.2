Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0KIDau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:30:50 -0500
Received: from THUNK.ORG ([69.25.196.29]:35768 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0KIDat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:30:49 -0500
Date: Mon, 8 Nov 2010 22:30:38 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com,
        cmm@us.ibm.com, cluster-devel@redhat.com
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109033038.GF3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
	cluster-devel@redhat.com
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109011222.GD2715@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:12:22PM +1100, Dave Chinner wrote:
> Hole punching was not included originally in fallocate() for a
> variety of reasons. IIRC, they were along the lines of:
> 
> 	1 de-allocating of blocks in an allocation syscall is wrong.
> 	  People wanted a new syscall for this functionality.
> 	2 no glibc interface needs it
> 	3 at the time, only XFS supported punching holes, so there
> 	  is not need to support it in a generic interface
> 	4 the use cases presented were not considered compelling
> 	  enough to justify the additional complexity (!)
> 
> In the end, I gave up arguing for it to be included because just
> getting the FALLOC_FL_KEEP_SIZE functionality was a hard enough
> battle.
> 
> Anyway, #3 isn't the case any more, #4 was just an excuse not to
> support anything ext4 couldn't do and lots of apps are calling
> fallocate directly (because glibc can't use FALLOC_FL_KEEP_SIZE) so
> #2 isn't an issue, either.

I don't recall anyone arguing #4 because of ext4, but I get very tired
of the linux-fsdevel bike-shed painting parties, so I often will
concede whatever is necessary just to get the !@#! interface in,
assuming we could add more flags later....

glibc does support fallocate(), BTW; it's just posix_fallocate() that
doesn't use FALLOC_FL_KEEP_SIZE.

> I guess that leaves #1 to be debated;
> I don't think there is any problem with doing what you propose.

I don't have a problem either.

As a completely separate proposal, what do people think about an
FALLOCATE_FL_ZEROIZE after which time the blocks are allocated, but
reading from them returns zero.  This could be done either by (a)
sending a discard in the case of devices where discard_zeros_data is
true and discard_granularty is less than the fs block size, or (b) by
setting the uninitialized flag in the extent tree.

						- Ted
