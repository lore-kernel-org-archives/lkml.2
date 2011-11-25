Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1KYRni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:43:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43086 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1KYRng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:43:36 -0500
Date: Fri, 25 Nov 2011 18:43:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] printk: add console output tracing
Message-ID: <20111125174327.GB23978@somewhere.redhat.com>
References: <20111117150040.GB18437@somewhere>
 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
 <20111118184401.GA24787@somewhere.redhat.com>
 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
 <20111118185449.GB24787@somewhere.redhat.com>
 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
 <20111123131622.GA10669@somewhere.redhat.com>
 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
 <20111124154519.GB18579@somewhere.redhat.com>
 <1322161216.5366.52.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322161216.5366.52.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:00:16PM +0100, Johannes Berg wrote:
> On Thu, 2011-11-24 at 16:45 +0100, Frederic Weisbecker wrote:
> 
> > > I don't really feel comfortable modifying the _call_console_drivers()
> > > function to not handle start > end (modulo log buf size of course), but
> > > at the same time I don't feel comfortable putting code into it that
> > > doesn't handle it.
> > 
> > So, the:
> > 
> > 	BUG_ON(((int)(start - end)) > 0);
> > 
> > check is there to ensure we haven't wrapped INT_MAX. If we have reached
> > that point it definetly means we have a bug because log_buf_len is itself
> > an int and we shouldn't overlap INT_MAX.
> 
> Ok that makes sense.
> 
> > The care on the wrapping that is done in _call_console_drivers() is
> > different and concerns log_buf_len itself. If log_buf_len = 8, start = 7
> > and end = 9, then you will enter the "((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK))"
> > condition that handle the wrap on LOG_BUF_MASK to print the two chars.
> > But this is totally different from "start > end" which would mean we have
> > a bug.
> 
> Oh. So we get end = 9 in that case? That seems confusing ... I would
> have expected end = 1 then! Which is the whole reason I got confused I
> guess.

end = 9 but (end & LOG_BUF_MASK) = 1

> 
> > So, in your tracepoint you can safely use "end - start" as a length for your
> > dynamic array. But the rest of your tracepoint (all the fast assign part)
> > still needs the masks as you did.
> 
> Oh, that's all you were trying to say?

Yeah I first thought my comment applied to all the mask game in the tracepoint but then
I started to feel ashamed when I realized it was only on the dynamic array declaration :)

> I can see that, ok. I just didn't
> see that end would be 9 instead of 1 and tried to handle that. The
> _call_console_drivers() code is a bit different I guess.
> 
> I'll send a new version.

Thanks.

> 
> johannes
> 
