Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2H1WXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:23:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2H1WXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:23:37 -0400
Date: Tue, 28 Aug 2012 15:23:04 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120828222303.GE1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <20120828220610.GH31674@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828220610.GH31674@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 06:06:10PM -0400, Vivek Goyal wrote:
> On Tue, Aug 28, 2012 at 10:37:36AM -0700, Kent Overstreet wrote:
> > Previously, if we ever try to allocate more than once from the same bio
> > set while running under generic_make_request() (i.e. a stacking block
> > driver), we risk deadlock.
> > 
> > This is because of the code in generic_make_request() that converts
> > recursion to iteration; any bios we submit won't actually be submitted
> > (so they can complete and eventually be freed) until after we return -
> > this means if we allocate a second bio, we're blocking the first one
> > from ever being freed.
> > 
> > Thus if enough threads call into a stacking block driver at the same
> > time with bios that need multiple splits, and the bio_set's reserve gets
> > used up, we deadlock.
> 
> Hi Kent,
> 
> So above deadlock possibility arises only if multiple threads are doing
> multiple splits from same pool and all the threads get blocked on mempool
> and don't return from ->make_request function.
> 
> Is there any existing driver in the tree which can cause this deadlock or
> it becomes a possibility only when splitting and bcache code shows up?

It is emphatically possible with dm, though you would probably need a
pathalogical configuration of your targets for it to be possible in
practice - at least with the targets currently commonly in use.

With most of the newer dm targets coming down the pipe I expect it
should be possible under real world configurations, with the caveat that
under that kind of memory pressure in practice many other things will
fall over first.
