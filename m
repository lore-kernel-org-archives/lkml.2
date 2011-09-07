Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1IGVKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:10:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48541 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab1IGVKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:10:50 -0400
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Sasha Levin <levinsasha928@gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <201109071656.49758.sgrubb@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <201109071630.15261.sgrubb@redhat.com> <1315427877.3576.46.camel@lappy>
	 <201109071656.49758.sgrubb@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 08 Sep 2011 00:10:27 +0300
Message-ID: <1315429827.3576.61.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 16:56 -0400, Steve Grubb wrote:
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

There is a blocking and a non blocking pool.

>  
> > Anyway, it won't happen fast enough to actually not block.
> > 
> > Writing 1TB of urandom into a disk won't generate 1TB (or anything close
> > to that) of randomness to cover for itself.
> 
> We don't need a 1:1 mapping of RNG used to entropy acquired. Its more on the scale of 
> 8,000,000:1 or higher.

I'm just saying that writing 1TB into a disk using urandom will start to
block, it won't generate enough randomness by itself.

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

There are bunch of other places that would need to be changed in that
case :)

Why not implement it as a user mode CUSE driver that would
wrap /dev/urandom and make it behave any way you want to? why push it
into the kernel?

-- 

Sasha.

