Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2IEEhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:37:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab2IEEhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:37:43 -0400
Date: Tue, 4 Sep 2012 21:37:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Kent Overstreet <koverstreet@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120905043737.GA2737@mtj.dyndns.org>
References: <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120903004927.GM15292@dastard>
 <20120904135422.GC13768@redhat.com>
 <20120904182633.GB3638@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905035758.GF13691@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905035758.GF13691@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Wed, Sep 05, 2012 at 01:57:59PM +1000, Dave Chinner wrote:
> > But, yeah, this can't be solved by enlarging the stack size.  The
> > upper limit is unbound.
> 
> Sure, but recursion issue is isolated to the block layer.
> 
> If we can still submit IO directly through the block layer without
> pushing it off to a work queue, then the overall stack usage problem
> still exists. But if the block layer always pushes the IO off into
> another workqueue to avoid stack overflows, then the context
> switches are going to cause significant performance regressions for
> high IOPS workloads.  I don't really like either situation.

Kent's proposed solution doesn't do that.  The rescuer work item is
used iff mempool allocation fails w/o GFP_WAIT.  IOW, we're already
under severe memory pressure and stalls are expected all around the
kernel (somehow this sounds festive...)  It doesn't alter the
breadth-first walk of bio decomposition and shouldn't degrade
performance in any noticeable way.

> So while you are discussing stack issues, think a little about the
> bigger picture outside of the immediate issue at hand - a better
> solution for everyone might pop up....

It's probably because I haven't been bitten much from stack overflow
but I'd like to keep thinking that stack overflows are extremely
unusual and the ones causing them are the bad ones.  Thank you very
much. :p

-- 
tejun
