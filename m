Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2ICFoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:44:09 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37008 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013Ab2ICFnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:43:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsENAMxCRFB5LHJk/2dsb2JhbABFhRy1AgEBAn+BCIIgAQEEAScTHCMFCwgDDgouFCUDIROIBwW6ARSKeS9hfDSEYwOVWIk0hmeCdQ
Date: Mon, 3 Sep 2012 15:43:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-m@kvack.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 3.5.2: moving files from xfs/disk -> nfs:
 radix_tree_lookup_slot+0xe/0x10
Message-ID: <20120903054327.GZ15292@dastard>
References: <CAO9zADzH7mG3Kp1EQ-0MtTE2CdyLmuz9jsaijgTXLSJ9rZ9tiw@mail.gmail.com>
 <20120901231338.GE6896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901231338.GE6896@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 07:13:38PM -0400, Christoph Hellwig wrote:
> I'd suspect it's something with the actual radix tree code, Ccing
> linux-mm in case they know more.

I don't think it has anything to do with the radix tree code....

> On Mon, Aug 27, 2012 at 11:00:10AM -0400, Justin Piszcz wrote:
> > Hi,
> > 
> > Moving ~276GB of files (mainly large backups) and everything has
> > seemed to lockup on the client moving data to the server, it is still
> > in this state..
.....

> > [75716.705720] Call Trace:
> > [75716.705729]  [<ffffffff812dcaee>] ? radix_tree_lookup_slot+0xe/0x10

It's just a symbol that was found in the stack. The real trace is
this:

> > [75716.705747]  [<ffffffff815a3d04>] schedule+0x24/0x70
> > [75716.705751]  [<ffffffff815a2549>] schedule_timeout+0x1a9/0x210
> > [75716.705764]  [<ffffffff815a3420>] wait_for_common+0xc0/0x150
> > [75716.705773]  [<ffffffff815a3d78>] wait_for_completion+0x18/0x20
> > [75716.705777]  [<ffffffff810dfa47>] writeback_inodes_sb_nr+0x77/0xa0
> > [75716.705785]  [<ffffffff810dfa99>] writeback_inodes_sb+0x29/0x40
> > [75716.705788]  [<ffffffff810e3407>] __sync_filesystem+0x47/0x90
> > [75716.705791]  [<ffffffff810e346b>] sync_one_sb+0x1b/0x20
> > [75716.705795]  [<ffffffff810bea71>] iterate_supers+0xe1/0xf0
> > [75716.705798]  [<ffffffff810e355b>] sys_sync+0x2b/0x60
> > [75716.705802]  [<ffffffff815a53a6>] system_call_fastpath+0x1a/0x1f
> > [75836.701197] INFO: task sync:8790 blocked for more than 120 seconds.

Which simply says that writeback of the dirty data at the time of
the sync call has taken longer than 120s.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
