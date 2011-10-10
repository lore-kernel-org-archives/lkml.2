Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1JJVdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:33:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39486 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1JJVdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:33:21 -0400
Date: Mon, 10 Oct 2011 14:33:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>,
        Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Subject: Re: Block regression since 3.1-rc3
Message-ID: <20111010213316.GM8100@google.com>
References: <1317397918.27140.15.camel@localhost>
 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
 <1317729761.25998.4.camel@localhost>
 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
 <20111008161421.GA5743@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111008161421.GA5743@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Sat, Oct 08, 2011 at 12:14:21PM -0400, Mike Snitzer wrote:
> Unless others have an immediate ah-ha moment, I'd suggest we revert
> commit 4853abaae7e4a2a (block: fix flush machinery for stacking drivers
> with differring flush flags).  Whereby avoiding unnecessarily reentering
> the flush machinery.

I don't object to the immediate fix but think that adding such special
case is gonna make the thing even more brittle and make future changes
even more difficult.  Those one off cases tend to cause pretty severe
headache when someone wants to evolve common code, so let's please
find out what went wrong and fix it properly so that everyone follows
the same set of rules.

> If commit ed8b752bccf256 (dm table: set flush capability based on
> underlying devices) is in place the flush gets fed directly to
> scsi_request_fn, which is fine because the request-based DM's
> request_queue's flush_flags reflect the flush capabilities of the
> underlying device(s).
> 
> We are then covered relative to the only request-based DM use-case
> people care about (e.g. dm-multipath, which doesn't use stacked
> request-based DM).
> 
> We can revisit upholding the purity of the flush machinery for stacked
> devices in >= 3.2.

Hmmm... another rather nasty assumption the current flush code makes
is that every flush request has either zero or single bio attached to
it.  The assumption has always been there for quite some time now.
That somehow seems broken by request based dm (either that or wrong
request is taking INSERT_FLUSH path).  Is it possible that a rq /w
single bio can end up with multiple bios after cloning?

Thank you.

-- 
tejun
