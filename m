Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1LTEGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 23:06:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LTEGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 23:06:08 -0500
Date: Tue, 20 Dec 2011 04:05:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220040556.GB23916@ZenIV.linux.org.uk>
References: <1324265775.25089.20.camel@mengcong>
 <4EEEE866.2000203@linux.vnet.ibm.com>
 <4EEF0003.3010800@codeaurora.org>
 <4EEF1A13.4000801@linux.vnet.ibm.com>
 <20111219121100.GI2203@ZenIV.linux.org.uk>
 <20111219235659.GT23662@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219235659.GT23662@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:56:59AM +1100, Dave Chinner wrote:

> > That got one hell of a deadlock potential ;-/  So far I'm more or less
> > in favor of doing get_online_cpus() explicitly in fs/namespace.c, outside
> > of namespace_sem.  But I still have not convinced myself that it's
> > really safe ;-/
> 
> Agreed, it looks like a lot simpler solution to this problem than a
> notifier. But I don't think I know enough about the usage context to
> determine if it is safe, either, so i can't really help you there. :/

That's really nasty; mntput_no_expire() (and thus mntput()) wants
br_write_lock()/br_write_unlock().  Right now we *know* that mntput()
is non-blocking in situations when we are holding more than one reference.
With that kind of change that isn't true anymore - one needs to have
long-term refs to make it safe.  And that's not going to be fun to audit...

Can we get some kind of non-blocking exclusion against CPU hotplug?  Note
that we care about it only for writers, i.e. when we are going to cause
cacheline bouncing from hell, no matter what.

I *really* hate making br_write_lock() blocking and explicit get_online_cpus()
around it isn't really any better.  Too much PITA verifying correctness after
the locking change.

At that point in the cycle the original patch (loop over all CPUs, online or
not) may turn out to be the only sane variant, as much as its going to
hurt us.
