Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1KRSzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:55:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61008 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1KRSzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:55:03 -0500
Date: Fri, 18 Nov 2011 19:54:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] printk: add console output tracing
Message-ID: <20111118185449.GB24787@somewhere.redhat.com>
References: <1321462856.4181.28.camel@frodo>
 <1321468380.4502.16.camel@jlt3.sipsolutions.net>
 <1321473443.4181.38.camel@frodo>
 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
 <20111117145502.GA18437@somewhere>
 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
 <20111117150040.GB18437@somewhere>
 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
 <20111118184401.GA24787@somewhere.redhat.com>
 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321641975.10266.73.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 07:46:15PM +0100, Johannes Berg wrote:
> On Fri, 2011-11-18 at 19:44 +0100, Frederic Weisbecker wrote:
> 
> > > +TRACE_EVENT_CONDITION(console,
> > > +	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
> > > +		 unsigned log_buf_len),
> > > +
> > > +	TP_ARGS(log_buf, start, end, log_buf_len),
> > > +
> > > +	TP_CONDITION(start != end),
> > > +
> > > +	TP_STRUCT__entry(
> > > +		__dynamic_array(char, msg,
> > > +				((end - start + log_buf_len) &
> > > +				 (log_buf_len - 1)) + 1)
> > 
> > Is all that care about log_buf_len necessary? It seems that
> > printk ensures that log_end - con_start never exceeds log_buf_len,
> > looking at emit_log_char()
> 
> I think it is. The buffer can wrap around so in that case end < start,
> which just end-start won't handle here.

Even if it wraps, end - start should always give a positive result.

We have that check in call_console_drivers():

	BUG_ON(((int)(start - end)) > 0)
