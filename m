Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1KXPpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:45:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63236 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1KXPpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:45:30 -0500
Date: Thu, 24 Nov 2011 16:45:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] printk: add console output tracing
Message-ID: <20111124154519.GB18579@somewhere.redhat.com>
References: <20111117145502.GA18437@somewhere>
 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
 <20111117150040.GB18437@somewhere>
 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
 <20111118184401.GA24787@somewhere.redhat.com>
 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
 <20111118185449.GB24787@somewhere.redhat.com>
 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
 <20111123131622.GA10669@somewhere.redhat.com>
 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322140919.5366.17.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 02:21:59PM +0100, Johannes Berg wrote:
> On Wed, 2011-11-23 at 14:16 +0100, Frederic Weisbecker wrote:
> 
> > > Also, call_console_drivers() doesn't pass this start/end through to
> > > _call_console_drivers(), it has loops and stuff there...
> > 
> > Yeah but looking at the loop there, start and end passed to
> > __call_console_drivers() are bounded between start and end passed to
> > call_console_drivers().
> 
> Looks like. Not that I have any idea why other code handles the wrap
> then?

It's not the same wrap.
More on that below.

> 
> > > In any case -- feel free to clean it all up, I basically copied the
> > > logic from _call_console_drivers assuming it was needed.
> > 
> > I'm just reviewing and suggesting a way to keep the patch more simple.
> > Outside that, I don't really need that patch myself ;)
> 
> :-)
> 
> > > I don't really want to know about the printk details :-)
> > 
> > Well, it's like working out outside in winter. It may not sound
> > very entertaining in the beginning but then it quickly becomes
> > invigorating, toning and good for the mood...I think...
> 
> Heh....
> 
> I don't really feel comfortable modifying the _call_console_drivers()
> function to not handle start > end (modulo log buf size of course), but
> at the same time I don't feel comfortable putting code into it that
> doesn't handle it.

So, the:

	BUG_ON(((int)(start - end)) > 0);

check is there to ensure we haven't wrapped INT_MAX. If we have reached
that point it definetly means we have a bug because log_buf_len is itself
an int and we shouldn't overlap INT_MAX.

The care on the wrapping that is done in _call_console_drivers() is
different and concerns log_buf_len itself. If log_buf_len = 8, start = 7
and end = 9, then you will enter the "((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK))"
condition that handle the wrap on LOG_BUF_MASK to print the two chars.
But this is totally different from "start > end" which would mean we have
a bug.

So, in your tracepoint you can safely use "end - start" as a length for your
dynamic array. But the rest of your tracepoint (all the fast assign part)
still needs the masks as you did.

But well, I'm being anal about two lines in TP_struct__entry(), that's really
not important...
