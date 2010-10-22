Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0JVNEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:04:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47976 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab0JVNEb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:04:31 -0400
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Ted Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <4CC0817F.1020403@kernel.dk>
References: <E1P8kSE-0001DW-8C@tytso-glaptop> <4CBFE4E2.7050001@kernel.dk>
	 <20101021165525.GB3127@thunk.org> <4CC07B62.9070000@panasas.com>
	 <4CC0817F.1020403@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Oct 2010 15:04:20 +0200
Message-ID: <1287752660.15336.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 20:07 +0200, Jens Axboe wrote:
> 
> >> +    do {
> >> +            bio = bio_alloc(GFP_NOIO, nvecs);
> >> +            nvecs >>= 1;
> >> +    } while (bio == NULL);
> > 
> > This is surly bad. bio_alloc must be allowed to fail
> > (Specially with GFP_NOIO). You should only loop down to
> > 1 and then prepare to return -ENOMEM from this function
> > and handle it properly in callers. (Or schedule and wait
> > like below)
> 
> Since __GFP_WAIT is set, it'll never return NULL. And as long as you
> don't allocate more than 1 before doing you submit_bio(), it should be
> OK in this case. 

__GFP_WAIT can return NULL, on OOM and when the size is over a magic
threshold.

I find it bad form to rely on any allocation not failing.
