Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0CZWBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:01:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab0CZWBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:01:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 09/15] PM / Hibernate: user, implement user_ops writer
Date: Fri, 26 Mar 2010 23:04:32 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <201003252314.33256.rjw@sisk.pl> <4BAC7FC3.50405@gmail.com>
In-Reply-To: <4BAC7FC3.50405@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003262304.32118.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 March 2010, Jiri Slaby wrote:
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
> be used, the consumer will see the flag and use to_do_buf, in this order.
> 
> Above that if I introduce locks the wait_event on the other side will
> grow into an unreadable mess. I would need to hold a lock when checking
> the condition and hold it until I reach to_do_buf use, but also unlock
> it on all paths that do not reach that point. Yeah, it's indeed doable,
> but I don't think, it will improve things.
> 
> I also don't think completion is appropriate here, as I have a condition
> to check for and it differs over wake_up sites.

OK

I have some other comments to this patch, but I'd like to understand what
really happens here, since the changelog is not too verbose.

Please explain the design here.

Thanks,
Rafael
