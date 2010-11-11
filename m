Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab0KKG17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:27:59 -0500
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:35604 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0KKG16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=hPoNGr
	zRT7zIU/QwUOLA7oMafH5yL+lzOzwl/QSBg7CrGju7woBt+KL6Nq8trGHtinfelD
	Fe3fEBjXvJubEJRmjYyKF/k3fjQx0SRyRJphZqqqOvu5wKHgFbpFhPxoJrVL/w/g
	kG7eueRO3oMmCmOklxGy/UfpGzAPnjzE2jFxQ=
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Nathan Lynch <ntl@pobox.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 00:27:42 -0600
Message-ID: <1289456863.4603.94.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: D2E3F1A4-ED5C-11DF-87CB-B53272ABC92C-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 11:55 -0500, Grant Likely wrote:
> On Tue, Nov 2, 2010 at 3:30 PM, Oren Laadan <orenl@cs.columbia.edu> wrote:
> > Hi,
> >
> > Following the discussion yesterday, here is a linux-cr diff that
> > that is limited to changes to existing code.
> >
> > The diff doesn't include the eclone() patches. I also tried to strip
> > off the new c/r code (either code in new files, or new code within
> > #ifdef CONFIG_CHECKPOINT in existing files).
> >
> > I left a few such snippets in, e.g. c/r syscalls templates and
> > declaration of c/r specific methods in, e.g. file_operations.
> >
> > The remaining changes in this patch include new freezer state
> > ("CHECKPOINTING"), mostly refactoring of exsiting code, and a bit
> > of new helpers.
> >
> > Disclaimer: don't try to compile (or apply) - this is only intended
> > to give a ballpark of how the c/r patches change existing code.
> [...]
> >  159 files changed, 2031 insertions(+), 587 deletions(-)
> 
> FWIW...
> 
> This patch has far reaching changes which quite frankly scare me;
> primarily because c/r changes many long-held assumptions about how
> Linux processes work.  It needs to track a large amount of state with
> lots of corner cases, and the Linux process model is already quite
> complex.  I know this is a fluffy hand-waving critique, but without
> being convinced of a strong general-purpose use-case, it is hard to
> get excited about a solution that touches large amounts of common
> code.

For the most part the c/r patch set is "merely" adding code and not
changing the way existing code works -- I'm pretty sure we haven't had
to alter anything hairy like locking or object lifetime rules.  Maybe
I've had my head in this code for too long, but I'm not seeing how
assumptions about the process model are changed significantly.  All the
process-related APIs like fork, clone, exec, wait, and exit all work as
they have before and if you're not actively using C/R you'd never know
the capability is there.

As for the lack of a general-purpose use-case... well, it's not terribly
unusual for Linux to sustain significant changes to satisfy what some
may consider a niche need.  Things like NUMA support, CPU and memory
hotplug - these were not "generally" useful features when they were
introduced.  So I don't think we're trying to break new ground in that
respect.


> c/r of desktop processes doesn't seem interesting other that as a test
> case, but I can possibly be convinced about HPC, embedded, industrial,
> or telecom use-cases, but for custom/specific-purpose applications the
> question must be asked if a fully user space or joint user/kernel
> method would better solve the problem.

This is in fact a joint approach -- the process tree is recreated in
user space at restart (not to mention that the user is responsible for
providing the restarted job a coherent view of the filesystem).

In any case, with HPC, C/R isn't about just fault tolerance necessarily;
it's for load-balancing and migration too.  So the checkpoint operation
needs to be as fast and efficient as possible, and ideally the image
should be readable/writable as a stream e.g. over a socket.  User space
really isn't up to this - for example, a user space implementation
generally cannot know which user pages are safe to omit from the image
(at least not without faulting them all in).

Users who need C/R on Linux today are resorting to LD_PRELOAD hacks and
moribund out-of-tree kernel patches, and I'm afraid they're going to
keep doing that until Linux provides a better alternative built-in.


