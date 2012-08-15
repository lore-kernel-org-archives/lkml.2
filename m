Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2HOASO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:18:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56517 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2HOASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:18:11 -0400
Date: Tue, 14 Aug 2012 17:18:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
Message-ID: <20120815001805.GH25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
 <20120813233520.GG25632@google.com>
 <alpine.LFD.2.02.1208142055260.32033@ionos>
 <20120814192203.GY25632@google.com>
 <alpine.LFD.2.02.1208142243500.32033@ionos>
 <20120814215632.GE25632@google.com>
 <alpine.LFD.2.02.1208150005090.32033@ionos>
 <20120814230100.GF25632@google.com>
 <alpine.LFD.2.02.1208150116570.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208150116570.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Wed, Aug 15, 2012 at 01:33:09AM +0200, Thomas Gleixner wrote:
> To convince me to accept your patches you should start answering my
> questions and suggestions seriously in the first place and not
> discarding them upfront as lunatic visions.
> 
> As long as you can't provide a proper counter argument against
> maintaining the timer in the same context as the work, no matter what
> the underlying mechanism to achieve this will be, I'm not going to
> accept any of this hackery neither near next nor mainline.

Sure, that's exactly why the patches are posted for review, so you're
suggesting for workqueue implement essentially its own timer list - be
that a simple sorted linked list or priority heap.  Am I understanding
you correctly?

If so, we're comparing the following two.

a. Adding IRQSAFE timer.  Runtime cost is one additional if() in timer
   execution path.

b. Implementing workqueue's own timer system which is driven by timer
   so that the timer part can also be protected by the usual workqueue
   synchronization.

To me, #a seems like the better choice here.

delayed_work is one of the more common constructs used widely in the
kernel.  It's often used in device drivers to defer processing to
process context and timer queueing (including modification) is a
frequent operation.

IRQ handlers schedule them, some drivers use it to poll the device,
block layer uses it for most of deferred handling - SCSI layer failing
to issue a command due to resource shortage reschedules delayed_work
repeatedly, and so on.

Essentially, delayed_work might be used for any purpose a timer is
used.  Timer users switch to delayed_work if process context becomes
necessary for whatever reason, so, I don't think we can get away with
simple sorted list implementation.  We might be okay under some
workloads but O(N^2) insertion complexity for something as commonly
used as delayed_work doesn't seem like a good idea to me.

We could go for more involved implementation, say a priority heap or
somewhat simplified version of tvec_base, but that seems like a bad
tradeoff to me.  We would be trading off fairly complex chunk of code
duplicating an existing capability to avoid adding fairly small
feature to the timer.  It will likely be worse than the proper timer
and we have to maintain two chunks of code doing about the same thing
to save single if() in the existing timer code.

Let's see if we can agree on the latter point first.  Do you agree
that it wouldn't be a good idea to implement relatively complex timer
subsystem inside workqueue?

Thanks.

-- 
tejun
