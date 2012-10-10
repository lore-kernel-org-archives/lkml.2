Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2JJAGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:06:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45264 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2JJAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:06:05 -0400
Date: Tue, 9 Oct 2012 17:06:00 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121010000600.GB26835@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009231059.GV26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:10:59PM -0700, Zach Brown wrote:
> > Well, the ringbuffer does have those compat flags and incompat flags.
> > Which libaio conveniently doesn't check, but for what it does it
> > shouldn't really matter I guess.
> 
> Well, the presumed point of the incompat flags would be to tell an app
> that it isn't going to get what it expects!  Ideally it'd abort, not
> blindly charge on ahead.
> 
> > I figure if anyone else is using the ringbuffer directly and not
> > checking the flag fields... well, they deserve to have their stuff
> > broken :P
> 
> Nope!  I subscribe to the unpopular notion that you don't change
> interfaces just because you can.

Heh, I won't argue.

The AIO ringbuffer stuff just annoys me more than most (it wasn't until
the other day that I realized it was actually exported to userspace...
what led to figuring that out was noticing aio_context_t was a ulong,
and got truncated to 32 bits with a 32 bit program running on a 64 bit
kernel. I'd been horribly misled by the code comments and the lack of
documentation.) 

> > Anyways, if we can't change the ringbuffer at all we could always create
> > a new version of the io_setup() syscall that gives you a new ringbuffer
> > format.
> 
> That might be the easiest way to tweak the existing aio interface, yeah.
> Jens wants to do that in his patches as well.  He used the hack of
> setting nr_events to INT_MAX to indicate not using the ring, but adding
> a flags parameter to a new syscall seems a lot less funky.

Alright. Maybe I'll start hacking on that...

> > I'm wondering what interest there is in creating a new aio interface to
> > solve these and other issues.
> > 
> > I kind of feel like as long as we've got a list of complaints, we should
> > prototype something in one place that fixes all our complaints... think
> > of it as documenting all the known issues, if nothing else.
> 
> I'd help out with that, yes.
> 
> On my list of complaints would be how heavy the existing aio
> setup/submission/completion/teardown interface is.   A better interface
> should make it trivial to just bang out a call and synchronously wait
> for it.  Get that right and you don't have to mess around with aio and
> sync variants.

Hmm yeah, setup and teardown is a good point.

I never liked aio_context_t too much - in some respects it would be
cleaner if it was just implicit and per thread. But we probably can't do
that since there are legitimate use cases for one thread submitting and
iocb and another thread reaping the events.

But if we do have an explicit handle, I don't see why it shouldn't be a
file descriptor.

But an implicit per thread context might be useful for the use case you
describe... or perhaps we can add a syscall to submit an iocb and wait
for it synchronously, without any aio_context_t involved.

> One of the harder things to get right would be specifying the DIF/DIX
> checksums per sector.  But I think we should.  Poor Martin has hung out
> to dry for too long.

Yes, that's one of the things I want to address with the aio attributes
stuff.

> 
> And perhaps obviously, I'd start with the acall stuff :).  It was a lot
> lighter.  We could talk about how to make it extensible without going
> all the way to the generic packed variable size duplicating or not and
> returning or not or.. attributes :).

Link? I haven't heard of acall before.
