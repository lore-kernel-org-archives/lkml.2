Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716Ab2FUSjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 14:39:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51947 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759345Ab2FUSja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 14:39:30 -0400
Message-ID: <1340303969.22218.9.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2012 11:39:29 -0700
In-Reply-To: <1340303360.27036.194.camel@gandalf.stny.rr.com>
References: <20120614154153.GD17140@kroah.com>
	 <1339693625.13377.242.camel@gandalf.stny.rr.com>
	 <20120615042233.GA10973@localhost> <20120615043017.GA9587@kroah.com>
	 <20120615120430.GB23681@gmail.com> <20120615231318.GD8205@kroah.com>
	 <1339804415.25903.63.camel@gandalf.stny.rr.com>
	 <20120618230337.GB23627@kroah.com>
	 <1340069326.25903.177.camel@gandalf.stny.rr.com>
	 <20120620122549.GA10561@gmail.com> <20120621171338.GF3270@kroah.com>
	 <1340300509.27036.185.camel@gandalf.stny.rr.com>
	 <1340302623.22065.9.camel@joe2Laptop>
	 <1340303360.27036.194.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 14:29 -0400, Steven Rostedt wrote:
> On Thu, 2012-06-21 at 11:17 -0700, Joe Perches wrote:
> > On Thu, 2012-06-21 at 13:41 -0400, Steven Rostedt wrote:
[]
> > > I'm playing around with making a KERN_FLUSH "<f>". Think that's a better
> > > approach?
> > 
> > I don't think that's better.  I think it's worse
> > because it intermixes the idea of a kernel message
> > logging level with a specific functionality to
> > emit any fragmentary message immediately.
> 
> Are you using a 50 char width terminal?

Nope.  Just an old habit.

> > 
> > I think a global setting via a some functions like:
> > 
> > (printk private variable)
> > bool printk_buffered = true;
> > 
> > bool printk_set_buffering(bool enable)
> > {
> > 	bool old_state = printk_buffered;
> > 	printk_buffered = enable;
> > 
> > 	return old_state;
> > }
> > 
> > and maybe:
> > 
> > bool printk_get_buffering(void)
> > {
> > 	return printk_buffered;
> > }
> > 
> > would be better because the non-buffered use should
> > really be pretty isolated to last_breath type output
> > and to pretty isolated cases like your long running
> > tests.
> > 
> > A separate printk_flush() function if really necessary
> > but sprinkling a bunch of printk_flush() calls seems
> > wasteful.
> 
> A global buffering disable may cause other things that are printed to be
> screwed up.

After Kay's deferral patch (an actual improvement), lots
of output could have been changed.  Turning off buffering
would simply revert to pre 3.5 behavior.  I don't think
that's a significant issue.

> Something that actually expects to be buffered.

There is nothing today that _expects_ buffering or is
guaranteed non-buffered.

The locations that benefit from non-buffering are few
and isolated.

> Or perhaps have printk_flush() become a new printk. That is,
> printk_flush("this does not buffer").

Yuck.

Then there'd be all the likely variants for
prefix [pr|dev|netdev]_<level>[_once|_ratelimited] postfix
too.


