Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2H1WGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 18:06:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2H1WGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 18:06:23 -0400
Date: Tue, 28 Aug 2012 18:06:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120828220610.GH31674@redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346175456-1572-10-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 10:37:36AM -0700, Kent Overstreet wrote:
> Previously, if we ever try to allocate more than once from the same bio
> set while running under generic_make_request() (i.e. a stacking block
> driver), we risk deadlock.
> 
> This is because of the code in generic_make_request() that converts
> recursion to iteration; any bios we submit won't actually be submitted
> (so they can complete and eventually be freed) until after we return -
> this means if we allocate a second bio, we're blocking the first one
> from ever being freed.
> 
> Thus if enough threads call into a stacking block driver at the same
> time with bios that need multiple splits, and the bio_set's reserve gets
> used up, we deadlock.

Hi Kent,

So above deadlock possibility arises only if multiple threads are doing
multiple splits from same pool and all the threads get blocked on mempool
and don't return from ->make_request function.

Is there any existing driver in the tree which can cause this deadlock or
it becomes a possibility only when splitting and bcache code shows up?

Thanks
Vivek
