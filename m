Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2EUSdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab2EUSdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:33:05 -0400
Date: Mon, 21 May 2012 14:32:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: NeilBrown <neilb@suse.de>, axboe@kernel.dk, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, tj@kernel.org,
        linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [dm-devel] [PATCH 12/13] Make generic_make_request handle
 arbitrarily large bios
Message-ID: <20120521183253.GA30143@redhat.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
 <20120518180550.0a6cdc34@notabene.brown>
 <20120518081444.GA27205@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120521171706.GH23993@redhat.com>
 <20120521175542.GA16598@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521175542.GA16598@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:55:42AM -0700, Kent Overstreet wrote:
> On Mon, May 21, 2012 at 01:17:06PM -0400, Vivek Goyal wrote:
> > May be I am missing something, hence I will ask.  Is punting to workqueue
> > will really solve the issue raised by Neil. 
> > 
> > Due to spliting required, we will be holding some bios in the stack and
> > these bios can't be submitted till further allocation from pool happens. So
> > will it matter whether we are waiting for allocation in submitting process
> > context or in worker thread context.
> 
> Punting to workqueue allows all the bio splits that have already been
> allocated to be submitted.
>
> > IOW, say you have a pool of 2 bios. We allocate 1 bio (say bio A),  and submit
> > it for IO (now 1 bio left in pool). Now, bio A needs to be split up, so we
> > allocate bio B and submit it (pool is empty now). Now we try to submit bio
> > B and this also needs to be split. There are no more free bios so we will
> > wait for some to get free but none of the bios (A and B) have actually
> > been submitted for IO so nothing will get freed and we have a deadlock
> > (This is assuming that memory is tight enough that we are not able to do
> > any allocations from the slab backing the mempool).
> 
> You're talking about a different issue. You can't safely split a split
> from the same bio pool - but this code doesn't do that since it adds a
> separate bio pool for each request_queue that's only for splits.

Ok, I missed the fact that there are per queue pools for bio allocation.
Thanks for clarifying.

Vivek
