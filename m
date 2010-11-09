Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0KIXll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:41:41 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:50091 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166Ab0KIXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:41:40 -0500
Date: Wed, 10 Nov 2010 10:40:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Ted Ts'o" <tytso@mit.edu>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
        cluster-devel@redhat.com
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101109234049.GQ2715@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
 <20101109044242.GH2715@dastard>
 <20101109214147.GK3099@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101109214147.GK3099@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 04:41:47PM -0500, Ted Ts'o wrote:
> On Tue, Nov 09, 2010 at 03:42:42PM +1100, Dave Chinner wrote:
> > Implementation is up to the filesystem. However, XFS does (b)
> > because:
> > 
> > 	1) it was extremely simple to implement (one of the
> > 	   advantages of having an exceedingly complex allocation
> > 	   interface to begin with :P)
> > 	2) conversion is atomic, fast and reliable
> > 	3) it is independent of the underlying storage; and
> > 	4) reads of unwritten extents operate at memory speed,
> > 	   not disk speed.
> 
> Yeah, I was thinking that using a device-style TRIM might be better
> since future attempts to write to it won't require a separate seek to
> modify the extent tree.  But yeah, there are a bunch of advantages of
> simply mutating the extent tree.
> 
> While we're on the subject of changes to fallocate, what do people
> think of FALLOC_FL_EXPOSE_OLD_DATA, which requires either root
> privileges or (if capabilities are in use) CAP_DAC_OVERRIDE &&
> CAP_MAC_OVERRIDE && CAP_SYS_ADMIN.  This would allow a trusted process
> to fallocate blocks with the extent already marked initialized.  I've
> had two requests for such functionality for ext4 already.  

We removed that ability from XFS about three years ago because it's
a massive security hole. e.g. what happens if the file is world
readable, even though the process that called
FALLOC_FL_EXPOSE_OLD_DATA was privileged and was allowed to expose
such data? Or the file is chmod 777 after being exposed?

The historical reason for such behaviour existing in XFS was that in
1997 the CPU and IO latency cost of unwritten extent conversion was
significant, so users with real physical security (i.e. marines with
guns) were able to make use of fast preallocation with no conversion
overhead without caring about the security implications. These days,
the performance overhead of unwritten extent conversion is minimal -
I generally can't measure a difference in IO performance as a result
of it - so there is simply no good reaѕon for leaving such a gaping
security hole in the system.

If anyone wants to read the underlying data, then use fiemap to map
the physical blocks and read it directly from the block device. That
requires root privileges but does not open any new stale data
exposure problems....

> (Take for example a trusted cluster filesystem backend that checks the
> object checksum before returning any data to the user; and if the
> check fails the cluster file system will try to use some other replica
> stored on some other server.)

IOWs, all they want to do is avoid the unwritten extent conversion
overhead. Time has shown that a bad security/performance tradeoff
decision was made 13 years ago in XFS, so I see little reason to
repeat it for ext4 today....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
