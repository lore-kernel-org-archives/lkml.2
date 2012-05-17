Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2EQJeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab2EQJeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:34:20 -0400
Date: Thu, 17 May 2012 12:34:17 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120517093417.GB10209@redhat.com>
References: <20120516181500.GA23791@amt.cnet>
 <20120516182520.GH28798@redhat.com>
 <20120516182948.GF10769@redhat.com>
 <20120516183822.GI28798@redhat.com>
 <20120516190757.GA12113@redhat.com>
 <20120517072841.GW32036@redhat.com>
 <20120517074946.GA27995@redhat.com>
 <4FB4AF6D.9080305@redhat.com>
 <20120517080731.GZ32036@redhat.com>
 <4FB4C3CE.9010907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB4C3CE.9010907@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 12:24:30PM +0300, Avi Kivity wrote:
> On 05/17/2012 11:07 AM, Gleb Natapov wrote:
> > > 
> > > No, let's refactor this so it makes sense.  The {has|get}_interrupt
> > > split is the cause of the problem, I think.  We need a single function,
> > > with callbacks that are called when an event happens.  The callbacks can
> > > request an irq window exit, inject an interrupt, play with pveoi, or
> > > cause a #vmexit.
> > > 
> > Not sure what do you mean here. I kind of like the code we have now, but
> > this may be because I understand it :)
> 
> Right now we have
> 
>    if (has_interrupt)
>        do something
>    if (get_interrupt)
>        do_something_else
> 
Not exactly. Now we have:
  if (has_interrupt && can inject)
    inject(get_interrupt())
  if (still has_interrupt)
    notify me when I can inject it.

There is not if(get_interrupt).

> this duplicates some of the logic and causes non-atomicty (which isn't a
> problem per se, but requires us to think of what happens if conditions
> change between the two steps).
> 
> What I'm thinking of is
> 
>    void process_interrupt(bool (*handle)());
Why we even want to pass different handle() to the function?

> 
> Where the return value tells us whether the interrupt was accepted by
> the handler.  The callback could decide to enable the irq window, to
> queue the interrupt, or to #vmexit (note that the latter can return
Queuing interrupt and requesting irq window ate not mutually exclusive.

> either true or false, depending on whether vmx is configured to ack the
> interrupt or not; svm would return true here if interrupts are intercepted).
> 
> -- 
> error compiling committee.c: too many arguments to function

--
			Gleb.
