Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0G1U7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:59:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab0G1U7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:59:17 -0400
Date: Wed, 28 Jul 2010 13:58:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
Message-Id: <20100728135857.2a0ab8bd.akpm@linux-foundation.org>
In-Reply-To: <4C509772.1070407@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>
	<20100728132314.29cd68c5.akpm@linux-foundation.org>
	<4C509772.1070407@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 13:47:46 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> > This is different from the patch I merged and I'm not seeing any
> > explanation for the change.
> > 
> > The implementation of usleep() looks odd.  The longer we sleep, the
> > greater the possible inaccuracy.  A code comment which explains the
> > thinking and which warns people about the implications is needed.

I wanna code comment!

> Yes it is different; the explanation was in the cover message. I should
> probably include a copy of the explanation in the commit message as
> well? It was becoming a very long commit message...
> 
> // FROM COVER MESSAGE:
>    This iteration is similar, with the notable difference that now
>    usleep has a "built-in slack" of 200%. This is analogous to msleep,
>    which has a built-in slack of 0.4% (since it relies on legacy timers,
>    which have a built-in slack of 0.4%). 200% slack is significantly
>    greater than 0.4%, but the scale of usleep is also significantly
>    different than that of msleep, and I believe 200% to be a sane
>    default.
> 
>    It is my opinion that this interface will most often mirror what
>    developers actually intend - indeed some people who have begun
>    trying to use the API raised this point -, however, I would like
>    some input as it is possibly confusing that the API will "double
>    your sleep" by default.
> 
>    The usleep_range API is still included, since it provides an
>    interface to override the "default slack" of 200% by providing
>    an explicit range, or to allow callers to specify an even larger
>    slack if possible.
> 
> The problem that was raised by a few people trying to use usleep here
> was that the API as written was very awkward -- there was never really
> a good reason to use "usleep" as it was written. The intention was
> to make usleep a usable / sensible API; the obvious alternative I see
> is to drop the usleep function entirely and only provide usleep_range - 
> which would probably fit well in your request for callers to think
> about what they are doing, if providing a somewhat awkward API.
> 
> The complaint was something to the effect of:
> 
>    "Well, I understand that I should probably give a range, but I have
>    no idea what a good range would be. I really just want it to sleep
>    for a little bit, but I probably shouldn't trigger an extra interrupt.
>    Given the limitations, what's the point of even having a usleep call
>    at all?"
> 
> 
> Thoughts?

My main concern is that someone will type usleep(50) and won't realise
that it goes and sleeps for 100 usecs and their code gets slow as a
result.  This sort of thing takes *years* to discover and fix.  If we'd
forced them to type usleep_range() instead, it would never have happened.



Another question: what is the typical overhead of a usleep()?  IOW, at
what delay value does it make more sense to use udelay()?  Another way
of asking that would be "how long does a usleep(1) take"?  If it
reliably consumes 2us CPU time then we shouldn't do it.

But it's not just CPU time, is it?  A smart udelay() should put the CPU
into a lower power state, so a udelay(3) might consume less energy than
a usleep(2), because the usleep() does much more work in schedule() and
friends?

