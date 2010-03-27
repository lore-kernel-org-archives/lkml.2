Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab0C0HCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 03:02:21 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53820 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751909Ab0C0HCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 03:02:20 -0400
Date: Sat, 27 Mar 2010 08:02:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
Message-ID: <20100327070207.GQ18689@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <20100324204259.GA6423@elf.ucw.cz>
 <4BAA86E8.5090108@gmail.com>
 <201003252314.33256.rjw@sisk.pl>
 <4BAC7FC3.50405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAC7FC3.50405@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-26 10:34:59, Jiri Slaby wrote:
> On 03/25/2010 11:14 PM, Rafael J. Wysocki wrote:
> > On Wednesday 24 March 2010, Jiri Slaby wrote:
> >> On 03/24/2010 09:42 PM, Pavel Machek wrote:
> >>>> +	if (test_bit(TODO_CLOSED, to_do_flags))
> >>>> +		return -EIO;
> >>>> +
> >>>> +	to_do_buf = buf;
> >>>> +	wmb();
> >>>> +	set_bit(TODO_WORK, to_do_flags);
> >>>> +	wake_up_interruptible(&to_do_wait);
> >>>
> >>> Uhuh, open-coded barriers... these need to be commented, and I guess
> >>> you just should not play this kind of trickery.
> >>
> >> It's just to ensure the to_do_buf store is not reordered with the
> >> set_bit. I wanted to avoid locks as too heavy tools here.
> > 
> > No, please use them, at least in a prototype version.
> > 
> > We can always optimize things out later, but doing optimizations upfront
> > doesn't really work well from my experience.
> > 
> > So, if you'd use a lock somewhere, please use it, or maybe use a completion if
> > that fits the design better.
> 
> That's it, I don't think a lock is appropriate here (I didn't even think
> of that) -- I don't know what to lock (OK, I see it, but it's not that
> clear). There is no potential for race per se, I only need to disable
> reordering (which locks do as a side-effect). I need the steps to be
> done in the A-B order where there is a barrier appropriate. Here, A is
> store to to_do_buf, B is set_bit. It's I set to_do_buf, flag that it may
> be used, the consumer will see the flag and use to_do_buf, in this
> order.

Could you just use same locking user.c uses? It does not really do any
magic...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
