Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0KRCNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:13:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab0KRCNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:13:40 -0500
Date: Wed, 17 Nov 2010 18:09:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling v2
Message-Id: <20101117180912.38541ca4.akpm@linux-foundation.org>
In-Reply-To: <20101118020640.GS22876@dastard>
References: <20101117042720.033773013@intel.com>
	<20101117150330.139251f9.akpm@linux-foundation.org>
	<20101118020640.GS22876@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010 13:06:40 +1100 Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Nov 17, 2010 at 03:03:30PM -0800, Andrew Morton wrote:
> > On Wed, 17 Nov 2010 12:27:20 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > On a simple test of 100 dd, it reduces the CPU %system time from 30% to 3%, and
> > > improves IO throughput from 38MB/s to 42MB/s.
> > 
> > The changes in CPU consumption are remarkable.  I've looked through the
> > changelogs but cannot find mention of where all that time was being
> > spent?
> 
> In the writeback path, mostly because every CPU is trying to run
> writeback at the same time and causing contention on locks and
> shared structures in the writeback path. That no longer happens
> because writeback is only happening from one thread instead of from
> all CPUs at once.

It'd be nice to see this quantified.  Partly because handing things
over to kernel threads uncurs extra overhead - scheduling cost and CPU
cache footprint.

But mainly because we're taking the work accounting away from the user
who caused it and crediting it to the kernel thread instead, and that's
an actively *bad* thing to do.

