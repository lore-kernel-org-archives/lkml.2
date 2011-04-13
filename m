Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab1DMFLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 01:11:46 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56175 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab1DMFLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 01:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZMqQMECGanjDBKJwQ78Qe/DopJEN4oX/4XO/Md6zCfJ9ZRMhoflYFnv27t2yfpD9/V
         QOwSQfuc8UMokPI9XkYMBwqTr2qzYGWTtU3o4hnRV9e1FiZblC1s7k78MzVlRfoFG9gb
         +MrFIambGOlO/ltXyeSz6q6VLNjq4K0Sajg0g=
Date: Wed, 13 Apr 2011 14:11:39 +0900
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110413051139.GC24161@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
 <20110411171803.GG9673@mtj.dyndns.org>
 <1302569276.2558.9.camel@mulgrave.site>
 <20110412025145.GJ9673@mtj.dyndns.org>
 <1302583757.2558.21.camel@mulgrave.site>
 <20110412051512.GL9673@mtj.dyndns.org>
 <1302621318.2604.19.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302621318.2604.19.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, James.

On Tue, Apr 12, 2011 at 10:15:18AM -0500, James Bottomley wrote:
> So your idea is that all final puts should go through a workqueue?  Like
> I said, that would work, but it's not just SCSI ... any call path that
> destroys a queue has to be audited.

Yeap.

> The problem is nothing to do with sleeping context ... it's that any
> work called by the block workqueue can't destroy that queue.  In a
> refcounted model, that's a bit nasty.

I can see your point but please read on.

> > Hmmm... maybe but at least I prefer doing explicit shutdown/draining
> > on destruction even if the base data structure is refcounted.  Things
> > become much more predictable that way.
> 
> It is pretty much instantaneous.  Unless we're executing, we cancel the
> work.  If the work is already running, we just let it complete instead
> of waiting for it.
> 
> Synchronous waits are dangerous because they cause entanglement.

There are two different types of dangers involved.  One is of getting
trapped into deadlock by recursing and ending up waiting for oneself.
The other of continuing operation on objects which could be in dubious
state.  I guess my point is that I prefer the former by a large
margin.

The deadlocks are more reliable in reproducibility.  Lockdep and soft
hang check can detect them easily and a single stack dump will point
us right to where the problem is.  The latter is much trickier.  The
problem is more difficult to trigger and even when it triggers the
effect often wouldn't be obvious.  Auditing for correctness is more
difficult too - which fields are safe to access post-mortem?  Is there
any chance that the ongoing operation might reach out to hardware
which is already gone or claimed by another software entity?

In this particular case, IMHO it's reasonable for block layer to
require that the destruction function not to be called directly from
request queue path although it definitely could have used better
documentation.

Thank you.

-- 
tejun
