Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1AUN6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:58:08 -0500
Received: from www.tglx.de ([62.245.132.106]:59596 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1AUN6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:58:06 -0500
Date: Fri, 21 Jan 2011 14:57:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Christoph Hellwig <hch@infradead.org>, Torben Hohn <torbenh@gmx.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@tglx.de>
Subject: Re: [PATCH] RFC: abstract access to xtime_lock into a set of inline
 functions
In-Reply-To: <AANLkTikS0WAUngUXVx3uCynXt07-1L+=aR5A09XOMtK9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101211445170.2971@localhost6.localdomain6>
References: <1295543648-13788-1-git-send-email-torbenh@gmx.de> <20110120173029.GA26121@infradead.org> <AANLkTikS0WAUngUXVx3uCynXt07-1L+=aR5A09XOMtK9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-616069890-1295618267=:2971"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-616069890-1295618267=:2971
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 20 Jan 2011, john stultz wrote:

> On Thu, Jan 20, 2011 at 9:30 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Thu, Jan 20, 2011 at 06:14:08PM +0100, Torben Hohn wrote:
> >> the -rt patches change the xtime_lock to a raw_seqlock_t
> >> so a pretty huge portion of the patch deals with changing
> >> the locking functions.
> >>
> >> this commit uses inline functions, to hide the type
> >> of the lock.
> >
> > That's not how kernel code usually works.
> 
> Yea, I'm not a fan of this patch either.
> 
> 
> >> -     write_seqlock(&xtime_lock);
> >> +     xtime_write_seqlock();
> >>       do_timer(1);
> >> -     write_sequnlock(&xtime_lock);
> >> +     xtime_write_sequnlock();
> >
> > However there's a pretty clear pattern of taking xtime_lock, calling
> > do_timer and then releasing.  A useful thing you could do is to rename
> > do_timer to do_timer_locked and make do_timer take and release
> > xtime_lock in one place.
> 
> Seems like a reasonable suggestion.  I suspect there's still quite a
> bit of stuff done under the same lock right around do_timer on a

I looked through the few remaining usage sites in arch/ and there is
really no code inside the locked region which relies on xtime_lock,
AFAICT.

> number of arches, but  having a locked call would cut down on how
> widely xtime is used.

I'd suggest to move do_timer() to kernel/time/timekeeping.c, then add
xtime_update() which takes xtime_lock and calls do_timer(). After that
convert each arch with a separate patch. The last step makes
xtime_lock and do_timer() local to the timekeeping / clockevents code.

Thanks,

	tglx
---1463795968-616069890-1295618267=:2971--
