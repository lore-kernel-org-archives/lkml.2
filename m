Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1CHHzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 02:55:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45287 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1CHHzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 02:55:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sx57ZqJGgjpamRY905m/KJBpmtH7yoUvEIb2r3x0Moel3xof4nZW7wltq67ps0TE1S
         cywfQupxxfJmEEuklZH+Tel53Zk76OmriMSe12lQLZLJC993ksUyZDGxQoOnvCssaKD+
         4ZCX/kz/xLEEwKFzqMzDLh17lGArayBBRKsBo=
Date: Tue, 8 Mar 2011 08:54:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call
 directly into q->request_fn() __blk_run_queue()
Message-ID: <20110308075458.GL20499@htj.dyndns.org>
References: <20110217111619.GR19830@htj.dyndns.org>
 <AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com>
 <20110218094903.GF21209@htj.dyndns.org>
 <4D6E4A46.1040709@kernel.dk>
 <20110304182507.GY20499@htj.dyndns.org>
 <x49r5aisp23.fsf@segfault.boston.devel.redhat.com>
 <4D7533B1.3070308@kernel.dk>
 <x49mxl6sot4.fsf@segfault.boston.devel.redhat.com>
 <4D7534D6.7020000@kernel.dk>
 <x49ipvusoaj.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ipvusoaj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 07, 2011 at 02:50:28PM -0500, Jeff Moyer wrote:
> > But yes, it sounds like IDE is violating this rule and that's why it was
> > broken. Even with that, having explicit control of the queue running
> > does make sense.

Yeah, IDE is the only one which actually depends on it.  At the time I
thought more drivers would use the sleeping context but that didn't
happen (yet).  That said, I think it's generally a good idea to
guarantee context on the issue path (the request_lock requirement
makes it quite ugly to use but that's a separate issue).  It makes
things much easier - e.g. we can use mempool and friends for forward
progress guarantee instead of doing explicit retrying which also can
hide deadlocks quite effectively.

> Well, I wonder if it makes sense *in this case*.  With all of the work
> going into optimizing the flushing, is deferring work to kblockd really
> the best idea?  Tejun, do you know if it has any measurable impact?

I don't think it matters.  First of all, the overhead itself isn't
that big to begin with.  More importantly, the flush optimization is
not about squeezing out the last cpu cycles out of the existing path.
It's about consolidating similar operations and thus increasing
scalability when a storm of fsync's are issued in parallel likely with
a lot of other IOs.  The kicking path won't be used at all on busy
queues (queue won't be empty).

So, I don't think there's anything to worry about here.

Thanks.

-- 
tejun
