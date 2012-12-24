Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2LXTHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 14:07:31 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:47724 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2LXTH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 14:07:29 -0500
Date: Mon, 24 Dec 2012 11:07:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121224190723.GE11817@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
 <20121224185555.GA5344@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121224185555.GA5344@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Borislav.

On Mon, Dec 24, 2012 at 07:55:55PM +0100, Borislav Petkov wrote:
> Basically, with the amount of bloat we're adding to the kernel, the
> couple of instructions we're adding here and there and think they won't
> harm us, tends to crop up with time until we're too damn slow to do
> anything.

Yeah, I think we need them for the operations to hold w/o outer
synchronization.  If you can think of ways to optimize them, please be
my guest.

> Now, you're saying that optimizing cold paths is something that calls
> for serious reconsideration of a person's priorities, and I'm saying
> just don't do anything in code that's not necessary. Fullstop. If this

Not doing anything that's not necessary is an extreme and not
necessary what you want in cold paths.  If doing something extra makes
your code much simpler and more maintainable and the path is cold
enough for the extra to not matter, then that's the right trade-off.

> is leading to convolutions, then the design is suboptimal and needs
> adjustment. If [delayed_]work_pending is being abused, then fix it or
> add a new primitive which only checks for pending work and doesn't
> unconditionally toggle interrupts.

"only checks for pending work" in a way which is race-free and usable
from any context is a tricky thing to do.

> > I don't think we have cases where this actually matters but it could
> > be that we can add work_pending() tests to queue_work_on(). I *think*
> > that shouldn't break work scheduling semantics. Not completely sure
> > tho. Need to think about it more.
> 
> Yes, something like that.

And that's broken.  It seems trivial but it really isn't and trying to
optimize things like that in cold paths is just a bad idea.  Not
enough people will pay attention to them and they will stay subtly
broken for a very long time.  So, having "not doing anything in code
which isn't necessary in code" as priority in cold paths is likely to
hurt you.  A better one would be "doing straight-forward and simple
thing with acceptable overhead".

Thanks.

-- 
tejun
