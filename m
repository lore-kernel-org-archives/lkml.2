Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab1EQPLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:11:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46046 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1EQPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Aqp+TYn8txB772SXzE+eLihP0k2oachyx1SUw1VzPObIGnCATpdwL4klSiWDwJFJqL
         sx9K8a0U5gUgcBZMiAPhKSfyDhhA08UlIX5icfBrpRg25fDNieS4rtMp6XTMbCYjGylY
         soYGvQh3X5KUOrF+imPlFwxCTJgys2GYiA7lE=
Date: Tue, 17 May 2011 17:11:07 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110517151107.GQ20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
 <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Tue, May 17, 2011 at 07:46:25AM -0700, Linus Torvalds wrote:
> This is pretty disgusting.
> 
> You're not using a real lock, and to compensate for that you use a
> bloccking bit-lock hack. And to make that hack extra ugly, you define
> the bit as a bitmask, and use the ilog2() macro to turn it into a bit
> pos.
> 
> Horrid. Horrid.

Heh, okay.  It's not a lock tho.  It's multiple waiter waiting for a
single event - so either explicit waitqueue or completion.  I was
doing a waitqueue but bit waitqueue didn't seem to add too much
complexity, so...

> Is there some fundamental reason why you cannot just turn the ev->lock
> into a real semaphore (allowing blocking), and then doing the dwork
> cancel under the semaphore - avoiding all the crazy bit-lock crud.

disk_check_events() can be called from non-sleepable context so we
need a spinlock protecting block count.

> Or just _add_ a semaphore to the 'struct disk_events', for chrissake.

Alright, a completion then.

> This is just too ugly to survive. And even if you fixed the ilog()
> (hint: just define the bit, and then use (1u<<BIT) to define the
> mask), it would be too ugly.

In many cases there are more C bitops than atomic or wait_bit() type
operations which take bit position rather than mask.  I find it less
painful to define constants as bit masks and using ilog2() on those
ops than doing lots of 1 << BIT.

I don't know, this is constantly painful.  More are defined as bit
masks but some prominent ones use bit positions and some even define
both.  Given that the C bitops are there by default, I wish the
explicit bitops also took bitmask and just did ilog2() internally, but
well it's too late and we're stuck with the mixed situation.

Thanks.

-- 
tejun
