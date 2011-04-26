Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab1DZAqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:46:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:3144 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1DZAqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:46:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="425368277"
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20110425091311.GC17734@mtj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
	 <20110422233204.GB1576@mtj.dyndns.org>
	 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
	 <20110425085827.GB17734@mtj.dyndns.org>
	 <20110425091311.GC17734@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 08:46:30 +0800
Message-ID: <1303778790.3981.283.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 17:13 +0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 25, 2011 at 10:58:27AM +0200, Tejun Heo wrote:
> > Eh, wasn't your optimization only applicable if flush is not
> > queueable?  IIUC, what your optimization achieves is merging
> > back-to-back flushes and you're achieving that in a _very_ non-obvious
> > round-about way.  Do it in straight-forward way even if that costs
> > more lines of code.
> 
> To add a bit more, here, flush exclusivity gives you an extra ordering
> contraint that while flush is in progress no other request can proceed
> and thus if there's another flush queued, it can be completed
> together, right?  If so, teach block layer the whole thing - let block
> layer hold further requests while flush is in progress and complete
> back-to-back flushes together on completion and then resume normal
> queue processing.
the blk-flush is part of block layer. If what you mean is the libata
part, block layer doesn't know if flush is queueable without knowledge
from driver.

> Also, another interesting thing to investigate is why the two flushes
> didn't get merged in the first place.  The two flushes apparently
> didn't have any ordering requirement between them.  Why didn't they
> get merged in the first place?  If the first flush were slightly
> delayed, the second would have been issued together from the beginning
> and we wouldn't have to think about merging them afterwards.  Maybe
> what we really need is better algorithm than C1/2/3 described in the
> comment?
the sysbench fileio does a 16 threads write-fsync, so it's quite normal
a flush is running and another flush is added into pending list.

Thanks,
Shaohua

