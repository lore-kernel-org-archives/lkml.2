Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1IGX5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511Ab1IGX5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:57:50 -0400
Date: Wed, 7 Sep 2011 19:57:40 -0400
From: Neil Horman <nhorman@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110907235739.GA4706@hmsreliant.think-freely.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <201109071630.15261.sgrubb@redhat.com>
 <1315427877.3576.46.camel@lappy>
 <201109071656.49758.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109071656.49758.sgrubb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:56:49PM -0400, Steve Grubb wrote:
> On Wednesday, September 07, 2011 04:37:57 PM Sasha Levin wrote:
> > On Wed, 2011-09-07 at 16:30 -0400, Steve Grubb wrote:
> > > On Wednesday, September 07, 2011 04:23:13 PM Sasha Levin wrote:
> > > > On Wed, 2011-09-07 at 16:02 -0400, Steve Grubb wrote:
> > > > > On Wednesday, September 07, 2011 03:27:37 PM Ted Ts'o wrote:
> > > > > > On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
> > > > > > > We're looking for a generic solution here that doesn't require
> > > > > > > re-educating every single piece of userspace. And anything done
> > > > > > > in userspace is going to be full of possible holes -- there
> > > > > > > needs to be something in place that actually *enforces* the
> > > > > > > policy, and centralized accounting/tracking, lest you wind up
> > > > > > > with multiple processes racing to grab the entropy.
> > > > > > 
> > > > > > Yeah, but there are userspace programs that depend on urandom not
> > > > > > blocking... so your proposed change would break them.
> > > > > 
> > > > > The only time this kicks in is when a system is under attack. If you
> > > > > have set this and the system is running as normal, you will never
> > > > > notice it even there. Almost all uses of urandom grab 4 bytes and
> > > > > seed openssl or libgcrypt or nss. It then uses those libraries.
> > > > > There are the odd cases where something uses urandom to generate a
> > > > > key or otherwise grab a chunk of bytes, but these are still small
> > > > > reads in the scheme of things. Can you think of any legitimate use
> > > > > of urandom that grabs 100K or 1M from urandom? Even those numbers
> > > > > still won't hit the sysctl on a normally function system.
> > > > 
> > > > As far as I remember, several wipe utilities are using /dev/urandom to
> > > > overwrite disks (possibly several times).
> > > 
> > > Which should generate disk activity and feed entropy to urandom.
> > 
> > I thought you need to feed random, not urandom.
> 
> I think they draw from the same pool.
> 
They share the primary pool, where timer/interrupt/etc randomness is fed in.
/dev/random and /dev/urandom each have their own secondary pools however.

>  
> > Anyway, it won't happen fast enough to actually not block.
> > 
> > Writing 1TB of urandom into a disk won't generate 1TB (or anything close
> > to that) of randomness to cover for itself.
> 
> We don't need a 1:1 mapping of RNG used to entropy acquired. Its more on the scale of 
> 8,000,000:1 or higher.
> 
Where are you getting that number from?

You may not need it, but there are other people using this facility as well that
you're not considering.  If you assume that in the example Sasha has given, if
conservatively, you have a modern disk with 4k sectors, and you fill each 4k
sector with the value obtained from a 4 byte read from /dev/urandom, You will:

1) Generate an interrupt for every page you write, which in turn will add at
most 12 bits to the entropy pool

2) Extract 32 bits from the entropy pool

Thats just a loosing proposition.   Barring further entropy generation from
another source, this is bound to stall with this feature enabled. 


> 
> > > > Something similar probably happens for getting junk on disks before
> > > > creating an encrypted filesystem on top of them.
> > > 
> > > During system install, this sysctl is not likely to be applied.
> > 
> > It may happen at any time you need to create a new filesystem, which
> > won't necessarily happen during system install.
> > 
> > See for example the instructions on how to set up a LUKS filesystem:
> > https://wiki.archlinux.org/index.php/System_Encryption_with_LUKS#Preparatio
> > n_and_mapping
> 
> Those instructions might need to be changed. That is one way of many to get random 
> numbers on the disk. Anyone really needing the security to have the sysctl on will 
> also probably accept that its doing its job and keeping the numbers random. Again, no 
> effect unless you turn it on.
> 

And then its enforced on everyone, even those applications that don't want
it/can't work with it on.  This has to be done in such a way that its opt-in on
a per-application basis.  The CUSE idea put up previously sounds like a pretty
good way to do this.  The ioctl for per-fd blocking thresholds is another way to
go.

Neil

> -Steve
