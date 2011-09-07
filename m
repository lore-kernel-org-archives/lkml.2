Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1IGUdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab1IGUdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:33:15 -0400
Date: Wed, 7 Sep 2011 16:33:05 -0400
From: Neil Horman <nhorman@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110907203305.GD24703@hmsreliant.think-freely.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <4E67B75B.8010500@redhat.com>
 <20110907192737.GD20571@thunk.org>
 <201109071602.24519.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109071602.24519.sgrubb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:02:24PM -0400, Steve Grubb wrote:
> On Wednesday, September 07, 2011 03:27:37 PM Ted Ts'o wrote:
> > On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
> > > We're looking for a generic solution here that doesn't require
> > > re-educating every single piece of userspace. And anything done in
> > > userspace is going to be full of possible holes -- there needs to be
> > > something in place that actually *enforces* the policy, and
> > > centralized accounting/tracking, lest you wind up with multiple
> > > processes racing to grab the entropy.
> > 
> > Yeah, but there are userspace programs that depend on urandom not
> > blocking... so your proposed change would break them.
> 
> The only time this kicks in is when a system is under attack. If you have set this and 
> the system is running as normal, you will never notice it even there. Almost all uses 
> of urandom grab 4 bytes and seed openssl or libgcrypt or nss. It then uses those 
> libraries. There are the odd cases where something uses urandom to generate a key or 
> otherwise grab a chunk of bytes, but these are still small reads in the scheme of 
Theres no way you can guarantee that.  A quick lsof on my system here shows 27
unique pids that are holding /dev/urandom open, and while they may all be small reads,
taken in aggregate, I can imagine that they could pull a significant amount of
entropy out of /dev/urandom.

> things. Can you think of any legitimate use of urandom that grabs 100K or 1M from 
> urandom? Even those numbers still won't hit the sysctl on a normally function system.
> 
How can you be sure of that?  This seems to make assumptions about both the rate
at which entropy is drained from /dev/urandom and the limit at which you will
start blocking, neither of which you can be sure of.

> When a system is underattack, do you really want to be using a PRNG for anything like 
How can you be sure that this only happens when a system is under some sort of
attack.  /dev/urandom is there for user space to use, and we can't make
assumptions as to how it will get drawn from.  What if someone was running some
monte-carlo based test program?  That could completely exhaust the entropy in
/dev/urandom and would be perfectly legitimate.

> seeding openssl? Because a PRNG is what urandom degrades into when its attacked. If 
> enough bytes are read that an attacker can guess the internal state of the RNG, do you 
> really want it seeding a openssh session? At that point you really need it to stop 
> momentarily until it gets fresh entropy so the internal state is unknown. That's what 
> this is really about.
I never really want my ssh session to be be seeded with non-random data.  Of
course, in my mind thats an argument for making ssh use /dev/random rather than
/dev/urandom, but I'm willing to take the tradeoff in speed most of the time.

> 
> -Steve
