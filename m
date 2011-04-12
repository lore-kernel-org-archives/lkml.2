Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1DLFPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:15:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43024 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1DLFPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=op2GXaXA3/jqhUJSxDNAARSa6ZwpKzlVzAVBvwKFC33qYcLxqKHIxsM5XCIr7E0y7H
         rZuzKQt0WZs+H8l3LDHf7SQL9tBwqecdkHt/NUnf9FYvGT+uhVRkQ6AINxe9DwZ1sXbq
         0x7ht34p4LHOc9sIlaYglb6/z94xmCfNdvNLA=
Date: Tue, 12 Apr 2011 14:15:12 +0900
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110412051512.GL9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
 <20110411171803.GG9673@mtj.dyndns.org>
 <1302569276.2558.9.camel@mulgrave.site>
 <20110412025145.GJ9673@mtj.dyndns.org>
 <1302583757.2558.21.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302583757.2558.21.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 11, 2011 at 11:49:17PM -0500, James Bottomley wrote:
> > But confused here.  Why does it make any difference whether the
> > release operation is in the request_fn context or not?  What makes
> > SCSI refcounting different from others?
> 
> I didn't say it did.  SCSI refcounting is fairly standard.
> 
> The problem isn't really anything to do with SCSI ... it's the way block
> queue destruction must now be called.  The block queue destruction
> includes a synchronous flush of the work queue.  That means it can't be
> called from the executing workqueue without deadlocking.  The last put
> of a SCSI device destroys the queue.  This now means that the last put
> of the SCSI device can't be in the block delay work path.  However, as
> the device shuts down that can very well wind up happening if
> blk_delay_queue() ends up being called as the device is dying.

Yeah, I understood that part.  I thought you were referring to the
problem caused by the proposed workqueue replacement in the patch when
you talked about workqueue related issues in the previous message, and
saying that there's an inherent problem with using workqueue directly.

> The entangled deadlock seems to have been introduced by commit
> 3cca6dc1c81e2407928dc4c6105252146fd3924f prior to that, there was no
> synchronous cancel in the destroy path.
> 
> A fix might be to shunt more stuff off to workqueues, but that's
> producing a more complex system which would be prone to entanglements
> that would be even harder to spot.

I don't agree there.  To me, the cause for entanglement seems to be
request_fn calling all the way through blocking destruction because it
detected that the final put was called with sleepable context.  It's
just weird and difficult to anticipate to directly call into sleepable
destruction path from request_fn whether it had sleepable context or
not.  With the yet-to-be-debugged bug caused by the conversion aside,
I think simply using workqueue is the better solution.

> Perhaps a better solution is just not to use sync cancellations in
> block?  As long as the work in the queue holds a queue ref, they can be
> done asynchronously.

Hmmm... maybe but at least I prefer doing explicit shutdown/draining
on destruction even if the base data structure is refcounted.  Things
become much more predictable that way.

Thanks.

-- 
tejun
