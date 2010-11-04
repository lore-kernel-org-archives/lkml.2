Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0KDBrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:47:53 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:39999 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab0KDBru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=lEt5II
	510HdDT5DyS6uWnX8Yx5kHSRfvgEW1to4zHhvtD7kts49W+GlMwwIcgZbqsx5dRe
	AoxPdEsqINO2aEfrORZm7EivvBoYJRefIuz8Du+GQfnR1guq4qKfEOKGAING3Y+Y
	dDM0UbQK+0g1dY4Df+NlARHM/2FCJjhg34eQE=
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Nathan Lynch <ntl@pobox.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101102214706.GA28593@lst.de>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>  <20101102214706.GA28593@lst.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 20:47:38 -0500
Message-ID: <1288835258.6132.56.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 849167A4-E7B5-11DF-A973-B51D107BB6B6-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 22:47 +0100, Christoph Hellwig wrote:
> Thanks Tejun,
> 
> your writeup brought up a lot of the same issues that I see with
> the in-kernel C/R.  Various C/R implementations that are entirely
> in userspace or with limited kernel assistance have been in production
> in HPC environments for years.

FWIW there are a couple of kernel-based C/R implementations (BLCR,
OpenVZ) in use in various contexts (not just HPC).


>   I think especially for these workloads
> C/R is an extremly useful feature, and a standard implementation would
> do Linux well.
> 
> But I think the "transparent" in-kernel one is the wrong approach.  It
> tries to give the illusion that C/R will just work, while a lot of
> things are simply not support.

I think this is somewhat true of the implementation under consideration
here (although generally it should fail checkpoints that it can't
restart), but it needn't be true of all possible kernel-based
implementations.


>   In this case whitelisting the allowed
> state by requiring special APIs for all I/O (or even just standard
> APIs as long as they are supposed by the C/R lib you're linked against)
> is the more pragmatic, and I think faithful aproach.

I don't think users will go for it.  They'll continue to use dodgy
out-of-tree kernel modules and/or LD_PRELOAD hacks instead of porting
their applications to a new library.  I think a C/R library is an
"ideal" solution, but it's one that nobody would use - especially in
HPC, unless the library somehow provides better performance.

The namespace/isolation features of Linux (CLONE_NEWPID et al) already
provide a pretty workable basis for creating tractably checkpoint-
and-restartable jobs, with a minimum of performance overhead and
application modification.


>   In addition to
> the amount of state not supported despite looking transparant the
> other big problem with the patchset is that it saves the kernel internal
> state which changes all the time from one release to another.

Most of the objects that the patchset saves and restores are right at
the "border" of the user/kernel interface, and they're not apt to change
much quickly (e.g. vma start and end, task sigaltstack info).   The
patchset certainly isn't serializing deep internal state such as wait
queues, locks, or reference counts.


> The handwaiving is that a userspace tool will solve it.  I'm pretty sure
> that's not the case; it might solve a few cases but the general
> version n to version m conversion is impossible to maintain.

With this I agree, though.  But if a change in kernel implementation
details forces an incompatible change in the checkpoint image format, is
that really a big deal?  Would it be so bad to say that a checkpoint
image may be restarted only on the same kernel version that created it?
With -stable or enterprise kernels I suspect the issue is unlikely to
come up.


