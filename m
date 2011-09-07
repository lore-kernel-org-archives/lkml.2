Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1IGTfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:35:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39564 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1IGTfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:35:39 -0400
Date: Wed, 7 Sep 2011 15:35:12 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Sasha Levin <levinsasha928@gmail.com>, '@hmsreliant.think-freely.org
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Neil Horman <nhorman@redhat.com>,
        Herbert Xu <herbert.xu@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110907193512.GA24659@hmsreliant.think-freely.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <1315417137-12093-1-git-send-email-jarod@redhat.com>
 <1315419179.3576.6.camel@lappy>
 <4E67B75B.8010500@redhat.com>
 <1315422330.3576.22.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315422330.3576.22.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 10:05:30PM +0300, Sasha Levin wrote:
> On Wed, 2011-09-07 at 14:26 -0400, Jarod Wilson wrote:
> > Sasha Levin wrote:
> > > On Wed, 2011-09-07 at 13:38 -0400, Jarod Wilson wrote:
> > >> Certain security-related certifications and their respective review
> > >> bodies have said that they find use of /dev/urandom for certain
> > >> functions, such as setting up ssh connections, is acceptable, but if and
> > >> only if /dev/urandom can block after a certain threshold of bytes have
> > >> been read from it with the entropy pool exhausted. Initially, we were
> > >> investigating increasing entropy pool contributions, so that we could
> > >> simply use /dev/random, but since that hasn't (yet) panned out, and
> > >> upwards of five minutes to establsh an ssh connection using an
> > >> entropy-starved /dev/random is unacceptable, we started looking at the
> > >> blocking urandom approach.
> > >
> > > Can't you accomplish this in userspace by trying to read as much as you
> > > can out of /dev/random without blocking, then reading out
> > > of /dev/urandom the minimum between allowed threshold and remaining
> > > bytes, and then blocking on /dev/random?
> > >
> > > For example, lets say you need 100 bytes of randomness, and your
> > > threshold is 30 bytes. You try reading out of /dev/random and get 50
> > > bytes, at that point you'll read another 30 (=threshold) bytes
> > > out /dev/urandom and then you'll need to block on /dev/random until you
> > > get the remaining 20 bytes.
> > 
> > We're looking for a generic solution here that doesn't require 
> > re-educating every single piece of userspace. [...]
> 
> A flip-side here is that you're going to break every piece of userspace
> which assumed (correctly) that /dev/urandom never blocks. Since this is
> a sysctl you can't fine tune which processes/threads/file-handles will
> block on /dev/urandom and which ones won't.
> 
I'm also squeamish about exactly this - theres no way to allow for applications
that expect a never-block /dev/urandom to co-exist with applications that want
an 'eventually' block /dev/urandom

That said, what about changing the model to make /dev/urandom configurable on a
per-file-descriptor basis,  Add an ioctl to the urandom_fops ioctl handler to
specify on a per file struct basis the maximum number of bytes that can be read
past a zero entropy point for that file.  The kernel could then track the number
of bytes read per fd after a zero entropy point (clearing it on a read when the
pool has non-zero entropy), and blocking/delaying any call until entropy had
been added back.  That way apps the require a non-blocking urandom can co-exist
with apps that have this new requirement, and only the new apps have to be
taught about the additional urandom configuration.
Neil
