Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0DFCjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:39:19 -0400
Received: from ozlabs.org ([203.10.76.45]:38019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab0DFCjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:39:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Is module refcounting racy?
Date: Tue, 6 Apr 2010 12:09:10 +0930
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Nick Piggin <npiggin@suse.de>, Nick Piggin <npiggin@gmail.com>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <20100318105533.GE25636@laptop> <20100401080940.GA8356@laptop> <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004010852170.3707@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004061209.10647.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010 02:25:59 am Linus Torvalds wrote:
> 
> On Thu, 1 Apr 2010, Nick Piggin wrote:
> > 
> > I think it can be done racelessly with my patch, which is not really too
> > much overhead. I think if this is considered too much, then we should
> > either fix code and preferably de-export and remove module_refcount from
> > drivers, or remove module removal completely.
> 
> I doubt your patch matters too much, but I like it conceptually and it 
> seems to be a nice basis for perhaps doing something clever in the long 
> run.
> 
> [ ie avoiding the stop_machine and instead perhaps doing some optimistic 
>   thing like "see if we seem to be unused right now, then unregister us, 
>   and see - after unregistering - that the usage counts haven't increased, 
>   and re-register if they have. ]

I dislike that we can see spurious failure for some random try_module_get
caller.

But perhaps that's inherent in module removal: someone can miss out, and if
you care, don't try to remove modules.

And grepping for try_module_get() reveals a suspicious (growing) number of
try_module_get(THIS_MODULE) which is almost always wrong.  If we're not
perfect, maybe we should aim for simple?

> So I'd like to apply it as a "good improvement, even if module unloading 
> which is the only thing that _should_ care deeply should already be under 
> stop-machine".
> 
> But I'd like an ack or two first.

Yep.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
