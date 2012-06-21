Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab2FUS3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 14:29:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794Ab2FUS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 14:29:22 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=oIkdWaUSXydja7H63rQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340303360.27036.194.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2012 14:29:20 -0400
In-Reply-To: <1340302623.22065.9.camel@joe2Laptop>
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
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 11:17 -0700, Joe Perches wrote:
> On Thu, 2012-06-21 at 13:41 -0400, Steven Rostedt wrote:
> > On Thu, 2012-06-21 at 10:13 -0700, Greg Kroah-Hartman wrote:
> > 
> > > > So mind re-sending the latest version of your printk flushing 
> > > > fix? I'll apply it for v3.5-rc if other trees won't pick it up.
> > > 
> > > I'll be glad to pick it up, just make it work properly :)
> > 
> > I'm playing around with making a KERN_FLUSH "<f>". Think that's a better
> > approach?
> 
> I don't think that's better.  I think it's worse
> because it intermixes the idea of a kernel message
> logging level with a specific functionality to
> emit any fragmentary message immediately.

Are you using a 50 char width terminal?

> 
> I think a global setting via a some functions like:
> 
> (printk private variable)
> bool printk_buffered = true;
> 
> bool printk_set_buffering(bool enable)
> {
> 	bool old_state = printk_buffered;
> 	printk_buffered = enable;
> 
> 	return old_state;
> }
> 
> and maybe:
> 
> bool printk_get_buffering(void)
> {
> 	return printk_buffered;
> }
> 
> would be better because the non-buffered use should
> really be pretty isolated to last_breath type output
> and to pretty isolated cases like your long running
> tests.
> 
> A separate printk_flush() function if really necessary
> but sprinking a bunch of printk_flush() calls seems
> wasteful.

A global buffering disable may cause other things that are printed to be
screwed up. Something that actually expects to be buffered. Which is why
I'm leaning to the log level version. As it keeps it contained to the
actual printk that does not want buffering.

Or perhaps have printk_flush() become a new printk. That is,
printk_flush("this does not buffer").

-- Steve


