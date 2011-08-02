Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1HBME5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:04:57 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28956 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120Ab1HBMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:04:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AksEAH3lN055LCkBgWdsb2JhbABCp2AVAQEWJiWBQAEBBAE6HCMQCAMYLhQlAyETh2zBCQ6FVV8Eo3E
Date: Tue, 2 Aug 2011 22:04:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110802120445.GF12870@dastard>
References: <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
 <20110801112330.GA27190@infradead.org>
 <20110801165242.GA18802@infradead.org>
 <20110802114428.GA6014@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802114428.GA6014@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 07:44:28PM +0800, Wu Fengguang wrote:
> On Tue, Aug 02, 2011 at 12:52:42AM +0800, Christoph Hellwig wrote:
> > wb_check_background_flush is indeed what we're hitting.
> 
> That means s_umount is NOT held by another queued writeback work.

Right. We already kind of knew that was ocurring because there's
a remount,ro going on.

> 
> > See the trace output using a patch inspired by Curt's below:
> > 
> > # tracer: nop
> > #
> > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > #              | |       |          |         |
> >            <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
> >            <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
> >            <...>-4279  [000]   113.034052: writeback_grab_super_failed: bdi 7:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=wb_check_background_flush
> 
> What's that bdi 7:0? And sb_dev=0:0, nr_pages=9223372036854775807=0x7fffffffffffffff.
> 
> All are indicating some special bdi/inode.

#define LOOP_MAJOR 7

It's a loop device. xfstests uses them quite a lot.

Maybe it would be a good idea to run xfstests on an xfs filesystem
in your regular writeback testing cycle to get decent coverage of
this case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
